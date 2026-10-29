# Spec: Phase 18 VFX — Garden Festival I Visual Effects

Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-18-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 VFX — Garden Festival I Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define all visual effects for Phase 18 Garden Festival I mechanics (terrace cycle blooming and sinking, acorn prism beam deflection, shaded stairs solar illumination, marble state phase shift, and L9000 Festival Gala celebration) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Terrace Cycle Shift (M851) | `state_toggle` | Daylight terrace blooms upwards with golden sun flares; at night sinks into ground with cool mist. | 8 / 20 / 40 |
| Acorn Beam Deflect (M852) | `glow_burst` | Brilliant prismatic flash as rolling acorn redirects beam with chromatic particle spray. | 10 / 25 / 50 |
| Shaded Stair Light (M853) | `glow_burst` | Darkness vaporizes as solar beam hits stairs, leaving sparkling steps of pure light. | 10 / 24 / 45 |
| Marble State Shift (M854) | `state_toggle` | Slick water droplet crystallizes into rough gray granite rock with frosty crackle. | 6 / 16 / 35 |
| L9000 Finale Win | `win_confetti` | Grand Festival of Sunlight & Shadows: glowing paper lanterns, golden sunbursts, fireworks. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`state_toggle`, `glow_burst`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Multi-floor concurrent particle systems are strictly pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `state_toggle` Terrace Cycle Shift: Instantaneous floor link state change; upward bloom and sinking mist disabled.
- `glow_burst` Acorn Beam Deflect: Instant ray redirection without chromatic particle burst.
- `glow_burst` Shaded Stair Light: Instant illumination toggle; sparkling light trail disabled.
- `state_toggle` Marble State Shift: Instant sprite swap between droplet and rock; frost crackle particles disabled.
- `win_confetti` L9000 Gala: Confetti count reduced to 15 particles, zero screen shake.

---

## Verification Plan

### Automated Tests
1. Particle clamp test: verify simultaneous beam deflection and terrace shift never exceeds 150 particles on High tier and 30 on Low tier.
2. Reduce Motion setting: verify screen shake is 0 dp across all hybrid events when accessibility toggle is on.

### Manual Verification
1. Verify Day-Night Terrace visual transition does not cause frame drops on multi-floor camera changes.
2. Verify Prismatic beam deflection renders cleanly across both Floor 1 and Floor 2 viewpoints.
