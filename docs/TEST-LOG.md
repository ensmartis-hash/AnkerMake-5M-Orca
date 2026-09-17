# Test log

Print a 20–25 mm cube, no supports, placed left-center of the bed (not on X=0–5, that is the purge lane). One change at a time after the baseline cubes.

## Stack for every cube

| Slot | Preset |
|------|--------|
| Printer | `Grok-v1-Anker-M5` |
| Filament | `Grok-v1-0.15FLOW.0.02PA.230C.MX.VL.SP43MMS.PETG` |
| Process | Super Quality / Medium / Super Fast (one at a time) |

Watch the start: one center Z-tap at ~165 °C, nozzle lifts, purge only on the left edge, then the cube. No puddle in the middle.

## Results

### YYYY-MM-DD — Super Quality 0.20 mm

- Start: scrape y/n · center blob y/n
- First layer: too high / good / too low
- Walls: …
- Seam: …
- Stringing: …
- Notes:
- Next change:

### YYYY-MM-DD — Medium 0.28 mm

- Start: scrape y/n · center blob y/n
- First layer: too high / good / too low
- Walls: …
- Notes:
- Next change:

### YYYY-MM-DD — Super Fast 0.48 mm

- Start: scrape y/n · center blob y/n
- First layer: too high / good / too low
- Underextrusion / pale walls: y/n (if yes, try 240–245 °C on filament, not more speed)
- Notes:
- Next change:

## Ranked next knobs (do not stack)

1. Z-offset on the printer screen if first layer is wrong — not flow.
2. Flow ±0.01 if walls are fat/skinny after Z is right.
3. PA ±0.005 if corners blob or gap.
4. Fan ±5–10% if layers weak or glossy/stringy.
5. Super Fast temp 240–245 if pale or underextruded at 230 °C.
