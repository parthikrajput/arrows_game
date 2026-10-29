Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, specs/ui/ui-ux-screens.md, SHARED_CORE_STANDARD.md §13, §14. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: UI — Phase 3 UI Additions (Sun/Moon Dial & Tutorials)

## Status
Draft

## Type
New Feature

## Goal
Design and integrate UI elements for Phase 3: the 5-move Sun/Moon Cycle Dial in the gameplay HUD, variant tutorial notification cards, and accessible color-blind shape encodings for cyclic mechanics.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Current HUD displays Move Counter, Heart Counter, Booster Tray, and Level Number.
- No global cycle indicator or cyclic state preview component exists in the gameplay UI.

## Proposed Change
Extend Flutter UI widgets in `lib/features/gameplay/widgets/`:

### 1. Sun & Moon Cycle Dial HUD Widget
- **Location:** Top gameplay header, positioned adjacent to the Move Counter.
- **Visual Design:** Circular gauge divided into 5 radial arc segments with a central celestial glyph:
  - **Day State:** Central glowing Sun glyph (`#FBC02D`) with amber arc segments (`#FFF59D`).
  - **Progress Pips:** Fills 1 radial segment clockwise with a crisp 150 ms ease-out sweep for each valid player Move.
  - **Cycle Transition (Move 5):** Dial executes a 250 ms `Curves.easeInOutCubic` 180° rotation, transforming the Sun into a crescent Moon (`#90CAF9`) and shifting the segment colors to midnight blue (`#1565C0`).
  - **Accessible Cue:** Includes text hint "Day: 3/5 moves" / "Night: 4/5 moves" on accessibility focus.

### 2. Phase 3 Tutorial Overlay Cards
One-line non-modal notification banner presented at the top of the board during intro levels:
- **L1001:** *"Day & Night Garden — The garden cycles between day and night every 5 moves."*
- **L1011:** *"Sunrise Gate — Open during the sunny day, closed at night."*
- **L1131:** *"Moonlit Twig Bridge — Shimmers into a bridge only under the moonlight."*
- **L1251:** *"Dawn Burrow — Portals active only in the morning sun."*
- **L1371:** *"Day-Bloom Line — Petal colors transform as day turns to night."*
- **Dismissal:** Automatically fades out after 4 seconds or immediately upon first player tap.

### 3. Color-Blind & Accessibility Features
- **M104 Dual-Color Glyphs:** Day-Bloom lines have distinctive geometric head markings (Sun diamond vs Moon crescent) in addition to color tinting.
- **M101 Sunrise Gate:** Features sharp petal silhouettes (spread open vs tightly crossed) visible in high-contrast mode.

## Affected Files
- `lib/features/gameplay/widgets/cycle_dial_widget.dart` (to be created)
- `lib/features/gameplay/widgets/tutorial_banner.dart` (changed to include Phase 3 cards)
- `lib/features/gameplay/screens/gameplay_screen.dart` (changed to include `CycleDialWidget` in top app bar)

## Design
- Matches design tokens in `specs/ui/ui-ux-screens.md`: 2D `CustomPainter` with soft-3D gradients, pre-baked drop shadows, and 48x48 dp minimum touch bounds.

## Risks
- Cluttered top app bar on small portrait viewports (320 dp wide). Mitigated by scaling Move and Cycle indicators into a unified compact pill on compact devices.

## Open Questions
- None. HUD requirements match `phase/phase_3/06_UI_AND_QA_PHASE_3.md` §1.
