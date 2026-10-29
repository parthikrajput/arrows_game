Source docs: phase_1/01_GAME_CONCEPT_AND_RULES.md, ../../SHARED_CORE_STANDARD.md

# Spec: Core Concept and Gameplay Rules

## Status
Draft

## Type
New Feature

## Goal
Implement the core turn-based puzzle rules, board representation, snake movement and bonk mechanics, life and star systems, and move resolution lifecycle for Snakes Slither Phase 1.

## Current State
Design documented in phase_1/01_GAME_CONCEPT_AND_RULES.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Turn-based logic puzzle without wall-clock pressure in the puzzle itself.
- Board grid from 4x4 up to 11x11 square cells; snakes occupy ordered cells where head is body[0].
- 3 hearts per attempt; bonking costs 1 heart; 0 hearts triggers Second Chance popup.
- Ad revive allowed once per level number; Heart Berry Refill costs 120 coins (max 2 per attempt).
- Free Tongue-Flick Preview via long-press (>= 350 ms).
- Strict deterministic 9-step move resolution order on each turn.

## Proposed Change
Build the core pure-Dart engine rules in `packages/puzzle_core` and hook them into Flutter state management (`GameBloc`):

### 1. Board & Snake Model
- **Grid Coordinates:** Origin `(0, 0)` at top-left, `x` increasing right, `y` increasing down. Phase 1 board sizes range from 4x4 up to 11x11.
- **Snake (`Path`):** An ordered list of contiguous orthogonal cells `body`, where `body[0]` is the head. Directions are strictly orthogonal: `U`, `D`, `L`, `R`. Snake length ranges from 2 to 8 cells.
- **Caterpillar Variant:** Visual skin variant with bead-like segmented body and antennae (`mods.skin = "caterpillar"`). Rules, hitboxes, and lane logic are identical to snakes.
- **Exit Lane:** The ray of cells starting immediately in front of `body[0]` in direction `dir` continuing to the board boundary.

### 2. Move Definition & Input Priority
- A **Move** is any player action that mutates board state: tapping a snake (which results in exit or bump), tapping an interactive obstacle (e.g., lever, lilypad, switch), or triggering state changes (e.g., waking a sleeping snake, relocating in mud).
- Boosters, long-press previews, pauses, and camera adjustments do not count as Moves.
- **Single Move at a time:** Move animation runs for <= 450 ms. Simultaneous inputs are blocked. Input queue capacity is 1: only the latest tap arriving during an active animation is queued; any earlier queued tap is discarded.
- **Tap Priority:**
  1. Interactive obstacle cells (levers, turntables, rotors) take priority over any snake body cell sharing that coordinate.
  2. In overlapping layered cells (Canopy M032), the upper-layer snake receives the tap.
  3. Snake body: tapping any segment (head, body, or tail) triggers the snake.
  4. Empty cell: 0.5-cell hit-slop selects the nearest snake segment.

### 3. Slither Out (Exit) & Head Bonk (Bump)
- **Slither Out:** If all cells along the exit lane are completely free of snakes and blocking obstacles:
  - The snake slithers forward along its lane, with body following the head path.
  - Duration is 250 to 450 ms based on lane distance.
  - Tail clears the board edge and the snake is removed.
  - Move counter increments by 1. Audio event `path_exit` and light haptic trigger.
- **Head Bonk (Bump):** If the exit lane contains another snake or blocking obstacle:
  - The head slides to the cell adjacent to the obstacle (or 0.25 cell forward if immediately adjacent), performs a bonk squash with 3-cycle shake, and slides back to its original position.
  - Board state does not change, but Move counter increments by 1 (move-based counters tick).
  - 1 Heart is deducted (or 1 Shield charge is absorbed if Safety Shell Shield is active).
  - Audio event `bump` and medium haptic trigger; blocker displays 120 ms red flash.

### 4. Locked Taps & Free Path Preview
- **Locked Tap:** If a snake is temporarily non-interactive (e.g., Frozen M003, Jungle Mist M010, out-of-order Hatch Order M028, Phasing ghost M021, Petal Cage M033, covered by Canopy M032, Tail-Biter Loop M046, or tangled rotation M013/M034):
  - Tap produces a soft side wobble (<= 200 ms), "nuh-uh" wobble audio `locked_tap`, and selection haptic.
  - A lock reason icon appears for 600 ms.
  - No heart is lost; Move counter does not increment.
  - *Exception:* Hungry Caterpillar (M036) with clear lane but no food is NOT a locked tap; it bonks (-1 Heart).
- **Tongue-Flick Preview:** Long-pressing a snake for >= 350 ms renders a dotted line along its prospective lane (green = clear, red = blocked with ✕ marker). Traces through mirrors/burrows. Stops with grey "?" at fog boundaries. Releasing cancels preview with 0 moves spent and no tap triggered.

### 5. Deterministic Move Resolution Order
Every Move must execute through this exact 9-step pipeline:
1. **Validate:** Check if target is locked. If locked, trigger locked tap and halt.
2. **Resolve Action:** Execute exit, bump, mud relocation, wake, interactive toggle, or rotation.
3. **Exit Triggers (immediate):** Fire non-lane exit triggers (keys M004/M043/M046, frost coil count M003, mist clearance M010, cage count M033, mongoose HP M049, spawn queue M035, pressure plate release M019, hatch order M028). Lane-based triggers (gems M026, food M036, mound hits M016, bridge crossing M042) fire along the path traversal.
4. **Increment Move Count:** `moveCount += 1`. (Parity mechanics M021 evaluate parity using the count *prior* to increment).
5. **Tick Counters:** In fixed order: M007 Lotus Bud Gate -> M017 Restless Caterpillar -> M031 Closing Hedge Gap -> M025 Patrolling Beetle -> M027 Creeping Vine -> M047 Growing Caterpillar -> M041 Chameleon color cycle.
6. **Evaluate Derived States:** Update pressure plate gates M019, fog boundaries M010, cages M033, lock states, pending spawns M035.
7. **Apply Heart Loss:** Any queued heart loss event applies (Safety Shell Shield absorbs first).
8. **Check Win:** If all snakes exited and all goals (e.g. gems) satisfied, declare Win immediately.
9. **Check Hearts:** If hearts == 0, trigger Second Chance flow.

### 6. Hearts, Second Chance & Fail
- **Hearts:** 3 maximum per attempt. Bump or counter expiration (M017) = -1 heart.
- **Second Chance:** Displays a 10-second countdown ring. Pauses when confirmation or shop sheets are opened, or when the app is backgrounded.
  - **Rewarded Ad Revive:** Grants +1 Heart. Limited to once per numbered level (`adReviveUsed[level]` persisted in save). Does not reset on restart; only resets when the level is cleared.
  - **Heart Berry Refill:** Costs 120 coins for +1 Heart. Maximum 2 refills per attempt.
- **Fail:** If countdown expires or player selects "No thanks", Level Failed screen appears with Retry and Home options. Retry is free (no energy system) and resets the board with full 3 hearts.
- **Post-Revive:** The board is never reset on revive; gameplay resumes from the current state.

### 7. Star Rating (★)
- ★★★: 0 hearts lost.
- ★★: 1 heart lost.
- ★: 2+ hearts lost, or any ad revive or Heart Berry Refill used.
- Boosters do not degrade star ratings. Replays can improve stars (saved as best stars); coins are awarded on first clear only, plus a one-time +20 coin bonus for the first ★★★ on that level.

## Affected Files
- `packages/puzzle_core/lib/src/model/cell.dart` (to be created)
- `packages/puzzle_core/lib/src/model/snake.dart` (to be created)
- `packages/puzzle_core/lib/src/model/board_state.dart` (to be created)
- `packages/puzzle_core/lib/src/model/move.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/engine.dart` (to be created)
- `packages/puzzle_core/lib/src/rules/move_resolver.dart` (to be created)
- `packages/puzzle_core/test/rules/engine_test.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/bloc/game_bloc.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/bloc/game_event.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/bloc/game_state.dart` (to be created)

## Risks
- Gesture ambiguity between short tap and long-press (>= 350 ms) preview must be cleanly resolved in the gesture arena so releasing a long press never executes a tap.
- Simultaneous input race conditions when multiple fingers tap rapidly; must strictly enforce input queue limit of 1.

## Open Questions
- Working title "Snakes Slither" is pending trademark search; package id `com.<studio>.snakesslither` will be finalized once studio identifier is confirmed. The old name "Snake Out!" must not be used anywhere.
