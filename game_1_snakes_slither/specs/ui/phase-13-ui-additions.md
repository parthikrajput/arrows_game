Source docs: phases/phase_13/06_UI_AND_QA_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §16.5, §17.28. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md, specs/ui/phase-12-ui-additions.md.

# Spec: UI — Phase 13 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Implement UI additions, fog alpha masking overlays, tongue-flick raycast preview beams, scout gecko aura badges, glow stone radiance shaders, and accessibility settings for Phase 13 (Levels 6001–6500).

## Current State
Design documented in `phases/phase_13/06_UI_AND_QA_PHASE_13.md` and `SHARED_CORE_STANDARD.md` §12, §16.5, not yet implemented.
- Previous UI assumed fully unoccluded board visibility.
- Phase 13 introduces real-time fog masking, translucent veil textures, optical false wall inspection cues, and pressure-activated area lighting.

## Proposed Change
Implement Phase 13 UI components in `packages/puzzle_ui/lib/src/phase_13/`:

### 1. HUD Additions & Fog Meter
- **Fog Cleared Percentage Meter:**
  - Located in the sub-header bar: `[FOG CLEARED: 65%]`.
  - Dynamically updates as scout geckos clear lanes and glow stone plates illuminate regions.
- **Scout Active Status Indicator:**
  - Displays whether an M601 Scout Gecko is active on the board: `[SCOUT ACTIVE: GECKO ON BOARD 🦎]`.
- **Fog Alpha Overlay:**
  - Shrouded cells render an atmospheric fog veil (alpha mask default: 0.85).
  - Shrouded cells obscure tile details (ice, switches, floor traps) while allowing vague contours of snakes to remain visible.

---

### 2. Fair Inspection & Through-Beam Preview
- **Tongue-Flick Through-Beam ($\ge 350\text{ ms}$):**
  - Long-pressing a snake directs a continuous golden raycast probe forward through fog.
  - If aimed at an impassable barrier, the probe terminates in a red bounce dot.
  - If aimed at an M603 Painted Wall (False Wall), the beam penetrates completely through the barrier with a sparkling golden shimmer, visually confirming that the obstacle is hollow canvas.
- **Scout Gecko Head Aura:**
  - M601 Scout Geckos feature a glowing emerald gecko glyph badge centered on their head sprite, rendering above the fog layer to guarantee identification.
- **Glow Stone Radiance Area:**
  - While occupied, M604 Glow Stones cast a warm golden light circle dispelling fog in a $3 \times 3$ grid radius.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P13-01 (L6001 / L6011):** "Mystery Mists: Scout Gecko" — Explains that Scout Geckos permanently clear fog within a 1-cell radius along their exit path.
- **Card P13-02 (L6131):** "Trick Mist: Returning Fog" — Demonstrates how standard snake exits allow fog to re-condense on un-scouted cells.
- **Card P13-03 (L6251):** "Painted Wall: Optical Illusion" — Teaches the $\ge 350\text{ ms}$ long-press tongue flick to detect false walls.
- **Card P13-04 (L6371):** "Glow Stone: Pressure Plate" — Demonstrates that resting on a jade plate illuminates the surrounding $3 \times 3$ area.

---

### 4. Accessibility & Multi-Modal Support
- **Fog Density Accessibility Slider:**
  - Settings menu offers a "Fog Density" toggle (`Normal: 85% opacity` vs `Accessible: 50% opacity`), enabling low-vision players to read underlying terrain while preserving game mechanics.
- **False Wall Visual Texture Discrepancy:**
  - M603 Painted Walls feature faint procedural surface hairline cracks, ensuring players can detect false barriers even without performing raycast previews.
- **High Contrast Raycast Probe:**
  - Raycast guide line renders with a 3px thickness and a 1px dark drop-shadow outline for clarity against both dark stone and bright fog.
- **Reduce Motion Support:**
  - Disables animated fog cloud drift, using a static alpha mask instead.
  - Replaces glowing radiance expansion animations with instant 50 ms light snaps.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_13/fog_alpha_overlay.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_13/tongue_flick_through_beam.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_13/scout_gecko_aura_badge.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_13/phase_13_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_13_ui_test.dart` (to be created)

## Risks and Open Questions
- **Fog Alpha Blending on Low-Tier Devices:** Real-time Gaussian blur and multi-layer fog shaders can strain low-end GPUs. Low-tier devices must fall back to a single pre-baked tiled alpha mask bitmap with zero runtime blur passes.
