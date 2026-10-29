# Spec: Phase 19 UI Additions — Garden Festival II HUD & Tutorial Cards

Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-19-signature-system.md, specs/gameplay/phase-19-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 UI Additions — Garden Festival II HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define all new gravity-growth composite indicators, rhythm rotor beat halos, cross-board split portals, local gravity sector compasses, tutorial cards, and accessibility enhancements required for Garden Festival II (Falling Vines, Rhythm Rotor, Twin-Garden Fork, and Gravity Turntable).

---

## Current State

Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md`, not yet implemented.

---

## Proposed Change

### 1. Gravity-Growth Composite Indicator (M901)
- Falling Vines display an integrated downward arrow indicating gravitational drift direction, along with a small green leaf pip indicating growth turns.
- Cells at risk of vine obstruction in the next turn render a soft warning tint on the ground.

### 2. Rhythm Rotor Beat Halo (M902)
- Center hub of Rhythm Rotor displays a musical treble clef icon surrounded by 4 orbital indicator dots.
- On each turn, one dot lights up; when all 4 illuminate, the halo pulses bright gold to warn the player: "Rotates on next move!"

### 3. Cross-Board Fork Portals (M903)
- Twin-Garden Fork displays dual glowing branches: Branch A points along Board A; Branch B features an iridescent swirling portal rift pointing toward Board B.
- Selecting an insect approaching the fork temporarily highlights both destination landing paths across both board views.

### 4. Local Gravity Sector Compass (M904)
- Gravity Turntable renders a miniature brass compass rose at its top corner.
- Arrow indicates the active local gravity pull vector for entities inside the turntable sector.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L9001 | Garden Festival II | "Advanced harmony of rotation, growth, splits, rhythm, and gravity!" |
| L9011 | Falling Vines | "Spreading vines that also drift with gravity. Clear lanes before they fall!" |
| L9131 | Rhythm Rotor | "This garden turntable turns automatically on the beat of the rhythm!" |
| L9251 | Twin-Garden Fork | "Split your insects across two completely separate garden boards!" |
| L9371 | Gravity Turntable | "Rotating this sector changes the direction of gravity within it." |

### 6. Phase 19 World Map Entry
- Map node: **Wind & Blossom Arena / Canopy Festival** (L9001–9500).
- Visual theme: Floating wind chimes, spinning blossom vanes, cascading waterfall bridges connecting floating garden islands.
- Pathway displays rotating pinwheel badges every 10 levels.

### 7. Accessibility Support
- **Colorblind Palettes:** Rhythm Rotor beat countdown uses numbered pips (1, 2, 3, 4) in addition to color illumination.
- **Reduced Motion:** Rotor turn and gravity slide animations render as fast 60 ms linear snaps; screen shake and blossom swirl vortexes are disabled.

---

## Verification Plan

### Automated Tests
1. Verify tutorial cards trigger strictly on L9001, L9011, L9131, L9251, and L9371.
2. Verify Rhythm Rotor beat halo dots sync with move count modulo conditions.

### Manual Verification
1. Inspect cross-board split highlighting on dual-board layouts for visual clarity and no z-fighting.
2. Verify brass compass rose arrow rotates smoothly when rotating Gravity Turntable.
