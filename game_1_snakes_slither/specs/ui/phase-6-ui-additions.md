Source docs: phases/phase_6/06_UI_AND_QA_PHASE_6.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §14, §15. Depends on: specs/ui/ui-ux-screens.md, specs/ui/phase-5-ui-additions.md.

# Spec: UI — Phase 6 UI Additions and Optical Overlays

## Status
Draft

## Type
New Feature

## Goal
Implement the user interface components, color-blind shape glyphs, optical status badges, interactive countdown meters, and tutorial cards for Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phases/phase_6/06_UI_AND_QA_PHASE_6.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Previous UI handled basic boards, floor tabs (Phase 4), and push momentum indicators (Phase 5).
- Phase 6 introduces dynamic multi-colored beam overlays, fractional convergence indicators, and dark cell state transitions.

## Proposed Change
Implement Phase 6 UI additions in `lib/features/gameplay/presentation/widgets/optics/`:

### 1. Optical Status HUD & Badges

1. **Prism Lock Convergence Badge (M252):**
   - Renders a floating circular pill badge directly above the M252 prism gate.
   - When 0 beams active: Dim lock icon.
   - When 1 beam active: Pulsing amber badge reading `"1/2"` with directional beam chevron indicating active source angle.
   - When $\ge 2$ beams active: Brilliant golden flash followed by latch unlock animation.
2. **Sundial Countdown Dial (M253):**
   - Centered circular countdown badge with carved stone numerals (`3`, `2`, `1`).
   - Active illumination displays a rotating sun-ray halo.
   - If beam is interrupted: Badge shakes with a 200 ms red flash and resets to initial count $N$.
3. **Dark Cell Shadow Overlay (M254):**
   - Translucent stylized leaf canopy shadow covering the tile (40% black alpha).
   - Dormant snake segments under shadow display a gentle Zzz sleeping bubble glyph.
   - Upon illumination: Shadow canopy dissolves with an expanding circular alpha wipe.

---

### 2. Color-Blind Shape Glyph Overlays (Standard §14.2)
To ensure complete accessibility for players with Deuteranopia, Protanopia, or Tritanopia, all colored light beams and matching filters embed distinct geometric glyphs:
- **Ruby Spectrum:** Solid Triangle ($\blacktriangle$) watermark embedded in beam and filter.
- **Cyan Spectrum:** Solid Square ($\blacksquare$) watermark embedded in beam and filter.
- **Emerald Spectrum:** Hexagon ($\hexagon$) watermark.
- **Gold Spectrum:** Diamond ($\blacklozenge$) watermark.
- **Violet Spectrum:** Circle ($\CIRCLE$) watermark.

---

### 3. Tutorial Cards (FTUE Onboarding)
Modal dismissable cards displayed at the start of respective intro levels:
- **L2511 Tutorial (Petal Filter):** *"Petal Filters change the color of sunlight! Match the beam color to unlock colored temple gates."*
- **L2631 Tutorial (Prism Lock):** *"Prism Locks need 2 light beams at once! Bounce rays from different angles to open the way."*
- **L2751 Tutorial (Sundial Receiver):** *"Sundial Gates need steady light! Keep the beam shining for the required moves without interruption."*
- **L2871 Tutorial (Shade Leaves):** *"Snakes sleeping in deep shade won't move! Shine sunlight on them to wake them up."*

## Affected Files
- `lib/features/gameplay/presentation/widgets/optics/prism_lock_badge.dart` — to be created
- `lib/features/gameplay/presentation/widgets/optics/sundial_counter_widget.dart` — to be created
- `lib/features/gameplay/presentation/widgets/optics/shade_leaf_overlay.dart` — to be created
- `lib/features/tutorials/data/phase_6_tutorial_cards.dart` — to be created

## Risks and Open Questions
- **HUD Clutter on 14×14 Grids:** Floating badges might overlap with adjacent snake heads on dense boards.
  - *Mitigation:* Badges scale down dynamically based on cell pixel size, fading out when the camera zooms out past 0.7x scale.

