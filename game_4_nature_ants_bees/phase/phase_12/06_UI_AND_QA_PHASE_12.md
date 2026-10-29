# 06 — UI, VFX & QA, Phase 12 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Gravity UI indicators, Autumn wind gust VFX, CI validation, performance budgets અને Phase 12 QA checklist.

**Related docs:** [Phase 12 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md)

---

## 1. UI Components for Falling Leaves
- **Global Gravity Compass HUD:**
  - સ્ક્રીનના ઉપરના ખૂણે સોનેરી પવન-દિશા કંપાસ જે હાલનું ગુરુત્વાકર્ષણ (Up, Down, Left, Right) દર્શાવે છે.
- **Dandelion Puff Floating Ring:**
  - Dandelion Puff Tile (M553) પર સફેદ રેશમી રૂંવાંનું કૂંડાળું જે દર્શાવે છે કે આ સેલ પર ગુરુત્વાકર્ષણ કામ કરતું નથી.
- **Heavy Beetle Weight Emblem:**
  - Heavy Beetle Line (M554) ના માથા પર પથ્થરનું ભાર ચિહ્ન ("Drifts with gravity").
- **Falling Acorn Motion Trails:**
  - એકોર્ન સરકતી વખતે તેની પાછળ હળવી ધૂળ અને પાંદડાંની ટ્રેઇલ.
- **Tutorial Overlay Cards:**
  - L5501: "Falling Leaves — Gravity pulls loose acorns and heavy beetles with the wind!"
  - L5511: "Wind-Vane Lever — Tap to shift gravity's direction across the whole garden."
  - L5631: "Falling Acorns — These acorns drop 1 tile after each move if their path is clear."
  - L5751: "Dandelion Puff Tile — Anti-gravity haven! Anything resting on this tile never falls."
  - L5871: "Heavy Beetle Line — Heavy ground ants slide with gravity. Bees fly safely above!"

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Gravity Shift (M551) | `lane_warp` | Fresh gust of autumn wind sweeps across board carrying fluttering golden leaves (160 ms). |
| Acorn Tumble (M552) | `dust_puff` | Soft earthy thump and tiny dirt puff as acorn drops 1 tile into resting position. |
| Dandelion Float (M553)| `state_toggle` | Gentle white dandelion seeds drift upwards in zero gravity aura as item rests on tile. |
| Beetle Drift (M554) | `guardian_hit` / heavy | Subdued ground rumble and leaf rustle as heavy beetle line slides 1 step. |
| L6000 Finale Win | `win_confetti` | Grand Autumn Gale Gala: whirlwind of scarlet and amber maple leaves, honey rain cascades. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Gravity Settlement Budget:** Grid-wide scanning and directional item movement complete in $\le 0.3\text{ ms}$.
- **CI Pre-Validation:** L5501–6000 ના તમામ 500 levels gravity solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 12 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P12-QA-01** | Wind-vane gravity vector change | Tapping lever changes global gravity vector reliably through U, L, D, R. | Not run |
| **P12-QA-02** | Falling acorn single step | Loose acorn drops exactly 1 tile per player move until hitting obstacle. | Not run |
| **P12-QA-03** | Dandelion puff immunity | Acorn or beetle resting on dandelion tile remains completely motionless. | Not run |
| **P12-QA-04** | Heavy beetle directional drift | Heavy beetle shifts with gravity; worker and scout bees fly unaffected. | Not run |
| **P12-QA-05** | Insect protection check | Falling items never land on or crush another insect; stop immediately adjacent. | Not run |
| **P12-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P12-QA-07** | L6000 Autumn Gale Gala | Finale solvable, awards Royal Honey Chest and Wind Whisperer badge. | Not run |
| **P12-QA-08** | Offline gravity generation | Seed-based generation works seamlessly offline across all devices. | Not run |

