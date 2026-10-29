# Spec: Phase 18 Signature System — Garden Festival I (Remix A)

Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-17-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 Signature System — Garden Festival I (Remix A) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define the system architecture, mathematical rule composition ($Rule_{\text{combo}} = Rule_A \circ Rule_B$), state evaluation order, and data-driven selection principles for Garden Festival I (Remix A), synthesizing the core mechanics of Phases 1 to 6 (Cycles, Multi-floor, Push Physics, and Beams).

---

## Current State

Design documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md` and `phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. Architectural Principle: Data-Driven Rule Composition
- Remix A does NOT invent arbitrary new primitives.
- Four combo mechanics are chosen by live analytics telemetry (D1–D30 completion rates, booster consumption, replay velocity) from the candidate pool:
  - Candidates: Day-Night Terrace (Cycles × Floors), Sunlit Acorn (Push × Beams), Shaded Stairs (Beams × Floors), Dawn Marble (Cycles × Push), Lens Terrace, Night Prism.
  - Active snapshot selection: M851 Day-Night Terrace, M852 Sunlit Acorn, M853 Shaded Stairs, M854 Dawn Marble.
- The rule of each combo mechanic is the strict mathematical composition of its two parent rules ($Rule_A \circ Rule_B$).
- Spatial layer attributes (ground ants, worker bees, canopy scout bees) are inherited directly from parent mechanic definitions.

### 2. Hybrid Systems Integration

#### Cycles × Multi-Floor (M851 Day-Night Terrace)
- Staircase connection linking Floor 1 and Floor 2 whose vertical passability is gated by global day/night cycle state.
- In State A (Day, 5 moves): Active stairs, transports insect upward upon entry.
- In State B (Night, 5 moves): Retracts flush into ground, behaving as ordinary flat lawn terrain.

#### Push Physics × Light & Beams (M852 Sunlit Acorn)
- Pushable acorn block mounted with a $90^\circ$ optical prism lens.
- Pushing the acorn to an open destination tile immediately updates solar raycast paths on the same turn.
- If sunlight strikes the newly repositioned acorn, the beam deflects $90^\circ$ clockwise towards distant sunflower receptors.

#### Light & Beams × Multi-Floor (M853 Shaded Stairs)
- Staircase vertical link initially shrouded in darkness and impassable.
- Directing a solar beam across its coordinates activates optical sensors, illuminating the steps and unlocking vertical transit to Floor 2.

#### Cycles × Push Physics (M854 Dawn Marble)
- Smooth rolling marble whose kinetic friction is modulated by diurnal cycle state.
- In State A (Day): Frictionless slide; pushing sends marble sliding until it impacts an obstacle or grid border.
- In State B (Night): Dew condensation solidifies marble; becomes a completely stationary, immovable block.

### 3. Tick Order Integration (SHARED_CORE_STANDARD.md §16.17)
1. Player tap action registered; selected line trajectory initiated.
2. If insect pushes movable entity (M852 Acorn / M854 Marble in Day):
   - Push physics simulation resolves destination cell.
3. Beam raycasting recalculated immediately:
   - Evaluates prism deflection on M852.
   - Evaluates beam illumination on M853 stairs.
4. Moving insect transitions floor if entering active vertical portal (M851 in Day, or illuminated M853).
5. Insect exit or arrival verified; cycle move counter increments.
6. Cycle state toggles if threshold reached (Day $\leftrightarrow$ Night):
   - M851 stairs active state flips.
   - M854 marble physical state flips (sliding $\leftrightarrow$ stationary).
7. Parity and win/loss state evaluated.

---

## Verification Plan

### Automated Tests
1. Verify Day-Night Terrace allows floor transition strictly during Day cycle turns.
2. Verify pushing Sunlit Acorn updates raycast deflection in the exact same turn before subsequent moves resolve.
3. Verify Shaded Stairs remain locked when unilluminated and unlock upon beam contact.
4. Verify Dawn Marble refuses push displacement during Night cycle turns.

### Manual Verification
1. Verify camera smooth floor pan triggers properly when climbing Day-Night Terrace.
2. Confirm optical beam deflection through multiple Sunlit Acorns renders without visual jitter.
