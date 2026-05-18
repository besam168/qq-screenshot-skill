---
name: qq-screenshot
description: Capture a fresh Windows desktop screenshot for QQ replies on Windows. Use when the user asks for 截图、截屏、桌面图、当前屏幕、最新桌面. Supports primary/secondary/all screens, optional labeled grid screenshots for click guidance, screenshot pruning, and returns MEDIA:<path> for OpenClaw media replies.
---

# qq-screenshot

Use this skill when the user wants a **fresh Windows desktop screenshot sent back in QQ**.

## What this skill does
- Capture the current Windows desktop
- Support `primary` / `secondary` / `all` screen targets
- Support `system`, `pil`, and `gdi` capture modes
- Support a **standard grid screenshot** mode for click guidance
- Save each screenshot with a new filename
- Prune old screenshots automatically
- Return `MEDIA:<path>` for direct OpenClaw media reply

## Default behavior
- Output folder: `./qq-screenshots` under the current working directory
- Capture target: `primary`
- Default method: `system`
- Fallback when `system` capture is unavailable or stale: `gdi`
- Output filename: `qq-screenshot_YYYYMMDD_HHMMSS_fff.png`
- Grid screenshot filename: `qq-grid_YYYYMMDD_HHMMSS_fff.png`
- Return format: `MEDIA:<absolute-path>`
- Auto-prune: keep the newest 50 screenshot files by default
- Standard grid preset: `quarter`

## How to use
Run the bundled PowerShell script:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1
```

### Useful options
#### Force PIL capture
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Method pil
```

#### Force GDI capture
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Method gdi
```

#### Use system screenshot helper explicitly
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Method system -SystemCaptureScript <path-to-capture-screen.ps1>
```

#### Capture the secondary display
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Screen secondary
```

#### Capture all displays
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Screen all
```

#### Standard grid screenshot
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File {baseDir}/scripts/capture-qq.ps1 -Method system -Grid -GridPreset quarter
```

## Grid screenshot standard
Use this when the user needs click guidance or coordinate-style desktop navigation.

Current standard:
- `quarter` preset
- square-like small cells
- row-major labels
- first row: `A1 A2 A3 ...`
- second row: `B1 B2 B3 ...`
- red grid lines + white label box + red text

Optional larger preset:
- `six`

## Reuse notes
This repository is now structured as a reusable public version:
- The grid overlay script is bundled locally as `scripts/make-grid.py`
- The main script resolves local bundled paths instead of machine-specific workspace paths
- If you have your own system screenshot helper, pass it via `-SystemCaptureScript`
- If no system helper is provided or it fails, the script falls back to `gdi`

## Requirements
- Windows
- PowerShell
- Python
- Pillow (`pip install pillow`)

## Intent mapping
- User says `截图` → normal screenshot
- User says `网格截图` → labeled grid screenshot
