# HotKeyTiles - Advanced Window Management for Windows

A powerful AutoHotkey-based window management system designed for large displays like the Samsung Odyssey 57". Organize your workspace with intelligent tiling, focus modes, and layout persistence.

## Features

### Core Window Management
- **F2 - Tile All Windows**: Automatically arrange all visible windows in a balanced grid layout
- **F3 - Focus Active Window**: Center and enlarge the currently active window (70% of screen)
- **F4 - Isolate Application**: Show only windows from the active application, hiding all others
- **F5 - Save Layout**: Save current window arrangement to disk
- **F6 - Restore Layout**: Restore saved layout, launching apps if needed

### Smart Features
- **Balanced Grid Layout**: Equal-sized windows distributed evenly across your screen
- **Smart Window Filtering**: Automatically excludes system windows, taskbar, and desktop
- **Multi-Window App Support**: When restoring layouts, multiple windows of the same app tile together in the saved space
- **Application Launching**: F6 automatically launches applications that aren't running
- **No Background Process**: Runs only when triggered, minimal resource usage
- **Confirmation Dialogs**: F5 asks for confirmation before overwriting saved layouts

## Installation

### Prerequisites

1. **Install AutoHotkey v2**: Download from [https://www.autohotkey.com/](https://www.autohotkey.com/)
   - **IMPORTANT**: Install **AutoHotkey v2** (not v1)
   - The installer will associate `.ahk` files with AutoHotkey

### Quick Start

1. Double-click `MosaicTiler.ahk` to run the script
2. A tray icon will appear in your system tray
3. Use the hotkeys to manage your windows:
   - **F2**: Tile all windows
   - **F3**: Focus active window
   - **F4**: Isolate application
   - **F5**: Save layout
   - **F6**: Restore layout

### Run on Startup (Optional)

To have the tiler available whenever you start Windows:

1. Press `Win+R` to open Run dialog
2. Type `shell:startup` and press Enter
3. Create a shortcut to `MosaicTiler.ahk` in this folder
4. The script will now start automatically when you log in

## Usage Guide

### F2 - Tile All Windows

Arranges all visible windows in a balanced grid layout.

**How it works:**
- Calculates optimal grid dimensions (as square as possible)
- Distributes windows evenly across the screen
- Each window gets approximately equal space
- Restores any hidden windows from isolation mode

**Example:** With 5 windows, creates a 3×2 grid (3 windows on top row, 2 on bottom)

### F3 - Focus Active Window

Centers and enlarges the currently active window.

**How it works:**
- Takes the active window
- Resizes it to 70% of screen size (configurable)
- Centers it on the screen
- Brings it to the foreground

**Use case:** Quickly focus on a single window while keeping others visible in the background

### F4 - Isolate Application

Shows only windows from the active application, hiding all others.

**How it works:**
1. Identifies the process of the active window
2. Finds all windows from the same process
3. Hides all other application windows
4. Tiles the application's windows across the full screen

**Use case:** Focus on a single application (e.g., all your browser windows or code editor instances)

**To return to normal:** Press **F2** to restore all hidden windows and tile everything

### F5 - Save Layout

Saves the current window arrangement to disk.

**What gets saved:**
- Window positions (x, y coordinates)
- Window sizes (width, height)
- Application executable paths
- Process names

**How it works:**
1. Shows confirmation dialog with window count
2. Saves layout to `saved_layout.json` in script directory
3. Overwrites previous layout if it exists

**Use case:** Save your ideal workspace arrangement for different tasks

### F6 - Restore Layout

Restores a previously saved layout.

**How it works:**
1. Reads `saved_layout.json`
2. For each application in the layout:
   - If running: Positions existing windows in saved locations
   - If not running: Launches the application and positions it
3. Multiple windows of same app tile together in the saved space

**Use case:** Quickly restore your workspace after reboot or when switching tasks

**KNOWN ISSUE:** Currently experiencing JSON parsing errors. Save (F5) works, but Restore (F6) fails with "Expected a Number but got a String" error. This is being investigated.

## Configuration

Open `MosaicTiler.ahk` in a text editor to customize settings:

```ahk
; Hotkey Configuration
global TILING_HOTKEY := "F2"             ; Tile all windows
global FOCUS_HOTKEY := "F3"              ; Focus active window
global ISOLATE_HOTKEY := "F4"            ; Isolate application
global SAVE_LAYOUT_HOTKEY := "F5"        ; Save layout
global RESTORE_LAYOUT_HOTKEY := "F6"     ; Restore layout

; Display Configuration
global MARGIN := 12                      ; Pixels between windows
global FOCUS_SIZE_PERCENT := 70          ; Focus mode size (50-90%)

; Debug Configuration
global DEBUG_MODE := true                ; Show debug tooltips
```

### Hotkey Format Examples

- `F2` = Function key F2
- `#m` = Win+M
- `^!t` = Ctrl+Alt+T
- `^+t` = Ctrl+Shift+T
- `!F1` = Alt+F1

### Excluding Windows

Add window classes or process names to exclude from tiling:

```ahk
global EXCLUDED_CLASSES := [
    "Shell_TrayWnd",                     ; Taskbar
    "Progman",                           ; Desktop
    "WorkerW",                           ; Desktop background
    "YourWindowClass",                   ; Add custom exclusions
]

global EXCLUDED_PROCESSES := [
    "ShellExperienceHost.exe",           ; Windows Shell
    "SearchUI.exe",                      ; Windows Search
    "YourApp.exe",                       ; Add custom exclusions
]
```

**To find a window's class name:**
1. Run Window Spy (included with AutoHotkey installation)
2. Hover over the window you want to identify
3. Note the "ahk_class" value

## Tray Menu

Right-click the tray icon for quick access:

- **Tile Windows Now** - Same as F2
- **Focus Active Window** - Same as F3
- **Isolate Application** - Same as F4
- **Save Layout** - Same as F5
- **Restore Layout** - Same as F6
- **Exit** - Close the script

Double-click the tray icon to tile all windows.

## Technical Details

### Architecture

- **Language**: AutoHotkey v2.0
- **Compatibility**: Windows 10/11
- **Monitor Support**: Primary monitor work area
- **Layout Storage**: JSON format in `saved_layout.json`

### Window Filtering

The script intelligently filters windows based on:
- **Visibility**: Must be visible (not hidden)
- **State**: Must not be minimized
- **Style**: Must have caption and system menu (WS_CAPTION)
- **Type**: Excludes tool windows (WS_EX_TOOLWINDOW)
- **Class**: Excludes system UI classes
- **Process**: Excludes system processes
- **Title**: Must have a window title

### Tiling Algorithm

**Balanced Grid Layout:**
1. Calculates optimal grid dimensions using `Ceil(Sqrt(windowCount))`
2. Distributes windows evenly across rows and columns
3. Last row expands windows to fill width if fewer than columns
4. Applies configurable margin between windows
5. Minimum window size enforced (50px)

### Layout Persistence

**Save Format (JSON):**
```json
[
    {
        "process": "Windsurf.exe",
        "path": "C:\\...\\Windsurf.exe",
        "title": "Window Title",
        "x": 0,
        "y": 0,
        "w": 1920,
        "h": 1080
    }
]
```

**Restore Logic:**
- Groups windows by process name
- Handles multiple windows per application
- Launches missing applications
- Waits for windows to appear before positioning

## Known Issues

### F6 Restore Layout - JSON Parsing Error

**Status:** Under Investigation

**Symptom:** When pressing F6 to restore a saved layout, the script shows an error:
```
Failed to read layout: Expected a Number but got a String.
```

**Cause:** The JSON serialization is converting integer values (window positions and sizes) to quoted strings in the JSON output, causing the parser to fail when reading them back.

**Current Workaround:** None available. F5 saves layouts successfully, but F6 cannot restore them.

**What we've tried:**
- Using `Integer()` conversion when saving values
- Using `Format("{}", obj)` for number serialization
- Using `String(Integer(obj))` conversion
- Separating value string building from concatenation

**Next steps:** May need to replace the custom JSON implementation with a simpler manual serialization approach or use AutoHotkey's built-in JSON library if available.

**Impact:** Layout save/restore feature (F5/F6) is currently non-functional.

## Troubleshooting

### Script Won't Run
- Ensure AutoHotkey v2 is installed (not v1)
- Right-click the script and select "Run Script"
- Check for error messages in the AutoHotkey error dialog
- Verify the script file isn't corrupted

### Some Windows Aren't Tiled
- The script excludes minimized windows
- System windows and windows without titles are filtered out
- Add exclusions in configuration if certain windows should be skipped
- Enable `DEBUG_MODE := true` to see how many windows are being tiled

### Windows Overlap
- Increase the `MARGIN` value (default: 12px)
- Try values between 12-20px for large displays
- Restart the script after changing configuration

### Hotkey Doesn't Work
- Check if another program is using the same hotkey
- Try a different hotkey combination in the configuration
- Make sure the script is running (check system tray)
- Some applications may block global hotkeys

### F4 Isolation Doesn't Show All App Windows
- Some applications use multiple processes for different windows
- The script groups by exact process name match
- This is expected behavior for multi-process applications

### Layout File Not Found (F6)
- Press F5 at least once to create a saved layout
- Check that `saved_layout.json` exists in the script directory
- Verify file permissions allow reading

## Tips for Large Displays

### Samsung Odyssey 57" Recommendations

- **Margin**: Use 12-16px for better visual separation
- **Window Count**: Works best with 8-15 windows
- **Focus Mode**: Adjust `FOCUS_SIZE_PERCENT` to 60-80% for optimal viewing
- **Workflow**: 
  1. Use F2 for general multitasking
  2. Use F4 to focus on specific applications
  3. Use F3 for temporary single-window focus
  4. Save different layouts for different tasks

### Multi-Monitor Setup

Currently supports primary monitor only. For multi-monitor setups:
- Windows on secondary monitors are not affected
- Tiling only applies to primary monitor work area
- Future enhancement: Per-monitor tiling

## Development

### File Structure

```
HotKeyTiles/
├── MosaicTiler.ahk          # Main script
├── README.md                # This file
├── LICENSE                  # License information
├── HotKeyTilerPRD.md       # Product requirements document
└── saved_layout.json        # Saved layout (created on first F5)
```

### Contributing

This project was developed for personal use on a Samsung Odyssey 57" display. Contributions and improvements are welcome.

## License

See LICENSE file for details.

## Support

For AutoHotkey-related questions:
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [AutoHotkey Forums](https://www.autohotkey.com/boards/)

## Version History

### Current Version (v1.0-beta)

**Features:**
- F2: Tile all windows in balanced grid
- F3: Focus active window
- F4: Isolate application
- F5: Save layout with confirmation
- F6: Restore layout (currently broken - JSON parsing issue)

**Known Issues:**
- F6 restore layout fails with JSON parsing error
- No multi-monitor support
- No undo/redo functionality

**Future Enhancements:**
- Fix F6 restore layout functionality
- Multi-monitor support
- Multiple saved layouts with names
- Undo last tiling operation
- Window-specific exclusion rules
- Keyboard-only window selection for tiling subset
