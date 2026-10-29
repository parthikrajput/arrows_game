# Phase 13 — Levels 6001–6500 (Weather Station)
> Toy Trains: Wooden Railway Puzzle ના Phase 13 update નું scope, signature system (Hidden Info & Steam Fog: Weather Station / Fog on the Line), 4 નવા railway base mechanics (M601–M604), 45 variants, release prerequisites અને Phase 13 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 12 index](../phase_12/README.md) · [Phase 14 index](../phase_14/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 13 = **Weather Station, Fog of War & Hidden Information Update (Fog on the Line)**. Phase 12 પૂર્ણ કરનાર ખેલાડીઓ માટે **L6001–6500** content:
1. **Signature System:** Weather Station (Hidden Info: પર્વતીય સ્ટેશન પર ગાઢ ધુમ્મસ, સ્ટીમ ક્લાઉડ્સ, સ્કાઉટ ટ્રેનો, મિરાજ ટ્રેનો, ફોલ્સ ફેન્સ દીવાલો અને લેન્ટર્ન પ્લેટ્સ).
2. **4 New Base Mechanics:**
   - M601: Scout Draisine / Scout Path (બોર્ડમાંથી બહાર નીકળતાં પોતાની લેનની આસપાસના 1 સેલ રેડિયસના તમામ છુપાયેલા સેલ્સ કાયમી પ્રગટ કરે છે).
   - M602: Mirage Steam / Mimic Fog (ધુમ્મસમાં આભાસી ડિકોય ટ્રેનો દર્શાવે છે; Route Peek સાચી સ્થિતિ પ્રદર્શિત કરે છે).
   - M603: Painted Backdrop / False Wall (દૃશ્યમાં લાકડાની વાડ જેવી લાગે છે પરંતુ પાટા આરપાર નીકળે છે; Route Peek ગ્રીન લાઇન દર્શાવે છે).
   - M604: Lantern Plate / Reveal Plate (જ્યાં સુધી ટ્રેન આ પ્લેટ પર રહે છે, ત્યાં સુધી રેડિયસ 2 ના વિસ્તારનું ધુમ્મસ હટેલું રહે છે).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L6500 "Weather Station Observatory Terminal" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 13 Value | Source |
|---|---|---|
| Levels | 6001–6500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Weather Station (Fog on the Line / Hidden Information) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M601 (L6011), M602 (L6131), M603 (L6251), M604 (L6371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6500 "Weather Station Observatory Terminal" (Target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P13-A (6001–6250) · P13-B (6251–6500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 34–48 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L6010 … L6490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L6500: 1,000 coins + 2 of each booster + Phase 13 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L6025, 6050 … 6500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 12
| Area | Phase 12 | Phase 13 |
|---|---|---|
| Signature System | Hill Line (Gravity & Incline) | **Weather Station (Fog on the Line)** |
| Board Visibility | Full static transparency | **Fog of War:** બોર્ડના ભાગો સ્ટીમ ધુમ્મસમાં ઢંકાયેલા રહે છે |
| Reconnaissance | None | **Scout Draisine (M601):** લેન ક્લિયર કરી આસપાસનું ધુમ્મસ દૂર કરે છે |
| Decoy Hazards | Real sliding crates | **Mirage Steam (M602):** નકલી ભ્રામક ટ્રેનો જે Route Peek થી ઓળખાય છે |
| Illusory Walls | Real solid barriers | **Painted Backdrop (M603):** દૃષ્ટિભ્રમ વાડ જેના પરથી ટ્રેન પસાર થઈ શકે છે |
| Dynamic Lighting | Static lamps | **Lantern Plate (M604):** ટ્રેન પ્લેટ પર ઉભી રહેતાં અજવાળું ફેલાય છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L6001–6500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_13_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 13`.
5. **Tutorial Assets:** Scout Draisine, Mirage Steam, Painted Backdrop, Lantern Plate localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_13_SCOPE_AND_RULES.md](./01_PHASE_13_SCOPE_AND_RULES.md) | Weather Station fog rules, scout reveal radius, false walls, lantern logic |
| 02 | [02_LEVEL_PLAN_6001_6500.md](./02_LEVEL_PLAN_6001_6500.md) | 50-block slot map, M601–M604 intros, 45 variants, L6491 review, L6500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) | Hidden Info rules, M601–M604 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_13.md](./04_VARIANTS_AND_MODIFIERS_PHASE_13.md) | 45 variant slots (Weather Station base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_13.md](./05_REWARDS_AND_ECONOMY_PHASE_13.md) | Economy inflow/outflow, Gift Crates, L6500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_13.md](./06_UI_AND_QA_PHASE_13.md) | Fog particle shaders, lantern beam visualizer, mirage shimmer VFX, QA |
