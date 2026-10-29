# Spec: Phase 19 Signature System — Garden Festival II (Remix B)

Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-18-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 Signature System — Garden Festival II (Remix B) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define the system architecture, mathematical rule composition ($Rule_{\text{combo}} = Rule_A \circ Rule_B$), deterministic tick execution pipeline, and data-driven candidate selection principles for Garden Festival II (Remix B), integrating the advanced mid-game systems of Phases 7 to 12 (Rotation, Growth, Split/Merge, Sequencing, Linked Boards, and Gravity).

---

## Current State

Design documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md` and `phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. Architectural Principle: Advanced Kinetic Composition
- Remix B synthesizes systems from Phases 7 through 12 without creating arbitrary new primitives.
- Selection is driven by player telemetry (completion rate, booster rate, retention impact):
  - Active snapshot selection: M901 Falling Vines (Growth × Gravity), M902 Rhythm Rotor (Sequencing × Rotation), M903 Twin-Garden Fork (Linked Boards × Split/Merge), M904 Gravity Turntable (Rotation × Gravity).
- Multi-system state transitions resolve deterministically according to the strict order of settlement (SHARED_CORE_STANDARD.md §16.17).

### 2. Hybrid Systems Integration

#### Growth × Gravity (M901 Falling Vines)
- Living morning glory vines that exhibit dual kinetic properties.
- On active growth turns (every $N$ moves), shoots advance orthogonally into free adjacent cells.
- Concurrently, all unsupported vine segments slide 1 cell downward along the active gravity vector.

#### Sequencing × Rotation (M902 Rhythm Rotor)
- A $4\times 4$ sub-board circular sector.
- Operates autonomously based on move parity: when $\text{moveCount} \bmod P == 0$, the sector rotates automatically $90^\circ$ clockwise without requiring a player tap.
- Contained insects, obstacles, and directional arrows rotate with the turntable.

#### Linked Boards × Split/Merge (M903 Twin-Garden Fork)
- Dividing branch node positioned at the boundary threshold between Board A and Board B.
- When an insect enters the fork:
  - Branch 1 turns $90^\circ$ and completes its exit within Board A.
  - Branch 2 teleports through the inter-board portal and continues its path onto Board B.
  - Both branches must have unobstructed exit paths simultaneously.

#### Rotation × Gravity (M904 Gravity Turntable)
- Rotatable circular zone (requires 1 player move or mechanism trigger).
- Rotating the sector $90^\circ$ CW rotates both the entities inside and also redirects the local directional gravity vector within that sector by $90^\circ$ CW.
- Loose debris and movable acorns within the sector slide immediately to align with the new vector.

### 3. Deterministic Order of Settlement (SHARED_CORE_STANDARD.md §16.17)
On each turn step:
1. **Player Action:** Insect tap executed; selected line moves along path.
2. **Sub-Board Rotor Ticks:** If $\text{moveCount} \bmod P == 0$, M902 Rhythm Rotors execute automatic $90^\circ$ CW rotation.
3. **Gravity Settlement:** Global and local gravity fields evaluate; loose acorns, sliding marbles, and falling vine segments drift downward until obstructed.
4. **Growth Expansion:** M901 vines and organic thickets expand into designated adjacent cells.
5. **Cross-Board Portals:** Inter-board branch transfers (M903) finalize on destination boards.
6. **State Stability:** Collisions, board boundaries, and heart loss checks evaluated.

---

## Verification Plan

### Automated Tests
1. Verify Falling Vines expand and settle downward in the exact specified tick order.
2. Verify Rhythm Rotor executes automatic $90^\circ$ rotation strictly when moveCount matches modulo condition.
3. Verify Twin-Garden Fork produces one line on Board A and one on Board B simultaneously.
4. Verify Gravity Turntable rotates local gravity vectors without affecting global gravity on the outer board.

### Manual Verification
1. Inspect visual clarity when Rhythm Rotor rotates automatically during insect motion.
2. Confirm dual-board split camera framing smoothly highlights both Boards A and B.
