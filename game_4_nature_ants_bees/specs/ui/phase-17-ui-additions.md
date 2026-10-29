# Spec: Phase 17 UI Additions — Garden Guardians HUD & Tutorial Cards

Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-17-signature-system.md, specs/gameplay/phase-17-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 UI Additions — Garden Guardians HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define all new boss segmented HP bars, armor shell overlays, spawner pulse countdown counters, heart-seed core reticles, tutorial cards, and accessibility enhancements required for Garden Guardians (Twin Hornets, Armored Rhino Beetle, Wasp Nest Guardian, and Heart-Seed Guardian).

---

## Current State

Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md`, not yet implemented.

---

## Proposed Change

### 1. Boss Segmented HP Bar
- Floating gold-trimmed segmented life bar positioned directly above each $2\times 2$ guardian entity.
- Each segment represents 1 hit point; empty segments transition to a dark hollow socket when damaged.
- For Twin Hornets (M801), both entities mirror identical segmented HP bars; taking damage on one body updates both bars simultaneously.

### 2. Armor Shell Overlay (M802)
- Armored Rhino Beetle renders a reflective stone/metallic carapace with a red padlock icon.
- Tapping or targeting an armored beetle while the shell is intact causes the red shield icon to pulse twice with a dull clank audio cue.
- When the linked Ivy Lever is pulled, the shell overlay cracks and shatters with a satisfying visual fracture.

### 3. Spawner Pulse Counter (M803)
- Wasp Nest Guardian displays a small circular mud badge showing the remaining moves until the next blocker spawn (e.g. "3 moves").
- The badge pulses with an amber warning outline when only 1 move remains before a spawn occurs.

### 4. Heart-Seed Core Reticle (M804)
- Central Core Tile inside the Heart-Seed Guardian renders a glowing red gem reticle.
- When an insect is selected whose planned linear exit path directly bisects the core tile, the reticle flares bright magenta to confirm valid trajectory targeting.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L8001 | Garden Guardians | "Huge boss obstacles block paths! Exit linked lines to deplete their HP." |
| L8011 | Twin Hornets | "Two giant hornets share one life pool. Clear either line to damage both!" |
| L8131 | Armored Rhino Beetle | "Invulnerable shell! Pull the linked lever to crack open its defenses." |
| L8251 | Wasp Nest Guardian | "Spawns mud blockers periodically. Defeat it quickly to stop the swarm!" |
| L8371 | Heart-Seed Guardian | "Only lines that exit directly through the center core deal damage." |

### 6. Phase 17 World Map Entry
- Map node: **Guardian Citadel / Hive Bastion** (L8001–8500).
- Visual theme: Imposing ancient bark trees, amber honeycomb spires, and colossal guardian silhouettes in the canopy background.
- Pathway turns into a sturdy ironwood vine accented with horn badges every 10 levels.

### 7. Accessibility Support
- **Colorblind Palettes:** Segmented HP bars use dual indicators (numeric count label "HP: 4/4" inside the bar) so color perception is not required.
- **Reduced Motion:** Boss death sequence replaces swirling pollen vortex with a clean 200 ms opacity fade-out; screen shake is disabled.

---

## Verification Plan

### Automated Tests
1. Verify tutorial cards trigger strictly on L8001, L8011, L8131, L8251, and L8371.
2. Verify numeric HP labels update accurately on each registered hit.

### Manual Verification
1. Inspect HP bar visibility when zooming out to 14×14 grid scale.
2. Verify Core Reticle flare is distinct from ordinary selection glows.
