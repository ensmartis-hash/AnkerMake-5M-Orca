# AnkerMake 5M Orca

OrcaSlicer profiles for an **AnkerMake M5** with an **0.8 mm all-metal** hotend, sliced in Orca 2.4.x and sent through [ankerctl](https://github.com/ensmartis-hash/ankermake-m5-protocol-windows-v3) (`localhost:4470`).

This repo is the working copy we refine after each test cube. Originals stay in `originals/`. Active profiles are `presets/v1/`.

| Slot | Grok-v1 preset |
|------|----------------|
| Printer | `Grok-v1-Anker-M5` |
| Filament | `Grok-v1-0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG` |
| Quality | `Grok-v1-Super Quality 0.20mm 0.8mm @Anker` |
| Daily | `Grok-v1-Medium 0.28mm 0.8mm @Anker` |
| Speed | `Grok-v1-Super Fast 0.48mm 0.8mm @Anker` |

Full before/after tables: **[docs/PRESETS.md](docs/PRESETS.md)**  
Cube notes: **[docs/TEST-LOG.md](docs/TEST-LOG.md)**

---

## Machine

| | |
|--|--|
| Printer | AnkerMake M5 (i3, 235 × 235 × 250 mm) |
| Firmware | v3 |
| Hotend | All-metal, **0.8 mm** nozzle |
| Material in v1 | unnamed PETG, 230 °C, flow 1.015, PA 0.02, MVS 43 mm³/s |
| Host | OctoPrint-compatible ankerctl on `localhost:4470` |

---

## Install into Orca

Orca must be **fully quit**. Cloud user-preset sync must be **off**, or Orca deletes local JSON that is not in the cloud library (that is why the first Grok-v1 drop vanished).

```powershell
# optional: confirm sync is off
# OrcaSlicer.conf -> "sync_user_preset": false

cd $env:USERPROFILE\AnkerMake-5M-Orca
powershell -File .\scripts\install-to-orca.ps1
```

Or: **File → Import → Import configs** and select the `presets/v1/machine`, `filament`, and `process` JSON files.

Then reopen Orca. Printer dropdown: look under Anker / All-Metal (it is a 0.8 mm printer). After `Grok-v1-Anker-M5` is selected, filament and process appear (incompatible presets are hidden).

Save each preset once from the Orca disk icon if you want to turn cloud sync back on later.

---

## What v1 actually changed

Short version — details in [docs/PRESETS.md](docs/PRESETS.md):

1. **Start G-code** — home at 165 °C so the Anker center Z-tap does not smear PETG; lift immediately; purge on the **left edge at Z 0.40**, never in the center; park at the back at end instead of `G28 X0 Y0`.
2. **Filament** — stop inheriting PLA+. Real PETG cooling (25–45% fan, first 3 layers off), PA **0.02 actually written**, retract 1.0 mm @ 30 mm/s, bed 75/70, first-layer nozzle 235.
3. **Process** — three jobs from the old 0.25 mm “slow” profile: 0.20 mm quality, 0.28 mm medium, 0.48 mm fast. Supports off, skirt on, gyroid/grid instead of lightning, travel capped to 300–500 mm/s, 3 walls on quality/medium.

---

## How we refine from here

1. Print a 20–25 mm cube with **Super Quality**. Watch start (one tap, left purge, no center blob).
2. Log the cube in [docs/TEST-LOG.md](docs/TEST-LOG.md).
3. One change at a time, in this order: Z-offset → flow → PA → fan → Super Fast temperature.
4. Copy `presets/v1/` to `presets/v2/` when the change is worth keeping. Commit the JSON **and** a PRESETS.md note.

Orca 2.4.2 rule: a user preset must `inherits` a **system** profile (`Anker M5 All-Metal 0.6 nozzle`, `Anker Generic PETG`, `0.35mm Draft 0.6mm nozzle @Anker`). Inheriting another user preset (`Tweak G-code…`, `Tweak Bredd+…`) makes Orca drop the file on load.

---

## Repo layout

```
presets/v1/          Grok-v1 JSON (machine / filament / process)
originals/           The three Tweak / 0.15FLOW presets we forked
docs/PRESETS.md      Full change tables
docs/TEST-LOG.md     Cube results
scripts/install-to-orca.ps1
```
