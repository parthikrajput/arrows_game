# 06 — UI, VFX & QA (Phase 3)
> Phase 3 (Day & Night Garden) ની UI (Sun/Moon dial HUD), visual effects (VFX) mapping, tier limits, tutorial cards, CI validation, performance budget, analytics અને QA checklist.

**Related docs:** [Phase 3 index](./README.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../../PERFORMANCE_OPTIMIZATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Phase 3 Rules](./01_PHASE_3_SCOPE_AND_RULES.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. UI Additions: Sun/Moon Dial HUD
- **HUD Placement:** Gameplay screen માં ટોચ પર (Moves counter ની બાજુમાં).
- **Visual:**
  - ગોળ સૂર્ય/ચંદ્ર ડાયલ (Sun in Day state, Moon in Night state).
  - 5-segment circular pip indicator: દરેક માન્ય Move પછી 1 pip ભરાય છે.
  - પાંચમો pip ભરાતાં ડાયલ 180° rotate થઈને Day ↔ Night બદલાય છે.
  - Accessibility: ટેક્સ્ટ લેબલ ("Day: 3 moves left" / "Night: 2 moves left") toggleable.

---

## 2. VFX Implementation (VFX Standard §4 મુજબ)
Phase 3 ના તમામ effects [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md) ના generic effect classes વાપરે છે (નવો class બનાવ્યા વગર):

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particles |
|---|---|---|---|
| Day ↔ Night Swap | `morph_flash` + ambient tween | આખા બોર્ડ પર 300 ms સોનેરી (Day) અથવા નીલમ (Night) પ્રકાશ લહેર | Low 0, Mid 15, High 30 |
| M101 Sun-Moon Gate Toggle | `state_toggle` | પથ્થર ગેટ ખુલતાં ધૂળ અને ચમકારા | Low 0, Mid 8, High 16 |
| M102 Moonlight Bridge State | `lane_warp` | રુપેરી મૂળિયાં પ્રગટ થતાં સોફ્ટ ગ્લો | Low 0, Mid 10, High 20 |
| M103 Burrows Warp | `portal_whoosh` | સાપ પ્રવેશતાં સોનેરી/નીલમ વમળ | Low 0, Mid 12, High 24 |
| M104 Twilight Flower Color Shift | `morph_flash` | પાંખડીઓનો રંગ બદલાતાં પાંદડીઓ ઊડે | Low 0, Mid 8, High 16 |
| Variant `Frozen(K)` Thaw | `crack_shards` | બરફ તૂટીને વિખેરાય | Low 0, Mid 10, High 20 |
| L1500 Finale Burst | `win_confetti` + `chest_burst` | ગોલ્ડન કન્ફેટી અને બેજ રિવિલ | Low 30, Mid 80, High 150 |

---

## 3. Accessibility & Performance
- **Reduce Motion:** જો OS અથવા In-app "Reduce Motion" સક્રિય હોય, તો Sun/Moon dial rotation બંધ થશે (માત્ર instant icon swap થશે) અને બોર્ડ વાઇડ ફ્લેશિંગ બંધ થશે.
- **Color-Blind Support:** M104 Flower Gate પર રંગ ઉપરાંત આગવા શેપ પેટર્ન (દા.ત. Teal = Circle, Amber = Diamond) દર્શાવાશે.
- **Performance Budget:**
  - On-device level generation: isolate thread પર **≤ 300 ms** (mid-tier) / **≤ 800 ms** (low-tier).
  - Gameplay rendering: 60 fps on low-tier (2 GB RAM), 120 fps on flagships. Dynamic layer પર એક જ Ticker.

---

## 4. CI Validation & Metadata Assets
1. **Pre-validation:** L1001–1500 ના તમામ seeds CI માં validate થયેલ હોવા જોઈએ.
2. **Shipped Assets:**
   - `assets/levels/phase_3_meta.bin` (દરેક લેવલનો seed attempt k, par, D, CRC, solution).
   - `assets/levels/seed_overrides.json` (જો કોઈ k ≠ 0 હોય તો).

---

## 5. QA Checklist (Phase 3)
| ID | Area | Test Case | Status |
|---|---|---|---|
| P3-QA-01 | Cycle Timing | દર 5 માન્ય Moves એ Cycle ચોક્કસ A ↔ B બદલાય છે | Not run |
| P3-QA-02 | Inverted Gates | M101 inverted gate Day માં બંધ અને Night માં ખુલે છે | Not run |
| P3-QA-03 | Bridge Void | M102 નિષ્ક્રિય હોય ત્યારે ખાડો બનીને સાપને બ્લોક કરે છે | Not run |
| P3-QA-04 | No Clipping | M101/M102 પર સાપ ઊભો હોય ત્યારે Cycle બદલાતાં સાપ કપાતો નથી | Not run |
| P3-QA-05 | Flower Colors | M104 માત્ર સક્રિય સાયકલના રંગના સાપને જ પ્રવેશવા દે છે | Not run |
| P3-QA-06 | Variants | 45 variants પોતાના modifier નિયમો (Frozen, Countdown વગેરે) બરાબર પાળે છે | Not run |
| P3-QA-07 | Determinism | Seed રી-જનરેટ કરતાં Android અને iOS પર એકસરખું JSON પરિણામ આપે છે | Not run |
| P3-QA-08 | 0-Hearts Check | L1001–1500 સોલ્વર રિપ્લેમાં કોઈ forced damage નથી | Not run |
| P3-QA-09 | Dial HUD | Move વધતાં 5-pip ડાયલ સચોટ ગતિ કરે છે | Not run |
| P3-QA-10 | Finale L1500 | L1500 ક્લિયર થતાં Treasure Chest (1,000 coins + 6 boosters) આપે છે | Not run |

