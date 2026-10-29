Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-19-base-mechanics.md.

# Spec: UI — Phase 19 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, rotor-growth animations, rhythm beat pulse indicators, and accessibility adaptations for Phase 19 (Levels 9001–9500).

## Current State
Documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Kinematic Mechanics & Rotor-Growth Visual Design
- **Ivy Hoop Rotor Dynamics:**
  - $4\times 4$ wooden embroidery hoop with carved floral patterns and embedded green vine root nodes.
  - Tapping triggers a smooth 220 ms 90° clockwise rotation accompanied by floating leaf particle bursts.
- **Twirl Weighted Thread Cues:**
  - Distinct metallic thread core with an embossed spinning top arrow icon; performs a mini 360° spin in-place before sliding into gravity destination.
- **Rhythm Belt Visual Meter:**
  - Conveyor tracks feature an integrated rhythmic metronome line pulsing with a bright gold glow on active beat steps.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 9001:** "Kinematic Atelier — Spatial harmony! Experience the dynamic interplay of rotation, growth, gravity, and rhythm."
- **Level 9011:** "Twirl Weighted Thread — Spin and slide! This thread twirls 90° after each move, then drops with gravity."
- **Level 9131:** "Ivy Hoop Rotor — Redirect the vine! Rotate the hoop to aim growing ivy roots toward new sectors."
- **Level 9251:** "Rhythm Belt — On the beat! This conveyor only moves on active metronome beats; time your stitches!"
- **Level 9371:** "Seam Edge Split — Twin entrance! Passing through the hoop seam splits your thread into two half-ply strands."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Rhythm Belt meters feature prominent textual beat indicators (`BEAT: ON / OFF`) alongside color changes.
  - Twirl thread rotation direction is clearly indicated by high-contrast directional arrow halos.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/ivy_hoop_rotor_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/twirl_thread_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/rhythm_meter_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_19_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.

