# Spec: Phase 18 UI Additions — Garden Festival I HUD & Tutorial Cards

Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-18-signature-system.md, specs/gameplay/phase-18-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 UI Additions — Garden Festival I HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define all new hybrid cycle-floor badges, prism deflection indicators, shaded stairs illumination rings, dawn marble state markers, tutorial cards, and accessibility enhancements required for Garden Festival I (Day-Night Terrace, Sunlit Acorn, Shaded Stairs, and Dawn Marble).

---

## Current State

Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md`, not yet implemented.

---

## Proposed Change

### 1. Cycle-Floor Dual Badge (M851)
- Day-Night Terrace displays a composite badge showing sun/moon diurnal cycle status paired with floor designation ("Floor 1 $\to$ Floor 2").
- During Day turns, the badge radiates a warm golden amber glow; during Night turns, it dims into a cool silver slate icon.

### 2. Prism Acorn Reflection Cue (M852)
- Sunlit Acorn displays a prominent glass faceted prism atop its shell.
- When aligned in an active light beam, a subtle translucent trajectory dashed line extends $90^\circ$ clockwise from the prism, visualizing the deflected beam vector.

### 3. Shaded Stairs Illumination Ring (M853)
- Shaded Stairs render dark thorny vines and a crimson padlock icon while in darkness.
- When an active light beam contacts the stairs, a golden ring of light ripples outward, dissolving the vines and lighting up glowing step treads.

### 4. Dawn Marble Solid/Slide Marker (M854)
- Dawn Marble displays dynamic status iconography:
  - Day state: Translucent glowing droplet icon indicating frictionless sliding capability.
  - Night state: Chiseled granite rock badge indicating locked, immovable solid collision state.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L8501 | Garden Festival I | "Experience the ultimate fusion of garden cycles, terraces, physics, and beams!" |
| L8511 | Day-Night Terrace | "These stairs only carry insects upstairs during the sunny day state!" |
| L8631 | Sunlit Acorn | "Push this acorn into light beams to redirect sunlight across the garden." |
| L8751 | Shaded Stairs | "Shrouded in darkness! Direct a light beam onto these stairs to climb up." |
| L8871 | Dawn Marble | "Slides smoothly during daylight, but freezes into solid immovable rock at night." |

### 6. Phase 18 World Map Entry
- Map node: **Festival Grounds / Solstice Pavilion** (L8501–9000).
- Visual theme: Multi-tiered hanging garden lanterns, sunbeam shafts piercing through foliage, and glowing celebration ribbons.
- Pathway displays festive paper lantern markers every 10 levels.

### 7. Accessibility Support
- **Colorblind Palettes:** Sunlit Acorn beam vectors display high-contrast directional chevrons in addition to color hues.
- **Reduced Motion:** Terrace blooming and retracting transitions render as instantaneous 50 ms crossfades rather than vertical scaling animations.

---

## Verification Plan

### Automated Tests
1. Verify tutorial cards trigger strictly on L8501, L8511, L8631, L8751, and L8871.
2. Verify Dawn Marble status marker updates instantly when cycle shifts between Day and Night.

### Manual Verification
1. Inspect Prism deflection dashed trajectory line for legibility on dense boards.
2. Verify camera transition smoothly frames active floor when ascending Day-Night Terrace.
