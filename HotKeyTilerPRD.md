An AutoHotkey “Mosaic Tiler” – PRD for AI Coding Agent [v0.1]  

## 1. Goal

Create a single AutoHotkey script that, when triggered by a hotkey, automatically rearranges all visible “normal” windows into a **non‑grid mosaic layout** so that every window is visible and non‑overlapping, then stops managing them until triggered again. The script should be usable as‑is by a power user on Windows 10/11.

***

## 2. Functional Requirements

### 2.1 Trigger behavior

- [ ] Define a global hotkey (default: `Win + M`) to execute the tiling logic.  
- [ ] On hotkey press, run once and exit (no background loop, no persistent window management).  
- [ ] If there are no eligible windows, do nothing gracefully (no errors or popups).  

### 2.2 Window selection

- [ ] Enumerate all top‑level windows. [autohotkey](https://www.autohotkey.com/board/topic/9966-hideshow-all-visible-windows/)
- [ ] Include only windows that satisfy:  
  - [ ] Not minimized (MinMax = 0). [autohotkey](https://www.autohotkey.com/board/topic/9966-hideshow-all-visible-windows/)
  - [ ] Visible (standard AutoHotkey visibility checks). [autohotkey](https://www.autohotkey.com/board/topic/9966-hideshow-all-visible-windows/)
  - [ ] Not disabled (exclude windows with `WS_DISABLED`). [autohotkey](https://www.autohotkey.com/board/topic/67214-windows-using-msdn-functions-in-ahk/)
- [ ] Exclude system/desktop UI windows:  
  - [ ] Taskbar (class `Shell_TrayWnd`).  
  - [ ] Desktop / background (`Progman`, `WorkerW`).  
  - [ ] Optionally: any window without a title.  
- [ ] Make it easy to add more exclusions by class or executable (e.g., a small list/array at top of script). [autohotkey](https://www.autohotkey.com/board/topic/66427-tiling-windows-by-type/)

### 2.3 Workspace region

- [ ] Use the **primary monitor’s work area** (screen minus taskbar) as the tiling region. [eli.thegreenplace](https://eli.thegreenplace.net/2007/10/31/conveniently-tiling-windows-on-the-screen)
- [ ] Obtain work area using `SysGet, MonitorWorkArea`. [eli.thegreenplace](https://eli.thegreenplace.net/2007/10/31/conveniently-tiling-windows-on-the-screen)
- [ ] Support taskbar on any edge (do not hard‑code offsets).  

### 2.4 Mosaic tiling algorithm

Core idea: recursive “mosaic” split with alternating orientation and non‑central split ratio.

- [ ] Represent free space as a list of rectangles, each with `x, y, w, h`.  
- [ ] Initialize free space list with a single rectangle (entire work area).  
- [ ] For each eligible window:  
  - [ ] Find the **largest** free rectangle by area.  
  - [ ] Remove that rectangle from the free‑space list.  
  - [ ] Split it into two rectangles (assigned and leftover) using:  
    - [ ] Split orientation that alternates between **vertical** and **horizontal** to avoid a rigid grid feel.  
    - [ ] A non‑central split ratio, e.g., 60/40 or 40/60, to create varied tile sizes.  
    - [ ] Optionally alternate 60/40 and 40/60 per window index for more variation.  
  - [ ] Assign the larger of the two halves (or a deterministic choice) to the current window.  
  - [ ] Push the other half back into the free‑space list for future windows.  
- [ ] Ensure the algorithm never produces negative or zero width/height.  
- [ ] The result: all windows are visible, no overlaps, layout looks organic rather than strict rows/columns. [eli.thegreenplace](https://eli.thegreenplace.net/2007/10/31/conveniently-tiling-windows-on-the-screen)

### 2.5 Applying positions

- [ ] Move each window into its assigned rectangle using `WinMove` with `x, y, width, height`. [autohotkey](https://www.autohotkey.com/board/topic/80580-how-to-programmatically-tile-cascade-windows/)
- [ ] Optional: apply a small margin (e.g., 5–10 px) so windows do not butt exactly against each other or screen edges.  
- [ ] Do not alter Z‑order more than necessary (no forced “always on top” changes).  

### 2.6 Error handling and robustness

- [ ] Script must not crash if:  
  - [ ] A window closes during enumeration or before move.  
  - [ ] The free‑space list becomes small; still compute valid sizes.  
- [ ] Fail silently (no message boxes) unless in an optional debug mode.  
- [ ] Tolerate large numbers of windows (e.g., 20–30) without extremely tiny tiles by:  
  - [ ] Still computing valid rectangles.  
  - [ ] (Optional) Early‑stopping or grouping if count exceeds a configurable threshold.  

***

## 3. Non‑Functional Requirements

- [ ] Implement in **AutoHotkey v2 syntax** (preferred) or clearly label if using v1. [autohotkey](https://www.autohotkey.com/boards/viewtopic.php?t=41258)
- [ ] Single self‑contained `.ahk` file that can be dropped into Startup or run manually.  
- [ ] Clear top‑of‑file configuration section for:  
  - [ ] Hotkey choice.  
  - [ ] Margin size.  
  - [ ] List of excluded window classes/processes.  
- [ ] Code should be readable and logically structured (functions for tiling, enumeration, etc.).  

***

## 4. Implementation Checklist (for the AI agent)

### 4.1 Script scaffolding

- [ ] Create an AutoHotkey script file with a header comment: name, purpose, usage.  
- [ ] Define configuration variables at the top (hotkey, margin, exclusions).  
- [ ] Define hotkey (default `#m`) to call a `MosaicTile()` function.  

### 4.2 Window enumeration function

- [ ] Implement function `GetTiledWindows()` that:  
  - [ ] Uses `WinGet, List` to get all top‑level windows. [autohotkey](https://www.autohotkey.com/board/topic/9966-hideshow-all-visible-windows/)
  - [ ] Filters using style, ex‑style, visibility, minimized state. [autohotkey](https://www.autohotkey.com/board/topic/67214-windows-using-msdn-functions-in-ahk/)
  - [ ] Excludes taskbar, desktop, and other configured classes/executables.  
  - [ ] Returns an array of window handles (`hwnd`).  

### 4.3 Work area detection

- [ ] Implement function `GetWorkArea()` that:  
  - [ ] Calls `SysGet, MonitorWorkArea, 1`. [eli.thegreenplace](https://eli.thegreenplace.net/2007/10/31/conveniently-tiling-windows-on-the-screen)
  - [ ] Returns an object `{x, y, w, h}` representing the tiling region.  

### 4.4 Mosaic tiling core

- [ ] Implement `MosaicTile()` that:  
  - [ ] Calls `GetTiledWindows()` and exits if no windows.  
  - [ ] Calls `GetWorkArea()` and initializes a `freeRects` list with that rectangle.  
  - [ ] Loops over windows and for each:  
    - [ ] Finds largest rectangle in `freeRects` by area.  
    - [ ] Removes it.  
    - [ ] Decides orientation (vertical/horizontal) based on a toggle and/or window index.  
    - [ ] Chooses split ratio (e.g., 0.6 vs 0.4) based on index or simple alternating logic.  
    - [ ] Computes two valid rectangles, guards against zero/negative sizes.  
    - [ ] Assigns one rect to current window, pushes the leftover back to `freeRects`.  
    - [ ] Applies margin to the assigned rect.  
    - [ ] Calls `WinMove` on that window with the final coordinates. [autohotkey](https://www.autohotkey.com/board/topic/80580-how-to-programmatically-tile-cascade-windows/)

### 4.5 Optional enhancements (if time permits)

- [ ] Add support for multi‑monitor tiling by:  
  - [ ] Running the algorithm separately per monitor, or  
  - [ ] Restricting to the monitor containing the mouse or active window. [eli.thegreenplace](https://eli.thegreenplace.net/2007/10/31/conveniently-tiling-windows-on-the-screen)
- [ ] Add a debug mode flag that:  
  - [ ] Displays a tooltip or log with window count and tiling region.  
- [ ] Add an alternate hotkey that tiles **only** windows of the same process as the active window. [autohotkey](https://www.autohotkey.com/board/topic/66427-tiling-windows-by-type/)

***

## 5. Acceptance Criteria

The script is “done” when:

- [ ] User can run the `.ahk` file, press `Win + M`, and see all visible normal windows rearranged into a **non‑grid mosaic** on the primary monitor, each fully visible and non‑overlapping.  
- [ ] No layout is enforced after the script completes; subsequent manual moves/resizes work normally.  
- [ ] Triggering the hotkey again recomputes a fresh mosaic based on the then‑current set of windows.  
- [ ] No message boxes or crashes appear in typical use (10–20 windows, one or more monitors).