# 06 — UI, VFX & QA, Phase 5 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Physics UI indicators, Acorn push and marble sliding VFX, CI validation, performance budgets અને Phase 5 QA checklist.

**Related docs:** [Phase 5 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. UI Components for Acorn Physics
- **Heavy Weight Indicator:**
  - Stone Pumpkins (M204) ના શિખર પર નાનું પથ્થરનું ભાર ચિહ્ન ("2x weight").
  - 1-વાઇડ સિંગલ લાઈન ટેપ કરતાં તે હળવું કંપન દર્શાવે છે ("Too heavy for single ants").
- **Key Pod Matching Indicator:**
  - Seed Key Pod (M203) અને Seed Socket Plate (M055) સમાન રંગીન પરાગ ગ્લો દર્શાવે છે જેથી મેચિંગ સોકેટ સરળતાથી ઓળખી શકાય.
- **Tutorial Overlay Cards:**
  - L2001: "Acorn Physics — Push acorns and heavy blocks to create open paths!"
  - L2011: "Mole Hole — Push an acorn into the deep hole to fill it and cross safely."
  - L2131: "Dewdrop Marble — Super slick marbles slide across the lawn until hitting an obstacle."
  - L2251: "Seed Key Pod — Push the key pod onto its matching socket to unlock thorn gates."
  - L2371: "Stone Pumpkin — Extremely heavy! Push with double-file ants or chained teams."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Acorn Push | `dust_puff` | Soft earth and dry leaf dust puffs as block is nudged. |
| Mole Hole Fill (M201) | `state_toggle` + collapse | Block tumbles into hole with deep earthy thud; cell levels into smooth grass. |
| Dewdrop Marble Slide (M202)| `lane_warp` (slide) | Shimmering water droplet trail and glassy reflection glints while in motion. |
| Key Pod Lock (M203) | `state_toggle` | Vibrant colored pollen burst and golden unlock aura on linked thorn gates. |
| Stone Pumpkin (M204) | `guardian_hit` / heavy | Heavy ground impact shockwave (3 dp) and stone dust burst upon movement. |
| L2500 Finale Win | `win_confetti` | Grand harvest celebration: golden wheat stalks, pumpkin seeds, and starlight confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Physics Momentum Calculation:** Pure integer forward steps, completing in $\le 0.5\text{ ms}$ on 14×14 boards.
- **CI Pre-Validation:** L2001–2500 ના તમામ 500 levels push solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 5 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P5-QA-01** | Push chain depth limit | Pushing 2 blocks succeeds; pushing 3 in a row bonks (-1 Heart). | Not run |
| **P5-QA-02** | Mole hole filling | Push block into hole eliminates both, leaving traversable flat lawn cell. | Not run |
| **P5-QA-03** | Dewdrop marble sliding | Marble slides continuously until hitting blocker, wall, or hole. | Not run |
| **P5-QA-04** | Seed Key Pod socket trigger | Resting on matching socket immediately unlocks linked thorn gates. | Not run |
| **P5-QA-05** | Stone Pumpkin weight check | Single 1-wide line bonks; Double-File line successfully pushes 1 step. | Not run |
| **P5-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P5-QA-07** | L2500 Great Harvest Gala | Finale solvable, awards Royal Honey Chest and Heavy Harvester badge. | Not run |
| **P5-QA-08** | Offline physics generation | Seed-based generation works seamlessly offline on all tiers. | Not run |

