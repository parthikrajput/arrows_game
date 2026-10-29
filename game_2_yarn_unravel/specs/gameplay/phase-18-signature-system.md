Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, ../../SCALING_TO_10000_LEVELS.md §10.3. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 18 Signature System: Remix A (Phases 1–6 Synergy)

## Status
Draft

## Type
New Feature

## Goal
Specify the multi-system synergy integration, data-driven combo mechanics selection (§10.3), composite tick resolution order, and solver node constraints for Yarn Unravel Phase 18 (Levels 8501–9000).

## Current State
Design documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md` and `phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md`, not yet implemented.
- Prior phases introduced individual signature mechanics in isolated progression tiers.
- Phase 18 introduces Remix A, unifying top-performing mechanics from Phases 1 through 6 into composite, synergistic puzzle configurations while maintaining strict solver performance budgets.

## Proposed Change
Implement the Remix A system within `packages/puzzle_core`:

### 1. Data-Driven Selection & Candidate Pool Synergy (§10.3)
Mechanics are selected based on high player engagement and solver tractability:
- **M851 — Cycle Crate:** Merges Phase 3 Day/Night cycles with Phase 5 push physics. In State A (Day), the crate slides freely; in State B (Night), it latches to the loom frame and acts as an immovable single blocker.
- **M852 — Floor Beam:** Merges Phase 6 light beams with Phase 4 multi-floor sheer organza. Light rays project vertically through translucent floor fabric to illuminate sun-catchers on secondary tiers.
- **M853 — Fogged Stair:** Merges Phase 4 multi-floor stairs with Phase 13 wool fluff fog. Stairs remain hidden beneath wool fluff until cleared by a thread passage.
- **M854 — Satin Charm Crate:** Merges Phase 5 sliding crates with Phase 2/16 key clasps. Sliding the satin-wrapped crate into a target clasp permanently pops the lock and dissolves the crate.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR pushes a valid crate (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Remix A Multi-System Resolution):**
  1. Cycles state transition: update Day/Night states ($m \pmod 5 == 0$).
  2. Light beam ray tracing & vertical floor penetration calculations.
  3. Push physics resolution & floor transitions.
  4. Fog reveals on stair cells.
- **Step 5 (Clasps & Gates Update):** Update clasps unlocked by Satin Charm Crates.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate snags from player unravel actions.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration & Node Budget Invariant
- In the IDA* puzzle solver:
  - Multi-system state hashing ensures state explosion is mitigated by DAG deadlock checks.
  - Search budget invariant: CI verifies that all generated seeds solve within $\le 1.5\text{M}$ nodes and $\le 100\text{ ms}$ isolate compute time.

## Affected Files
- `packages/puzzle_core/lib/src/models/remix_a_state.dart` (to be created: composite multi-system model)
- `packages/puzzle_core/lib/src/logic/remix_a_controller.dart` (to be created: cross-system tick dispatcher)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: multi-system DAG heuristics)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: composite layout generator)

## Risks and Open Questions
- None. System interactions comply with `SHARED_CORE_STANDARD.md` §11 and §16.17.
