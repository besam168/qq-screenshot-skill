# qq-screenshot-skill

A Windows/OpenClaw skill for capturing **fresh desktop screenshots for QQ replies**, with optional **standard grid overlay** for click guidance.

This repository is the GitHub-published version of the `qq-screenshot` skill currently used in OpenClaw.

---

## What it does

- Capture the current Windows desktop
- Return a QQ-sendable `MEDIA:<path>` result for OpenClaw
- Support multiple capture methods:
  - `system` - preferred default on this machine
  - `pil`
  - `gdi`
- Support selecting display target:
  - `primary`
  - `secondary`
  - `all`
- Support **standard grid screenshot** mode for click guidance
- Automatically prune old screenshot files

---

## Repository structure

```text
qq-screenshot-skill/
├─ SKILL.md
└─ scripts/
   ├─ capture-qq.ps1
   └─ make-grid.py
```

- `SKILL.md` - skill metadata and OpenClaw-facing instructions
- `scripts/capture-qq.ps1` - main screenshot entry script
- `scripts/make-grid.py` - standard grid overlay generator

---

## Default behavior

Current defaults:

- Output directory:
  `C:\Users\besam\.openclaw\workspace\qq-screenshots`
- Default capture method:
  `system`
- Default display target:
  `primary`
- Standard grid preset:
  `quarter`
- Auto-prune:
  keep newest 50 screenshots by default

Output filenames:

- Normal screenshot:
  `qq-screenshot_YYYYMMDD_HHMMSS_fff.png`
- Grid screenshot:
  `qq-grid_YYYYMMDD_HHMMSS_fff.png`

---

## Usage

### 1. Normal screenshot

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1
```

### 2. Force system screenshot path

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method system
```

### 3. Force PIL capture

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method pil
```

### 4. Force GDI capture

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method gdi
```

### 5. Capture secondary screen

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Screen secondary
```

### 6. Capture all screens

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Screen all
```

### 7. Standard grid screenshot

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method system -Grid -GridPreset quarter
```

### 8. Return raw file path instead of MEDIA output

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -NoMedia
```

---

## Parameters

### `capture-qq.ps1`

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `-OutputDir` | string | `C:\Users\besam\.openclaw\workspace\qq-screenshots` | Output folder |
| `-NoMedia` | switch | off | Output raw path instead of `MEDIA:<path>` |
| `-Method` | enum | `system` | Capture method: `system`, `pil`, `gdi` |
| `-Screen` | enum | `primary` | Target screen: `primary`, `secondary`, `all` |
| `-KeepCount` | int | `50` | Max number of screenshot files to keep |
| `-Grid` | switch | off | Generate labeled grid screenshot |
| `-GridPreset` | enum | `quarter` | Grid preset: `quarter`, `six` |

---

## Standard grid screenshot spec

This repository now follows a **standardized grid screenshot format** intended for QQ click guidance.

### Current standard

- Preset: `quarter`
- Small square-like cells
- Row-major labeling
- Labels look like:
  - first row: `A1 A2 A3 ...`
  - second row: `B1 B2 B3 ...`
- Approximate baseline cell size:
  around `40px`
- Visual style:
  red grid lines + white label box + red text

### Use case

This is intended for:

- button positioning
- remote click guidance
- desktop coordination
- screenshot-based operator instructions

---

## Dependencies

### PowerShell side

- Windows PowerShell / PowerShell with permission to run local script

### Python side

`make-grid.py` requires Pillow:

```powershell
pip install pillow
```

The PIL capture route also depends on Pillow.

---

## How the capture methods work

### `system`
Preferred default on this machine.

This route delegates to a companion script from another local skill:

- `skills/telegram-image-sender/scripts/capture-screen.ps1`

If the system screenshot route does not produce a valid fresh image, the script falls back to `gdi` capture.

### `pil`
Uses Python `PIL.ImageGrab`.

### `gdi`
Uses Windows GDI / `CopyFromScreen`.

---

## Notes

- This repository is designed around a Windows + OpenClaw environment.
- Some paths are machine-specific and may need adjustment before reuse on another machine.
- The current implementation expects the OpenClaw workspace layout used by the author.

---

## Recommended OpenClaw usage

User intent mapping:

- User says `截图` -> return normal screenshot
- User says `网格截图` -> return standard grid screenshot

---

## Version direction

Compared with earlier public versions, this version includes:

- standardized grid screenshot behavior
- dedicated `make-grid.py` script
- cleaner long-term format for QQ click guidance
- pruning logic that covers both normal and grid screenshots

---

## License

Add a license if you want to make redistribution terms explicit.
