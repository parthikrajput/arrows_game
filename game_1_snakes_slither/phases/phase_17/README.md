# Phase 17 — Levels 8001–8500 (Mongoose Clan)
> Snakes Slither ના Phase 17 update નું scope, signature system (Guardians & Boss Metagame: Mongoose Clan), 4 નવા base mechanics (M801–M804), 45 variants, release prerequisites અને Phase 17 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 16 index](../phase_16/README.md) · [Phase 18 index](../phase_18/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 17 = **Advanced Guardian & Boss HP Puzzle Update (Mongoose Clan)**. Phase 16 પૂર્ણ કરનાર players માટે **L8001–8500** content:
1. **Signature System:** Mongoose Clan (સાપોના પરંપરાગત શત્રુ નોળિયાઓનું કુળ જે બોર્ડ પર ગાર્ડિયન તરીકે ઊભા રહીને રસ્તા રોકે છે અને HP પુલ ધરાવે છે).
2. **4 New Base Mechanics:**
   - M801: Mongoose Twins / Twin Guardian (બે જોડિયા નોળિયાઓ એક જ સંયુક્ત HP પૂલ શેર કરે છે).
   - M802: Armadillo Guardian / Shield Guardian (જ્યાં સુધી તેનું લિંક્ડ શીલ્ડ લિવર ON હોય ત્યાં સુધી કોઈ ડેમેજ લેતો નથી).
   - M803: Mama Mongoose / Spawner Guardian (દર $N$ મૂવ્સે પોતાની આસપાસના ખાલી સેલ પર એક પથ્થર [Garden Rock] પેદા કરે છે, મહત્તમ 3).
   - M804: Mongoose Den Core / Guardian Core (જ્યારે લિંક્ડ સાપ તેની નિયુક્ત બાજુમાંથી બહાર નીકળે ત્યારે જ તેનું HP ઘટે છે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L8500 "Fortress of the Clan Chieftain" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 17 Value | Source |
|---|---|---|
| Levels | 8001–8500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Mongoose Clan (Guardians, shared HP pools, shield levers, rock spawners) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M801 (L8011), M802 (L8131), M803 (L8251), M804 (L8371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L8491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8500 "Fortress of the Clan Chieftain" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P17-A (8001–8250) · P17-B (8251–8500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes | SCALING §3.5 |
| Obstacle Instances | 8–15 instances (ગાર્ડિયન્સ, પથ્થરો, શીલ્ડ લિવર્સ) | SCALING §3.5 |
| Jungle Gift Basket | 49 (L8010 … L8490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L8500: 1,000 coins + 2 of each booster + Phase 17 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L8025, 8050 … 8500), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 16
| Area | Phase 16 | Phase 17 |
|---|---|---|
| Signature System | Keys Deluxe (Treasure Keys) | **Guardians (Mongoose Clan)** |
| Board Resistance | Passive locks & gates | **Active Boss Guardians (HP Pools)**: સાપો નીકળતાં ગાર્ડિયનની લાઈફ ઘટે |
| Shared HP Logic | 1 key = 1 lock | **Twin HP Pools (M801)**: 2 નોળિયાઓ એક જ આયુષ્ય વહેંચે છે |
| Invulnerability | None | **Shield Levers (M802)**: લિવર બંધ કર્યા વગર ડેમેજ અશક્ય |
| Dynamic Obstacles | Static rock placement | **Spawner Guardian (M803)**: મૂવ્સ સાથે નવા પથ્થર પેદા થાય |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L8001–8500 ના તમામ seeds pre-validated with guardian defeat solvers.
2. **Metadata Asset:** `phase_17_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 17`.
5. **Tutorial Assets:** Twin Guardian (M801) અને Shield Guardian (M802) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_17_SCOPE_AND_RULES.md](./01_PHASE_17_SCOPE_AND_RULES.md) | Scope, limits, rules, guardian HP state engine. |
| 02 | [02_LEVEL_PLAN_8001_8500.md](./02_LEVEL_PLAN_8001_8500.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) | Signature system rules, M801–M804 mechanics, spawning limits. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_17.md](./04_VARIANTS_AND_MODIFIERS_PHASE_17.md) | 45 variant catalog (Block 803–849), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_17.md](./05_REWARDS_AND_ECONOMY_PHASE_17.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_17.md](./06_UI_AND_QA_PHASE_17.md) | Guardian HP bars, Spawner pips, VFX/SFX, QA checklist. |

---

## 6. Open Decisions
- **OD-P17-01:** M803 Mama Mongoose Rock Spawn Cap — શું 3 પથ્થર પેદા થયા પછી વધુ પથ્થર પેદા થઈ શકે? Default: ના, બોર્ડ પર એકસાથે મહત્તમ 3 સ્પોન્ડ પથ્થર જ રહી શકે છે જેથી બોર્ડ ક્યારેય ડેડલોક ન થાય.
- **OD-P17-02:** ગાર્ડિયનનું HP શૂન્ય થતાં શું તે બોર્ડ પરથી ગાયબ થઈ જાય છે? Default: હા, નોળિયો હસીને જંગલમાં ભાગી જાય છે અને તેનો સેલ સંપૂર્ણ ખુલ્લો રસ્તો બની જાય છે.

