# Phase 13 — Levels 6001–6500 (Mystery Mists)
> Snakes Slither ના Phase 13 update નું scope, signature system (Hidden Info & Fog of War: Mystery Mists), 4 નવા base mechanics (M601–M604), 45 variants, release prerequisites અને Phase 13 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 12 index](../phase_12/README.md) · [Phase 14 index](../phase_14/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 13 = **Fog of War & Hidden Information Puzzle Update (Mystery Mists)**. Phase 12 પૂર્ણ કરનાર players માટે **L6001–6500** content:
1. **Signature System:** Mystery Mists (બોર્ડ પર છવાયેલું રહસ્યમય ધુમ્મસ જે ટાઇલ્સ અને અવરોધોને ઢાંકે છે, સ્કાઉટ સાપો અને ગ્લો સ્ટોન્સ વડે જ્ઞાન પ્રગટ કરવું).
2. **4 New Base Mechanics:**
   - M601: Scout Gecko / Scout Path (બહાર નીકળતી વખતે પોતાની લેનના 1-સેલ વિસ્તારમાં રહેલા તમામ છુપાયેલા તત્વો પ્રગટ કરે છે).
   - M602: Trick Mist / Mimic Fog (સાપ બહાર નીકળ્યા પછી તે ખાલી થયેલા 1 સેલ પર ફરીથી ધુમ્મસ છવાઈ જાય છે, સિવાય કે સ્કાઉટ નીકળી ચૂક્યો હોય).
   - M603: Painted Wall / False Wall (દૃશ્યમાં દીવાલ જેવી લાગે છે પરંતુ સાપ આરપાર નીકળી શકે છે; ફ્રી પાથ પ્રીવ્યૂ સત્ય દર્શાવે છે).
   - M604: Glow Stone / Reveal Plate (જ્યાં સુધી સાપનું શરીર આ પ્લેટ પર રહે છે, ત્યાં સુધી તેના $3\times 3$ વિસ્તારનું સંપૂર્ણ સત્ય પ્રગટ રહે છે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L6500 "Heart of the Phantom Mists" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 13 Value | Source |
|---|---|---|
| Levels | 6001–6500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Mystery Mists (Fog-of-war, fair reveal mechanics, scouting) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M601 (L6011), M602 (L6131), M603 (L6251), M604 (L6371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6500 "Heart of the Phantom Mists" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P13-A (6001–6250) · P13-B (6251–6500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes | SCALING §3.5 |
| Obstacle Instances | 8–15 instances (ફોગ સેલ્સ, ફોલ્સ વોલ્સ, ગ્લો પ્લેટ્સ) | SCALING §3.5 |
| Jungle Gift Basket | 49 (L6010 … L6490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L6500: 1,000 coins + 2 of each booster + Phase 13 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L6025, 6050 … 6500), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 12
| Area | Phase 12 | Phase 13 |
|---|---|---|
| Signature System | Gravity Physics (Monsoon Winds) | **Hidden Info (Mystery Mists)** |
| Board Visibility | 100% full board visible | **Fog of War**: ધુમ્મસ હેઠળ ટાઇલ્સ અને અવરોધો આંશિક રીતે છુપાયેલા |
| Scouting Role | None | **Scout Gecko (M601)**: સાપના એક્ઝિટથી ધુમ્મસ કાયમી દૂર થાય |
| Visual Deception | Strict physical boundaries | **Painted Wall (M603)**: ભ્રામક દીવાલો જેમાંથી સાપ પસાર થઈ શકે છે |
| Proximity Reveal | None | **Glow Stone (M604)**: પ્રેશર-આધારિત $3\times 3$ એરિયા રીવીલ |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L6001–6500 ના તમામ seeds pre-validated with fair reveal constraints.
2. **Metadata Asset:** `phase_13_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 13`.
5. **Tutorial Assets:** Scout Gecko (M601) અને False Wall (M603) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_13_SCOPE_AND_RULES.md](./01_PHASE_13_SCOPE_AND_RULES.md) | Scope, limits, rules, fog-of-war transparency engine. |
| 02 | [02_LEVEL_PLAN_6001_6500.md](./02_LEVEL_PLAN_6001_6500.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) | Signature system rules, M601–M604 mechanics, preview fairness guarantees. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_13.md](./04_VARIANTS_AND_MODIFIERS_PHASE_13.md) | 45 variant catalog (Block 603–649), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_13.md](./05_REWARDS_AND_ECONOMY_PHASE_13.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_13.md](./06_UI_AND_QA_PHASE_13.md) | Fog render layer, Reveal VFX, False wall shaders, QA checklist. |

---

## 6. Open Decisions
- **OD-P13-01:** M603 False Wall પર ફ્રી પ્રીવ્યૂ (Tongue-Flick $\ge 350\text{ ms}$) કેવી રીતે સત્ય દર્શાવે છે? Default: પ્રીવ્યૂ પાથ દીવાલમાંથી આરપાર પસાર થતો સોનેરી લીટી તરીકે સ્પષ્ટ દેખાશે, જેથી ખેલાડી જાણી શકે કે તે માત્ર પેઇન્ટેડ દીવાલ છે.
- **OD-P13-02:** M602 Trick Mist શું સ્કાઉટ બહાર નીકળ્યા પછી પણ પાછું આવી શકે? Default: ના, એકવાર સ્કાઉટ સાપ બહાર નીકળે એટલે આખો રીવીલ થયેલો વિસ્તાર કાયમી ધુમ્મસ-મુક્ત બને છે.
