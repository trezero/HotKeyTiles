#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Mosaic Tiler - AutoHotkey Window Manager
; ============================================================================
; Purpose: Rearranges all visible windows into a non-grid mosaic layout
; Usage: Press Win+M to tile all windows on your primary monitor
; Author: Generated for Windows 10 with Samsung Odyssey 57" display
; ============================================================================

; ============================================================================
; CONFIGURATION SECTION
; ============================================================================

global TILING_HOTKEY := "F2"             ; F2 to tile all windows (change to your preference)
global FOCUS_HOTKEY := "F3"              ; F3 for focus mode (change to your preference)
global ISOLATE_HOTKEY := "F4"            ; F4 to isolate active application (change to your preference)
global SAVE_LAYOUT_HOTKEY := "F5"        ; F5 to save current layout (change to your preference)
global RESTORE_LAYOUT_HOTKEY := "F6"     ; F6 to restore saved layout (change to your preference)
global MARGIN := 12                      ; Pixels between windows (adjust as needed)
global DEBUG_MODE := true                ; Set to true for debug tooltips
global FOCUS_SIZE_PERCENT := 70          ; Percentage of screen for focus mode (50-90)

; Track hidden windows for isolation mode
global hiddenWindows := []

; Layout save file path
global LAYOUT_FILE := A_ScriptDir "\saved_layout.json"

; Excluded window classes (add more as needed)
global EXCLUDED_CLASSES := [
    "Shell_TrayWnd",                     ; Taskbar
    "Progman",                           ; Desktop
    "WorkerW",                           ; Desktop background
    "Windows.UI.Core.CoreWindow",        ; Windows 10/11 UI elements
    "ApplicationFrameWindow",            ; Some UWP apps (optional)
]

; Excluded process names (add more as needed)
global EXCLUDED_PROCESSES := [
    "ShellExperienceHost.exe",           ; Windows Shell Experience
    "SearchUI.exe",                      ; Windows Search
    "StartMenuExperienceHost.exe",       ; Start Menu
]

; ============================================================================
; HOTKEY REGISTRATION
; ============================================================================

Hotkey(TILING_HOTKEY, (*) => MosaicTile())
Hotkey(FOCUS_HOTKEY, (*) => FocusMode())
Hotkey(ISOLATE_HOTKEY, (*) => IsolateApplication())
Hotkey(SAVE_LAYOUT_HOTKEY, (*) => SaveLayout())
Hotkey(RESTORE_LAYOUT_HOTKEY, (*) => RestoreLayout())

; ============================================================================
; MAIN TILING FUNCTION
; ============================================================================

MosaicTile() {
    ; Restore any hidden windows from isolation mode
    RestoreHiddenWindows()
    
    ; Get all eligible windows
    windows := GetTileableWindows()
    
    if (windows.Length = 0) {
        if (DEBUG_MODE)
            ToolTip("No windows to tile")
        return
    }
    
    ; Get work area
    workArea := GetWorkArea()
    
    if (DEBUG_MODE)
        ToolTip("Tiling " windows.Length " windows in area: " workArea.w "x" workArea.h)
    
    ; Calculate optimal grid layout
    layout := CalculateBalancedLayout(windows.Length, workArea)
    
    ; Apply layout to each window
    Loop windows.Length {
        windowIndex := A_Index
        hwnd := windows[windowIndex]
        rect := layout[windowIndex]
        
        ; Apply margin to rectangle
        finalRect := ApplyMargin(rect, MARGIN)
        
        ; Move window to position
        try {
            WinMove(finalRect.x, finalRect.y, finalRect.w, finalRect.h, "ahk_id " hwnd)
        } catch {
            ; Window may have closed, continue silently
        }
    }
    
    if (DEBUG_MODE) {
        SetTimer(() => ToolTip(), -2000)  ; Clear tooltip after 2 seconds
    }
}

; ============================================================================
; FOCUS MODE FUNCTION
; ============================================================================

FocusMode() {
    ; Get the active window
    try {
        hwnd := WinGetID("A")
    } catch {
        if (DEBUG_MODE)
            ToolTip("No active window")
        return
    }
    
    ; Get work area
    workArea := GetWorkArea()
    
    ; Calculate centered position with specified percentage of screen
    sizePercent := FOCUS_SIZE_PERCENT / 100.0
    
    ; Calculate dimensions
    focusWidth := Integer(workArea.w * sizePercent)
    focusHeight := Integer(workArea.h * sizePercent)
    
    ; Center the window
    focusX := workArea.x + Integer((workArea.w - focusWidth) / 2)
    focusY := workArea.y + Integer((workArea.h - focusHeight) / 2)
    
    ; Move and resize the window
    try {
        WinMove(focusX, focusY, focusWidth, focusHeight, "ahk_id " hwnd)
        WinActivate("ahk_id " hwnd)  ; Ensure it's on top
        
        if (DEBUG_MODE)
            ToolTip("Focus mode: " focusWidth "x" focusHeight " at " focusX "," focusY)
    } catch {
        if (DEBUG_MODE)
            ToolTip("Failed to focus window")
    }
    
    if (DEBUG_MODE) {
        SetTimer(() => ToolTip(), -2000)  ; Clear tooltip after 2 seconds
    }
}

; ============================================================================
; ISOLATE APPLICATION FUNCTION
; ============================================================================

IsolateApplication() {
    ; Get the active window
    try {
        activeHwnd := WinGetID("A")
        activeProcess := WinGetProcessName("ahk_id " activeHwnd)
    } catch {
        if (DEBUG_MODE)
            ToolTip("No active window")
        return
    }
    
    ; Get all tileable windows
    allWindows := GetTileableWindows()
    
    ; Separate windows into same process and others
    appWindows := []
    otherWindows := []
    
    for hwnd in allWindows {
        try {
            processName := WinGetProcessName("ahk_id " hwnd)
            if (processName = activeProcess)
                appWindows.Push(hwnd)
            else
                otherWindows.Push(hwnd)
        }
    }
    
    if (appWindows.Length = 0) {
        if (DEBUG_MODE)
            ToolTip("No windows found for " activeProcess)
        return
    }
    
    ; Hide all other windows
    global hiddenWindows := []
    for hwnd in otherWindows {
        try {
            WinHide("ahk_id " hwnd)
            hiddenWindows.Push(hwnd)
        }
    }
    
    ; Get work area
    workArea := GetWorkArea()
    
    ; Tile the application windows
    layout := CalculateBalancedLayout(appWindows.Length, workArea)
    
    Loop appWindows.Length {
        windowIndex := A_Index
        hwnd := appWindows[windowIndex]
        rect := layout[windowIndex]
        
        ; Apply margin to rectangle
        finalRect := ApplyMargin(rect, MARGIN)
        
        ; Move window to position
        try {
            WinMove(finalRect.x, finalRect.y, finalRect.w, finalRect.h, "ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
        } catch {
            ; Window may have closed, continue silently
        }
    }
    
    if (DEBUG_MODE) {
        ToolTip("Isolated " appWindows.Length " windows of " activeProcess "`nHid " hiddenWindows.Length " other windows")
        SetTimer(() => ToolTip(), -2000)
    }
}

; ============================================================================
; RESTORE HIDDEN WINDOWS
; ============================================================================

RestoreHiddenWindows() {
    global hiddenWindows
    
    if (hiddenWindows.Length = 0)
        return
    
    ; Show all hidden windows
    for hwnd in hiddenWindows {
        try {
            WinShow("ahk_id " hwnd)
        }
    }
    
    if (DEBUG_MODE && hiddenWindows.Length > 0) {
        ToolTip("Restored " hiddenWindows.Length " hidden windows")
        SetTimer(() => ToolTip(), -1000)
    }
    
    ; Clear the list
    hiddenWindows := []
}

; ============================================================================
; SAVE LAYOUT FUNCTION
; ============================================================================

SaveLayout() {
    ; Get all tileable windows
    windows := GetTileableWindows()
    
    if (windows.Length = 0) {
        if (DEBUG_MODE)
            ToolTip("No windows to save")
        return
    }
    
    ; Ask for confirmation before saving
    result := MsgBox("Save current window layout?`n`nThis will overwrite any previously saved layout.`n`nWindows to save: " windows.Length, "Save Layout Confirmation", "OKCancel Icon?")
    
    if (result = "Cancel")
        return
    
    ; Build layout data structure
    layoutData := []
    
    for hwnd in windows {
        try {
            ; Get window information
            processName := WinGetProcessName("ahk_id " hwnd)
            processPath := WinGetProcessPath("ahk_id " hwnd)
            title := WinGetTitle("ahk_id " hwnd)
            
            ; Get window position and size
            WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
            
            ; Store window data (ensure integers)
            windowData := {
                process: processName,
                path: processPath,
                title: title,
                x: Integer(x),
                y: Integer(y),
                w: Integer(w),
                h: Integer(h)
            }
            
            layoutData.Push(windowData)
        }
    }
    
    ; Convert to JSON and save to file
    try {
        jsonText := JSON.Stringify(layoutData, 4)
        
        ; Delete existing file if it exists
        if (FileExist(LAYOUT_FILE))
            FileDelete(LAYOUT_FILE)
        
        FileAppend(jsonText, LAYOUT_FILE)
        
        if (DEBUG_MODE)
            ToolTip("Saved layout with " layoutData.Length " windows")
    } catch as err {
        if (DEBUG_MODE)
            ToolTip("Failed to save layout: " err.Message)
    }
    
    if (DEBUG_MODE) {
        SetTimer(() => ToolTip(), -2000)
    }
}

; ============================================================================
; RESTORE LAYOUT FUNCTION
; ============================================================================

RestoreLayout() {
    ; Read layout file
    if (!FileExist(LAYOUT_FILE)) {
        if (DEBUG_MODE)
            ToolTip("No saved layout found")
        return
    }
    
    try {
        jsonText := FileRead(LAYOUT_FILE)
        layoutData := JSON.Parse(jsonText)
    } catch as err {
        if (DEBUG_MODE) {
            ; Show first 200 chars of JSON for debugging
            preview := SubStr(jsonText, 1, 200)
            MsgBox("Failed to read layout: " err.Message "`n`nJSON preview:`n" preview, "JSON Parse Error", "Icon!")
        }
        return
    }
    
    if (layoutData.Length = 0) {
        if (DEBUG_MODE)
            ToolTip("Layout file is empty")
        return
    }
    
    ; Group windows by process to handle multiple windows per app
    processBounds := Map()
    
    for windowData in layoutData {
        processName := windowData.process
        
        if (!processBounds.Has(processName)) {
            processBounds[processName] := {
                path: windowData.path,
                x: windowData.x,
                y: windowData.y,
                w: windowData.w,
                h: windowData.h,
                count: 1
            }
        } else {
            ; Expand bounds to include this window's space
            bounds := processBounds[processName]
            bounds.count++
        }
    }
    
    ; Get currently running windows by process
    currentWindows := Map()
    allWindows := GetTileableWindows()
    
    for hwnd in allWindows {
        try {
            processName := WinGetProcessName("ahk_id " hwnd)
            if (!currentWindows.Has(processName))
                currentWindows[processName] := []
            currentWindows[processName].Push(hwnd)
        }
    }
    
    ; Restore or launch each application
    for processName, bounds in processBounds {
        ; Check if application is already running
        if (currentWindows.Has(processName)) {
            ; Application is running - tile its windows in the saved space
            appWindows := currentWindows[processName]
            TileWindowsInBounds(appWindows, bounds)
        } else {
            ; Application not running - launch it
            try {
                Run(bounds.path)
                if (DEBUG_MODE)
                    ToolTip("Launched " processName)
                
                ; Wait a moment for window to appear, then position it
                Sleep(1000)
                
                ; Find the new window(s)
                newWindows := []
                allWindows := GetTileableWindows()
                for hwnd in allWindows {
                    try {
                        if (WinGetProcessName("ahk_id " hwnd) = processName)
                            newWindows.Push(hwnd)
                    }
                }
                
                if (newWindows.Length > 0)
                    TileWindowsInBounds(newWindows, bounds)
                    
            } catch as err {
                if (DEBUG_MODE)
                    ToolTip("Failed to launch " processName ": " err.Message)
            }
        }
    }
    
    if (DEBUG_MODE) {
        ToolTip("Restored layout with " layoutData.Length " window positions")
        SetTimer(() => ToolTip(), -2000)
    }
}

; ============================================================================
; TILE WINDOWS IN BOUNDS
; ============================================================================

TileWindowsInBounds(windows, bounds) {
    if (windows.Length = 0)
        return
    
    ; Create a work area from the bounds
    workArea := {
        x: bounds.x,
        y: bounds.y,
        w: bounds.w,
        h: bounds.h
    }
    
    ; Calculate layout for these windows
    layout := CalculateBalancedLayout(windows.Length, workArea)
    
    ; Apply layout to each window
    Loop windows.Length {
        windowIndex := A_Index
        hwnd := windows[windowIndex]
        rect := layout[windowIndex]
        
        ; Apply margin to rectangle
        finalRect := ApplyMargin(rect, MARGIN)
        
        ; Move window to position
        try {
            WinMove(finalRect.x, finalRect.y, finalRect.w, finalRect.h, "ahk_id " hwnd)
        } catch {
            ; Window may have closed, continue silently
        }
    }
}

; ============================================================================
; JSON HELPER FUNCTIONS
; ============================================================================

class JSON {
    static Stringify(obj, indent := 0) {
        if (Type(obj) = "Array") {
            result := "["
            if (obj.Length > 0) {
                result .= "`n"
                for item in obj {
                    result .= this.Indent(indent + 1) this.Stringify(item, indent + 1) ","
                    result .= "`n"
                }
                result := SubStr(result, 1, -2) "`n" this.Indent(indent)
            }
            result .= "]"
            return result
        }
        
        if (Type(obj) = "Map") {
            result := "{"
            first := true
            for key, value in obj {
                if (!first)
                    result .= ","
                result .= "`n" this.Indent(indent + 1) '"' key '": ' this.Stringify(value, indent + 1)
                first := false
            }
            if (!first)
                result .= "`n" this.Indent(indent)
            result .= "}"
            return result
        }
        
        if (Type(obj) = "Object") {
            result := "{"
            first := true
            try {
                for key, value in obj.OwnProps() {
                    if (!first)
                        result .= ","
                    
                    ; Build the value string separately to preserve type
                    valueStr := this.Stringify(value, indent + 1)
                    result .= "`n" this.Indent(indent + 1) '"' key '": ' valueStr
                    first := false
                }
            }
            if (!first)
                result .= "`n" this.Indent(indent)
            result .= "}"
            return result
        }
        
        objType := Type(obj)
        
        if (objType = "String")
            return '"' this.Escape(obj) '"'
        
        if (objType = "Integer")
            return String(Integer(obj))  ; Convert integer to string representation
        
        if (objType = "Float")
            return String(Float(obj))  ; Convert float to string representation
        
        if (obj = "" || !IsSet(obj))
            return "null"
        
        ; Default: try to convert to string
        return '"' this.Escape(String(obj)) '"'
    }
    
    static Parse(jsonText) {
        jsonText := Trim(jsonText)
        pos := 1
        return this.ParseValue(jsonText, &pos)
    }
    
    static ParseValue(jsonText, &pos) {
        this.SkipWhitespace(jsonText, &pos)
        
        char := SubStr(jsonText, pos, 1)
        
        if (char = "{")
            return this.ParseObject(jsonText, &pos)
        if (char = "[")
            return this.ParseArray(jsonText, &pos)
        if (char = '"')
            return this.ParseString(jsonText, &pos)
        if (char = "t" || char = "f")
            return this.ParseBoolean(jsonText, &pos)
        if (char = "n")
            return this.ParseNull(jsonText, &pos)
        if (char = "-" || (char >= "0" && char <= "9"))
            return this.ParseNumber(jsonText, &pos)
        
        throw Error("Invalid JSON at position " pos)
    }
    
    static ParseObject(jsonText, &pos) {
        obj := {}
        pos++  ; Skip {
        this.SkipWhitespace(jsonText, &pos)
        
        if (SubStr(jsonText, pos, 1) = "}") {
            pos++
            return obj
        }
        
        loop {
            this.SkipWhitespace(jsonText, &pos)
            key := this.ParseString(jsonText, &pos)
            this.SkipWhitespace(jsonText, &pos)
            
            if (SubStr(jsonText, pos, 1) != ":")
                throw Error("Expected : at position " pos)
            pos++
            
            value := this.ParseValue(jsonText, &pos)
            obj.%key% := value
            
            this.SkipWhitespace(jsonText, &pos)
            char := SubStr(jsonText, pos, 1)
            
            if (char = "}")
                break
            if (char != ",")
                throw Error("Expected , or } at position " pos)
            pos++
        }
        
        pos++  ; Skip }
        return obj
    }
    
    static ParseArray(jsonText, &pos) {
        arr := []
        pos++  ; Skip [
        this.SkipWhitespace(jsonText, &pos)
        
        if (SubStr(jsonText, pos, 1) = "]") {
            pos++
            return arr
        }
        
        loop {
            value := this.ParseValue(jsonText, &pos)
            arr.Push(value)
            
            this.SkipWhitespace(jsonText, &pos)
            char := SubStr(jsonText, pos, 1)
            
            if (char = "]")
                break
            if (char != ",")
                throw Error("Expected , or ] at position " pos)
            pos++
        }
        
        pos++  ; Skip ]
        return arr
    }
    
    static ParseString(jsonText, &pos) {
        pos++  ; Skip opening "
        result := ""
        
        loop {
            char := SubStr(jsonText, pos, 1)
            
            if (char = '"')
                break
            
            if (char = "\") {
                pos++
                char := SubStr(jsonText, pos, 1)
                if (char = "n")
                    result .= "`n"
                else if (char = "t")
                    result .= "`t"
                else if (char = "r")
                    result .= "`r"
                else
                    result .= char
            } else {
                result .= char
            }
            
            pos++
        }
        
        pos++  ; Skip closing "
        return result
    }
    
    static ParseNumber(jsonText, &pos) {
        start := pos
        
        if (SubStr(jsonText, pos, 1) = "-")
            pos++
        
        while (pos <= StrLen(jsonText)) {
            char := SubStr(jsonText, pos, 1)
            if (char >= "0" && char <= "9" || char = ".")
                pos++
            else
                break
        }
        
        numStr := SubStr(jsonText, start, pos - start)
        if (numStr = "" || numStr = "-")
            throw Error("Invalid number at position " start)
        
        return Integer(numStr)
    }
    
    static ParseBoolean(jsonText, &pos) {
        if (SubStr(jsonText, pos, 4) = "true") {
            pos += 4
            return true
        }
        if (SubStr(jsonText, pos, 5) = "false") {
            pos += 5
            return false
        }
        throw Error("Invalid boolean at position " pos)
    }
    
    static ParseNull(jsonText, &pos) {
        if (SubStr(jsonText, pos, 4) = "null") {
            pos += 4
            return ""
        }
        throw Error("Invalid null at position " pos)
    }
    
    static SkipWhitespace(jsonText, &pos) {
        while (pos <= StrLen(jsonText)) {
            char := SubStr(jsonText, pos, 1)
            if (char = " " || char = "`t" || char = "`n" || char = "`r")
                pos++
            else
                break
        }
    }
    
    static Indent(level) {
        result := ""
        loop level
            result .= "    "
        return result
    }
    
    static Escape(str) {
        str := StrReplace(str, "\", "\\")
        str := StrReplace(str, '"', '\"')
        str := StrReplace(str, "`n", "\n")
        str := StrReplace(str, "`t", "\t")
        str := StrReplace(str, "`r", "\r")
        return str
    }
}

; ============================================================================
; BALANCED LAYOUT CALCULATION
; ============================================================================

CalculateBalancedLayout(windowCount, workArea) {
    ; Calculate optimal grid dimensions
    ; Try to make it as square as possible while using all space
    cols := Ceil(Sqrt(windowCount))
    rows := Ceil(windowCount / cols)
    
    ; Calculate cell dimensions
    cellWidth := workArea.w / cols
    cellHeight := workArea.h / rows
    
    ; Create layout array
    layout := []
    
    ; Assign positions to each window
    Loop windowCount {
        index := A_Index - 1  ; 0-based for math
        col := Mod(index, cols)
        row := Floor(index / cols)
        
        ; Calculate rectangle for this window
        rect := {
            x: workArea.x + (col * cellWidth),
            y: workArea.y + (row * cellHeight),
            w: cellWidth,
            h: cellHeight
        }
        
        ; For the last row, if there are fewer windows than columns,
        ; expand the windows to fill the width evenly
        if (row = rows - 1) {
            windowsInLastRow := windowCount - (row * cols)
            if (windowsInLastRow < cols) {
                expandedWidth := workArea.w / windowsInLastRow
                colInLastRow := Mod(index, cols)
                rect.x := workArea.x + (colInLastRow * expandedWidth)
                rect.w := expandedWidth
            }
        }
        
        layout.Push(rect)
    }
    
    return layout
}

; ============================================================================
; WINDOW ENUMERATION
; ============================================================================

GetTileableWindows() {
    windows := []
    
    ; Enumerate all windows
    allWindows := WinGetList()
    
    for hwnd in allWindows {
        ; Check if window is eligible
        if (IsWindowTileable(hwnd))
            windows.Push(hwnd)
    }
    
    return windows
}

IsWindowTileable(hwnd) {
    ; Check if window exists
    if (!WinExist("ahk_id " hwnd))
        return false
    
    ; Check if window is visible
    if (!WinGetStyle("ahk_id " hwnd))
        return false
        
    style := WinGetStyle("ahk_id " hwnd)
    exStyle := WinGetExStyle("ahk_id " hwnd)
    
    ; Must have WS_VISIBLE (0x10000000)
    if (!(style & 0x10000000))
        return false
    
    ; Must not be minimized (check MinMax state)
    minMax := WinGetMinMax("ahk_id " hwnd)
    if (minMax = -1)  ; -1 = minimized
        return false
    
    ; Must not be disabled (WS_DISABLED = 0x08000000)
    if (style & 0x08000000)
        return false
    
    ; Check for excluded window classes
    try {
        winClass := WinGetClass("ahk_id " hwnd)
        for excludedClass in EXCLUDED_CLASSES {
            if (winClass = excludedClass)
                return false
        }
    }
    
    ; Check for excluded processes
    try {
        processName := WinGetProcessName("ahk_id " hwnd)
        for excludedProcess in EXCLUDED_PROCESSES {
            if (processName = excludedProcess)
                return false
        }
    }
    
    ; Optionally exclude windows without titles
    try {
        title := WinGetTitle("ahk_id " hwnd)
        if (title = "")
            return false
    }
    
    ; Check for tool windows (WS_EX_TOOLWINDOW = 0x00000080)
    ; Exclude them as they're typically floating toolbars
    if (exStyle & 0x00000080)
        return false
    
    ; Must be a normal window (should have caption and system menu)
    ; WS_CAPTION = 0x00C00000
    if (!(style & 0x00C00000))
        return false
    
    return true
}

; ============================================================================
; WORK AREA DETECTION
; ============================================================================

GetWorkArea() {
    ; Get primary monitor work area (excludes taskbar)
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    
    return {
        x: left,
        y: top,
        w: right - left,
        h: bottom - top
    }
}

; ============================================================================
; UTILITY FUNCTIONS
; ============================================================================

ApplyMargin(rect, margin) {
    return {
        x: rect.x + margin,
        y: rect.y + margin,
        w: Max(rect.w - (margin * 2), 50),  ; Minimum 50px width
        h: Max(rect.h - (margin * 2), 50)   ; Minimum 50px height
    }
}

; ============================================================================
; SCRIPT INFO & TRAY MENU
; ============================================================================

; Show tray tip on startup
TraySetIcon("shell32.dll", 174)  ; Window icon
A_IconTip := "Mosaic Tiler`n" TILING_HOTKEY " = Tile All | " FOCUS_HOTKEY " = Focus`n" ISOLATE_HOTKEY " = Isolate | " SAVE_LAYOUT_HOTKEY " = Save | " RESTORE_LAYOUT_HOTKEY " = Restore"

; Create tray menu
A_TrayMenu.Delete()  ; Remove default menu items
A_TrayMenu.Add("Tile Windows Now", (*) => MosaicTile())
A_TrayMenu.Add("Focus Active Window", (*) => FocusMode())
A_TrayMenu.Add("Isolate Application", (*) => IsolateApplication())
A_TrayMenu.Add()  ; Separator
A_TrayMenu.Add("Save Layout", (*) => SaveLayout())
A_TrayMenu.Add("Restore Layout", (*) => RestoreLayout())
A_TrayMenu.Add()  ; Separator
A_TrayMenu.Add("Tile: " TILING_HOTKEY " | Focus: " FOCUS_HOTKEY, (*) => "")
A_TrayMenu.Disable("Tile: " TILING_HOTKEY " | Focus: " FOCUS_HOTKEY)
A_TrayMenu.Add("Isolate: " ISOLATE_HOTKEY " | Save: " SAVE_LAYOUT_HOTKEY " | Restore: " RESTORE_LAYOUT_HOTKEY, (*) => "")
A_TrayMenu.Disable("Isolate: " ISOLATE_HOTKEY " | Save: " SAVE_LAYOUT_HOTKEY " | Restore: " RESTORE_LAYOUT_HOTKEY)
A_TrayMenu.Add()  ; Separator
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Default := "Tile Windows Now"  ; Double-click action
