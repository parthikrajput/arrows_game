Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md. Depends on: specs/ui/phase-3-ui-additions.md, specs/gameplay/phase-4-signature-system.md.

# Spec: UI — Phase 4 UI & Multi-Floor Viewport Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the UI controls, Floor Switcher vertical tab strip, cross-floor remaining thread counters, Organza transparency shader rendering, and tutorial cards for Yarn Unravel Phase 4 (Sewing Room Floors).

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md`, not yet implemented.
- Phase 3 introduced the Sun/Moon Loom Dial widget.
- Phase 4 requires seamless vertical floor switching controls and multi-floor thread telemetry.

## Proposed Change
Implement the Phase 4 UI components in `lib/features/gameplay/view/widgets/`:

### 1. Floor Switcher Tab Strip (`FloorSwitcherWidget`)
- Positioned vertically along the right screen margin in portrait layout.
- **Tab Buttons:** Displays tabs corresponding to the active level's floor count:
  - `F1`: Embroidery Table (Ground floor)
  - `F2`: Cutting Table (Mid floor)
  - `F3`: Attic Loom (Top floor, active on 3-floor levels)
- **Active State:** The selected tab displays an embossed wooden frame with golden needle trim.
- **Thread Count Badges:** Each tab features a small woven wool badge displaying the remaining unraveled threads on that floor (e.g., `F1: 14`, `F2: 8`). When a floor is 100% cleared, its badge displays a golden checkmark icon.
- **Interaction:** Tapping an inactive tab initiates a 250 ms vertical camera glide to the target floor (cost: 0 Moves).

### 2. Organza Transparency Rendering (`OrganzaShader`)
- Organza sections (M152) are painted on upper floors using an alpha-blended sheer silk shader (`Color.fromARGB(140, 255, 255, 255)`).
- The painter renders a dimmed, desaturated projection of the lower-floor board cells directly underneath, allowing the player to discern lower-floor thread orientations.

### 3. Illustrated Tutorial Cards (Purl the Kitten)
Modal tutorials appearing on introductory levels:
- **L1501 (Multi-Floor):** Purl pointing paws toward the floor tabs: *"This quilt has multiple floors! Tap F1 and F2 to switch views."*
- **L1511 (M151 Stairs):** Purl sliding down a spool stair: *"Spool Stairs carry needles smoothly between floors!"*
- **L1631 (M152 Organza):** Purl looking through sheer silk: *"Organza floors are sheer! Tap threads underneath without switching floors."*
- **L1751 (M153 Drop Hole):** Purl dropping a yarn ball through a hole: *"Drop Holes guide threads down to the floor below!"*
- **L1871 (M154 Bobbin Lift):** Purl pulling a lift lever: *"Rest your needle on the Bobbin Lift, then tap to ride up or down!"*

### 4. Accessibility
- **Screen Reader Support:** VoiceOver / TalkBack announcements on floor tab changes: *"Floor 2 Cutting Table selected, 8 threads remaining."*
- **Floor High-Contrast Mode:** Renders distinctive high-contrast geometric floor borders (solid double border for F1, dashed for F2, dotted for F3) to aid navigation.

## Affected Files
- `lib/features/gameplay/view/widgets/floor_switcher_widget.dart` (to be created)
- `lib/features/gameplay/view/painters/organza_floor_painter.dart` (to be created)
- `lib/features/gameplay/view/dialogs/purl_tutorial_dialog.dart` (changed: add Phase 4 tutorial assets)

## Risks
- Vertical camera glides causing stutter on low-tier phones if both floors remain active in the display tree. Mitigated by culling non-visible floors during steady-state gameplay.

## Open Questions
None. UI layout and widget specifications match Phase 4 documentation.
