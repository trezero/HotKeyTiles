# Windows Tiling & Window Management Apps: Bugs, Complaints, and Negative User Experiences

Research compiled March 2026. Sources include GitHub issues, Reddit, Steam Community, official forums, Hacker News, review sites, and developer blogs.

---

## Table of Contents

1. [FancyZones (PowerToys)](#1-fancyzones-powertoys)
2. [AquaSnap](#2-aquasnap)
3. [DisplayFusion](#3-displayfusion)
4. [Divvy](#4-divvy)
5. [GridMove](#5-gridmove)
6. [bug.n](#6-bugn)
7. [Komorebi](#7-komorebi)
8. [GlazeWM](#8-glazewm)
9. [Workspacer](#9-workspacer)
10. [MaxTo](#10-maxto)
11. [WindowGrid](#11-windowgrid)
12. [Moom](#12-moom)
13. [Microsoft Snap Assist](#13-microsoft-snap-assist)
14. [Cross-Cutting Themes](#14-cross-cutting-themes)

---

## 1. FancyZones (PowerToys)

### Layout Persistence / Save-Restore (Critical, Long-Standing)

- **Layouts reset after reboot**: Custom layouts revert to factory presets on restart. This bug has persisted across many versions and has "effectively never been solved." (GitHub issues #7790, #27120, #19630)
- **Layouts require double-save**: Changes do not persist unless the user saves twice in the editor. (GitHub issue #30594)
- **Layout not applied after closing editor**: Zones disappear from screens when the editor is closed, though they reappear when the editor is reopened. (GitHub issue #30930)
- **Different layouts for different monitors overwrite each other**: When editing layouts for multiple displays, both displays can end up with the same layout (the last one selected). (GitHub issue #19243)
- **Layout randomly reassigns to wrong monitors**: When switching between docked/undocked states or different monitor configurations, layouts either unassign or assign to incorrect screens. (GitHub issue #34734)

### Multi-Monitor and DPI Issues

- **Zones cannot extend full width on super-ultrawide at 125% DPI**: On dual 2560x1440 displays at 125% scaling, zones max out at 4485px instead of full width. Single-display mode works correctly. (GitHub issue #8416)
- **FancyZones Editor appears blurry on mixed-DPI setups**: Text and UI elements blur when monitors use different scaling (e.g., 150% and 200%). (GitHub issue #20766)
- **Triple-monitor zone misalignment**: The FancyZones editor displays monitors in a different order than Windows Display settings, causing overlays to be correct on only one monitor. (GitHub issue #40629)
- **Windows not restored to correct size after sleep**: Apps become smaller (at least vertically) and offset from their zone positions after wake from sleep. (GitHub issue #18907)

### Application Compatibility

- **Zones not showing for certain apps**: WhatsApp, Discord, and Spotify do not respond to Shift+drag to show zones, while Chrome and File Explorer work fine. (GitHub issue #18786)
- **Conflict with Rhino.Inside.Revit**: FancyZones causes Grasshopper search windows and tab previews to appear in wrong locations. (McNeel Forum)
- **Conflict with Start 11**: FancyZones uses Windows taskbar state detection, causing blank spaces at the bottom of the display when Start 11 hides the taskbar. (Stardock Forums)
- **Windows 11 Settings window stopped working with FancyZones** after an update. (GitHub issue #29668)

### Post-Update Breakage

- **FancyZones stops working entirely after PowerToys update**: Shift+drag no longer shows zones; Win+Arrow unresponsive. (GitHub issue #34810)

---

## 2. AquaSnap

### Multi-Monitor Issues

- **AquaMagnet fails on secondary monitor**: The magnet effect (window-to-window snapping) works on the primary monitor but not on the second monitor in multi-monitor setups. (Nurgo Software UserVoice)
- **Cannot drag-to-dock on shared monitor edge**: The edge between two adjacent monitors cannot be used as a snap/dock target. (UserVoice)
- **Keyboard shortcuts unreliable with mismatched DPI**: When two adjacent monitors have very different DPI scaling, multi-monitor keyboard shortcuts become unreliable. (Official documentation)

### General Issues

- **Activation failures after update**: The app constantly complains that Steam is not logged in despite it being active; the ON state is greyed out in the context menu. (Steam Community)
- **Tray icon crashes**: Occasional crashes of the system tray icon requiring restart. (AlternativeTo reviews)
- **Keyboard shortcuts broken with non-standard taskbar position**: Moving or resizing windows with keyboard shortcuts does not work when the taskbar is on the left or top of the screen. (Official known issues)
- **Key features paywalled**: Many capabilities (multi-monitor support, advanced snapping) require the paid Pro version. (User reviews)

---

## 3. DisplayFusion

### Performance Degradation

- **System becomes unusable over time**: After extended use, the entire system can require 3-8 seconds to respond to every click. Closing DisplayFusion immediately resolves the issue. (DisplayFusion Forums)
- **High CPU usage on Windows 11**: Users report 10-20%+ CPU usage after upgrading to Windows 11, with general system delays and lag. (DisplayFusion Forums)
- **Memory leaks**: System becomes progressively slower until DisplayFusion is restarted. (DisplayFusion Forums)

### Gaming Interference

- **FPS drops when minimizing/restoring games**: Significant frame rate drops tied to DisplayFusion's window management hooks. (DisplayFusion Forums)
- **Alt+Tab breaks or flickers**: Alt+Tab menu shows tiny/distorted preview windows or causes flickering after launching Steam overlay in games. (DisplayFusion Forums, Steam Community)
- **Freezing and crashing games**: Direct reports of games locking up due to DisplayFusion hooks. (Steam Community)

### Window Position Persistence

- **Restored windows land on wrong monitor**: Even after a successful save, subsequent restores can move windows like Chrome to another display with no intervening changes. (DisplayFusion Forums)
- **Sleep/resume restores old positions**: Waking from sleep applies an older saved position set instead of the most recent one. (DisplayFusion Forums)
- **DisplayPort disconnect scrambles all windows**: When DisplayPort monitors power off (even via power plan), Windows rearranges all windows randomly on remaining monitors; DisplayFusion cannot always recover. (DisplayFusion Forums)
- **Positions not remembered across reboots**: Window handles change when windows are destroyed and re-created, so positions are lost. (DisplayFusion Forums)

### Windows 11 Compatibility

- **Secondary taskbars not staying on top**: Apps maximize over secondary taskbars. (DisplayFusion Forums)
- **Start menu appears on wrong screen**: Opening the Start menu on a secondary monitor shows it on the primary screen instead. (DisplayFusion Forums)
- **Taskbar flickering with multi-monitor taskbars enabled**: Full-screen apps get hidden behind the taskbar. (DisplayFusion Forums)

### High DPI / Ultrawide

- **Mixed DPI causes inconsistent UI scaling**: Some DisplayFusion interface elements appear very large while others are tiny on mixed DPI setups (e.g., ultrawide + high-DPI laptop). (DisplayFusion Forums)
- **Blurry wallpapers on high-DPI displays**: Wallpaper rendering does not respect per-monitor DPI settings. (DisplayFusion Forums)
- **Updates break configurations**: User settings and monitor profiles lost or reset after updates. (DisplayFusion Forums)

---

## 4. Divvy

### Bugs

- **iTunes 12 freezes when resized**: A known, long-standing issue where resizing iTunes with Divvy causes the application to hang. (Official known issues)
- **Incompatible with certain browsers**: Orion browser windows do not respond to Divvy grid positioning. (Orion Issue Tracker)

### UX Frustrations

- **Nag screen in free version**: Persistent purchase reminder dialog disrupts workflow. (User reviews)
- **Learning curve**: The grid-based interface is initially confusing; not immediately intuitive how to define and use zones. (Hacker News)
- **Windows version appears abandoned**: WinDivvy has not received meaningful updates; unclear if it is still actively maintained. (Mizage website)

---

## 5. GridMove

### Abandoned / Unmaintained

- **Original project abandoned since 2018**: No updates from the original author (JGPaiva) since February 2018. (GitHub)
- **Community fork archived in 2024**: The mirtlecn fork was archived (read-only) in April 2024. (GitHub)
- **Does not work on Windows 11**: Users report the tool is non-functional on Windows 11. (SourceForge reviews)

### Known Bugs

- **Large gaps between tiled windows on Windows 10+**: Window borders changed in Windows 10, causing visible gaps between side-by-side windows that GridMove cannot compensate for. (GitHub issue #10)
- **Taskbar gap**: The smaller Windows 10 taskbar creates a gap between windows and the taskbar edge. (GitHub issue #17)
- **Cannot move admin-privileged windows**: GridMove (based on AutoHotkey) cannot interact with windows run as Administrator. (GitHub issues)
- **Chrome tab-click triggers snapping**: Clicking tabs in Chrome's upper-left corner activates GridMove's snap behavior instead of switching tabs. (GitHub issues)

---

## 6. bug.n

### Abandoned / Unmaintained

- **No longer actively developed**: The current stable version (v9) is effectively abandoned, with no active maintenance. (GitHub)
- **Written in AHK v1**: Uses AutoHotkey v1, which is now legacy; no port to v2 exists. (GitHub)

### Stability and Compatibility

- **Unusable on Windows 8.1**: Non-functional menus (Firefox, Wordpad), popups appearing in wrong positions, floating windows resizing or moving uncontrollably. (GitHub issue #49)
- **Windows 10 Start Menu broken**: Full-screen Start Menu only takes up slightly more than half the screen. (GitHub issue #229)
- **Chrome management failures**: Certain Chrome versions cannot be managed at all. (GitHub issue #1)
- **Gets slow over time**: Performance degrades during long-running sessions; requires periodic restart. (GitHub documentation)

### Multi-Monitor Issues

- **Taskbar popups in wrong positions on multi-monitor**: On Windows 8.1+ with external monitors, popup elements appear on the wrong screen. (GitHub issue #49)
- **Programs start on wrong monitor**: Windows sometimes launch on an unexpected monitor; shuffling/resizing is required to fix. (GitHub issues)

---

## 7. Komorebi

### Multi-Monitor Issues (Major Pain Point)

- **Layout mix-up with 3+ monitors**: Komorebi fails to properly recognize and map monitor arrangements, repeatedly confusing monitor IDs. (GitHub issue #1056)
- **Crashes with multi-monitor setups**: Reports of outright crashes when using more than one monitor. (GitHub issue #18, Komorebi-Fork)
- **Monitor hot-plug breaks everything**: Connecting or disconnecting monitors causes the bar to resize/disappear, windows to change size, workspaces to lose windows. Managed windows can become permanently unmanaged. (GitHub issues #1512, #267)
- **Inconsistent multi-monitor behaviors**: Window focus, movement, and workspace assignment behave differently across monitors. (GitHub issue #1053)

### Performance

- **CPU usage creeps up over time**: After prolonged use, fan speed increases and CPU usage rises 3-5%, persisting even after restarting Komorebi. (GitHub issue #862)
- **Animation lag**: New window animation has significant lag when animation is enabled. (GitHub issues)

### Application Compatibility

- **Cannot tile Zoom or Task Manager**: These applications are not recognized or managed by Komorebi. (GitHub issues)
- **Windows 11 Outlook (OLK.exe) not tiled properly**: The new Outlook app does not respond to tiling commands. (GitHub issue #1214)

### Architecture Limitation

- **No built-in hotkey system**: Komorebi requires a separate tool (whkd or AutoHotkey) for keybindings, adding configuration complexity and potential for conflicts. (Official documentation)

---

## 8. GlazeWM

### Crashes and Freezes

- **Freezes when switching workspaces**: GlazeWM becomes completely unresponsive; keybinds stop working; requires killing the process from Task Manager. (GitHub issue #1144)
- **Startup failures**: Fresh installations fail with an error about failing to execute 'zebar' due to default startup_commands in config.yaml. (GitHub issue #1147)

### Multi-Monitor / Sleep-Wake

- **Windows migrate to wrong monitor after sleep/wake**: In dual-monitor setups, windows on the main monitor move to new workspaces on the secondary monitor after lock/sleep cycles. (GitHub issue #907)
- **Windows Desktop conflict**: Switching between Windows virtual desktops causes all windows to collapse into a single monitor. (GitHub issue #1211)

### DPI Scaling

- **Wrong window sizes with mixed DPI scaling**: Using two monitors at different scales (e.g., 150% and 100%) causes windows to be incorrectly sized, especially at the border between monitors. Known bug in GlazeWM v3. (GitHub issue #661)
- **System apps consistently wrong size**: Task Manager, Registry Editor, and Task Scheduler always display at incorrect dimensions on secondary monitors. (GitHub issue #661)

### Hotkey / Input Conflicts

- **Win key combinations open Start Menu**: Using Win+[key] for workspace switching triggers the Start Menu due to a timing/race condition with the Win key release. (GitHub issue #1215)
- **Windows thumbnail preview steals focus**: Hovering over taskbar to view window previews causes the entire screen to show a focus border. (GitHub issue #978)

### Workspace Reliability

- **Programs open in wrong workspace after config reload**: Reloading the config multiple times causes programs to switch workspaces unexpectedly. (GitHub issue #773)

---

## 9. Workspacer

### Window Management Failures

- **Windows sometimes disappear entirely**: Particularly with UnityEngine and IntelliJ applications -- switching back to a workspace shows the windows are simply gone. (GitHub issue #207)
- **Windows fail to minimize on workspace switch**: When changing workspaces, windows from the previous workspace remain visible. (GitHub issues)
- **Workspacer disables itself randomly**: The tiling manager stops managing windows without user action or error messages. (GitHub issue #168)

### Application Compatibility

- **JetBrains suite causes visual glitches**: The entire window blanks out for milliseconds on every edit when using IdeaVim in JetBrains IDEs. (GitHub issues)
- **VS Code ignores Workspacer keybindings**: VS Code intercepts keybindings for switching windows or moving them to other workspaces. (GitHub issues)
- **WSLg windows not managed on Windows 11**: GUI windows from WSL are invisible to Workspacer. (GitHub issue #266)

### General Issues

- **Slow development velocity**: Users note that bugs persist for long periods without fixes. (Hacker News, GitHub)
- **Tight coupling between WM and keyboard config**: Configuration is frustrating because window management and hotkey configuration are intertwined with no separation of concerns. (Hacker News)
- **"Major bugs" acknowledged**: The official documentation itself acknowledges likely major unfixed bugs. (Official website)

---

## 10. MaxTo

### Startup and Stability

- **Fails to start; reports already running**: After reboot, MaxTo does not appear but claims it is already running when launched manually. No process visible in Task Manager. (GitHub issue #307)
- **Crashes related to virtual desktops**: Virtual desktop interactions cause crashes. (Release notes)
- **Missing regions after reboot**: Configured regions disappear after system restart. (Release notes)

### Performance

- **Unbearably slow window dragging**: A smoothing effect on window movement makes dragging painfully slow; the animation cannot keep up with hand speed. (GitHub issue #480)

### Windows 11 Compatibility

- **Maximize ignores regions on Windows 11**: Maximizing a window takes the full screen regardless of MaxTo region configuration. (GitHub issue #769)

### Administrative Privileges

- **Elevation does not work**: Attempting to run MaxTo with admin privileges fails silently; cannot manage elevated windows. (GitHub issues)

---

## 11. WindowGrid

### DPI and Display Issues

- **Grid transposed on portrait monitors**: The grid overlay is incorrectly oriented when a monitor is in portrait mode (Height > Width). (Official known issues)
- **Non-DPI-aware windows misplaced between monitors**: Moving windows between monitors with different DPI scaling causes positioning errors. (Official known issues)
- **Some Windows 10 windows display incorrectly**: Certain window types do not render properly with WindowGrid. (Changelog)

### Compatibility

- **Visual Studio crashes**: Moving floating windows in Visual Studio causes crashes. (Changelog)
- **Chrome tab tearing**: Hook-related issues cause tab-tearing glitches in Chrome. (Changelog)
- **Antivirus false positives**: WindowGrid32.dll may need to be whitelisted in antivirus software. (Official documentation)

### Project Status

- **Abandoned; does not work on Windows 11**: No updates in 5+ years. Users report it is non-functional on Windows 11. (SourceForge reviews)
- **Grid overlay has occasional delays**: The overlay does not always appear promptly when dragging. (User reports)

---

## 12. Moom

**Moom does not exist for Windows.** It is a macOS-only application. The developers have explicitly stated they have no plans to create a Windows version: "As for Moom on PCs, it's not something we'll ever do, as neither of us are Windows users." (Many Tricks blog)

No Windows-specific complaints exist because there is no Windows version.

---

## 13. Microsoft Snap Assist (Built-in Windows)

### Fundamental Limitations

- **No custom zones**: Users cannot create their own layout zones; limited to Microsoft's preset layouts (halves, thirds, quarters). Power users must use FancyZones for custom arrangements. (Windows Central, WindowsForum)
- **No per-app zone memory**: Cannot force an application to always launch in a specific zone or position. (WindowsForum)
- **Limited to 4 snapped windows on Win10**: Windows 10 Snap only supports up to 4 windows; Windows 11 improved with Snap Layouts but still has preset limitations.

### Ultrawide / Large Display Problems

- **Two-window split wastes space on ultrawide**: Snapping two windows side-by-side on a 49" ultrawide makes each window far too large; no built-in way to do 3-way or asymmetric splits. (Steam Community, DisplayFusion Forums)
- **No concept of "maximum useful size"**: Windows has no information about the max desired size of a window, so tiling on large displays gives each window more space than the content needs. (Hacker News, GNOME blog)

### Multi-Monitor Issues

- **No direct snap-to-external-monitor**: Windows must be physically dragged completely off the primary monitor before snapping on the external one. (Microsoft Q&A)
- **Inside edges between monitors not recognized as snap edges**: Snap only targets the outer desktop edge, not individual monitor boundaries in extended displays. (Microsoft Q&A)
- **Mixed DPI causes snap glitches**: Windows resize, jump, or disappear when snapping across monitors with different DPI scaling. (DisplayFusion Forums)

### UX Annoyances

- **Snap flyout is intrusive and hard to dismiss**: The top-of-screen flyout (Windows 11) appears when dragging windows to the top, disrupting natural drag behavior that power users have built over decades. (Windows Central)
- **Snap Assist cannot be partially disabled**: Users who want keyboard shortcuts (Win+Z) but not the drag flyout cannot disable one without the other. (ElevenForum)
- **Legacy apps and custom UI toolkits don't support Snap**: Some desktop apps prevent snapping or resizing entirely. (Microsoft developer docs)
- **Snap Groups unreliable**: Snap Groups (Windows 11) are supposed to remember window groupings but frequently fail to restore correctly, especially after sleep or app restarts.

---

## 14. Cross-Cutting Themes

These issues affect the majority of Windows tiling/window management tools:

### 14.1 Multi-Monitor Configuration is Fragile

Nearly every tool struggles with multi-monitor setups, especially:
- **Monitor hot-plugging** (dock/undock, DisplayPort disconnect): Windows scrambles all window positions; tools cannot reliably restore them. Affected: DisplayFusion, Komorebi, FancyZones, GlazeWM.
- **Monitor ID instability**: Windows assigns different IDs to monitors across reboots or configuration changes, causing layouts to apply to the wrong screen. Affected: FancyZones, Komorebi, GlazeWM, DisplayFusion.
- **Sleep/wake window migration**: Windows moves windows to remaining monitors during sleep; tools fail to move them back. Affected: FancyZones, GlazeWM, DisplayFusion.

### 14.2 DPI Scaling is a Universal Pain Point

- Mixed-DPI setups (e.g., 4K laptop + 1080p external) cause zone misalignment, incorrect window sizes, blurry UI elements, and positioning errors in virtually every tool tested.
- The underlying Windows APIs for display coordinates and DPI awareness are inconsistent, and most tools struggle to handle the translation correctly.
- Affected: FancyZones, GlazeWM, DisplayFusion, AquaSnap, WindowGrid, Komorebi.

### 14.3 Ultrawide / Super-Ultrawide Displays Are Poorly Served

- Built-in Windows Snap only offers basic 2-4 window splits that waste space on 49" displays.
- FancyZones zone creation maxes out prematurely on super-ultrawides at non-100% DPI.
- Most tools were designed for standard 16:9 displays and treat ultrawides as an afterthought.

### 14.4 Window State Persistence / Layout Restoration is Unreliable

- This is arguably the hardest problem in window management. Window handles change across sessions, applications may refuse to be resized/moved programmatically, and the Windows API provides no standard mechanism for it.
- FancyZones layout persistence has been broken in various ways across years of releases.
- DisplayFusion save/restore produces inconsistent results, especially across reboots.
- This is also a known bug in this project (HotKeyTiles/MosaicTiler F6 restore).

### 14.5 Application Compatibility is Unpredictable

- UWP apps, Electron apps, and apps run as Administrator each have different window management behaviors.
- Admin-privileged windows cannot be managed by non-elevated tools (affects GridMove, MaxTo, any AHK-based tool).
- Specific apps resist tiling: Zoom, Task Manager, JetBrains IDEs, Discord, Spotify, new Outlook (OLK.exe).
- Affected: Komorebi, FancyZones, Workspacer, GridMove, WindowGrid.

### 14.6 Performance Degradation Over Time

- Multiple tools exhibit memory leaks or increasing CPU usage during long sessions.
- Affected: DisplayFusion (system becomes unusable), bug.n (gets slow), Komorebi (CPU creep), Workspacer (intermittent).
- Common workaround: periodic restart of the window manager.

### 14.7 Updates Break Existing Configurations

- PowerToys/FancyZones updates frequently reset or corrupt saved layouts.
- DisplayFusion updates have lost user settings and monitor profiles.
- Windows OS updates break compatibility with third-party window managers.
- Affected: FancyZones, DisplayFusion, MaxTo.

### 14.8 Hotkey Conflicts and Input Issues

- Tools that use global hotkeys risk conflicts with applications, games, and accessibility software.
- The Win key is particularly problematic: using Win+[key] combos for workspace switching opens the Start Menu due to timing issues (GlazeWM, Komorebi).
- Keyboard-driven tiling managers have low discoverability for new users.

### 14.9 Abandoned Projects

- Several tools are effectively dead: GridMove (2018), bug.n (unmaintained), WindowGrid (5+ years), Divvy/WinDivvy (unclear status), Workspacer (slow development).
- Users adopting these tools risk depending on software that will never be fixed.
- The Windows tiling manager ecosystem has high project turnover; only FancyZones, Komorebi, GlazeWM, and DisplayFusion appear actively maintained as of 2026.

### 14.10 The Fundamental Windows Limitation

Windows was not designed as a tiling window manager OS. All tools are fighting against:
- The Desktop Window Manager (DWM) controlling window composition
- No standard API for workspace/virtual desktop management that third-party tools can reliably hook
- Window style flags and behaviors varying wildly across application frameworks (Win32, WPF, UWP, Electron, Qt, etc.)
- The Windows shell (explorer.exe) actively fighting to maintain its own window management behaviors

---

## Summary Table: Top Complaint Per App

| App | #1 Complaint |
|-----|-------------|
| FancyZones | Layout persistence broken across reboots/sleep (years-long bug) |
| AquaSnap | Multi-monitor features unreliable, especially with mixed DPI |
| DisplayFusion | Performance degrades to unusable levels over time |
| Divvy | Windows version appears abandoned; limited updates |
| GridMove | Abandoned since 2018; broken on Windows 10+ |
| bug.n | Abandoned; unusable on modern Windows versions |
| Komorebi | Multi-monitor setups crash or lose track of windows |
| GlazeWM | Freezes requiring Task Manager kill; sleep/wake scrambles layouts |
| Workspacer | Windows disappear; major acknowledged unfixed bugs |
| MaxTo | Window dragging unacceptably slow; startup failures |
| WindowGrid | Abandoned; broken on Windows 11 |
| Moom | No Windows version exists |
| Snap Assist | No custom zones; ultrawide displays poorly served |
