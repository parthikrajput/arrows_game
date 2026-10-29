# Spec: Phase 14 UI Additions — Reflecting Pond HUD & Tutorial Cards

Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 UI Additions — Reflecting Pond HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define all new water mirror shaders, mirrored line target highlights, inverted direction badges, tutorial cards, and accessibility enhancements required for Reflecting Pond (Pond Axis, Reflection Lock, Twin Pond, and Upside-Down Line).

---

## Current State

Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md`, not yet implemented.

---

## Proposed Change

### 1. Pond Axis Water Shader
- Shimmering cerulean water axis rendering across the board center with gentle 1.5 Hz sine-wave ripples (`p14_water_ripple_hz = 1.5`).
- In low-motion mode, dynamic water wave displacement is disabled; a static translucent blue divider strip is shown.

### 2. Mirrored Twin Target Highlight
- Touching or hovering over any line instantly illuminates its mirrored twin on the opposite shore with a matching cerulean aura glow.
- When dragging, both projected scent trails render synchronously across the axis.

### 3. Upside-Down Line Inversion Marker (M654)
- Upside-Down Lines display an animated water whirlpool pattern across body segments and a distinct reverse chevron emblem on the carapace ("Runs in reverse").
- Screen-reader announce: "Upside-Down Line: moves in reverse direction".

### 4. Twin Pond Split HUD Indicator (M653)
- For twin-pond stages, top bar displays dual aquatic crests ("Pond 1" and "Pond 2"), flashing cyan whenever synchronized taps process.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L6501 | Reflecting Pond | "The calm water reflects your moves. Tapping one insect moves its twin!" |
| L6511 | Pond Axis | "Move insects across the mirror axis. Both twins must reach exit safely." |
| L6631 | Reflection Lock | "Unlocked only when the key insect on the opposite side of the pond escapes." |
| L6751 | Twin Pond | "Dual ponds receive taps simultaneously. Balance both garden shores!" |
| L6871 | Upside-Down Line | "Optical illusion! This insect moves opposite to where its head is facing." |

### 6. Phase 14 World Map Entry
- New chapter entry "Reflecting Pond" unlocks on world map when `maxPhase ≥ 14`.
- Chapter icon: twin water lilies reflected across a calm sapphire pond.

---

## Acceptance Criteria
- [ ] Pond Axis water shader animates smoothly without dropping frames.
- [ ] Mirrored twin highlight immediately illuminates when primary line is touched.
- [ ] Upside-Down Line clearly communicates inverted direction with reverse chevron glyph.
- [ ] All 5 tutorial cards fire once on intro levels and suppress on replays.
- [ ] Color-blind accessibility modes provide distinct geometric markers on mirrored twin pairs.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/pond_axis_shader.dart` | To be created |
| `packages/ui/lib/hud/mirrored_twin_highlighter.dart` | To be created |
| `packages/ui/lib/hud/upside_down_line_badge.dart` | To be created |
| `packages/ui/lib/hud/twin_pond_hud.dart` | To be created |
| `packages/ui/lib/tutorial/phase_14_cards.dart` | To be created |
| `assets/phase_14/ui/` | To be created |

---

## Risks and Open Questions

1. **Dual Trajectory Clarity:** Projecting two simultaneous scent trails on crowded boards may clutter the display. Alpha blending and color coding must maintain clear visual hierarchy.
