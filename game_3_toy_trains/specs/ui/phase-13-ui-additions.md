Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-12-ui-additions.md, specs/gameplay/phase-13-signature-system.md.

# Spec: UI — Phase 13 UI & Weather Station Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, procedural atmospheric fog overlays, route peek visualizers, scout radar sweeps, lantern illumination circles, and tutorial cards for Phase 13 (Weather Station) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered unobstructed railway boards.
- Phase 13 introduces dynamic fog cloud textures that conceal sections of the railway yard.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Fog & Reconnaissance Visualizers
- **Atmospheric Fog Overlay:**
  - Multi-layered procedural steam cloud shader rendered over hidden grid cells (`#F3F4F6` with subtle billowing noise).
  - Smooth 300 ms radial dissolve animation when tiles are scouted or illuminated.
- **Route Peek Indicator:**
  - Long-pressing on any train or fogged tile activates a 2-second trajectory projection, rendering true green path chevrons through mirage clouds or false backdrops.
- **Lantern Illumination Radius (M604):**
  - Warm amber radial glow circle (`#FEF3C7`, 2-cell radius) around occupied lantern plates.
- **Scout Radar Ping (M601):**
  - Expanding concentric radar ring emitted as scout draisines depart the board.

### 2. Tutorial Cards (`ftue_cards`)
- **L6011 (M601 Scout Draisine):** "Thick steam conceals the mountain station! Send Scout Draisines down the track to clear the fog!"
- **L6131 (M602 Mirage Steam):** "That train in the steam is just an illusion! Long-press to Peek and guide your train straight through!"
- **L6251 (M603 Painted Backdrop):** "This wooden fence is just a painted backdrop! Trains can drive right through it!"
- **L6371 (M604 Lantern Plate):** "Park a train on the Lantern Plate to light up the tracks around it!"

### 3. Accessibility & High-Contrast Options
- Option to replace particle fog with a crisp semi-transparent dotted hatch pattern (`opacity: 0.7`).
- Route Peek accessible via double-tap as an alternative to long-press.

## Affected Files
- `lib/features/gameplay/presentation/widgets/fog_cloud_layer.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/route_peek_overlay.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/lantern_glow_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 13 tutorial cards)

## Design
- Screen: Gameplay screen during Weather Station levels.
- Design tokens: Consistent with misty alpine observatory motifs.

## Risks
- Heavy fragment shader usage for fog causing thermal throttling. Mitigation: Flat tiled texture atlas fallback on Low tier devices.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_13/06_UI_AND_QA_PHASE_13.md`.
