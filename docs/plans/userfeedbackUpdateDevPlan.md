# User Feedback Update Development Plan

Based on competitor research in [docs/research/competitorIssues.md](../research/competitorIssues.md), this plan addresses the key pain points that plague every Windows tiling manager — giving HotKeyTiles a clear edge by solving what others can't.

---

## Phase 1: Fix What's Broken (Critical)

### 1.1 Fix F6 Layout Restore (JSON Parse Bug)

**Problem:** The `JSON.ParseNumber()` method calls `Integer(numStr)` on all numbers, which fails on floats and can mishandle string-to-number conversion. This is the same class of bug that has plagued FancyZones for years — broken layout persistence is the #1 competitor complaint across the entire ecosystem.

**Root Cause (line 681):**
```ahk
return Integer(numStr)
```
This throws "Expected a Number but got a String" when the number string contains a decimal point or when AHK's type coercion fails on certain numeric strings.

**Fix:**
- Detect whether `numStr` contains a `.` and return `Float(numStr)` vs `Integer(numStr)` accordingly
- Add a guard: if conversion fails, fall back to `Number(numStr)` which handles both types
- Add validation that saved JSON can be round-tripped (save then immediately parse) before confirming success to user

**Files:** `MosaicTiler.ahk` (JSON class, ~lines 663-681)

**Acceptance Criteria:**
- F5 save followed by F6 restore correctly repositions all windows
- Layout survives reboot (file persists, re-parsed correctly on next session)
- Error dialog shows actionable info if JSON file is corrupt

---

### 1.2 Improve Layout Restore Window Matching

**Problem:** Current restore matches windows only by process name. If a user has 3 Chrome windows, the restore can't distinguish which content goes where — it just tiles all Chrome windows into the saved Chrome bounds. Every competitor (DisplayFusion, FancyZones) struggles here too.

**Fix:**
- Save window title alongside process name (already done)
- Use a scoring system for matching: exact title match > title substring match > process-only match
- Save window class as an additional discriminator
- Store window count per process so restore knows when windows are missing vs. extra

**Files:** `MosaicTiler.ahk` (SaveLayout, RestoreLayout functions, ~lines 256-428)

**Acceptance Criteria:**
- 3 Chrome windows with different pages restore to their correct positions (matched by title)
- Extra windows (opened after save) get tiled into remaining space rather than ignored
- Missing windows are skipped gracefully with a tooltip count ("Restored 4/6 windows")

---

## Phase 2: Ultrawide & Large Display Excellence

### 2.1 Smart Layout Presets for Ultrawide

**Problem:** Built-in Windows Snap and most competitors only offer 2-4 window splits — wasteful on a 57" ultrawide. FancyZones requires manual zone creation. HotKeyTiles' current `Ceil(Sqrt(n))` grid doesn't account for extreme aspect ratios.

**Fix:**
- Detect display aspect ratio and adjust grid algorithm:
  - Standard (16:9): current behavior (balanced grid)
  - Ultrawide (21:9 / 32:9): prefer more columns than rows (e.g., 4-col for 4 windows instead of 2x2)
  - Super-ultrawide (32:9, ~57"): support up to 6-8 column layouts
- Add configurable layout presets at the top of the script:
  - `LAYOUT_MODE := "auto"` (aspect-ratio-aware, default)
  - `LAYOUT_MODE := "grid"` (current behavior)
  - `LAYOUT_MODE := "columns"` (all side-by-side)
  - `LAYOUT_MODE := "main+stack"` (one large window left, stack on right — the i3/dwm pattern)

**Files:** `MosaicTiler.ahk` (new config vars, CalculateBalancedLayout rewrite, ~lines 735-778)

**Acceptance Criteria:**
- On a 5120x1440 display with 4 windows, default layout produces 4 columns (not 2x2)
- `main+stack` mode gives the active window 50% width, remaining windows stacked on the right
- User can switch modes via config variable or new hotkey

### 2.2 Zone-Aware Focus Mode

**Problem:** Current FocusMode centers at 70% of screen — on a 57" ultrawide that's still ~3500px wide, far larger than any app needs. Competitors like FancyZones don't even offer focus mode.

**Fix:**
- Cap focus window at a maximum pixel width (configurable, default 2560px — one standard monitor width)
- On ultrawide displays, focus mode should center the window in the nearest "virtual monitor" third rather than dead center of the full display
- Add `FOCUS_MAX_WIDTH := 2560` config variable

**Files:** `MosaicTiler.ahk` (FocusMode function, ~lines 109-148)

**Acceptance Criteria:**
- On a 5120x1440 display, focused window is 2560px wide (not 3584px at 70%)
- Window is centered on screen (or optionally in the half where it was before focus)

---

## Phase 3: Resilience & Stability

### 3.1 Sleep/Wake Layout Recovery

**Problem:** The #1 cross-cutting issue: Windows scrambles window positions after sleep/wake, monitor disconnect, or dock/undock. FancyZones, DisplayFusion, GlazeWM, and Komorebi all fail here. This is HotKeyTiles' biggest opportunity to differentiate.

**Fix:**
- Auto-save layout on a configurable interval (default: every 60 seconds) to a rotating buffer of 3 files (`autosave_1.json`, `autosave_2.json`, `autosave_3.json`)
- Detect display configuration change events (monitor connect/disconnect, resolution change) using `WM_DISPLAYCHANGE` message
- On display change detection, wait 2-3 seconds for Windows to settle, then auto-restore from the most recent autosave
- Add a new hotkey (F7 or configurable) for "Restore Last Autosave" as manual fallback
- Add config: `AUTO_RESTORE_ON_DISPLAY_CHANGE := true`

**Files:** `MosaicTiler.ahk` (new autosave timer, WM_DISPLAYCHANGE handler, new RestoreAutosave function)

**Acceptance Criteria:**
- After sleep/wake, windows return to their pre-sleep positions within 5 seconds (automatic)
- After DisplayPort disconnect + reconnect, auto-restore fires and repositions windows
- Manual F7 press restores from most recent autosave if auto-restore didn't fire or got it wrong
- Autosave files rotate (no unbounded disk growth)

### 3.2 Admin Window Handling

**Problem:** AHK scripts can't move or resize windows running as Administrator unless the script itself is elevated. This affects GridMove, Komorebi, and every AHK-based tool. Users see some windows "immune" to tiling with no explanation.

**Fix:**
- Detect admin-privileged windows during enumeration (check for access denied when querying process info)
- Show a clear tooltip when admin windows are skipped: "Skipped 2 admin windows (run as Admin to manage all)"
- Add a `RUN_ELEVATED := false` config option with instructions in the config section
- If `RUN_ELEVATED` is true, add `#Requires Admin` or use a self-elevation relaunch pattern at startup

**Files:** `MosaicTiler.ahk` (IsWindowTileable, config section, optional startup elevation)

**Acceptance Criteria:**
- When tiling with non-elevated script, admin windows are skipped with a visible count
- When `RUN_ELEVATED` is true, script relaunches itself as admin and can tile all windows
- No silent failures — user always knows why a window wasn't tiled

### 3.3 Graceful Handling of Untileable Apps

**Problem:** Certain apps (Zoom, Spotify, Discord, UWP apps) resist being moved/resized. Komorebi, FancyZones, and Workspacer all have per-app compatibility issues with no clear user feedback.

**Fix:**
- After issuing `WinMove`, verify the window actually moved (re-read position, compare to target)
- If a window didn't move/resize, add it to a "stubborn windows" list and report to user
- Add a `FORCE_RESIZE := false` config option that uses `WinRestore` before `WinMove` (un-maximize first)
- Add a configurable exclusion list in the config section with common offenders pre-documented:
  ```ahk
  global EXCLUDED_PROCESSES := [
      ; ... existing ...
      ; "Zoom.exe",           ; Uncomment if Zoom resists tiling
      ; "Spotify.exe",        ; Uncomment if Spotify resists tiling
  ]
  ```

**Files:** `MosaicTiler.ahk` (MosaicTile, IsWindowTileable, config section)

**Acceptance Criteria:**
- After tiling, tooltip shows "Tiled 8 windows (2 resisted — see log)" if any windows didn't comply
- Maximized windows are restored before tiling attempt (fixes the most common "won't move" case)
- Config section has documented exclusion list for known-problematic apps

---

## Phase 4: Power User Features

### 4.1 Per-Window Layout Memory

**Problem:** No competitor offers per-window zone memory (Snap Assist explicitly lacks this). Users want "Chrome always goes top-left, VS Code always goes right half."

**Fix:**
- New hotkey: `F8` (configurable) — "Pin Window to Zone"
  - Saves current window's process + class + title pattern mapped to its current x/y/w/h
  - Stored in `pinned_windows.json`
- When F2 (MosaicTile) runs, pinned windows get their saved positions first; remaining windows fill leftover space
- Pinned positions are per-process-and-title-pattern (regex), so "Chrome - Gmail" always goes to one spot while "Chrome - GitHub" goes to another

**Files:** `MosaicTiler.ahk` (new PinWindow function, modified MosaicTile, new JSON file)

**Acceptance Criteria:**
- User pins VS Code to right half; on every F2 tile, VS Code is placed there first
- Other windows are tiled around pinned windows without overlapping
- Pinned window config survives reboots

### 4.2 Multi-Monitor Awareness

**Problem:** Current `GetWorkArea()` only queries monitor 1. Multi-monitor is the #1 pain point for Komorebi, FancyZones, and DisplayFusion — monitor ID instability, hot-plug chaos, and wrong-monitor placement.

**Fix:**
- Enumerate all monitors using `MonitorGetCount()` and `MonitorGetWorkArea(n)`
- Change F2 behavior: tile windows across all monitors (distribute evenly) or tile only on the active monitor (configurable)
- Add config: `TILE_MODE := "active_monitor"` vs `"all_monitors"`
- Determine which monitor a window is on by checking its center point against monitor bounds
- For `active_monitor` mode, only tile windows whose center is on the same monitor as the active window

**Files:** `MosaicTiler.ahk` (GetWorkArea, MosaicTile, new GetMonitorForWindow helper, config section)

**Acceptance Criteria:**
- With 2 monitors, F2 tiles only windows on the current monitor (default mode)
- With `all_monitors` mode, windows are distributed across monitors evenly
- Adding/removing a monitor doesn't crash the script

### 4.3 Configurable Hotkeys via GUI or Config File

**Problem:** Hardcoded F2-F6 keys will conflict with applications. GlazeWM's Win-key conflicts and general hotkey collision is a recurring complaint. Currently users must edit source code to change keys.

**Fix:**
- Move hotkey config to an external `config.ini` file (AHK v2 has `IniRead`/`IniWrite`)
- If `config.ini` doesn't exist, create it with defaults on first run
- Add a tray menu item "Edit Hotkeys..." that opens the config file in Notepad
- Add a tray menu item "Reload Config" that re-reads and re-registers hotkeys
- Support modifier combos: `^F2` (Ctrl+F2), `!F2` (Alt+F2), `#F2` (Win+F2)

**Files:** New `config.ini`, `MosaicTiler.ahk` (config loading, hotkey registration refactor)

**Acceptance Criteria:**
- User edits `config.ini`, clicks "Reload Config" from tray, new hotkeys work immediately
- Default config.ini is auto-generated with all current defaults + comments explaining each option
- Invalid hotkey strings show an error tooltip instead of crashing

---

## Phase 5: Performance & Long-Term Reliability

### 5.1 Memory and Performance Guardrails

**Problem:** DisplayFusion becomes unusable over time. bug.n gets slow. Komorebi's CPU creeps up. As a long-running script, HotKeyTiles must not degrade.

**Fix:**
- Ensure all arrays and maps are properly cleared after use (no accumulating references)
- Audit `hiddenWindows` array: verify it's cleared when windows are restored, and prune stale handles (windows that were closed while hidden)
- Add a periodic cleanup timer (every 5 minutes) that validates `hiddenWindows` entries still exist
- Keep the script single-threaded with no persistent hooks — AHK's event-driven model is already lightweight

**Files:** `MosaicTiler.ahk` (RestoreHiddenWindows, new cleanup timer)

**Acceptance Criteria:**
- Script runs for 24+ hours with periodic tiling without memory growth
- `hiddenWindows` never contains handles to closed windows
- No observable CPU usage when idle (0% between hotkey presses)

### 5.2 Robust Error Reporting

**Problem:** Most competitors fail silently. Workspacer "disables itself randomly." MaxTo "fails to start" with no useful error. Users are left guessing.

**Fix:**
- Replace bare `try/catch` blocks with specific error logging
- Add an optional log file (`mosaic_tiler.log`) when `DEBUG_MODE` is true
- Log format: `[2026-03-19 14:30:00] TILE: 8 windows, 2 skipped (admin), 1 resisted resize`
- Cap log file at 1MB (rotate on overflow)
- Add tray menu item "View Log" that opens the log file

**Files:** `MosaicTiler.ahk` (new LogMessage function, all try/catch blocks, tray menu)

**Acceptance Criteria:**
- Every tiling operation produces a log entry with window count, skip reasons, and errors
- Log file doesn't grow unbounded
- User can diagnose "why didn't my window tile?" by checking the log

---

## Implementation Priority & Dependencies

```
Phase 1 (Critical - do first)
  ├── 1.1 Fix JSON Parse ← blocks everything involving save/restore
  └── 1.2 Improve Window Matching ← builds on 1.1

Phase 2 (High value - ultrawide differentiator)
  ├── 2.1 Smart Layout Presets ← independent
  └── 2.2 Zone-Aware Focus ← independent

Phase 3 (Resilience - biggest competitor gap)
  ├── 3.1 Sleep/Wake Recovery ← depends on 1.1 (needs working JSON)
  ├── 3.2 Admin Window Handling ← independent
  └── 3.3 Untileable App Handling ← independent

Phase 4 (Power features)
  ├── 4.1 Per-Window Memory ← depends on 1.1, 1.2
  ├── 4.2 Multi-Monitor ← independent (big scope)
  └── 4.3 External Config ← independent (quality of life)

Phase 5 (Long-term health)
  ├── 5.1 Memory Guardrails ← independent
  └── 5.2 Error Reporting ← independent (but useful during all other phases)
```

**Recommended order:** 1.1 → 5.2 → 1.2 → 2.1 → 2.2 → 3.2 → 3.3 → 3.1 → 4.3 → 4.1 → 4.2 → 5.1

Start with the JSON fix (unblocks everything), then add error reporting (helps debug everything else), then work through features by impact.

---

## Non-Goals (Explicit)

These are out of scope to keep HotKeyTiles simple and differentiated:

- **Virtual desktops / workspaces** — Windows has this built in; adding it creates GlazeWM/Komorebi-level complexity
- **Window decorations / titlebars** — fighting DWM is a losing battle
- **Mouse-based zone creation GUI** — FancyZones already does this; our strength is keyboard-driven simplicity
- **Auto-start applications** — current RestoreLayout launches missing apps, but a full app-launcher is out of scope
- **Cross-reboot monitor ID tracking** — Windows monitor IDs are unstable; we work with what's available at runtime rather than fighting the OS

---

*Plan derived from analysis of 12 competitor applications and their collective ~50+ documented bug categories. See [docs/research/competitorIssues.md](../research/competitorIssues.md) for full source material.*
