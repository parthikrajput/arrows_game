Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-3-signature-system.md.

# Spec: UI — Phase 3 UI & HUD Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, HUD widgets, tutorial dialogs, and accessibility representations for Phase 3 (Day & Night Timetable) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases featured static top HUD displays (Level number, Stars, Hearts, Settings).
- Phase 3 requires an interactive timetable dial communicating the 5-move cyclic state.

## Proposed Change
Extend the Flutter UI layer with Phase 3 presentation components:

### 1. Sun/Moon Timetable Dial HUD Widget
- **Placement:** Integrated into the top gameplay bar adjacent to the level title.
- **Visual Design:** Circular miniature wooden dial rimmed with antique brass brackets.
  - Center icon: Carved wooden Sun (`#F59E0B`) during Day Service; carved wooden Crescent Moon (`#93C5FD`) during Night Service.
  - Outer ring: 5 segmented pip notches filling clockwise with golden enamel as valid Moves are made.
  - Tooltip: Long-press displays chip: `"Day Service: 3 moves until Night"`.
- **Transition Animation:** On the 5th move, the center icon performs a smooth 180° flip (300 ms) while pip segments reset to empty.

### 2. Tutorial Cards (`ftue_cards`)
Appears automatically before the first move of introduced mechanic levels:
- **L1001 (Timetable Intro):** "Day & Night Timetable! The table service changes every 5 Moves. Keep an eye on the Sun & Moon dial!"
- **L1011 (Day/Night Gate):** "Day/Night Gates open only during their scheduled service hours. Plan your route ahead!"
- **L1131 (Day/Night Overpass):** "Overpasses drop when night arrives, blocking both tracks. Clear the junction in time!"
- **L1251 (Day/Night Tunnel):** "Tunnel doors lock shut at night. Enter only when the green signal is lit!"
- **L1371 (Day/Night Livery):** "Dual-Livery Trains repaint themselves when the sun sets, changing which station gates they can enter!"

### 3. Ambient Lighting & Tabletop Aesthetics
- **Day Service:** Warm tabletop sunlight with gentle wooden table grain highlights.
- **Night Service:** Cozy evening railway depot ambiance; miniature brass street lamps illuminate corners with warm amber cones (`#FDE68A`, opacity 0.15).

### 4. Accessibility & Color-Blind Integrity
- Cyclic mechanics never rely solely on color shifts.
- Sun state features radiating rays pattern + sun glyph; Moon state features crescent glyph + starlight dot pattern.
- High-contrast mode provides bold black-and-white border outlines around active open gates.

## Affected Files
- `lib/features/gameplay/presentation/widgets/hud_cycle_dial.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/cycle_ambient_overlay.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 3 tutorial cards)

## Design
- Screen: Gameplay screen during Day vs Night service states.
- Component: Animated brass Sun/Moon dial.
- Design tokens: Consistent with Phase 1 and 2 wooden toy aesthetic.

## Risks
- Viewport clutter on small 320 dp screens. Mitigation: Dial measures compact 36x36 dp; text labels hidden by default and accessible via tap.

## Open Questions
- None. All UI components match `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `SHARED_CORE_STANDARD.md`.

