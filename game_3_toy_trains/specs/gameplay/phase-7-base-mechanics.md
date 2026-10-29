Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-6-base-mechanics.md.

# Spec: Gameplay — Phase 7 Base Mechanics (M301–M304)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base rotational mechanics (M301–M304) introduced in Phase 7 (Levels 3001–3500) of Toy Trains: Wooden Railway Puzzle, establishing their rules, matrix transformations, interactive states, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured single-cell turntables (M013) and 3x3 rotating yards (M091).
- Phase 7 introduces 4x4 sub-board turntable rotors, marching perimeter exits, clockwork spinning engines, and mechanical turntable locks.

## Proposed Change
Implement the 4 base rotational mechanics in `packages/puzzle_core/lib/src/mechanics/phase_7/`:

### 1. M301 · Rotating Yard Block (Sub-board Rotor)
- **Intro Level:** L3011 (Block 2, x1).
- **Category:** T (Interactive Sub-Board Rotor).
- **Exact Rule:** $4 \times 4$ localized rotating table section with central lever. Tapping the lever (1 Move) rotates all 16 cells, internal tracks, and fully contained trains 90° Clockwise. If any train partially straddles the rotor boundary, tapping the lever triggers a locked tap (soft wobble, 0 moves, 0 hearts lost).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M301", "origin": [4, 4], "size": [4, 4], "params": {}, "hammerable": false}
  ```

### 2. M302 · Spinning Station Exits (Rotating Edges)
- **Intro Level:** L3131 (Block 14, x1).
- **Category:** B (Dynamic Border Exits).
- **Exact Rule:** Perimeter departure gaps that cycle clockwise around the outer tabletop border every `params.period` valid player Moves (ticks during Step 3 of the turn lifecycle). A train departing when its exit lane does not align with an active gap collides with the solid wooden rim (-1 heart bump).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M302", "params": {"period": 4, "exitLength": 2}, "hammerable": false}
  ```

### 3. M303 · Spinner Engine (Spin Path)
- **Intro Level:** L3251 (Block 26, x1).
- **Category:** P (Auto-Rotating Locomotive).
- **Exact Rule:** Clockwork-geared locomotive. On **every** valid player Move anywhere on the board (train departure or lever flip), the Spinner Engine rotates its heading vector 90° CW in-place. The player must plan their turns so the engine aligns with an open track lane when ready to depart.
- **Hammerable:** Yes (Track Crane can remove the train as a normal departure).
- **JSON Definition:**
  ```json
  {
    "paths": [
      {"id": "p1", "color": "orange", "dir": "U", "body": [[5, 6], [5, 7]], "params": {"autoSpin": true}}
    ],
    "mechanics": [
      {"id": "o3", "type": "M303", "cells": [], "params": {"path": "p1"}, "hammerable": false}
    ]
  }
  ```

### 4. M304 · Turntable Lock (Rotation Lock)
- **Intro Level:** L3371 (Block 38, x1).
- **Category:** K (Mechanical Lock).
- **Exact Rule:** Heavy locking bar mechanism anchored to an M301 rotor or M013 turntable. While the linked key train (`keyPathId`) remains on the board, the turntable lever is locked (tapping lever = locked tap). Once the key train successfully departs, the lock disengages permanently.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M304", "params": {"targetRotorId": "o1", "keyPathId": "p_key"}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_7/m301_sub_board_rotor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_7/m302_spinning_exits.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_7/m303_spinner_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_7/m304_turntable_lock.dart` (to be created)

## Risks
- Orientation desync if Spinner Engines are located inside a rotating 4x4 rotor. Mitigated by explicit composition order: rotor transform applied first, followed by in-place auto-spin increment.

## Open Questions
- None. All mechanics match `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md` and `SHARED_CORE_STANDARD.md` §11.
