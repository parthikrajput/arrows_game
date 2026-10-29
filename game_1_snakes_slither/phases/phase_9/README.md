# Phase 9 — Levels 4001–4500 (Twin Rivers)
> Snakes Slither ના Phase 9 update નું scope, signature system (Split & Merge: Twin Rivers), 4 નવા base mechanics (M401–M404), 45 variants, release prerequisites અને Phase 9 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 8 index](../phase_8/README.md) · [Phase 10 index](../phase_10/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 9 = **Snake Topology Transformation Update (Split & Merge)**. Phase 8 પૂર્ણ કરનાર players માટે **L4001–4500** content:
1. **Signature System:** Twin Rivers (બે સાપોનું એકમાં મર્જર અને એક સાપનું બે સ્વતંત્ર સાપોમાં વિભાજન).
2. **4 New Base Mechanics:**
   - M401: Hug Pad / Merger Pad (બે સાપના માથા પેડ પર હોય ત્યારે ટેપ કરવાથી એક લાંબા સાપમાં જોડાય).
   - M402: Fork Stump / Twin Splitter (સાપ આ ટાઇલ પરથી પસાર થતાં $90^\circ$ ડાબે અને જમણે બે અર્ધભાગમાં વિભાજીત થાય).
   - M403: Bead Lock / Segment Lock (કુલ $N$ સેગમેન્ટ બહાર નીકળ્યા પછી જ લોક ખુલે).
   - M404: Reunion Gate / Rejoin Gate (વિભાજીત થયેલા બંને અર્ધભાગ સાપ બહાર નીકળી જાય ત્યારે જ ખુલે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L4500 "Twin Waters Convergence" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 9 Value | Source |
|---|---|---|
| Levels | 4001–4500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Twin Rivers (Split & Merge topology, segment accounting) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M401 (L4011), M402 (L4131), M403 (L4251), M404 (L4371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L4491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L4500 "Twin Waters Convergence" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P9-A (4001–4250) · P9-B (4251–4500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes (વિભાજન બાદ ડાયનેમિક સંખ્યા વધે) | SCALING §3.5 |
| Obstacle Instances | 8–15 instances | SCALING §3.5 |
| Jungle Gift Basket | 49 (L4010 … L4490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L4500: 1,000 coins + 2 of each booster + Phase 9 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L4025, 4050 … 4500), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 8
| Area | Phase 8 | Phase 9 |
|---|---|---|
| Signature System | Growth (Overgrown Garden) | **Split & Merge (Twin Rivers)** |
| Snake Identity | Fixed snake identity per attempt | **Dynamic Entity Lifecycle**: સાપનું મર્જર થઈને મોટો સાપ બને અથવા સ્પ્લિટ થઈને બે સ્વતંત્ર સાપ બને |
| Body Length Dynamics | Fixed segment length | **Variable Segment Count**: સાપની લંબાઈ રમત દરમિયાન બદલાય છે |
| Lock Logic | Pruning/Seed count checks | **Segment Counter (M403) & Split Pair Verification (M404)** |
| Collision Complexity | Static blocker avoid | **Split Divergence**: બંને પાથ એકસાથે ક્લિયર હોવા અનિવાર્ય છે |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L4001–4500 ના તમામ seeds pre-validated with zero-deadlock guarantees.
2. **Metadata Asset:** `phase_9_meta.bin` અને `seed_overrides.json` બંડલમાં શામેલ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 9`.
5. **Tutorial Assets:** Merger Pad (M401) અને Twin Splitter (M402) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_9_SCOPE_AND_RULES.md](./01_PHASE_9_SCOPE_AND_RULES.md) | Scope, limits, rules, engine changes (Dynamic Snake Entity lifecycle). |
| 02 | [02_LEVEL_PLAN_4001_4500.md](./02_LEVEL_PLAN_4001_4500.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) | Signature system rules, M401–M404 mechanics, tick order, edge cases. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_9.md](./04_VARIANTS_AND_MODIFIERS_PHASE_9.md) | 45 variant catalog (Block 403–449), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_9.md](./05_REWARDS_AND_ECONOMY_PHASE_9.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_9.md](./06_UI_AND_QA_PHASE_9.md) | UI indicators (Split preview, Segment HUD), VFX/SFX, QA checklist. |

---

## 6. Open Decisions
- **OD-P9-01:** M402 Twin Splitter માં જ્યારે સાપ ઓડ (Odd) સંખ્યાના સેગમેન્ટ્સ ધરાવતો હોય ત્યારે વિભાજન કેવી રીતે કરવું ($N/2$ rounding vs head gets $+1$). Default: Head gets $\lceil N/2 \rceil$, tail gets $\lfloor N/2 \rfloor$.
- **OD-P9-02:** M401 Merger Pad માં જો બંને સાપના રંગ અલગ હોય તો મર્જ્ડ સાપનો રંગ શું ગણવો? Default: સાપ A (જેના માથાની દિશા જાળવવામાં આવે છે) તેનો રંગ પ્રભાવી બને છે.

