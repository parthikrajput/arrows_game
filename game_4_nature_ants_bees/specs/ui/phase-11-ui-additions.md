# Spec: Phase 11 UI Additions — Twin Gardens HUD & Tutorial Cards

Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 UI Additions — Twin Gardens HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define all new HUD controls, dual-viewport switcher bars, cross-board connection indicators, tutorial cards, and accessibility enhancements required for Twin Gardens (Garden Gate Link, Pen-Pal Key, Reflecting Pond Board, and Relay Burrow).

---

## Current State

Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md`, not yet implemented.

---

## Proposed Change

### 1. Dual-Board Viewport Toggle Bar
- Top-mounted toggle tabs labelled "Garden A" and "Garden B".
- Tapping switches active camera with a smooth 250 ms horizontal panning animation.
- A small badge on each tab indicates remaining unresolved insects on that board.
- Double-tap or pinch-out zooms out to a split "Overview Mode" showing both boards side by side.

### 2. Link Mini-Map Preview Widget
- Bottom corner renders an interactive miniature dual-square icon representing Board A and Board B.
- Shows glowing link nodes connecting boundaries, allowing players to orient cross-board paths at a glance.

### 3. Cross-Board Key Connection Beam (M502)
- Tapping a Pen-Pal Key insect renders an ethereal golden guidance beam arcing toward the board edge / tab, indicating which board holds its linked lock.
- In low-motion mode, replaced with a static target badge (`→ Garden B: Lock 1`).

### 4. Relay Burrow Portal Glow (M504)
- Subterranean burrows exhibit a subtle pulsating earthen amber vortex around their opening.
- Indicates to the player that this structure is an underground transport conduit.

### 5. Tutorial Overlay Cards
Presented once per player profile upon reaching the designated mechanic intro level:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L5001 | Twin Gardens | "Two interconnected gardens! Switch between boards to solve the dual puzzle." |
| L5011 | Garden Gate Link | "Insects exiting this gate enter the matching cell in the other garden." |
| L5131 | Pen-Pal Key | "This insect carries a key that unlocks a distant lock in Garden B!" |
| L5251 | Reflecting Pond Board | "Moving this insect simultaneously controls its reflection in the twin garden." |
| L5371 | Relay Burrow | "Ants dive into this subterranean tunnel to emerge directly into the other garden." |

### 6. Phase 11 World Map Entry
- New chapter entry "Twin Gardens" unlocks on world map when `maxPhase ≥ 11`.
- Chapter icon: dual mirrored clover leaves with golden ribbon link.

---

## Acceptance Criteria
- [ ] Viewport toggle bar switches focus between boards with smooth 250 ms pan.
- [ ] Mini-map accurately reflects cross-board link positions and active line count.
- [ ] Pen-Pal Key guidance indicator clearly points to destination board.
- [ ] Relay Burrow visual differentiates clearly from standard hole obstacles.
- [ ] All 5 tutorial cards fire once on intro levels and suppress on replays.
- [ ] UI contrast meets WCAG 2.1 AA across both board environments.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/dual_board_toggle_bar.dart` | To be created |
| `packages/ui/lib/hud/link_mini_map.dart` | To be created |
| `packages/ui/lib/hud/key_connection_beam.dart` | To be created |
| `packages/ui/lib/hud/relay_burrow_widget.dart` | To be created |
| `packages/ui/lib/tutorial/phase_11_cards.dart` | To be created |
| `assets/phase_11/ui/` | To be created |

---

## Risks and Open Questions

1. **Touch Target Size on Toggle Tabs:** In mobile portrait mode, tabs must have minimum 48×48 dp touch targets without obstructing puzzle boundary cells.
