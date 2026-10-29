# 06 — UI, VFX & QA (Phase 7)
> Phase 7 (Whirlwind Valley) ની UI (Rotor handles, direction chevrons), visual effects (VFX) mapping, tier limits, tutorial cards, CI validation, performance budget, analytics અને QA checklist.

**Related docs:** [Phase 7 index](./README.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../../PERFORMANCE_OPTIMIZATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Phase 7 Rules](./01_PHASE_7_SCOPE_AND_RULES.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. UI Additions: Rotor Handles & Directional Cues
- **Center Handle:** 4×4 Island Spinner (M301) ના કેન્દ્રમાં લાકડાનું ચક્ર હેન્ડલ દેખાય છે, જે ટેપ કરતાં 90° CW ફરે છે.
- **Spinning Snake Indicator:** M303 ના માથા પર આગામી દિશા દર્શાવતો નાનો ગોળાકાર તીર ક્યુ (swirl glyph) પ્રદર્શિત થાય છે.
- **Tangled Lock Warning:** જો કોઈ સાપ પોતાના શરીર તરફ દિશા ધરાવતો હોય તો તેના માથા પર "Tangled!" વૉબલ આઇકોન દેખાય છે.

---

## 2. VFX Implementation (VFX Standard §4 મુજબ)

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particles |
|---|---|---|---|
| M301 Sub-board Rotation | `rotate_swoosh` | 4×4 પ્લેટફોર્મ ફરતાં પાંદડાંનો વમળ (static picture rotate, no rebuild) | Low: 0, Mid: 15, High: 30 |
| M302 Shifting Hedges | `dust_puff` | કિનારીની ઝાડી 1 સેલ સરકતાં હળવી ધૂળ | Low: 0, Mid: 6, High: 12 |
| M303 Spinning Snake Turn | `lane_warp` | સાપનું માથું 90° વળાંક લેતાં હળવો ગ્રીન સ્પાર્કલ | Low: 0, Mid: 8, High: 16 |
| M304 Gear Lock Latch | `state_toggle` + `badge_pulse` | ગિયર યોગ્ય ખૂણે સેટ થતાં પથ્થર ગેટ ઓપન | Low: 0, Mid: 10, High: 20 |
| L3500 Finale Summit Burst | `win_confetti` + `chest_burst` | શિખર વાવાઝોડું સોનેરી પાંદડાં અને કન્ફેટી | Low: 30, Mid: 80, High: 150 |

---

## 3. Accessibility & Performance
- **Reduce Motion:** રોટેશન સ્મૂધ એનિમેશનને બદલે 100 ms ઇન્સ્ટન્ટ સ્નેપ થશે; વમળના પાંદડાં બંધ થશે.
- **Performance Budget:**
  - 4×4 રોટેશન દરમિયાન static layer picture re-record થતું નથી; માત્ર `Canvas.rotate` મેટ્રિક્સ ટ્રાન્સફોર્મ થાય છે.
  - On-device level generation: **$\le 300\text{ ms}$** (mid-tier).

---

## 4. CI Validation & Metadata Assets
- `assets/levels/phase_7_meta.bin` માં L3001–3500 ના સોલ્યુશન્સ અને પાર મૂવ્સ શિપ થશે.
- `assets/levels/seed_overrides.json` માં k-overrides સંગ્રહાશે.

---

## 5. QA Checklist (Phase 7)
| ID | Area | Test Case | Status |
|---|---|---|---|
| P7-QA-01 | Partial Snake Lock | અડધો સાપ 4×4 ની અંદર અને અડધો બહાર હોય ત્યારે રોટર Locked Tap આપે છે | Not run |
| P7-QA-02 | Sub-board Rotation | સંપૂર્ણ અંદર રહેલા સાપનું શરીર અને `dir` 90° CW ફરે છે | Not run |
| P7-QA-03 | Tangled Invariant | નવી દિશા પોતાના શરીર પર આવતાં સાપ Tangled (Locked Tap) બને છે | Not run |
| P7-QA-04 | Border Shift | દરેક Move પછી Turning Hedges 1 સેલ CW આગળ સરકે છે | Not run |
| P7-QA-05 | Spinning Snake | સાપ દર Move એ 90° CW દિશા બદલે છે | Not run |
| P7-QA-06 | Gear Alignment | M304 માત્ર નિયત રોટેશન એંગલ પર જ ખુલે છે | Not run |
| P7-QA-07 | Determinism | Seed રી-જનરેટ કરતાં Android અને iOS પર એકસરખું JSON પરિણામ આપે છે | Not run |
| P7-QA-08 | 0-Hearts Check | L3001–3500 સોલ્વર રિપ્લેમાં કોઈ forced damage નથી | Not run |
| P7-QA-09 | Finale L3500 | L3500 ક્લિયર થતાં 1,000 coins + 6 boosters મળે છે | Not run |
