# Spec: Phase 20 Signature System — Grand Master Garden & All-Systems Integration

Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-19-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 Signature System — Grand Master Garden & All-Systems Integration |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define the comprehensive system architecture, deterministic 9-step tick execution pipeline (SHARED_CORE_STANDARD.md §16.17), all-systems integration rules (uniting mechanics from all previous 19 phases), and L10,000 Grand Finale systems coordination for the Grand Master Garden.

---

## Current State

Design documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md` and `phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. Architectural Principle: Pinnacle Integration
- Grand Master Garden brings together all mechanics across the game's entire 10,000-level journey:
  - Diurnal Cycles (Phase 3), Multi-floor Terraces (Phase 4), Acorn Physics (Phase 5), Sunlight Beams (Phase 6), Whirling Rotors (Phase 7), Floral Growth (Phase 8), Split/Merge Swarms (Phase 9), Rhythmic Sequencing (Phase 10), Linked Twin Gardens (Phase 11), Gravity Incline (Phase 12), Mystery Fog (Phase 13), Reflecting Pond (Phase 14), Brook Conveyors (Phase 15), Royal Keyrings (Phase 16), and Garden Guardians (Phase 17).
- Four Grand Combos represent pool integrations across major evolutionary eras:
  - M951 (Pool P3–P8): Eternal Bloom Canopy (Cycles × Growth).
  - M952 (Pool P9–P12): Twin Cascade Nexus (Linked Boards × Split/Merge × Gravity).
  - M953 (Pool P13–P17): Shrouded Guardian Aegis (Hidden Fog × Royal Keys × Guardians).
  - M954 (Pool P18–P19): Prismatic Rhythm Turntable (Sunlit Beams × Rotation × Rhythm Sequencing).

### 2. Standard 9-Step Deterministic Multi-System Tick Order (§16.17)
Whenever multiple dynamic systems trigger on a single player move, the engine strictly processes them in this exact order:
1. **Player Move Execution:** Selected insect line advances along its planned path on its current layer.
2. **Conveyors & Brook Streams (Phase 15):** Conveyor tracks and water currents advance resting objects by 1 cell.
3. **Gravity Shift & Acorn Falls (Phase 12):** Loose acorns and unsupported blocks fall along active gravity vectors.
4. **Growth Flora Spreading (Phase 8):** Morning glory vines and thorn bushes expand into free adjacent cells.
5. **Rhythm Pulse & Timed Rotors (Phase 10 & 19):** Modulo move counter updates; automated turntables rotate $90^\circ$ CW.
6. **Light Beam & Prism Recalculation (Phase 6):** Solar rays refract through mirrors and newly displaced prism blocks.
7. **Hidden Fog Clearance (Phase 13):** Mystery mist dispels around newly cleared paths and line coordinates.
8. **Guardians Reaction & Armor State (Phase 17):** Boss entities evaluate key deliveries, core strikes, and armor integrity.
9. **Line Clear & Goal Verification:** Insects reaching nest/hive exits vanish from grid; win/loss status evaluated.

### 3. Ultimate Grand Finale — L10,000 Queen's Eternal Garden
- Full master board: $14\times 14$ grid dimensions.
- 3 simultaneous spatial layers: Ground Ants, Worker Bees, and Canopy Scout Bees.
- Exactly 40 insects coordinating through at least 12 distinct active mechanics.
- Features Twin Hornet Bosses with 3 Chitin Armor Shells each, requiring precise multi-step puzzle resolution to clear.
- Target difficulty peaks at $D \approx 95$.

### 4. Post-10,000 Endless Prestige Loop
- Upon clearing L10,000, player is awarded the "Eternal Hive Champion" cosmetic badge.
- Unlocks **Endless Grand Mastery Mode**, generating procedural high-tier daily and prestige levels from the complete pool of mechanics.

---

## Verification Plan

### Automated Tests
1. Verify all 9 steps in §16.17 execute in exact sequence without race conditions or re-entrant calls.
2. Verify L10,000 board configuration contains 40 lines across 3 layers and meets $D \approx 95$ target.
3. Verify Endless Grand Mastery unlock flag persists upon L10,000 completion.

### Manual Verification
1. Play through L10,000 in debug harness to confirm all 12 simultaneous systems tick deterministically.
2. Validate post-10K UI displays Endless Mastery access and profile badge properly.
