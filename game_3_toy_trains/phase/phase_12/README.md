# Phase 12 — Levels 5501–6000 (Hill Line)
> Toy Trains: Wooden Railway Puzzle ના Phase 12 update નું scope, signature system (Gravity & Incline Physics: Hill Line), 4 નવા railway base mechanics (M551–M554), 45 variants, release prerequisites અને Phase 12 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 11 index](../phase_11/README.md) · [Phase 13 index](../phase_13/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 12 = **Mountain Incline, Gravity & Falling Physics Update (Hill Line)**. Phase 11 પૂર્ણ કરનાર ખેલાડીઓ માટે **L5501–6000** content:
1. **Signature System:** Hill Line (Gravity Physics: બોર્ડ પર 4 દિશાઓમાં બદલાતી ગ્રેવિટી જે લૂઝ ક્રેટ્સ અને ભારે બેલાસ્ટ ટ્રેનોને ઢાળ તરફ ગતિ કરાવે છે).
2. **4 New Base Mechanics:**
   - M551: Tilt Lever / Gravity Lever (ટેપ કરવાથી ગ્રેવિટીની દિશા બદલાય છે, HUD પર ઢાળનો એરો દેખાય છે).
   - M552: Loose Crates / Falling Blockers (પ્રત્યેક મૂવ પછી મુક્ત ક્રેટ્સ ગ્રેવિટીની દિશામાં 1 સેલ નીચે સરકે છે જ્યાં સુધી રોકાણ ન આવે).
   - M553: Balloon Pad / Anti-grav Tile (આ પેડ પર રહેલો ક્રેટ કે આઇટમ ગુરુત્વાકર્ષણને અવગણે છે).
   - M554: Ballast Train / Weight Path (ભારે પથ્થર ભરેલી ટ્રેન જે પોતાના પાટા આગળ મુક્ત જગ્યા હોય તો ગ્રેવિટીની દિશામાં 1 સેલ આપોઆપ સરકે છે).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L6000 "Hill Climb Mountain Terminal" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 12 Value | Source |
|---|---|---|
| Levels | 5501–6000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Hill Line (Dynamic Board Incline & Gravity) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M551 (L5511), M552 (L5631), M553 (L5751), M554 (L5871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6000 "Hill Climb Mountain Terminal" (Finale target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P12-A (5501–5750) · P12-B (5751–6000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 34–46 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L5510 … L5990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L6000: 1,000 coins + 2 of each booster + Phase 12 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L5525, 5550 … 6000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 11
| Area | Phase 11 | Phase 12 |
|---|---|---|
| Signature System | Twin Tables (Linked Boards) | **Hill Line (Gravity & Incline)** |
| Board Orientation | Flat static multi-boards | **Dynamic Board Tilt:** ગ્રેવિટી લીવર સમગ્ર બોર્ડના ઢાળની દિશા બદલે છે |
| Autonomous Drift | None | **Loose Crates (M552):** લૂઝ કાર્ગો ગ્રેવિટીની દિશામાં સરકીને પાટા બ્લોક કે ક્લિયર કરે છે |
| Anti-Gravity Safety | None | **Balloon Pad (M553):** ફ્લોટિંગ ટાઇલ્સ ક્રેટ્સને ગ્રેવિટીમાં પડવાથી સુરક્ષિત રાખે છે |
| Heavy Physics | Standard locomotive weight | **Ballast Train (M554):** વજનદાર ટ્રેન પોતાની મેળે ઢાળ તરફ સરકે છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L5501–6000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_12_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 12`.
5. **Tutorial Assets:** Tilt Lever, Falling Crates, Balloon Pads, Ballast Trains localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_12_SCOPE_AND_RULES.md](./01_PHASE_12_SCOPE_AND_RULES.md) | Hill Line incline rules, gravity ticks, loose crates, ballast slide logic |
| 02 | [02_LEVEL_PLAN_5501_6000.md](./02_LEVEL_PLAN_5501_6000.md) | 50-block slot map, M551–M554 intros, 45 variants, L5991 review, L6000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) | Gravity rules, M551–M554 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_12.md](./04_VARIANTS_AND_MODIFIERS_PHASE_12.md) | 45 variant slots (Hill Incline base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_12.md](./05_REWARDS_AND_ECONOMY_PHASE_12.md) | Economy inflow/outflow, Gift Crates, L6000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_12.md](./06_UI_AND_QA_PHASE_12.md) | Board tilt HUD compass, gravity dust trails, crate fall VFX, QA |
