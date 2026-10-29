Source docs: phase_1/01_GAME_CONCEPT_AND_RULES.md, ../../SHARED_CORE_STANDARD.md

# Spec: Core Concept and Gameplay Rules

## Status
Draft

## Type
New Feature

## Goal
Implement the core turn-based puzzle rules, board representation, wool thread unraveling and snag mechanics, life and star systems, and move resolution lifecycle for Yarn Unravel Phase 1.

## Current State
Design documented in phase_1/01_GAME_CONCEPT_AND_RULES.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Turn-based cozy logic puzzle without wall-clock pressure in the puzzle itself.
- Board grid from 4x4 up to 11x11 square cells; threads occupy ordered cells where needle head is `body[0]`.
- 3 hearts per attempt; snagging costs 1 heart; 0 hearts triggers "Tangled Up!" Second Chance popup.
- Rewarded ad revive allowed once per level number; Heart Refill costs 120 coins (max 2 per attempt).
- Free Thread Peek preview via long-press (>= 350 ms).
- Strict deterministic 7-step move resolution order on each turn.

## Proposed Change
Build the core pure-Dart engine rules in `packages/puzzle_core` and hook them into Flutter state management (`GameBloc`):

### 1. Board & Thread Model
- **Grid Coordinates:** Origin `(0, 0)` at top-left, `x` increasing right, `y` increasing down. Phase 1 board sizes range from 4x4 up to 11x11.
- **Board Appearance:** Rectangular craft board with light birch wood frame and cream linen fabric texture. Centered cross-stitch dots at cell intersections. Circular embroidery hoop is strictly excluded from gameplay grids to avoid clipping.
- **Thread (`Path`):** An ordered list of contiguous orthogonal cells `body`, where `body[0]` is the needle head. Directions are strictly orthogonal in Phase 1: `U`, `D`, `L`, `R`. Thread length ranges from 2 to 8 cells.
- **Visual Segments:** Stroke width = `cell * 0.42`, round caps and joins, twisted-ply texture shader with soft corner fillets (`radius = cell * 0.35`). Needle head at `body[0]` displays a silver needle sprite pointing in `dir`, containing a color-blind icon in the eye. Tail ends in a fluffy wool tuft.
- **Pull Lane (Exit Lane):** The ray of cells starting immediately in front of `body[0]` in direction `dir` continuing to the board boundary.
- **Over/Under Weaving Rule:** True physical over/under weaving is NOT supported in Phase 1 or 2. Threads do not weave through each other. Overlaps are handled strictly through explicit Layer mechanics (M015 Stitch Bridge, M032 Double Fabric Layers).

### 2. Move Definition & Input Priority
- A **Move** is any player action that mutates board state: tapping a thread (which results in unravel exit or snag bump) or tapping an interactive obstacle (Presser Lever M009, Spool Spinner M013, Thread Guide Switch M018, Quilt Block Rotor M034, Treadle Gear Lever M045).
- Boosters, Thread Peek long-press previews, pauses, settings, and camera zooms do NOT count as Moves.
- **Single Move at a Time:** Move animation executes for <= 450 ms. Simultaneous inputs are rejected. Input queue capacity is 1: only the most recent tap arriving during active animation is queued; any earlier queued taps are dropped.
- **Tap Priority:**
  1. Interactive obstacle cells (levers, spinners, switches, rotors) take priority over any thread body cell sharing that coordinate. On Spool Spinner (M013), needle cell triggers spinner; body cells trigger thread.
  2. In overlapping layered cells (M015 Stitch Bridge, M032 Double Fabric Layers), the upper-layer thread receives the tap.
  3. Thread body: tapping any segment (needle head, body, or tuft tail) triggers the thread.
  4. Double-Needle Thread (M023): tapping exactly in the middle triggers the `body[0]` needle end.
  5. Empty cell: 0.5-cell hit-slop selects the nearest thread segment.

### 3. Unravel (Exit) & Snag (Bump)
- **Unravel (Exit):** If all cells along the pull lane are completely clear of other threads (on the same layer) and blocking obstacles:
  - The needle pulls forward along its lane, with the rest of the thread following the exact path behind it (snake-style follow through corners).
  - Duration is 250 to 450 ms based on lane distance.
  - Tail clears the board edge and the thread is removed from board state.
  - Visual: a decorative small yarn ball rolls up at the board edge.
  - Move counter increments by 1. Audio event `path_exit` ("zzzip-fwip") and light haptic trigger.
- **Snag (Bump):** If the pull lane contains another thread or a blocking obstacle:
  - The needle moves forward to the blocker (or 0.25 cell forward if immediately adjacent), snags with thread tension, and springs back with an ease/spring curve to its rest position.
  - Board state remains unchanged, but Move counter increments by 1 (move-based obstacle counters tick).
  - 1 Heart is deducted (or 1 Shield charge is absorbed if Thimble Shield is active).
  - Audio event `bump` (damped thread-snag "twang" <= 3 kHz) and medium haptic trigger; blocker flashes red pulse for 120 ms. Screen shake triggers on Mid/High tiers (0 dp on Low tier).

### 4. Locked Taps & Free Thread Peek
- **Locked Tap:** If a thread is temporarily non-interactive (e.g., Knotted Thread M003, covered by Wool Fluff M010, out of sequence in Tagged Threads M028, locked in Safety-Pin Cage M033, covered by Double Fabric Layers M032, ghost phase in Sheer Silk M021, tangled direction pointing into body, or Knitted Loop M046):
  - Tap produces a soft side wobble (<= 200 ms), muted thread pluck audio `locked_tap`, and selection haptic.
  - Lock reason icon appears for 600 ms.
  - No heart is lost; Move counter does not increment. Hint solver will never suggest a locked thread.
- **Thread Peek (Path Preview):** Long-pressing a thread for >= 350 ms renders a dotted chain-stitch line along its pull lane:
  - Green dotted line = lane is completely clear to board edge.
  - Red dotted line = lane is blocked, displaying a red ✕ marker on the blocking cell.
  - Traces through portals (Pompom Tunnel M008) and deflectors (Hook Deflector M014).
  - Stops with grey "?" at Wool Fluff (M010) boundaries.
  - Locked thread long-press displays grey preview line with lock icon.
  - Releasing touch cancels preview with 0 moves spent and no tap triggered.

### 5. Move Resolution Order (Deterministic 7-Step Pipeline)
When a valid Move is initiated, engine resolves state in this strict deterministic order:
1. **Action Resolve:** Evaluate pull lane on current state (portals, deflectors, switches, hop pads, inner exits). Determine Exit, Bump, Relocate (Glue Dot M037), or Interactive toggle. Fire immediate non-lane exit effects (clasp unlock, Knotted counter decrements, Wool Fluff clearing, Guardian HP reduction, Sequins collection, Skein Spawners). Parity mechanics (M021 Sheer Silk) evaluate state using move count *prior* to increment.
2. **Move Count Increment:** `moveCount += 1`.
3. **Counters Tick:** Tick move-based counters in exact sequence:
   `M007 (Basting Seam) -> M017 (Fraying Thread) -> M031 (Zipper Edge) -> M025 (Rolling Yarn Ball) -> M027 (Spreading Tangle) -> M047 (Growing Knit Thread) -> M041 (Ombre Thread)`.
4. **Derived States:** Recompute pressure plates (Foot Pedal Plate M019), fog visibility (Wool Fluff M010), cages (Safety-Pin Cage M033), and color locks.
5. **Heart Loss:** Apply queued heart loss (Bump => -1 Heart; Fraying Thread M017 countdown reaching 0 => -1 Heart). Thimble Shield absorbs hit first if charges remain.
6. **Win Check:** All threads exited AND all secondary objectives complete (e.g. Sequins M026 collected). If won, triggers 600 ms celebration, locks input, and transitions to Level Complete.
7. **0-Heart Check:** If hearts == 0, trigger "Tangled Up!" Second Chance popup.

### 6. Hearts, Revives, and Second Chance
- **Attempt Budget:** 3 Stitched-Felt Hearts per attempt. Max hearts is strictly 3.
- **0 Hearts Trigger:** Second Chance popup ("Tangled Up!") displays a 10-second countdown ring. Board is frozen.
- **Option A (Rewarded Ad Revive):** +1 Heart. Permitted **once per level number** (persisted in `adReviveUsed[level]`; does not reset on restart; resets upon level completion).
- **Option B (Heart Refill):** Costs **120 Coins** for +1 Heart. Permitted **maximum 2 times per attempt**.
- **Decline / Timeout:** Triggers Level Failed screen with free Retry (full 3 hearts, board reset).
- **No Energy System:** Free retries; no lives timer or energy gate.

### 7. Star Ratings (★)
- ★★★: Cleared with **0 hearts lost**.
- ★★: Cleared with **1 heart lost**.
- ★: Cleared with **2+ hearts lost** OR any revive used (ad revive or Heart Refill).
- Boosters do not degrade star ratings; hits absorbed by Thimble Shield count as 0 hearts lost. Replays can improve star count.

### 8. Edge Cases & Invariants
- **E1 (Fast Multi-Tap):** Input queue holds at most 1 pending tap; surplus taps are discarded.
- **E2 (Double-Tap on Exiting Thread):** Second tap ignored since thread is immediately removed from logical state in Step 1.
- **E3 (Shield Hit on 1 Charge):** Absorbs hit, reduces charge to 0, heart count remains unchanged, shield HUD icon fades out.
- **E4 (Last Heart Loss):** Hearts reach 0; Second Chance opens immediately. No further board interactions allowed until resolved.
- **E5 (Coins < 120 at Refill):** Heart Refill button navigates to mini coin shop sheet; countdown ring pauses while sheet is active.
- **E6 (App Backgrounded / Killed):** If backgrounded mid-animation, animation snaps to completed state and game auto-pauses. If process killed, attempt is discarded and resumes at level start with 3 hearts; `adReviveUsed` status remains saved.
- **E7 (Simultaneous Win and Fail):** Logically impossible. Bumps do not alter thread positions; exits do not deduct hearts. Fraying Thread (M017) expiring -1 heart only occurs while thread is on board; if that thread exits, it is removed in Step 1 before Step 3 counter tick.

## Affected Files
- `packages/puzzle_core/lib/src/model/board_state.dart` (to be created)
- `packages/puzzle_core/lib/src/model/thread_path.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/lane_resolver.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/move_resolver.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/engine.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/bloc/game_bloc.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/view/board_view.dart` (to be created)

## Risks
- Thread following around tight 90-degree corners must maintain constant linear speed to prevent visual stretching.
- Hit slop priority on small 29 dp cells on 360 dp screens must correctly distinguish between needle head and adjacent interactive levers.

## Open Questions
- None. All rules and numbers align strictly with SHARED_CORE_STANDARD.md §1–§4.

