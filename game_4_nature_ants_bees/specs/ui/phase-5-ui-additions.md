Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, specs/ui/ui-ux-screens.md, SHARED_CORE_STANDARD.md §13, §14. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: UI — Phase 5 UI Additions (Push Physics Cues & Indicators)

## Status
Draft

## Type
New Feature

## Goal
Design and integrate UI elements for Phase 5: push trajectory ghost overlays in Scent Trail Preview, heavy Stone Pumpkin multi-file requirements cues, hole fill transformation indicators, and Phase 5 tutorial notification cards.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Current UI handles line previews and single-cell static obstacle clicks.
- Visual trajectory guides for sliding low-friction marbles, pit filling indicators, and heavy push weight warnings do not exist.

## Proposed Change
Extend Flutter UI widgets in `lib/features/gameplay/widgets/`:

### 1. Push Trajectory & Ghost Preview
- When the player long-presses (>= 350 ms) an insect line aligned to strike a push block:
  - The Scent Trail Preview draws the insect line's path up to the block.
  - A translucent ghost silhouette of the push block is projected forward showing its destination cell.
  - For Dewdrop Marbles (M202), the ghost trajectory extends continuously until the first obstruction, highlighting the final resting cell or pit fill with a subtle golden halo.

### 2. Stone Pumpkin Heavy Weight Cue
- When a single-file line is previewed hitting a Stone Pumpkin (M204):
  - A flashing warning badge ("Requires 2 Lines or Double-File Swarm") appears briefly above the pumpkin.
  - Line preview shows an immediate red bonk indicator.
  - When double-file or linked lines are aligned, the pumpkin displays an emerald push arrow.

### 3. Mole Hole Terrain Transformation Indicator
- When a block is pushed into a Mole Hole (M201):
  - An expanding radial soil compaction ring (300 ms) plays over the tile.
  - The cell visually morphs into standard garden lawn with small daisy sprouts indicating the lane is permanently open.

### 4. Phase 5 Tutorial Overlay Cards
One-line non-modal notification banner presented at the top of the board during intro levels:
- **L2001:** *"Acorn Physics — Push blocks across the garden lawn to clear paths and fill pits."*
- **L2011:** *"Mole Hole — Push rolling acorns or marbles into deep holes to pave walkable ground!"*
- **L2131:** *"Dewdrop Marble — Ultra-smooth dewdrop marbles slide continuously until hitting an obstacle."*
- **L2251:** *"Seed Key Pod — Push this key block onto its matching colored socket to unlock thorn gates."*
- **L2371:** *"Stone Pumpkin — Too heavy for single lines! Push using Double-File swarms."*

## Affected Files
- `lib/features/gameplay/widgets/push_trajectory_painter.dart` (to be created)
- `lib/features/gameplay/widgets/tutorial_banner.dart` (changed to include Phase 5 cards)
- `lib/features/gameplay/screens/gameplay_screen.dart` (changed to render push trajectory guide)

## Design
- Matches design tokens in `specs/ui/ui-ux-screens.md`: 2D `CustomPainter` with soft-3D gradients, pre-baked drop shadows, and 48x48 dp minimum touch bounds.

## Risks
- Cluttered preview overlay when multiple blocks are pushed in a chain reaction. Mitigated by limiting preview ghosting to the first two blocks in the chain.

## Open Questions
- None. UI components and trajectory cues match `phase/phase_5/06_UI_AND_QA_PHASE_5.md` §1.

