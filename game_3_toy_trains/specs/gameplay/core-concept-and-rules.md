Source docs: phase_1/01_GAME_CONCEPT_AND_RULES.md, ../../SHARED_CORE_STANDARD.md

# Spec: Core Concept and Gameplay Rules (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the core turn-based railway puzzle rules, board and train models, exit and buffer clack bump mechanics, life and star systems, and move resolution lifecycle for Toy Trains: Wooden Railway Puzzle Phase 1.

## Current State
Design documented in phase_1/01_GAME_CONCEPT_AND_RULES.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Turn-based logic puzzle without wall-clock pressure in the puzzle itself.
- Board grid from 4x4 up to 11x11 square cells; trains occupy ordered cells where engine is body[0].
- 3 hearts per attempt; buffer clack bump costs 1 heart; 0 hearts triggers "Back on Track?" Second Chance popup.
- Ad revive allowed once per level number; Heart Refill costs 120 coins (max 2 per attempt).
- Free Route Peek path preview via long-press (>= 350 ms).
- Strict deterministic move resolution pipeline on each turn.

## Proposed Change
Build the core pure-Dart engine rules in `packages/puzzle_core` and hook them into Flutter state management (`GameBloc`):

### 1. Board & Train Model
- **Grid Coordinates:** Origin `(0, 0)` at top-left, `x` increasing right, `y` increasing down. Phase 1 board sizes range from 4x4 up to 11x11.
- **Train (`Path`):** An ordered list of contiguous orthogonal cells `body`, where `body[0]` is the engine (head). Engine direction `dir` is strictly orthogonal in Phase 1: `U`, `D`, `L`, `R`. Carriages (1 to 4 cars) occupy `body[1..N]`. Total train length is 2 to 5 cells. 1 cell = 1 car. Carriages follow polyline curves around bends.
- **No Free-running Loops:** Trains never circle tracks or run on figure-8 circuits. Every train departs straight along its exit lane. The only loop mechanic is M046 Loop Line Train with its fixed locked-ring rule.
- **Exit Lane:** The straight ray of cells starting immediately in front of `body[0]` in direction `dir` continuing to the board boundary (tabletop edge).

### 2. Move Definition & Input Priority
- A **Move** is any player action that mutates board state: tapping a train (resulting in exit or bump), tapping an interactive railway cell (lever M009, turntable M013, switch M018, rotating yard M034, master gear lever M045), waking a Cold Engine (M012), or relocating in Sand Drift (M037).
- Boosters, long-press Route Peek previews, pauses, and camera adjustments do not count as Moves.
- **Single Move at a time:** Move animation runs for <= 450 ms. Simultaneous inputs are blocked. Input queue capacity is 1: only the latest tap arriving during an active animation is queued; any earlier queued tap is discarded.
- **Tap Priority:**
  1. In overlapping layered cells (Viaduct Deck M032), the upper-layer train receives the tap.
  2. Interactive railway cells take priority over a train car standing on that coordinate (e.g. M013 Turntable, M034 Rotating Yard hub); tap operates the interactive cell. To drive the train, the player taps any of its other cars.
  3. Tangled trains: If turntable or yard rotation leaves an engine facing its own carriage (`body[1]`), the train is in a "tangled" state. Tapping it triggers a locked tap (soft wobble, no heart lost, no move counted) until rotated free.
  4. Train body: tapping any car (engine or carriage) triggers the train.
  5. Push-Pull Train (M023): tapping near either end drives toward that end; tapping the exact center defaults to `body[0]`.

### 3. Departure (Exit) & Buffer Clack (Bump)
- **Departure (Exit):** If all cells along the exit lane are completely free of other trains and blocking obstacles:
  - The train chugs forward along its lane, with carriages following the engine's path.
  - Duration is 250 to 450 ms based on lane distance.
  - Train rolls off the table edge into the Toy Box Station and is removed from the board.
  - Move counter increments by 1. Audio event `path_exit` and light haptic trigger.
- **Buffer Clack (Bump):** If the exit lane contains another train or blocking obstacle:
  - The train rolls forward until its buffers contact the blocker, produces a buffer clack (`bump`), shakes, and rolls back to its starting position using `Curves.easeOutBack`.
  - Board state does not change, but Move counter increments by 1 (move-based countdowns tick).
  - 1 Heart is deducted (or 1 Shield charge is absorbed if Cowcatcher Shield is active).
  - Audio event `bump` and medium haptic trigger; blocker displays red flash.

### 4. Locked Taps & Free Route Peek
- **Locked Tap:** If a train is non-interactive (Snowed-In M003, Steam Cloud M010, out-of-order Timetable M028, Locked Siding M033, Viaduct underpass M032, Phantom Express odd-move ghost phase M021, or Tangled turntable state):
  - Tap produces a soft wooden knock sound `locked_tap`, selection haptic, and a visual lock reason icon for 600 ms.
  - No heart is lost; Move counter does not increment.
- **Route Peek (Path Preview):** Long-pressing a train for >= 350 ms renders a dotted line along its prospective track:
  - Green = clear path off board.
  - Red = blocked, marked with a red ✕ on the collision cell.
  - Route Peek traces through tunnels (M008/M044) and overpasses (M015); stops with a grey "?" at Steam Clouds.
  - Releasing cancels preview with 0 moves spent and no heart lost. Free tool available from FTUE L2.

### 5. Move Resolution Pipeline (Engine Contract)
Each move resolves in strict deterministic order:
1. **Action Execution:** Train exit animation starts, buffer clack bump occurs, or interactive cell state flips.
2. **Move Counter Increment:** `moveCount += 1`.
3. **Move-based Mechanics Tick (Step 3):** Fixed tick order (SHARED_CORE_STANDARD §16.17):
   - M007 Level Crossing countdown ticks.
   - M017 Steam Pressure countdown ticks.
   - M031 Last Call Exit countdown ticks.
   - M025 Handcar Patrol advances 1 cell along track loop.
   - M027 Creeping Ivy sprouts 1 cell (fixed order U, R, D, L).
   - M047 Auto-Coupler Freight grows 1 carriage if move threshold met.
   - M041 Windmill Signal blocker state cycles.
   *(Parity mechanics like M021 Phantom Express use pre-increment parity).*
4. **Derived States Recompute:** Thaw Snowed-In (M003), update Ticket Barriers (M004/M043), Steam Cloud visibility (M010), Weighbridge Plates (M019), Locked Sidings (M033), Clock Tower Guardian HP (M049), and Depot Dispatcher spawns (M035).
5. **Heart-Loss Application:** Bump penalties or Steam Pressure expirations deduct hearts; Cowcatcher Shield absorbs first if active.
6. **Win Check:** Evaluated before 0-heart fail. If all trains have exited and secondary goals (M026 Mail Sacks) are fulfilled, level is WON even if the final move was a bump.

### 6. Hearts, Revive & Second Chance
- **Hearts:** 3 hearts per attempt.
- **0 Hearts State:** Triggers "Back on Track?" Second Chance popup with a 10-second countdown ring.
- **Revive Options:**
  - Option A: Rewarded Ad grants +1 Heart. Allowed strictly **once per level number** (`adReviveUsed[level]`; restarting does not reset; cleared level resets).
  - Option B: Heart Refill costs **120 coins** for +1 Heart. Maximum **2 refills per attempt**.
- If countdown expires or player taps "No thanks", Level Failed screen displays with free Retry (resets board, restores 3 hearts).

### 7. Stars (★)
- ★★★: 0 hearts lost.
- ★★: 1 heart lost.
- ★: 2+ hearts lost OR any revive / Heart Refill used.
- Boosters do not degrade star ratings (Cowcatcher Shield absorbs prevent heart loss).

## Affected Files
- `packages/puzzle_core/lib/src/model/board.dart` (to be created)
- `packages/puzzle_core/lib/src/model/path.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/move_resolver.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/lane_tracer.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/tick_order.dart` (to be created)
- `apps/toy_trains/lib/game/bloc/game_bloc.dart` (to be created)
- `apps/toy_trains/lib/game/bloc/game_state.dart` (to be created)
- `apps/toy_trains/lib/game/widgets/second_chance.dart` (to be created)

## Risks
- Rapid tapping during train exit animations could cause desync if input queue exceeds 1.
- Collision detection along curved carriage bodies must trace exact grid occupancy per frame.

## Open Questions
- None. All rules and numbers strictly adhere to phase_1/01 and SHARED_CORE_STANDARD.md.
