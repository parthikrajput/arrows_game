# 01 — Phase 3 Scope & Rule Changes (ફેઝ 3 નિયમો)
> Levels 1001–1500 માટે Phase 2 rules ઉપર Cycles system (Day & Night Garden), on-device generation limits, fixed difficulty plateau D 60–76, Remote Config keys અને gameplay invariants.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11, §12, §16, §17](./../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](./../../SCALING_TO_10000_LEVELS.md) · [03 Signature System & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
Phase 1 અને 2 ના તમામ core gameplay rules યથાવત્ રહે છે:
- **Turn-based & Deterministic:** પઝલમાં કોઈ wall-clock timer નથી (માત્ર 30-sec Golden Nectar Rush).
- **Life & Revive:** 3 Hearts per attempt; bonk = −1 Heart; ad revive level દીઠ 1 વાર; Honey Heart Refill 120 coins (max 2/attempt).
- **Boosters:** Nectar Glow Hint (60), Queen's Royal Shield (80), Leaf Blower (100), અને free Scent Trail Preview (350 ms long-press).
- **Layer Rules:** Ground (Ants, layer 0), Air (Worker Bees, layer 1), Canopy (Canopy Scout Bees, layer 2). Ants અને bees ક્યારેય collide થતાં નથી; `tall: true` obstacles ત્રણેય layers ને block કરે છે.
- **Fairness:** દરેક level 0 hearts lost અને 0 boosters થી solvable હોવો ફરજિયાત છે (CI solver certified).

## 2. What's New in Phase 3 (નવું શું છે)
1. **On-Device Level Generation:**
   - Bundled JSON files નથી. Levels રનટાઇમ પર `seed = hash64("ants_bees", level, GENERATOR_VERSION) + k` થી generate થાય છે ([SCALING §2–§4](../../SCALING_TO_10000_LEVELS.md)).
   - CI તમામ 500 levels pre-validate કરે છે; failing seeds `seed_overrides.json` માં સ્ટોર થાય છે.
2. **Signature System — Cycles: Day & Night Garden:**
   - બોર્ડ દર 5 Moves એ બે રાજ્યો વચ્ચે બદલાય છે: **State A (Day)** અને **State B (Night)**.
   - Formula: `cycleState = (moveCount / 5) % 2` (0 = Day/A, 1 = Night/B).
3. **4 New Base Mechanics (M101–M104):**
   - M101 Sunrise Gate (Cycle Gate), M102 Moonlit Twig Bridge (Cycle Bridge), M103 Dawn Burrow (Cycle Portal), M104 Day-Bloom Line (Cycle Color).
4. **45 Base × Modifier Variants:**
   - Base mechanics સાથે 10 standard modifiers જોડાઈને 45 નવી gameplay પરિસ્થિતિઓ સર્જે છે.

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom અને Pan હંમેશા ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines (Ants, Bees, Canopy Scouts નો સંતુલિત mix).
- **Obstacle Count:** 8 થી 14 obstacle instances.
- **Difficulty Plateau (D 60–76):**
  - Standard §17.24 મુજબ Phase 3 થી Phase 20 સુધી difficulty band fixed plateau **60–76** પર રહે છે.
  - Difficulty આંકડાકીય કદ વધારવાને બદલે cycle timing અને mechanic synergy થી ઉત્પન્ન થાય છે.

## 4. Remote Config Keys
- `maxPhase = 3`: Phase 3 content unlock કરવા માટે.
- `p3_cycle_period = 5`: Moves per cycle state (default 5).
- `p3_generator_profile = 0`: CI validated profile selector.

## 5. Invariants & Edge Cases
- **Move Count Tick:** Move counter માત્ર board-mutating player actions (line tap exit/bonk, interactive control tap) પર જ વધે છે. Boosters, zoom/pan અને preview moves ગણાતા નથી.
- **Cycle Flip Moment:** 5મા move ના exit/bonk animation પૂર્ણ થયા પછી cycle state બદલાય છે (Tick order §16.17 step 6).

