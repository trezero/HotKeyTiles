# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HotKeyTiles (aka MosaicTiler) is a single-file AutoHotkey v2 window management tool for Windows 10/11, designed for large displays (Samsung Odyssey 57"). It tiles, focuses, isolates, and persists window layouts via global hotkeys.

## Language & Runtime

- **AutoHotkey v2.0** (not v1 — syntax is significantly different)
- Single script: `MosaicTiler.ahk` — all logic lives here
- Run with: double-click the `.ahk` file (requires AHK v2 installed)
- No build step, no package manager, no tests

## Architecture

The script is organized into clearly labeled sections:

1. **Configuration** (top of file) — hotkeys, margin, focus size, excluded classes/processes
2. **Hotkey Registration** — binds F2-F6 to handler functions
3. **Core Functions**: `MosaicTile()`, `FocusMode()`, `IsolateApplication()`, `SaveLayout()`, `RestoreLayout()`
4. **Custom JSON class** — hand-rolled `JSON.Stringify()` and `JSON.Parse()` since AHK v2 has no built-in JSON support
5. **Layout Engine** — `CalculateBalancedLayout()` uses a grid algorithm (`Ceil(Sqrt(n))` columns)
6. **Window Enumeration** — `GetTileableWindows()` / `IsWindowTileable()` filters by style flags, class, process
7. **Tray Menu** — system tray icon with menu items mirroring hotkey actions

Key design patterns:
- Global `hiddenWindows` array tracks windows hidden by F4 isolation; F2 restores them
- Layout persistence uses `saved_layout.json` in the script directory
- All window operations wrapped in `try/catch` for resilience against windows closing mid-operation

## Known Bug

**F6 Restore Layout is broken.** The custom `JSON.Stringify()` serializes integers correctly, but `JSON.Parse()` may fail with "Expected a Number but got a String" on restore. The root cause is in the JSON class implementation. See README.md "Known Issues" section for details and attempted fixes.

## Hotkey Map

| Key | Function | Description |
|-----|----------|-------------|
| F2 | `MosaicTile()` | Tile all windows in balanced grid |
| F3 | `FocusMode()` | Center active window at 70% screen |
| F4 | `IsolateApplication()` | Hide all windows except active app's |
| F5 | `SaveLayout()` | Save window positions to JSON |
| F6 | `RestoreLayout()` | Restore saved layout (currently broken) |
