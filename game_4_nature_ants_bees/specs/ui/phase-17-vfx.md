# Spec: Phase 17 VFX — Garden Guardians Visual Effects

Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-17-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 VFX — Garden Guardians Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define all visual effects for Phase 17 Garden Guardians mechanics (boss hit impacts, armor carapace fracture, mud blocker spawn pop, boss defeat vortex dissolve, and L8500 Royal Hive Defense celebration) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Guardian Hit (M801) | `glow_burst` | Boss flinches with electric yellow sparks, earthy rumble, and 4 dp screen shake. | 8 / 20 / 40 |
| Shell Shatter (M802) | `state_toggle` | Thick beetle armor shell cracks with metallic fracture chime, crumbling into stone dust. | 10 / 25 / 50 |
| Blocker Spawn (M803) | `dust_puff` | Mud bubble pops violently at nest perimeter, depositing fresh clay obstacle. | 6 / 16 / 30 |
| Boss Defeat (M804) | `state_toggle` | Giant guardian dissolves into brilliant vortex of golden pollen and floating petals (300 ms). | 12 / 35 / 70 |
| L8500 Finale Win | `win_confetti` | Grand Royal Hive Defense Gala: massive honey bursts, royal crown fireworks, rainbow confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`glow_burst`, `state_toggle`, `dust_puff`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous boss hits or multi-entity defeats are pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `glow_burst` Guardian Hit: Spark particles disabled; boss flashes white tint for 60 ms with zero screen shake.
- `state_toggle` Shell Shatter: Instantaneous sprite change from armored to unarmored without stone dust particles.
- `dust_puff` Blocker Spawn: Mud obstacle appears instantaneously in 1 frame without burst bubbles.
- `state_toggle` Boss Defeat: Clean 150 ms alpha fade-out; swirling pollen particles disabled.
- `win_confetti` L8500 Gala: Confetti count reduced to 15 particles, zero screen shake.

---

## Verification Plan

### Automated Tests
1. Particle clamp test: verify simultaneous dual hornet defeat never exceeds 150 particles on High tier and 30 on Low tier.
2. Reduce Motion setting: verify screen shake is 0 dp across all guardian events when accessibility toggle is on.

### Manual Verification
1. Verify Boss Defeat animation duration stays within 300 ms (`p17_guardian_defeat_ms = 300`) and cleanly frees pathing grid.
2. Verify Wasp Nest blocker spawn particle does not obscure the countdown badge.
