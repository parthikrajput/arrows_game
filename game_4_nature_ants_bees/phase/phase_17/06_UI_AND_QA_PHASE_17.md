# 06 — UI, VFX & QA, Phase 17 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Guardian boss UI indicators, Armor shattering VFX, CI validation, performance budgets અને Phase 17 QA checklist.

**Related docs:** [Phase 17 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md)

---

## 1. UI Components for Garden Guardians
- **Boss Segmented HP Bar:**
  - $2\times 2$ ગાર્ડિયનની ઉપર તરતી સોનેરી-લાલ વિભાજિત HP પટ્ટી જે બાકી રહેલા હિટ્સ સ્પષ્ટ દર્શાવે છે.
- **Armor Shell Overlay:**
  - Armored Rhino Beetle (M802) પર ધાતુ જેવું ચળકતું કવચ જે લીવર ઓપરેટ ન થાય ત્યાં સુધી લાલ શિલ્ડ આઇકન દર્શાવે છે.
- **Spawner Pulse Counter:**
  - Wasp Nest Guardian (M803) ના મુખ પર ભમરી આઇકન સાથે આગામી બ્લોકર સ્પોન થવાના બાકી Moves દર્શાવતું બેજ.
- **Heart-Seed Core Reticle:**
  - Heart-Seed Guardian (M804) ના કેન્દ્રીય સેલ પર લાલ કલગીવાળું ચોક્કસ ટાર્ગેટ ચિહ્ન ("Direct hit lane required").
- **Tutorial Overlay Cards:**
  - L8001: "Garden Guardians — Huge boss obstacles block paths! Exit linked lines to deplete their HP."
  - L8011: "Twin Hornets — Two giant hornets share one life pool. Clear either line to damage both!"
  - L8131: "Armored Rhino Beetle — Invulnerable shell! Pull the linked lever to crack open its defenses."
  - L8251: "Wasp Nest Guardian — Spawns mud blockers periodically. Defeat it quickly to stop the swarm!"
  - L8371: "Heart-Seed Guardian — Only lines that exit directly through the center core deal damage."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Guardian Hit (M801) | `guardian_hit` / heavy | Boss flinches with electric yellow sparks, earthy rumble, and 4 dp screen shake. |
| Shell Shatter (M802) | `state_toggle` | Thick beetle armor shell cracks with metallic fracture chime, crumbling into stone dust. |
| Blocker Spawn (M803) | `dust_puff` | Mud bubble pops violently at nest perimeter, leaving fresh brown clay obstacle. |
| Boss Defeat (M804) | `state_toggle` | Giant guardian dissolves into brilliant vortex of golden pollen and floating flower petals (300 ms). |
| L8500 Finale Win | `win_confetti` | Grand Royal Hive Defense Gala: massive honey bursts, royal crown fireworks, rainbow confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Boss Logic Execution Budget:** Multi-cell footprint collision checks and spawner ticks complete in $\le 0.2\text{ ms}$.
- **CI Pre-Validation:** L8001–8500 ના તમામ 500 levels guardian solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 17 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P17-QA-01** | Twin hornets shared HP | Line exit drops shared HP by 1; both hornets vanish simultaneously at 0 HP. | Not run |
| **P17-QA-02** | Rhino beetle armor invulnerability | Lines exiting while armor is active deal 0 damage; lever removes armor. | Not run |
| **P17-QA-03** | Wasp nest spawner pacing | Nest spawns exactly 1 mud blocker every N moves into first free neighbor. | Not run |
| **P17-QA-04** | Heart-seed core piercing lane | Only lines whose straight trajectory intersects core tile decrement HP. | Not run |
| **P17-QA-05** | Tall boss obstruction check | Both ground ants and airborne bees bonk into guardian 2x2 footprint. | Not run |
| **P17-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P17-QA-07** | L8500 Royal Hive Defense | Finale solvable, awards Royal Honey Chest and Hive Protector badge. | Not run |
| **P17-QA-08** | Offline boss generation | Seed-based generation works seamlessly offline across all devices. | Not run |

