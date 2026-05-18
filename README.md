# qq-screenshot-skill

A reusable Windows/OpenClaw skill for capturing **fresh desktop screenshots for QQ replies**, with optional **labeled grid overlays** for click guidance.

This repository is now packaged as a **more complete open-source version**:

- less machine-specific
- includes a bundled grid overlay generator
- includes a bundled default system capture helper
- supports fallback behavior
- usable both inside and outside OpenClaw

---

## Features

- Capture the current Windows desktop
- Return OpenClaw-friendly `MEDIA:<path>` output
- Support multiple capture modes:
  - `system`
  - `pil`
  - `gdi`
- Support screen target selection:
  - `primary`
  - `secondary`
  - `all`
- Support **standard labeled grid screenshots**
- Automatically prune old screenshots

---

## Repository structure

```text
qq-screenshot-skill/
├─ LICENSE
├─ SKILL.md
├─ README.md
└─ scripts/
   ├─ capture-qq.ps1
   ├─ capture-screen.ps1
   └─ make-grid.py
```

---

## Requirements

- Windows
- PowerShell
- Python 3
- Pillow

Install Pillow:

```powershell
pip install pillow
```

---

## Quick start

### 1. Clone the repository

```powershell
git clone https://github.com/besam168/qq-screenshot-skill.git
cd qq-screenshot-skill
```

### 2. Normal screenshot

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1
```

### 3. Grid screenshot

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Grid -GridPreset quarter
```

### 4. Return raw path instead of `MEDIA:<path>`

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -NoMedia
```

---

## Parameters

### `capture-qq.ps1`

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `-OutputDir` | string | `./qq-screenshots` | Output folder |
| `-NoMedia` | switch | off | Return raw path instead of `MEDIA:<path>` |
| `-Method` | enum | `system` | Capture method: `system`, `pil`, `gdi` |
| `-Screen` | enum | `primary` | Target screen: `primary`, `secondary`, `all` |
| `-KeepCount` | int | `50` | Max number of screenshots to keep |
| `-Grid` | switch | off | Generate labeled grid screenshot |
| `-GridPreset` | enum | `quarter` | Grid preset: `quarter`, `six` |
| `-SystemCaptureScript` | string | empty | Optional path to a helper PowerShell script that supports `-UseSystemScreenshot -OutputPath ...` |

---

## Capture modes

### 1) `system`
This repository now bundles a default helper:

- `scripts/capture-screen.ps1`

So the default `system` mode can run without depending on another private skill directory.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method system
```

You can still override it with your own helper:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method system -SystemCaptureScript C:\path\to\capture-screen.ps1
```

If the helper script is missing or fails, the skill falls back to `gdi` capture.

### 2) `pil`
Uses Python Pillow `ImageGrab`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method pil
```

### 3) `gdi`
Uses Windows GDI / `CopyFromScreen`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method gdi
```

---

## Screen targeting

### Primary screen

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Screen primary
```

### Secondary screen

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Screen secondary
```

### All screens

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Screen all
```

---

## Grid screenshot mode

Use grid screenshots when you need click guidance or coordinate-style desktop navigation.

### Standard preset

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Grid -GridPreset quarter
```

### Larger preset

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Grid -GridPreset six
```

### Current grid style

- row-major labels
- first row: `A1 A2 A3 ...`
- second row: `B1 B2 B3 ...`
- red grid lines
- white label boxes
- red label text

---

## Output behavior

Normal screenshot filename pattern:

```text
qq-screenshot_YYYYMMDD_HHMMSS_fff.png
```

Grid screenshot filename pattern:

```text
qq-grid_YYYYMMDD_HHMMSS_fff.png
```

By default the script keeps the newest 50 screenshot files and prunes older ones.

---

## OpenClaw usage

This repository is suitable for OpenClaw skill usage because it returns:

```text
MEDIA:<absolute-path>
```

Suggested user intent mapping:

- `截图` -> normal screenshot
- `网格截图` -> labeled grid screenshot

To use it as an OpenClaw skill, keep:
- `SKILL.md`
- `scripts/capture-qq.ps1`
- `scripts/capture-screen.ps1`
- `scripts/make-grid.py`

---

## Standalone usage

You can also use this outside OpenClaw as a plain Windows screenshot utility.

Examples:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -NoMedia
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture-qq.ps1 -Method gdi -Screen secondary -NoMedia
```

---

## Portability notes

This public version is more reusable than the earlier machine-bound version because it now includes:

- local bundled `make-grid.py`
- local bundled `capture-screen.ps1`
- no hardcoded OpenClaw workspace path for the grid script
- optional override for a custom system capture helper
- default output directory relative to current working directory

---

## License

This project is released under the MIT License. See `LICENSE`.
