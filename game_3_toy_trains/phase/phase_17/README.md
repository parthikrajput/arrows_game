# Phase 17 — Levels 8001–8500 (Clock Towers)
> Toy Trains: Wooden Railway Puzzle ના Phase 17 update નું scope, signature system (Guardian Boss Puzzles: Clock Towers / Guardians), 4 નવા railway base mechanics (M801–M804), 45 variants, release prerequisites અને Phase 17 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 16 index](../phase_16/README.md) · [Phase 18 index](../phase_18/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 17 = **Clockwork Guardians & Strategic Boss Puzzles Update (Clock Towers)**. Phase 16 પૂર્ણ કરનાર ખેલાડીઓ માટે **L8001–8500** content:
1. **Signature System:** Clock Towers (Guardians: બોર્ડ પર વિશાળ ક્લોક ટાવર્સ જે HP ધરાવે છે, સ્પોનર્સ, આર્મર્ડ શિલ્ડ્સ અને ક્લોક કોર મિકેનિઝમ).
2. **4 New Base Mechanics:**
   - M801: Twin Clock Towers / Twin Guardian (બે ટાવર્સ જે એક જ સંયુક્ત HP પૂલ શેર કરે છે; કોઈ પણ એક પાસે ટ્રેન ક્લિયર થતાં HP ઘટે છે).
   - M802: Armoured Clock Tower / Shield Guardian (ટાવરનું HP ત્યારે જ ઘટે છે જ્યારે સંલગ્ન ટ્રેનો ચોક્કસ ક્રમમાં એક્ઝિટ થાય).
   - M803: Depot Tower / Spawner Guardian (દર N Moves એ પોતાના ખાલી પાડોશી સેલમાં નવો બફર સ્ટોપ સ્પોન કરે છે જ્યાં સુધી તેનું HP 0 ન થાય).
   - M804: Clock Core / Guardian Core (જ્યાં સુધી તેનું HP 0 ન થાય **અને** તેનો કેન્દ્રીય સેલ સિગ્નલ બીમ દ્વારા પ્રકાશિત ન થાય ત્યાં સુધી અદૃશ્ય થતો નથી).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L8500 "Citadel of the Grand Clock Tower" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 17 Value | Source |
|---|---|---|
| Levels | 8001–8500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Clock Towers (Guardian Boss Puzzles & Multi-Phase Clocks) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M801 (L8011), M802 (L8131), M803 (L8251), M804 (L8371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L8491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8500 "Citadel of the Grand Clock Tower" (Target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P17-A (8001–8250) · P17-B (8251–8500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 36–52 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L8010 … L8490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L8500: 1,000 coins + 2 of each booster + Phase 17 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L8025, 8050 … 8500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 16
| Area | Phase 16 | Phase 17 |
|---|---|---|
| Signature System | Ticket Office (Keys Deluxe) | **Clock Towers (Guardians)** |
| Board Presence | Passive barriers & tickets | **Active Guardian Entities:** HP પૂલ ધરાવતા વિશાળ ક્લોક ટાવર્સ |
| Health Dynamics | Single unlock | **Multi-Hit Towers:** પ્રત્યેક ટ્રેન એક્ઝિટ પર HP ઘટે છે |
| Hazard Spawning | Static blockers | **Depot Tower (M803):** દર N મૂવે પાટા પર બફર સ્ટોપ્સ સ્પોન કરે છે |
| Multi-Condition | Key or button | **Clock Core (M804):** HP 0 + લાઇટ બીમ બંને એકસાથે જરૂરી |

## 4. Release Prerequisites
1. **CI Generator Run:** L8001–8500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_17_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 17`.
5. **Tutorial Assets:** Twin Towers, Armoured Tower, Depot Spawner, Clock Core localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_17_SCOPE_AND_RULES.md](./01_PHASE_17_SCOPE_AND_RULES.md) | Clock Towers guardian rules, HP decay, spawner logic, beam triggers |
| 02 | [02_LEVEL_PLAN_8001_8500.md](./02_LEVEL_PLAN_8001_8500.md) | 50-block slot map, M801–M804 intros, 45 variants, L8491 review, L8500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) | Guardians rules, M801–M804 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_17.md](./04_VARIANTS_AND_MODIFIERS_PHASE_17.md) | 45 variant slots (Clock Towers base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_17.md](./05_REWARDS_AND_ECONOMY_PHASE_17.md) | Economy inflow/outflow, Gift Crates, L8500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_17.md](./06_UI_AND_QA_PHASE_17.md) | Clock Tower HP gauge HUD, ticking gear animations, destruction VFX, QA |
