# 06 — UI, VFX & QA (Phase 5)
> Phase 5 (Coconut Grove Physics) ની UI (Push direction indicators), visual effects (VFX) mapping, tier limits, tutorial cards, CI validation, performance budget, analytics અને QA checklist.

**Related docs:** [Phase 5 index](./README.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../../PERFORMANCE_OPTIMIZATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Phase 5 Rules](./01_PHASE_5_SCOPE_AND_RULES.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. UI Additions: Push Indicators
- **Push Cue:** સાપનું માથું નારિયેળની અડીને ઊભું હોય ત્યારે નારિયેળ પર હળવો ગતિ-તીર (direction chevron) દર્શાવાય છે.
- **Heavy Boulder Warning:** Jackfruit Boulder (M204) પર સામાન્ય સાપ દ્વારા ટેપ કરતાં નાનું "Too Heavy!" શેક પ્રોમ્પ્ટ મળે છે.
- **Pit Status:** ભરાયેલા ખાડા પર માટી અને ઘાસની કુદરતી રચના દેખાય છે.

---

## 2. VFX Implementation (VFX Standard §4 મુજબ)

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particles |
|---|---|---|---|
| M201 Coconut Falls in Pit | `dust_puff` + `state_toggle` | ખાડામાં નારિયેળ બેસતાં ધૂળનો પફ અને ઘાસ ફેલાવું | Low 0, Mid 10, High 18 |
| M202 Dew-Slick Slide | `dust_puff` + `lane_warp` | લપસતી વખતે પાછળ સ્પાર્કલ સ્લાઇડ ટ્રેઇલ | Low 0, Mid 8, High 16 |
| M203 Key Coconut Unlocks | `state_toggle` + `crack_shards` | સોનેરી કી જ્યોત અને તાળું તૂટવું | Low 0, Mid 12, High 24 |
| M204 Heavy Boulder Push | `bump_flash` + `dust_puff` | ભારે પથ્થર ખસતાં જમીન કંપન (Mid 4 dp, High 6 dp shake) | Low 0, Mid 15, High 30 |
| L2500 Finale Shrine Burst | `win_confetti` + `chest_burst` | શ્રાઇન બર્સ્ટ અને ગોલ્ડન કન્ફેટી | Low 30, Mid 80, High 150 |

---

## 3. Accessibility & Performance
- **Reduce Motion:** Heavy boulder shake બંધ થશે; sliding blocks પર ટ્રેઇલ અને ધૂળ અદૃશ્ય થશે (માત્ર smooth translation).
- **Performance Budget:**
  - Continuous sliding (M202) દરમિયાન ફ્રેમરેટ 60 fps જળવાશે.
  - On-device level generation: isolate thread પર **≤ 300 ms** (mid-tier).

---

## 4. CI Validation & Metadata Assets
- `assets/levels/phase_5_meta.bin` માં L2001–2500 ના સોલ્યુશન્સ અને પાર મૂવ્સ શિપ થશે.
- `assets/levels/seed_overrides.json` માં k-overrides સંગ્રહાશે.

---

## 5. QA Checklist (Phase 5)
| ID | Area | Test Case | Status |
|---|---|---|---|
| P5-QA-01 | Basic Push | પાછળ ખાલી સેલ હોય તો નારિયેળ 1 સેલ આગળ ખસે છે | Not run |
| P5-QA-02 | Pit Filling | નારિયેળ પડતાં ખાડો સામાન્ય ફ્લોર બની જાય છે | Not run |
| P5-QA-03 | Continuous Slide | M202 જ્યાં સુધી અવરોધ ન આવે ત્યાં સુધી લપસતું રહે છે | Not run |
| P5-QA-04 | Crate Key | M203 લોક સેલ પર પહોંચતાં જ લોક કાયમ માટે ખુલી જાય છે | Not run |
| P5-QA-05 | Heavy Resistance | સામાન્ય સાપ M204 ને ધક્કો મારતાં બોંક (−1 Heart) થાય છે | Not run |
| P5-QA-06 | Giant Anaconda Push| જાયન્ટ સાપ M204 ને સફળતાપૂર્વક 1 સેલ ધકેલે છે | Not run |
| P5-QA-07 | Open Edge Fall | ખુલ્લી કિનારે ધકેલાતાં નારિયેળ બોર્ડ બહાર પડીને દૂર થાય છે | Not run |
| P5-QA-08 | Determinism | Seed રી-જનરેટ કરતાં Android અને iOS પર એકસરખું JSON પરિણામ મળે છે | Not run |
| P5-QA-09 | 0-Hearts Check | L2001–2500 સોલ્વર રિપ્લેમાં કોઈ forced damage નથી | Not run |
| P5-QA-10 | Finale L2500 | L2500 ક્લિયર થતાં 1,000 coins + 6 boosters મળે છે | Not run |

