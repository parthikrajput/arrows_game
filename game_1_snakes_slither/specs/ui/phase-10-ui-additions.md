Source docs: phases/phase_10/06_UI_AND_QA_PHASE_10.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §17.28. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-10-base-mechanics.md, specs/ui/phase-9-ui-additions.md.

# Spec: UI — Phase 10 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Implement UI additions, HUD widgets, sequence ribbon indicators, tutorial dialogues, and accessibility enhancements for Phase 10 (Levels 4501–5000), supporting Jungle Drum Festival rhythm gating, totem patterns, and parade queues.

## Current State
Design documented in `phases/phase_10/06_UI_AND_QA_PHASE_10.md` and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Previous UI handled bifurcation previews, bead counters, and twin entity markers.
- Phase 10 requires real-time rhythm forecast ribbons, chromatic totem match slots, ordinal parade callout banners, and echo sequence mirror trackers.

## Proposed Change
Implement the Phase 10 UI widgets in `packages/puzzle_ui/lib/src/phase_10/`:

### 1. HUD Additions & Sequence Trackers
- **Rhythm Beat Ribbon:**
  - Positioned directly in the top HUD sub-bar: `[RHYTHM: [● OPEN] [○ CLOSED]]`.
  - Visualizes the immediate 2–3 beat forward lookahead, showing players the exact state of active M451 Drum Gates on the upcoming move.
  - Pulses synchronously with each player move input.
- **Totem Pattern Indicator:**
  - Displays a stacked or horizontal ribbon of colored gem slots corresponding to active M452 Totem Locks (e.g., `[TOTEM: 🔴 🟢 🔵]`).
  - Slots illuminate with a golden checkmark when correctly matched in the trailing exit buffer.
- **Parade Next Callout:**
  - Renders a floating badge over the M453 Parade Gate: `[PARADE NEXT: #3]`.
  - Dynamically updates as snakes clear the gate.
- **Echo Sequence Progress Bar:**
  - Displays Group A's recorded color sequence as semi-transparent ghost tokens.
  - As Group B snakes exit, the corresponding token fills with full opacity and sparkles upon matching.

---

### 2. Snake Dorsal Number Badging
- Snakes designated for M453 Parade Exits feature large, bold numerical dorsal badges centered on their head and lead segments ($1, 2, \dots, N$).
- Badges feature high-contrast white digits with 2px dark drop shadows, remaining crisp across all board zoom scales.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P10-01 (L4501 / L4511):** "Jungle Drum Festival: Rhythm Gate" — Explains that the gate opens and closes based on player moves, not real-time clocks.
- **Card P10-02 (L4631):** "Totem Pattern Lock: Chromatic Sequence" — Explains that the last $k$ snakes exiting the board must match the totem colors in exact order.
- **Card P10-03 (L4751):** "Parade Exit: Numbered Order" — Demonstrates that snakes must exit in ascending numerical order ($1 \to 2 \to 3$).
- **Card P10-04 (L4871):** "Echo Frogs: Mirror Choir" — Explains that Group B must echo the exact exit sequence chosen for Group A.
- **Card P10-05 (L5000):** "Grand Halfway Milestone" — Special celebratory dialog welcoming the player to the 5,000-level project midpoint.

---

### 4. Accessibility & Multi-Modal Design
- **Shape & Symbol Augmented Colors:**
  - To support players with color blindness, chromatic totem and echo slots pair every color with an intrinsic geometric icon:
    - Red $\to$ Circle (●)
    - Blue $\to$ Square (■)
    - Yellow $\to$ Triangle (▲)
    - Green $\to$ Star (★)
- **Acoustic Pitch Differentials:**
  - Open and closed drum states emit distinct audio pitches (High Drum vs Low Drum), providing auditory cues for upcoming gate states.
- **Reduce Motion Support:**
  - Replaces pulsing acoustic ring ripples with static state icons.
  - Confetti and firework emitters are disabled or replaced with static banner transitions.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_10/rhythm_beat_ribbon.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_10/totem_pattern_hud_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_10/parade_callout_badge.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_10/echo_sequence_hud_tracker.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_10/phase_10_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_10_ui_test.dart` (to be created)

## Risks and Open Questions
- **HUD Horizontal Space on Narrow Screens:** Displaying Rhythm, Totem, and Parade trackers simultaneously exceeds the width of standard mobile displays ($< 380\text{ dp}$). The HUD must condense into a tabbed or single-row carousel showing only the nearest relevant mechanic tracker based on camera focus.
