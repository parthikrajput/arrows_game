# Spec: Phase 10 UI Additions — Garden Rhythm HUD & Tutorial Cards

Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-10-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 UI Additions — Garden Rhythm HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define all new HUD indicators, rhythmic cycle visualizers, queue badges, tutorial cards, and accessibility enhancements required for Garden Rhythm (Cricket Gate, Bead-String Lock, Queue Hedge, and Echo Bloom).

---

## Current State

Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md`, not yet implemented.

---

## Proposed Change

### 1. Rhythm Cycle Indicator (M451)
- Cricket Gate displays an animated musical eighth-note emblem on its central arch.
- Each player move produces a radial chromatic pulse; a numeric sub-badge indicates remaining moves until the open phase (e.g. "2 moves").
- In low-motion mode, dynamic pulse is disabled; a static fraction badge (`1/3`) is shown.

### 2. Bead-String HUD Bar (M452)
- Top HUD area renders a horizontal string of coloured glass beads corresponding to the required sequence.
- Successfully exited matching colours light up their bead with a bright crystalline gleam.
- An out-of-order exit causes unmatched beads to shatter gently and reset to dull empty wire.

### 3. Queue Number Badges (M453)
- Queue Hedges render embossed brass number plates (1, 2, 3...) at the board edge.
- The active departing number plate glows softly in gold; inactive queued plates remain muted bronze.
- Screen readers announce: "Queue Hedge: currently expecting insect number [N]".

### 4. Echo Bloom Recording Overlay (M454)
- Echo Bloom displays a central crystal stamen.
- Phase 1 (Recording): petals illuminate in sequence as lines exit, accompanied by an ambient purple pollen mist.
- Phase 2 (Playback): central stamen glows cyan, showing the target echo sequence with glowing musical notes.

### 5. Tutorial Overlay Cards
Displayed once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L4501 | Garden Rhythm | "Timing and exit order make the garden hum in harmony!" |
| L4511 | Cricket Gate | "Opens only on specific rhythm moves (e.g. every 3rd move). Plan ahead!" |
| L4631 | Bead-String Lock | "Exit insects in the exact color sequence shown on the bead string." |
| L4751 | Queue Hedge | "Insects must exit in strict numerical order: 1, then 2, then 3." |
| L4871 | Echo Bloom | "Memorize the first group's exit colors; the second group must match the echo!" |

### 6. Phase 10 World Map Entry
- New chapter entry "Garden Rhythm" unlocks when `maxPhase ≥ 10`.
- World map icon: musical treble clef woven from fresh morning vines.

---

## Acceptance Criteria
- [ ] Rhythm countdown badge accurately updates on every valid player move.
- [ ] Bead-String HUD accurately highlights matched colours and resets cleanly on errors.
- [ ] Queue number plates highlight current valid exit number.
- [ ] Echo Bloom distinguishes between recording (purple) and playback (cyan) states.
- [ ] All 5 tutorial cards appear once on intro levels and suppress on replays.
- [ ] Contrast ratios comply with WCAG 2.1 AA across light and dark board skins.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/rhythm_pulse_widget.dart` | To be created |
| `packages/ui/lib/hud/bead_string_bar.dart` | To be created |
| `packages/ui/lib/hud/queue_badge_overlay.dart` | To be created |
| `packages/ui/lib/hud/echo_bloom_hud.dart` | To be created |
| `packages/ui/lib/tutorial/phase_10_cards.dart` | To be created |
| `assets/phase_10/ui/` | To be created |

---

## Risks and Open Questions

1. **Bead-string visibility on small devices:** On 5-inch phones in portrait mode, displaying long bead strings ($k \ge 5$) alongside standard move counters and heart displays requires careful layout scaling.
