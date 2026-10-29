# Spec: Phase 20 UI Additions — Grand Master Garden & Finale HUD

Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-20-signature-system.md, specs/gameplay/phase-20-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 UI Additions — Grand Master Garden & Finale HUD |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define all new Grand Master HUD controls, bloom canopy stage rings, twin cascade gravity arrows, shrouded guardian key progress trackers, prismatic rotor light previews, L10,000 Twin Hornet boss health bars, tutorial cards, and Post-10K Endless Prestige UI.

---

## Current State

Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md`, not yet implemented.

---

## Proposed Change

### 1. Grand Master Systems HUD & Adaptive Minimap
- Adaptive zoom and pan interface (pinch-to-zoom and two-finger pan) optimized for $14\times 14$ maximum board sizes.
- Mini-map navigation thumbnail appears in top-right corner when zoomed in, showing overall board occupancy and boss entity locations.

### 2. Eternal Bloom Canopy Stage Ring (M951)
- Circular floral ring around the base of M951 vines:
  - Green pulsing glow = Withered / Passable.
  - Amber glow = Sprouting / Transitioning.
  - Crimson barrier glow = Full Bloom / Impassable.

### 3. Twin Cascade Gravity Arrows (M952)
- Dual directional arrows emblazoned on M952 nexus node:
  - Blue downward arrow highlights the local gravity slide vector on Board A.
  - Purple swirling portal arrow highlights the inter-board warp trajectory into Board B.

### 4. Shrouded Guardian Key Progress Tracker (M953)
- Floating golden shield HUD badge above M953 showing key progress (e.g. $0/3$, $1/3$, $2/3$, $3/3$).
- Sockets illuminate with royal dew gem sprites as keys are gathered from the mist.

### 5. Prismatic Rotor Light Path Preview (M954)
- Faint dashed rainbow guide rays extend from the $4\times 4$ turntable prism, previewing projected light beam paths after the next scheduled $90^\circ$ rotation.

### 6. L10,000 Twin Hornet Boss Health & Armor Bars
- Dual royal boss HUD bars anchored at the top of the screen during L10,000.
- Displays 3 Chitin Armor Shell pips for Hornet A and Hornet B, along with core HP bars.

### 7. Post-L10,000 Endless Prestige UI
- Main menu features a radiant golden portal: **Endless Grand Mastery Mode**.
- Profile screen unlocks the animated **"Eternal Hive Champion"** badge and sparkling Crown Flower avatar frame.

### 8. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L9501 | The Grand Master Garden | "Every creature, flower, and mechanism from your journey unites here!" |
| L9511 | Eternal Bloom Canopy | "Time your march when these cyclical flowers wither away!" |
| L9631 | Twin Cascade Nexus | "A line split across twin boards under active gravitational pull." |
| L9751 | Shrouded Guardian Aegis | "Dispel the deep fog, gather the Royal Keys, and satisfy the guardian!" |
| L9871 | Prismatic Rhythm Turntable | "Light beams and turn-tracks synchronized to the rhythm of the garden." |
| L10000 | Queen's Eternal Garden | "The ultimate test! 40 lines, 3 layers, twin hornets, and 12 systems. Lead the swarm to eternity!" |

### 9. Accessibility Support
- **Colorblind Palettes:** Bloom canopy states utilize geometric icons (Open Circle = Passable, Solid Octagon = Blocked) in addition to color rings.
- **Reduced Motion:** L10,000 grand victory celebration replaces rotating light beams and swarming bees with static golden banner sparkles and instant victory dialog.

---

## Verification Plan

### Automated Tests
1. Verify tutorial cards trigger strictly on L9501, L9511, L9631, L9751, L9871, and L10000.
2. Verify L10,000 boss bars accurately decrement armor shells upon lever pulls.

### Manual Verification
1. Inspect Minimap HUD toggle when pinching to zoom on 14×14 grid.
2. Verify Endless Grand Mastery portal displays prominently on main menu after beating L10,000.
