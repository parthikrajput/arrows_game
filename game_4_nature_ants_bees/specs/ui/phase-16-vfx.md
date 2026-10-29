# Spec: Phase 16 VFX — Royal Keyring Visual Effects

Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-16-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 VFX — Royal Keyring Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define all visual effects for Phase 16 Royal Keyring mechanics (chain key hopping, key crafting synthesis fusion, skeleton row/column light wave sweep, key swap arc trace, and L8000 Queen's Royal Lock Gala celebration) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Chain Key Pass (M751) | `state_toggle` | Golden key hops from opened lock to next insect with high musical harp chime. | 6 / 18 / 35 |
| Key Crafting (M752) | `state_toggle` | Dual half-keys orbit central flower, fusing with radiant polychromatic flash and deep chord. | 10 / 25 / 50 |
| Skeleton Wave (M753) | `glow_burst` | Orthogonal golden light wave sweeps across row and column, disintegrating locks (120 ms). | 12 / 30 / 60 |
| Key Swap (M754) | `state_toggle` | Twin golden sparks trace looping arcs through the air, exchanging key icons between lines. | 8 / 20 / 40 |
| L8000 Finale Win | `win_confetti` | Grand Queen's Royal Lock Gala: showering golden filigree keys, royal crown fireworks, confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`state_toggle`, `glow_burst`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous key passes or multi-lock skeleton disintegrations are pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `state_toggle` Chain Key Pass: Instant key icon reappearance on recipient; arc particle hops disabled.
- `state_toggle` Key Crafting: Instant fusion flash without orbiting rotation animation.
- `glow_burst` Skeleton Wave: Instant row/column highlight flash (40 ms) instead of sweeping 120 ms beam wave.
- `state_toggle` Key Swap: Keys swap positions instantly in 1 frame without looping arc trails.
- `win_confetti` L8000 Gala: Confetti count reduced to 15 particles, zero screen shake.

---

## Verification Plan

### Automated Tests
1. Particle clamp test: verify simultaneous skeleton sweep and key crafting never exceeds 150 particles on High tier and 30 on Low tier.
2. Reduce Motion setting: verify skeleton wave duration drops from 120 ms to 40 ms instant tint.

### Manual Verification
1. Verify Skeleton Dew Key exit feels punchy and clear without obscuring neighboring line paths.
2. Verify Key Crafting audio chord synchronizes accurately with visual fusion flash.
