# Spec: Phase 15 UI Additions — Brook & Rails HUD & Tutorial Cards

Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-15-signature-system.md, specs/gameplay/phase-15-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 UI Additions — Brook & Rails HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define all new flowing water texture shaders, sluice valve state indicators, tidal countdown HUD meters, tutorial cards, and accessibility enhancements required for Brook & Rails (Brook Fork, Tide Brook, Sluice Lever, and Lazy River).

---

## Current State

Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md`, not yet implemented.

---

## Proposed Change

### 1. Flowing Water Texture Shader
- Brook tiles render animated blue-green water waves drifting along flow vectors at $32\text{ dp/s}$.
- Small translucent directional chevrons drift with the current, visually communicating vector direction.
- In low-motion mode, dynamic flowing water texture is disabled; static high-contrast directional arrows are displayed.

### 2. Sluice Lever Valve State Indicator (M703)
- Sluice Levers display a sturdy wooden rotary valve.
- State: glowing brass wheel when open; cross-barred wooden dam sprite when closed.
- Tapping triggers a tactile mechanical rotation sound and brief 0.1 s UI pulse.

### 3. Tide Reversal Countdown Badge (M702)
- Tide Brook streams display a miniature floating water-clock badge at the stream head (e.g. "2 moves to reverse").
- Badge turns amber at 1 move remaining, warning the player of imminent current flip.

### 4. Lazy River Carousel Directional Indicators (M704)
- Lazy River corner tiles display subtle circular vortex ripples highlighting clockwise orbital movement.
- An ant circulating within the loop displays a small "Orbiting" icon above its head.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L7001 | Brook & Rails | "Flowing streams drift resting ants forward with the water current!" |
| L7011 | Brook Fork | "Water branches in two ways. Sluice gates choose the ant's route." |
| L7131 | Tide Brook | "The garden tide turns! River flow reverses direction periodically." |
| L7251 | Sluice Lever | "Tap the wooden lever to reroute river forks and open canal gates." |
| L7371 | Lazy River | "Closed water loop! Ants orbit smoothly until you tap them to exit." |

### 6. Phase 15 World Map Entry
- New chapter entry "Brook & Rails" unlocks on world map when `maxPhase ≥ 15`.
- Chapter icon: flowing garden canal with a miniature waterwheel.

---

## Acceptance Criteria
- [ ] Brook water shader clearly indicates flow direction at 32 dp/s without frame drops.
- [ ] Sluice Lever valve state clearly distinguishes open and closed flow configurations.
- [ ] Tide countdown badge accurately displays moves remaining until 180° reversal.
- [ ] Lazy River circulation path is visually distinct from linear streams.
- [ ] All 5 tutorial cards fire once on intro levels and suppress on replays.
- [ ] Stream colors comply with WCAG 2.1 AA contrast standards against grass terrain.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/flowing_brook_shader.dart` | To be created |
| `packages/ui/lib/hud/sluice_valve_widget.dart` | To be created |
| `packages/ui/lib/hud/tide_countdown_badge.dart` | To be created |
| `packages/ui/lib/hud/lazy_river_overlay.dart` | To be created |
| `packages/ui/lib/tutorial/phase_15_cards.dart` | To be created |
| `assets/phase_15/ui/` | To be created |

---

## Risks and Open Questions

1. **Chevron Contrast on Bright Board Themes:** Translucent white flow chevrons must remain clearly legible on bright sandy or sunny grass ground textures. Outline strokes should be added.
