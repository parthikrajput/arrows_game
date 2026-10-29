# Spec: Phase 10 VFX — Garden Rhythm Visual Effects

Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-10-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 VFX — Garden Rhythm Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define all visual effects for Phase 10 Garden Rhythm mechanics (cricket pulse, bead illumination, queue departure, echo playback, and L5000 Mid-Season Symphony celebration) within established particle tiers, Reduce Motion, and accessibility constraints.

---

## Current State

Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Cricket Gate Pulse (M451) | `state_toggle` | Crisp musical cricket chirp with rhythmic green musical wave radiating outwards. | 6 / 20 / 40 |
| Bead Match (M452) | `state_toggle` | Glass bead illuminates with brilliant rainbow glint and high harp arpeggio note. | 8 / 24 / 45 |
| Queue Exit (M453) | `lane_warp` | Golden number plate dissolves in warm shimmer as correct line exits smoothly. | 6 / 18 / 35 |
| Echo Playback (M454) | `state_toggle` | Crystal bell tone resonates as matching color echoes, opening central flower petal. | 10 / 25 / 50 |
| L5000 Finale Win | `win_confetti` | Grand Mid-Season Symphony Gala: musical clef fireworks, golden music streamers, confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map to standard classes (`state_toggle`, `lane_warp`, `win_confetti`). No novel VFX classes required.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous events are clamped to prevent exceeding the frame-rate threshold on Low tier devices.

### Reduce Motion Adjustments
- `state_toggle` Cricket Pulse: Ring expansion animation disabled; single frame brightness flash on gate frame only.
- `state_toggle` Bead Match: Static glow overlay cross-faded over 0.1 s; no rainbow glint particles.
- `lane_warp` Queue Exit: Number plate fades out instantly; no particle shimmer.
- `state_toggle` Echo Playback: Petal snaps open without crystal bell light rays.
- `win_confetti` L5000 Finale: Static celebratory floral border and golden text banner without flying clefs or streamers.

### Colour-Blind Accessibility
- Bead colours are reinforced with embedded embossed geometric icons (Circle = Red, Diamond = Blue, Triangle = Yellow, Square = Green).
- Queue number plates use bold serif high-contrast typography legible against all terrain textures.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables drifting particles and screen shake.
- [ ] Geometric glyphs on beads provide full clarity under Protanopia, Deuteranopia, and Tritanopia.
- [ ] L5000 finale fireworks do not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/cricket_pulse_effect.dart` | To be created |
| `packages/vfx/lib/effects/bead_match_effect.dart` | To be created |
| `packages/vfx/lib/effects/queue_exit_effect.dart` | To be created |
| `packages/vfx/lib/effects/echo_playback_effect.dart` | To be created |
| `packages/vfx/lib/effects/mid_season_symphony_confetti.dart` | To be created |
| `assets/phase_10/vfx/` | To be created |

---

## Risks and Open Questions

1. **Audio-VFX Synchronization:** The rhythmic concept relies on audio-visual synchrony. On low-tier devices with high audio latency, VFX and sound triggers must be queued together to avoid desync between musical chime and visual bead match.
