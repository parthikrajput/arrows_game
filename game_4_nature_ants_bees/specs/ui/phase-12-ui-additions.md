# Spec: Phase 12 UI Additions — Falling Leaves HUD & Tutorial Cards

Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 UI Additions — Falling Leaves HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define all new HUD widgets, compass visualizers, anti-gravity aura badges, tutorial cards, and accessibility enhancements required for Falling Leaves (Wind-Vane Lever, Falling Acorns, Dandelion Puff Tile, and Heavy Beetle Line).

---

## Current State

Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md`, not yet implemented.

---

## Proposed Change

### 1. Global Gravity Compass HUD
- Top-right corner displays a golden brass weather-vane compass dial.
- Clearly indicates the active gravity vector $\vec{g}$ using an illuminated acorn arrow pointing Up, Down, Left, or Right.
- Tapping the M551 lever rotates the compass smoothly over 160 ms with a gentle clicking sound.

### 2. Dandelion Puff Floating Aura
- Dandelion Puff Tiles (M553) emit a soft, swirling white filament halo at ground level.
- Objects stationed on the tile display a subtle levitation shadow (2 dp elevation lift), indicating immunity to falling.

### 3. Heavy Beetle Weight Indicator
- Heavy Beetle Lines (M554) display a small stone weight icon on their lead insect sprite.
- Shows directional drift arrows indicating where the line will slide after the next move.

### 4. Falling Acorn Trajectory Ghosting
- Long-pressing a falling acorn shows a dotted trajectory line to its eventual resting cell in the current gravity direction.
- In low-motion mode, trajectory displays as a static dashed arrow.

### 5. Tutorial Overlay Cards
Displayed once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L5501 | Falling Leaves | "Gravity pulls loose acorns and heavy beetles with the wind!" |
| L5511 | Wind-Vane Lever | "Tap to shift gravity's direction across the whole garden." |
| L5631 | Falling Acorns | "These acorns drop 1 tile after each move if their path is clear." |
| L5751 | Dandelion Puff Tile | "Anti-gravity haven! Anything resting on this tile never falls." |
| L5871 | Heavy Beetle Line | "Heavy ground ants slide with gravity. Bees fly safely above!" |

### 6. Phase 12 World Map Entry
- New chapter entry "Falling Leaves" unlocks on world map when `maxPhase ≥ 12`.
- Chapter icon: wind-blown golden oak leaf and weather-vane rooster.

---

## Acceptance Criteria
- [ ] Gravity compass clearly displays current vector and rotates accurately on shifts.
- [ ] Dandelion Puff tiles visually communicate anti-gravity status with levitation shadow.
- [ ] Heavy beetles display weight glyph and directional motion indicators.
- [ ] Falling acorns project clear drop trajectory on long-press.
- [ ] All 5 tutorial cards fire once on intro levels and suppress on replays.
- [ ] Color contrast complies with WCAG 2.1 AA across autumnal board skins.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/gravity_compass_widget.dart` | To be created |
| `packages/ui/lib/hud/dandelion_aura_overlay.dart` | To be created |
| `packages/ui/lib/hud/heavy_beetle_badge.dart` | To be created |
| `packages/ui/lib/hud/falling_acorn_ghost.dart` | To be created |
| `packages/ui/lib/tutorial/phase_12_cards.dart` | To be created |
| `assets/phase_12/ui/` | To be created |

---

## Risks and Open Questions

1. **Compass Visibility on Crowded Boards:** In 14×14 grids, ensuring the top-right compass does not obscure upper-right puzzle perimeter exit gates.
