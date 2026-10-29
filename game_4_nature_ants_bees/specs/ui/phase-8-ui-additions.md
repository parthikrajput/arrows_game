# Spec: Phase 8 UI Additions — Bloom Season HUD & Tutorial Cards

Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-8-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 UI Additions — Bloom Season HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define all new HUD indicators, tutorial overlay cards, and accessibility requirements needed to communicate Bloom Season mechanics (vine growth, shears pruning, seed countdown, pollination gate progress) to the player.

---

## Current State

Design documented in phase/phase_8/06_UI_AND_QA_PHASE_8.md, not yet implemented.

---

## Proposed Change

### 1. Vine Spreading Pulse Indicator (M351)
- When a Morning Glory Vine (M351) is due to expand on the next turn (i.e., `moveCount % growEvery == growEvery - 1`), all vine cells show a pulsing green glow on their blossom sprites.
- Pulse animation: 0.3 s ease-in-out loop; low-motion mode shows a solid green outline instead.
- Colour-blind mode: pulse uses a distinct shape indicator (leaf flicker) in addition to colour.

### 2. Shears Snip UI Cue (M352)
- Garden Shears tile permanently shows a small shimmering silver edge glow ("Ready to snip").
- On activation: flash cut animation (0.1 s), pruned vine cells fade out over 0.25 s.
- Accessibility: shears cell has a screen-reader label "Garden Shears — guide any insect across to prune adjacent vines".

### 3. Seed Countdown Badge (M353)
- Seed token placed by Seed-Dropping Line shows a circular countdown badge with remaining moves (e.g., "3 moves to sprout").
- Badge updates each move. At "1 move to sprout", badge turns amber.
- When seed sprouts into a pebble blocker: brief green-to-grey transition animation (0.4 s).
- Low-motion mode: badge number only, no animation.

### 4. Pollination Gate Progress Indicator (M354)
- Pollination Gate (M354) shows a petal-pollen meter on its sprite: petals fill incrementally with each qualifying adjacent exit.
- Meter label: "1/3 pollinated", "2/3 pollinated", "Bloomed open!".
- Colour-blind: meter segments use shape (unfilled circle → half-filled → full petal) in addition to colour.

### 5. Tutorial Overlay Cards
Cards fire exactly once per mechanic per player account (first encounter at intro x1 level):

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L3501 | Bloom Season | "Living vines and flowers grow dynamically as you make moves!" |
| L3511 | Morning Glory Vine | "Spreads in 4 directions every few moves. Clear paths before it blocks exits!" |
| L3631 | Garden Shears | "Guide any ant or bee across the shears to snip away adjacent vines." |
| L3751 | Seed-Dropping Line | "Drops a seed upon exit. Pass over it before it sprouts into a blocker!" |
| L3871 | Pollination Gate | "Guide insects out from adjacent lanes to pollinate and bloom open the gate." |

- Cards use the standard tutorial overlay layout (bottom sheet, tap to dismiss, skip button).
- Cards are skippable after 1.5 s.
- Repeated display suppressed after first dismissal (persisted in local save).

### 6. Phase 8 World Map Entry
- New chapter entry "Bloom Season" added after the Phase 7 chapter on the world map.
- Chapter icon: morning glory vine in blossom.
- Chapter unlocks when `maxPhase ≥ 8` (Remote Config).

---

## Acceptance Criteria
- [ ] Vine pulse indicator fires exactly 1 turn before expansion; does not fire on non-expansion turns.
- [ ] Low-motion mode replaces pulse animation with static green outline.
- [ ] Seed countdown badge decrements correctly each move; turns amber at 1 move remaining.
- [ ] Pollination gate meter fills correctly per adjacent exit; shows correct fraction.
- [ ] All 5 tutorial cards fire once at their trigger levels and are suppressed on replay.
- [ ] All new UI elements pass WCAG 2.1 AA colour contrast.
- [ ] Chapter icon "Bloom Season" appears on world map when maxPhase ≥ 8.

---

## Design

- Vine pulse colour: `#4CAF50` (green), pulse glow radius 4 dp.
- Shears edge glow colour: `#C0C0C0` (silver).
- Seed badge: circular, 18 dp diameter, `#FFC107` (amber) at 1 move remaining.
- Pollination meter: 32×32 dp sprite, fills with `#FFD700` (golden pollen).
- Tutorial card: white bottom sheet, 72 dp top padding, 16 sp body text, dismiss tap target 44×44 dp minimum.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/vine_pulse_indicator.dart` | To be created |
| `packages/ui/lib/hud/seed_countdown_badge.dart` | To be created |
| `packages/ui/lib/hud/pollination_meter.dart` | To be created |
| `packages/ui/lib/tutorial/phase_8_cards.dart` | To be created |
| `packages/ui/lib/world_map/chapter_bloom_season.dart` | To be created |
| `assets/phase_8/ui/` | To be created |

---

## Risks and Open Questions

1. **Pulse timing sync:** Vine pulse must be in exact sync with the game tick order; if UI renders one frame late, the pulse will appear after expansion rather than before. Confirm frame scheduling in `tick_order.dart`.
2. **Seed badge on small grids:** At 12×12 grid on small phone screens, the 18 dp seed badge may overlap adjacent cells. A layout adjustment may be needed.
3. **Screen reader support for live countdown:** Dynamic countdown badge (`3 → 2 → 1`) should announce changes via accessibility semantics; confirm framework support for live region updates.
