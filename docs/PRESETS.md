# Grok-v1 preset changes

Baseline date: 2026-09-17  
Printer: AnkerMake M5, firmware v3, **0.8 mm all-metal** hotend  
Slicer: OrcaSlicer 2.4.2 via ankerctl (`localhost:4470`)  
Material: unnamed PETG (flow 1.015, claimed MVS 43 mm³/s)

Originals were **not** edited. They live in [`originals/`](../originals/) for diffing. Grok-v1 copies live in [`presets/v1/`](../presets/v1/).

When you refine, bump to `presets/v2/` (or edit v1 and log it here). Do not save over the Tweak originals until a cube beats them.

---

## Why the old stack lost to a Flashforge Finder

Three independent problems stacked:

1. **Start G-code** heated PETG to print temp, then Anker skip-`G28` tapped the nozzle in the **center of the bed** and purged at **Z=0.3**. That is the scrape and the center artifact.
2. **Filament** was named PETG but inherited **SUNLU PLA+**, so cooling was 100% fan and 1 s layer time. Pressure advance **0.02 was only in the name** — the JSON had no `pressure_advance` key.
3. **Process** ran everything at 30 mm/s, travel 1000 (machine max 600), lightning infill, supports on with a **1°** threshold, aligned-back seam, 2 walls, no skirt, 0.4 mm first layer on a 0.25 mm profile.

---

## Printer — `Grok-v1-Anker-M5`

Fork of `Tweak G-code Anker M5 All-Metal 0.8 nozzle`  
File: [`presets/v1/machine/Grok-v1-Anker-M5.json`](../presets/v1/machine/Grok-v1-Anker-M5.json)  
Inherits system: `Anker M5 All-Metal 0.6 nozzle` (Orca 2.4.2 will not load a user preset that inherits another user preset)

Unchanged: 0.8 mm nozzle, `localhost:4470`, ZV input shaping, `M83` skip of firmware wipe + 3-point, `M420 S1` mesh restore, `LAYER_COUNT` marker.

| Setting | Original Tweak | Grok-v1 | Why |
|---------|----------------|---------|-----|
| Nozzle at `G28` | Full first-layer temp (230 °C PETG) | **165 °C**, then `M109` after moving to the left edge | Center Z-tap must not dump molten PETG |
| Retract before home | 15 mm | **1.5 mm** | 15 mm on all-metal 0.8 is a clog risk |
| After home | XY move / purge at Z 0.3 | **Lift Z 10 immediately** | Stops scrape after the tap |
| Mesh fade | `M420 Z15` | `M420 Z10` | Fade starts closer to the part |
| Purge | X=-2, Z=0.3, two lines | **X=2 and 3.2, Z=0.40**, E32+E36 | 0.3 mm is too low for 0.8 mm; stay on the printable left margin |
| After purge | Retract 1 mm, Z8, X5 Y20 | Retract **0.8 mm**, Z8, **X12 Y25** | Park off the purge lines, not over center |
| End G-code | `G28 X0 Y0` | **Park X5 Y220**, no XY home | No drag back across the part |
| Min layer height | 0.18 mm | **0.16 mm** | Allows 0.20 mm Super Quality |

**Still expected:** one center **tap** at start. That is Anker skip-G28 single-point home. It must not smear or grind.

**Once after a nozzle change:** Auto-Level on the printer screen. Skip-G28 does not build a new mesh; `M420` only reloads what is saved.

If 3-point leveling still runs, this firmware is ignoring `M83`. Do not add more start G-code until that is confirmed.

---

## Filament — `Grok-v1-0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG`

Fork of `0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG @System`  
File: [`presets/v1/filament/Grok-v1-0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG.json`](../presets/v1/filament/Grok-v1-0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG.json)

Kept from calibration: flow **1.015**, MVS **43**, nozzle **230 °C**.

| Setting | Original | Grok-v1 | Why |
|---------|----------|---------|-----|
| Parent | `SUNLU PLA+ @System` | **`Anker Generic PETG`** | PLA parent forced 100% fan onto PETG |
| Compatible printers | 0.6 mm All-Metal only | Grok-v1-Anker-M5 + both 0.8 mm user printers | Otherwise Orca hides it (`show_unsupported_presets` is off) |
| Pressure advance | Enabled, **K missing** | **K = 0.02** | Name said 0.02; JSON did not |
| Fan min / max | 100 / 100 (PLA) | **25 / 45** | PETG layer bonding |
| Fan off first N layers | 1 | **3** | First layers need heat |
| Full fan layer | 0 | **5** | Ramp, do not slam |
| Overhang fan | 100% | **50% at 50% overhang** | Less shock-cooling |
| Slow-down layer time | **1 s** | **8 s** | Small features get cooling time |
| Slow-down min speed | inherited | **15 mm/s** | |
| Bed | 70 first / 65 other | **75 / 70** | Slightly more PETG adhesion on 0.8 mm |
| First-layer nozzle | 230 | **235**, then 230 | Better first-layer flow |
| Retraction | printer 0.5 mm @ 60 | **1.0 mm @ 30**, unretract 30 | PETG on direct drive |
| Wipe | printer default | **on, 2 mm, 70% retract-before-wipe** | |
| Z-hop | 0 | **0.2 mm slope lift** | Less scars / travel stringing |
| Vitrification | PLA 54–60 | **85** | PETG |

If Super Fast looks pale or underextruded, raise **this filament** to 240–245 °C for that cube only. Do not raise speed first — 230 °C is sized for Quality/Medium melt time.

---

## Process — three forks of `Tweak Bredd+120% Slow 0.25mm 0.8mm nozzle @Anker`

All three inherit system `0.35mm Draft 0.6mm nozzle @Anker` (same Orca parent rule as the printer).

### Shared vs original

| Setting | Original Tweak 0.25 mm | All Grok-v1 processes |
|---------|------------------------|------------------------|
| Supports | On, tree, **1°** | **Off**, threshold **30°** |
| Skirt | 0 | **2 loops** |
| Travel speed | **1000 mm/s** | 300 / 400 / 500 (machine max 600) |
| Seam | aligned_back, 5% gap | nearest or back, 8–10% gap, scarf kept |
| Wall generator | inherited | **classic** |
| Elephant foot | inherited 0.2 | 0.15 / 0.15 / 0.12 |
| Compatible printers | 0.6 mm system list | Grok-v1-Anker-M5 + 0.8 mm user printers |

### Super Quality — `Grok-v1-Super Quality 0.20mm 0.8mm @Anker`

First cube. 0.20 mm is 25% of a 0.8 mm nozzle.

| | Original | Super Quality |
|--|----------|----------------|
| Layer / first | 0.25 / 0.40 | **0.20 / 0.28** |
| Line width (default / outer / inner) | 120 / 110 / 120 | **105 / 100 / 105** |
| Walls / top / bottom | 2 / 4 / 4 | **3 / 5 / 5**, one-wall top |
| Speeds outer / inner / infill / top / first / travel | 30 / 30 / 30 / 30 / 50 inh. / 1000 | **40 / 60 / 70 / 35 / 25 / 300** |
| Accel default / outer / travel | 1000 / 1000 / 1000 | **1200 / 500 / 2500** |
| Infill | lightning | **20% gyroid** |
| Seam | aligned_back | **nearest** + scarf all |
| Precise outer / avoid crossing | inherited on | **on** |

### Medium — `Grok-v1-Medium 0.28mm 0.8mm @Anker`

Daily driver. Closest in height to the old 0.25 mm profile.

| | Original | Medium |
|--|----------|--------|
| Layer / first | 0.25 / 0.40 | **0.28 / 0.32** |
| Line width | 120 / 110 / 120 | **115 / 110 / 115** |
| Walls / top / bottom | 2 / 4 / 4 | **3 / 4 / 4** |
| Speeds outer / inner / infill / top / first / travel | 30 all / 1000 | **60 / 90 / 110 / 50 / 30 / 400** |
| Accel default / outer / travel | 1000 | **1800 / 800 / 3000** |
| Infill | lightning | **15% gyroid** |
| Seam | aligned_back | **back** + scarf all |

### Super Fast — `Grok-v1-Super Fast 0.48mm 0.8mm @Anker`

Speed, melt-limited. At 0.48 × 1.20 × 0.8 mm the 43 mm³/s cap is ~90 mm/s, so inner/infill sit at 90.

| | Original | Super Fast |
|--|----------|------------|
| Layer / first | 0.25 / 0.40 | **0.48 / 0.40** |
| Line width | 120 / 110 / 120 | **120 / 115 / 120** |
| Walls / top / bottom | 2 / 4 / 4 | **2 / 3 / 3** |
| Speeds outer / inner / infill / top / first / travel | 30 all / 1000 | **80 / 90 / 90 / 70 / 35 / 500** |
| Accel default / outer / travel | 1000 | **3000 / 1500 / 4000** |
| Infill | lightning | **10% grid** |
| Precise outer / avoid crossing | on | **off** |
| Scarf | all | **contour only** |

---

## Versioning for the next pass

| Version | When to cut it |
|---------|----------------|
| v1 | Baseline cubes, start G-code + PETG cooling |
| v2 | After Super Quality cube: Z-offset / flow / PA only if evidence |
| v3 | After Medium and Super Fast cubes |

Keep JSON filenames and Orca `name` fields identical. Orca matches on `name`, not folder.

Suggested commit message style:

```
v2 Super Quality: PA 0.02 -> 0.025 after corner blobs on 20mm cube
```
