Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-13-base-mechanics.md.

# Spec: UI — Phase 13 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, tutorial overlays, fog shader rendering, and accessibility adaptations for Phase 13 (Levels 6001–6500).

## Current State
Documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Fog of War Visual Rendering
- **Wool Fluff Cloud Shader:**
  - Procedural soft cloud effect layered over the linen grid cells.
  - Features organic fuzzy yarn edges and gentle slow-pulsing wool fiber textures.
  - When fog is cleared, a 250 ms soft circular dissolve wipes out the fluff from the reveal origin.
- **Lantern Plate Illumination:**
  - When a thread rests on a Lantern Plate, board fog transitions smoothly from 100% opacity to 40% semi-transparency.
  - Subtle golden ambient lighting washes over the linen canvas to convey warm lantern light.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 6001:** "Wool Fluff Fog — Mystery hides beneath the wool! Scout paths or find lanterns to unveil the threads."
- **Level 6011:** "Scout Thread — Silver needle glides clear! Pulling this thread sweeps away wool fluff along its path."
- **Level 6131:** "Decoy Fluff — Not all fluff hides a snare! Some wool puffs dissolve at the slightest touch."
- **Level 6251:** "Painted Wall — An illusion on fabric! This painted ruler lets your threads glide right through."
- **Level 6371:** "Lantern Plate — Hold the brass plate down to illuminate what lies beneath the fog!"

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Painted walls feature a distinct cross-stitch dotted pattern to differentiate them from solid wooden ruler blockers (M002).
  - Lantern Plate provides an icon toggle overlay showing an open-eye / closed-eye symbol for active illumination.
  - Question mark (`?`) peek indicators are rendered in high-contrast cyan/yellow with clear outlines.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/shaders/wool_fluff_fog_shader.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/lantern_plate_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/scout_thread_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_13_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.

