# 06 — UI, VFX & QA (Phase 4)
> Phase 4 (Great Tree Floors) ની UI (Floor tabs, camera vertical slide), visual effects (VFX) mapping, tier limits, tutorial cards, CI validation, performance budget, analytics અને QA checklist.

**Related docs:** [Phase 4 index](./README.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../../PERFORMANCE_OPTIMIZATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Phase 4 Rules](./01_PHASE_4_SCOPE_AND_RULES.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. UI Additions: Multi-Floor Tabs
- **Floor Navigation Bar:** Screen ની જમણી બાજુ વર્ટિકલ ફ્લોટિંગ ટેબ્સ (`[F3]`, `[F2]`, `[F1]`).
- **Active State:** સક્રિય માળનો ટેબ હાઈલાઈટ થાય છે.
- **Inter-floor Transition:** ટેબ ટેપ કરતાં કેમેરા 200 ms માં વર્ટિકલ પેરાલેક્સ ઇફેક્ટ સાથે નવા માળ પર જાય છે.
- **Off-screen Floor Badge:** જો બીજા માળ પર કોઈ સાપ તૈયાર હોય કે એક્શન ચાલી રહી હોય તો તે ફ્લોર ટેબ પર હળવું પલ્સ ડોટ (leaf glow) દેખાય છે.

---

## 2. VFX Implementation (VFX Standard §4 મુજબ)

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particles |
|---|---|---|---|
| Floor Camera Slide | `lane_warp` | હળવી ઊભી સ્લાઇડ અને પાંદડાંની લહેર | Low 0, Mid 10, High 20 |
| M151 Root Stairs Transition | `portal_whoosh` | સાપ સીડીમાં પ્રવેશે ત્યારે મૂળિયાંમાંથી લીલો સ્પાર્કલ | Low 0, Mid 8, High 16 |
| M152 Dewglass Floor Passage | `beam_glow` | કાચ જેવી પારદર્શક ટાઈલ પરથી સરકતાં ક્રિસ્ટલ શાઇન | Low 0, Mid 6, High 12 |
| M153 Knot Hole Drop | `dust_puff` | હોલમાં પડતાં અને નીચે લેન્ડ થતાં સોફ્ટ ડસ્ટ ક્લાઉડ | Low 0, Mid 10, High 18 |
| M154 Vine Lift Movement | `state_toggle` + `dust_puff` | પાલખું ખસે ત્યારે વેલોનું ખેંચાણ અને ધૂળ | Low 0, Mid 12, High 24 |
| L2000 Finale Crown Burst | `win_confetti` + `chest_burst` | કેનોપી ક્રાઉન કન્ફેટી અને ગોલ્ડન લીવ્સ | Low 30, Mid 80, High 150 |

---

## 3. Accessibility & Performance
- **Reduce Motion:** Vertical slide animation ની જગ્યાએ instant cut થશે; floor switch સીધો render થશે.
- **Performance Budget:**
  - દરેક ફ્લોરનું સ્ટેટિક લેયર સ્વતંત્ર `PictureRecorder` દ્વારા કેશ થશે, જેથી ફ્લોર સ્વિચ કરતી વખતે રી-બિલ્ડ ન થાય.
  - On-device generation: 3-floor levels માટે પણ generate સમય **≤ 300 ms** (mid-tier).

---

## 4. CI Validation & Metadata Assets
- `assets/levels/phase_4_meta.bin` માં L1501–2000 ના સોલ્યુશન્સ અને પાર મૂવ્સ શિપ થશે.
- `assets/levels/seed_overrides.json` માં k-overrides સંગ્રહાશે.

---

## 5. QA Checklist (Phase 4)
| ID | Area | Test Case | Status |
|---|---|---|---|
| P4-QA-01 | Floor Viewing | Floor tabs ટેપ કરવાથી Move Count વધતો નથી | Not run |
| P4-QA-02 | Stairs Continuity | M151 Root Stairs દ્વારા સાપ બીજા માળે સમાન દિશામાં સરકે છે | Not run |
| P4-QA-03 | Dewglass Transp. | M152 પર ઉપરનો સાપ નીચેના સાપને લોક કરતો નથી | Not run |
| P4-QA-04 | Knot Hole One-Way | M153 માત્ર નીચે ડ્રોપ કરે છે, ઉપર જઈ શકાતું નથી | Not run |
| P4-QA-05 | Lift Locked Tap | સાપ આંશિક રીતે લિફ્ટ પર હોય ત્યારે ટેપ Locked Tap આપે છે | Not run |
| P4-QA-06 | Camera Auto-Pan | સાપ માળ બદલે ત્યારે કેમેરા તેની પાછળ ટાર્ગેટ ફ્લોર પર સ્મૂધલી જાય છે | Not run |
| P4-QA-07 | Determinism | Seed રી-જનરેટ કરતાં બધા પ્લેટફોર્મ પર એકસરખું JSON બને છે | Not run |
| P4-QA-08 | 0-Hearts Check | L1501–2000 માં તમામ માળના સાપ 0 હાર્ટ લોસથી ક્લિયર થાય છે | Not run |
| P4-QA-09 | Finale L2000 | L2000 ક્લિયર થતાં 1,000 coins + 6 boosters મળે છે | Not run |

