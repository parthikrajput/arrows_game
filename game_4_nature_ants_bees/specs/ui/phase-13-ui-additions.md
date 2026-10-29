# Spec: Phase 13 UI Additions — Mystery Meadow HUD & Tutorial Cards

Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 UI Additions — Mystery Meadow HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define all new fog overlay shaders, reconnaissance radar badges, false wall inspection markers, tutorial cards, and accessibility enhancements required for Mystery Meadow (Scout Ant, Mirage Mist, Painted Pebble, and Sunlit Plate).

---

## Current State

Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md`, not yet implemented.

---

## Proposed Change

### 1. Volumetric Fog Shader Overlay
- Semi-transparent, animated morning fog shader ($40\%$ base opacity) obscuring unrevealed board tiles.
- In low-motion mode, dynamic drifting particles are disabled; a static soft-edged cloudy texture mask is displayed.

### 2. Scout Ant Radar Rings (M601)
- Scout Ants permanently display a soft pulsing sonar ring around their head antenna.
- Communicates to the player that this line serves as a reconnaissance unit.

### 3. Painted Pebble Inspection Glyphs (M603)
- When using Scent Trail Preview (long-press 350 ms) targeting a Painted Pebble, an amber "?" badge hovers above the stone, indicating it is passable.
- Screen-reader announce: "Painted Pebble: illusionary wall, safe to pass".

### 4. Sunlit Plate Crosshairs HUD (M604)
- When an ant steps onto a Sunlit Plate, glowing golden grid-lines trace its entire row and column, displaying the illuminated reveal zone.
- Uncovered lines within this crosshair highlight with a bright white silhouette.

### 5. Tutorial Overlay Cards
Displayed once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L6001 | Mystery Meadow | "Morning fog hides garden paths. Send scouts to clear the way!" |
| L6011 | Scout Ant | "When this insect exits, it clears all fog within 2 tiles of its path." |
| L6131 | Mirage Mist | "Looks like plain grass, but passing nearby blankets the area in fog." |
| L6251 | Painted Pebble | "An optical illusion! Insects pass right through without bumping." |
| L6371 | Sunlit Plate | "Stand an ant on this plate to illuminate its whole row and column." |

### 6. Phase 13 World Map Entry
- New chapter entry "Mystery Meadow" unlocks on world map when `maxPhase ≥ 13`.
- Chapter icon: lantern-lit morning clover shrouded in soft mist.

---

## Acceptance Criteria
- [ ] Fog overlay conceals untappable lines clearly while maintaining board aesthetics.
- [ ] Scout Ant radar pulses distinctly identify reconnaissance lines.
- [ ] Painted Pebbles display "?" icon under Scent Trail Preview.
- [ ] Sunlit Plate highlights active orthogonal row/col corridors clearly.
- [ ] All 5 tutorial cards fire once on intro levels and suppress on replays.
- [ ] Visual elements pass WCAG 2.1 AA contrast requirements against misted tiles.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/fog_shader_widget.dart` | To be created |
| `packages/ui/lib/hud/scout_radar_overlay.dart` | To be created |
| `packages/ui/lib/hud/painted_pebble_inspector.dart` | To be created |
| `packages/ui/lib/hud/sunlit_plate_crosshair.dart` | To be created |
| `packages/ui/lib/tutorial/phase_13_cards.dart` | To be created |
| `assets/phase_13/ui/` | To be created |

---

## Risks and Open Questions

1. **Fog Mask Texture Aliasing:** Sharp rectangular transitions on 14×14 tiles can look harsh; soft bilinear falloff at Chebyshev boundary edges is required for high visual polish.
