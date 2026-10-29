# 06 — UI, VFX & QA (Phase 6)
> Phase 6 (Sun Temple Light) ની UI (Beam color badges), visual effects (VFX) mapping, tier limits, tutorial cards, CI validation, performance budget, analytics અને QA checklist.

**Related docs:** [Phase 6 index](./README.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../../PERFORMANCE_OPTIMIZATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Phase 6 Rules](./01_PHASE_6_SCOPE_AND_RULES.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. UI Additions: Beam Color Badges & Sensor HUD
- **Receiver Status HUD:** જ્યારે કોઈ Prism Lock (M252) પર 1 કિરણ પડે ત્યારે "1/2 Beams" આઇકોનિક બેજ પલ્સ થાય છે.
- **Sundial Counter:** M253 પર બાકી રહેલા સળંગ મૂવ્સનો આંકડો (દા.ત. "3 moves left") સૂર્યઘડી ડાયલ પર પ્રદર્શિત થાય છે.
- **Color-Blind Glyph Overlays:** દરેક બીમ અને ફિલ્ટર પર કલર ઉપરાંત અનન્ય પ્રતીક (Ruby = Triangle, Cyan = Square, Gold = Diamond) દેખાય છે.

---

## 2. VFX Implementation (VFX Standard §4 મુજબ)

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particles |
|---|---|---|---|
| M251 Petal Filter Passage | `beam_glow` + `morph_flash` | બીમ ફિલ્ટરમાંથી નીકળતાં રંગીન સ્પાર્કલ્સ અને હળવી ચમક | Low: beam only, Mid: 10, High: 20 |
| M252 Prism Lock Unlock | `state_toggle` + `beam_glow` | બહુવિધ કિરણો મળતાં જ્વલંત સ્ફટિક બર્સ્ટ અને ગેટ ઓપન | Low: 0, Mid: 15, High: 30 |
| M253 Sundial Latch Complete | `badge_pulse` + `win_confetti` | સૂર્યઘડી પૂર્ણ થતાં સોનેરી પ્રકાશ તરંગ | Low: 0, Mid: 12, High: 24 |
| M254 Shade Leaves Dissolve | `fog_dissolve` | બીમ પડતાં અંધારા પાંદડાં ઓગળીને સાપ જાગે | Low: 0, Mid: 8, High: 16 |
| L3000 Finale Sanctum Burst | `win_confetti` + `chest_burst` | સૂર્ય મંદિર ભવ્ય કન્ફેટી અને ગોલ્ડન ઓરા | Low: 30, Mid: 80, High: 150 |

---

## 3. Accessibility & Performance
- **Reduce Motion:** બીમ પલ્સિંગ બંધ થશે (માત્ર સ્ટેટિક ગ્લો); શેડ લીવ્સ ડિઝોલ્વ ઇન્સ્ટન્ટ આલ્ફા કટ થશે.
- **Performance Budget:**
  - Dynamic ray tracing isolate અથવા compute worker માં **$\le 2\text{ ms}$** માં થાય છે.
  - On-device level generation: **$\le 300\text{ ms}$** (mid-tier).

---

## 4. CI Validation & Metadata Assets
- `assets/levels/phase_6_meta.bin` માં L2501–3000 ના સોલ્યુશન્સ અને પાર મૂવ્સ શિપ થશે.
- `assets/levels/seed_overrides.json` માં k-overrides સંગ્રહાશે.

---

## 5. QA Checklist (Phase 6)
| ID | Area | Test Case | Status |
|---|---|---|---|
| P6-QA-01 | Petal Filtering | બીમ ફિલ્ટરમાંથી પસાર થતાં માત્ર તે રંગના રીસીવરને જ સક્રિય કરે છે | Not run |
| P6-QA-02 | Prism Multi-Beam | M252 માત્ર ત્યારે જ ખુલે છે જ્યારે $\ge 2$ કિરણો એકસાથે પડે | Not run |
| P6-QA-03 | Sundial Timer | સળંગ $N$ મૂવ્સ બીમ ચાલુ રહે તો જ ગેટ Latch Open થાય છે | Not run |
| P6-QA-04 | Sundial Reset | વચ્ચે 1 મૂવ માટે બીમ કપાતાં કાઉન્ટર રીસેટ થાય છે | Not run |
| P6-QA-05 | Shade Leaves Lock | અંધારા સેલમાં માથું ધરાવતો સાપ બીમ પડ્યા પહેલાં Locked Tap આપે છે | Not run |
| P6-QA-06 | Ray Obstruction | સાપનું શરીર બીમને રોકે છે (ઓપેક બોડી બ્લોકિંગ) | Not run |
| P6-QA-07 | Determinism | Seed રી-જનરેટ કરતાં બધા પ્લેટફોર્મ પર સમાન પરિણામ આપે છે | Not run |
| P6-QA-08 | 0-Hearts Check | L2501–3000 સોલ્વર રિપ્લેમાં કોઈ forced damage નથી | Not run |
| P6-QA-09 | Finale L3000 | L3000 ક્લિયર થતાં 1,000 coins + 6 boosters મળે છે | Not run |
