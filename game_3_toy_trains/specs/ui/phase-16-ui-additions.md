Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-15-ui-additions.md, specs/gameplay/phase-16-signature-system.md.

# Spec: UI — Phase 16 UI & Ticket Office Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, ticket chain connection tracers, ticket stub crafting animations, master pass golden halos, swap pad indicators, and tutorial cards for Phase 16 (Ticket Office) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered standard static keys and locks.
- Phase 16 introduces dynamic multi-key networks, half-ticket crafting booths, and universal master passes.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Ticket Office & Key Crafting Visualizers
- **Ticket Chain Tracers (M751):**
  - Golden chain link visualizer drawn between Barrier A and nested Ticket Car B, making sequential dependencies explicit to players.
- **Ticket Punch Booth Graphic (M752):**
  - Ornate wooden conductor ticket punch booth. Delivering left (🎟️L) and right (🎟️R) stubs triggers a mechanical stamping punch animation that outputs a luminous Golden Ticket.
- **Master Pass Golden Aura (M753):**
  - Radiant golden sunbeam aura encircling the Master Pass locomotive, accompanied by an omni-key skeleton badge floating above its cab.
- **Ticket Swap Pad Emblems (M754):**
  - Brass interlocking arrows etched into parallel siding tracks that glow green when two key-carrying trains are ready to exchange.

### 2. Tutorial Cards (`ftue_cards`)
- **L7511 (M751 Ticket Chain):** "Some tickets are locked behind gates! Unlock the first barrier to release the next ticket down the line!"
- **L7631 (M752 Ticket Punch):** "Combine Left and Right Ticket Stubs at the Punch Booth to craft the Master Golden Ticket!"
- **L7751 (M773 Master Pass):** "The Golden Master Pass can open any colored barrier on the track! Choose where to use it wisely!"
- **L7871 (M754 Ticket Swap Pad):** "Park two trains on the Swap Pads to trade their held tickets!"

### 3. Accessibility & High-Contrast Options
- Color-blind support: Distinct geometric stamps (Star, Crescent, Cross) embossed onto ticket stubs and barriers in addition to colors.
- Reduced-motion mode replaces ticket punch stamp animation with instantaneous 120 ms crossfade.

## Affected Files
- `lib/features/gameplay/presentation/widgets/ticket_chain_tracer.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/ticket_punch_booth.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/master_pass_aura.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 16 tutorial cards)

## Design
- Screen: Gameplay screen during Ticket Office levels.
- Design tokens: Vintage railway station and brass ticket bureau motif (`#B45309`, `#F59E0B`, `#FDE047`).

## Risks
- Obscuring track tiles with wide chain tracers. Mitigation: Tracers rendered as thin dashed golden spline curves with 0.6 opacity.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_16/06_UI_AND_QA_PHASE_16.md`.
