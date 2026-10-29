# Spec: Phase 9 VFX — Swarm Splits Visual Effects

Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-9-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 VFX — Swarm Splits Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define all visual effects for Phase 9 Swarm Splits mechanics (merge fusion, fork split, clasp unlock, arch opening, and L4500 finale celebration) while adhering to particle budgets, Reduce Motion options, and colour-blind accessibility.

---

## Current State

Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md`, not yet implemented. Existing effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Merge Fusion (M401) | `state_toggle` | Honey bond snaps lines together with golden droplet burst and cheerful stick sound. | 8 / 24 / 45 |
| Fork Split (M402) | `lane_warp` | Line cleanly divides into two neat columns with crisp leaf snap and divergent trails. | 10 / 25 / 50 |
| Clasp Unlock (M403) | `state_toggle` | Golden clasp pops open with bright chime, releasing back segments with yellow sparkle. | 6 / 18 / 35 |
| Arch Opening (M404) | `state_toggle` | Dense ivy arch unfurls into blooming floral canopy with sweet resonant chord. | 8 / 26 / 55 |
| L4500 Finale Win | `win_confetti` | Grand Swarm Reunion: converging firefly streams, golden honey fireworks, festive petals. | 30 / 80 / 150 |

> [!NOTE]
> All effects map to existing VFX classes (`state_toggle`, `lane_warp`, `win_confetti`). No new effect classes are required.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous events (e.g. multiple splits or merges occurring in succession) must be batched or clamped to remain strictly within per-frame tier allowances.

### Reduce Motion Adjustments
- `state_toggle` Merge Fusion: Replaced by immediate single golden outline flash (1 frame), no floating droplet particles.
- `lane_warp` Fork Split: Replaced with instantaneous branching without trailing leaf particles.
- `state_toggle` Clasp Unlock: Clasp sprite simply toggles open with 0.1 s opacity cross-fade.
- `state_toggle` Arch Opening: Canopy sprite switches to open state with 0.1 s cross-fade.
- `win_confetti` L4500 Finale: Static celebratory golden aura and banner overlay without moving fireflies.

### Colour-Blind Accessibility
- Golden honey tones (`#FFB300`) accompanied by viscous droplet shapes.
- Divergent branch trails use high-contrast primary colours and directional chevron overlays.
- Key clasp uses distinct lock/unlock geometric glyphs in addition to amber sparkle.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables drifting particles and screen shake.
- [ ] Non-colour geometric glyphs provide full clarity under Protanopia, Deuteranopia, and Tritanopia.
- [ ] L4500 finale fireworks do not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/merge_fusion_effect.dart` | To be created |
| `packages/vfx/lib/effects/fork_split_effect.dart` | To be created |
| `packages/vfx/lib/effects/clasp_unlock_effect.dart` | To be created |
| `packages/vfx/lib/effects/arch_open_effect.dart` | To be created |
| `packages/vfx/lib/effects/swarm_reunion_confetti.dart` | To be created |
| `assets/phase_9/vfx/` | To be created |

---

## Risks and Open Questions

1. **Simultaneous Fork and Merge VFX:** In late-stage variant levels, a split branch may enter a merge pad on the same move cycle; the VFX pipeline must sequence or combine the two audio-visual cues smoothly.
