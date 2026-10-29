# Spec: Phase 19 VFX — Garden Festival II Visual Effects

Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-19-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 VFX — Garden Festival II Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define all visual effects for Phase 19 Garden Festival II mechanics (falling vine slide dust puffs, rhythm rotor auto-turn chimes, cross-board split portal warp, gravity turntable wind vortex, and L9500 Winds & Blooms celebration) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Falling Vine Slide (M901) | `dust_puff` + `lane_warp` | Spreading shoots slide downwards with leafy dust puffs and organic rustling sounds. | 8 / 18 / 35 |
| Auto-Rotor Turn (M902) | `state_toggle` | Resonant cello chord chimes as the 4x4 sector snaps 90° CW surrounded by golden ring. | 6 / 16 / 35 |
| Cross-Board Split (M903) | `lane_warp` | Insect cleanly divides; one half dashes locally while other teleports via sparkling portal to Board B. | 10 / 25 / 50 |
| Gravity Turntable (M904) | `state_toggle` | Wind vortex sweeps circular region; loose debris settles into newly aligned gravity direction. | 10 / 24 / 45 |
| L9500 Finale Win | `win_confetti` | Grand Festival of Winds & Blooms: massive whirlwind of cherry blossoms, golden honey sparks, confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`dust_puff`, `lane_warp`, `state_toggle`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous kinetic rotations across dual boards are pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `dust_puff` + `lane_warp` Vine Slide: Leaf dust puffs disabled; vines translate instantaneously.
- `state_toggle` Auto-Rotor Turn: Instantaneous 90° snapping rotation without gold ring trail or camera shake.
- `lane_warp` Cross-Board Split: Instantaneous branch spawn without sparkling portal vortex.
- `state_toggle` Gravity Turntable: Loose debris translates linearly without circular wind vortex.
- `win_confetti` L9500 Gala: Blossom swirl count reduced to 15 particles, zero screen shake.

---

## Verification Plan

### Automated Tests
1. Particle clamp test: verify simultaneous auto-rotor turn and cross-board split never exceeds 150 particles on High tier and 30 on Low tier.
2. Reduce Motion setting: verify screen shake is 0 dp across all kinetic events when accessibility toggle is on.

### Manual Verification
1. Verify Rhythm Rotor auto-turn animation synchronizes smoothly with audio chime.
2. Verify cross-board portal teleport effect leaves no trailing visual ghosting on Board A or Board B.
