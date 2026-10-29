# Spec: Phase 9 UI Additions — Swarm Splits HUD & Tutorial Cards

Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-9-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 UI Additions — Swarm Splits HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define all new HUD indicators, preview markers, tutorial cards, and accessibility enhancements required for Swarm Splits (Merge Pads, Fork Twigs, Segment Clasps, and Reunion Arches).

---

## Current State

Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md`, not yet implemented.

---

## Proposed Change

### 1. Merge Pad Sticky Pool UI (M401)
- Honey Merge Pad displays a translucent golden honey pool.
- When the first line halts, subtle ripples and a shimmering amber ring encircle the head segment to indicate "Awaiting coupling".
- Accessibility: screen-reader announces "Honey Merge Pad: first insect coupled, waiting for second line".

### 2. Fork Branch Trajectory Preview (M402)
- Scent Trail Preview (long-press 350 ms) on a Fork Twig renders two divergent trajectory paths (left 90° CCW and right 90° CW).
- Blocked branch paths are tinted transparent crimson with an 'X' indicator, showing atomic failure before commit.
- In low-motion mode, paths are rendered as solid geometric lines without dash animations.

### 3. Segment Clasp Buckle UI (M403)
- Line segments locked by a Segment Clasp show an embossed miniature golden clasp buckle overlay.
- A floating dotted tether connects the clasp to its linked key insect.
- Key insect displays a matching miniature key icon on its dorsal sprite.

### 4. Reunion Arch Dual Progress Indicator (M404)
- Arch frame has two floral indicator bulbs (left and right arches).
- When left split half exits, left petal lights up green. When right split half exits, right petal lights up green.
- Both lit triggers full blooming arch animation and open pathway indicator.

### 5. Tutorial Overlay Cards
Cards fire exactly once per player account upon encountering the mechanic at its intro level:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L4001 | Swarm Splits | "Ants and bees split into branches or unite into large caravans!" |
| L4011 | Honey Merge Pad | "Move lines onto the sticky pad to combine them into one long caravan." |
| L4131 | Fork Twig | "Divides the line into two halves exiting left and right. Both paths must be clear!" |
| L4251 | Segment Clasp | "Clasp locks the back segments until the linked key insect escapes." |
| L4371 | Reunion Arch | "Both split halves must exit safely before this majestic arch will open." |

- Standard bottom sheet format, dismissible, skippable after 1.5 s, state persisted in local profile.

### 6. Phase 9 World Map Entry
- New chapter entry "Swarm Splits" unlocks on the world map when `maxPhase ≥ 9`.
- Chapter icon: stylized branching twig with coupled honey bees.

---

## Acceptance Criteria
- [ ] Merge Pad displays ripple and coupling wait state when first line halts.
- [ ] Scent Trail Preview shows dual trajectory paths and flags collisions atomically.
- [ ] Segment Clasp visually binds back segments and marks key line clearly.
- [ ] Reunion Arch tracks left and right split half exits independently.
- [ ] All 5 tutorial cards fire at their designated x1 intro levels and suppress on replays.
- [ ] UI contrast meets WCAG 2.1 AA guidelines.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/ui/lib/hud/merge_pad_indicator.dart` | To be created |
| `packages/ui/lib/hud/fork_preview_overlay.dart` | To be created |
| `packages/ui/lib/hud/segment_clasp_badge.dart` | To be created |
| `packages/ui/lib/hud/reunion_arch_meter.dart` | To be created |
| `packages/ui/lib/tutorial/phase_9_cards.dart` | To be created |
| `assets/phase_9/ui/` | To be created |

---

## Risks and Open Questions

1. **Dual trajectory clutter on mobile:** In tight 14x14 boards, drawing two divergent scent trail paths simultaneously may overlap other lines. Need clear alpha fading for overlapping preview trails.
2. **Tether line legibility:** Dynamic dotted tether between clasp and key insect must not obscure board obstacles.
