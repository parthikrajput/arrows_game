# 06 — UI, VFX & QA, Phase 15 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Water conveyor UI indicators, Rushing stream VFX, CI validation, performance budgets અને Phase 15 QA checklist.

**Related docs:** [Phase 15 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md)

---

## 1. UI Components for Brook & Rails
- **Flowing Water Texture Shader:**
  - ઝરણાંની ટાઇલ્સ પર $32\text{ dp/s}$ ની ઝડપે વહેતાં વાદળી-લીલા પાણીના તરંગો અને નાની શેવ્રોન એરો લાઇન્સ.
- **Sluice Lever Valve State:**
  - Sluice Lever (M703) પર લાકડાનો વાલ્વ જે પ્રવાહ ચાલુ હોય ત્યારે સોનેરી અને બંધ હોય ત્યારે લાલ બેરિકેડ દર્શાવે છે.
- **Tide Reversal Countdown HUD:**
  - Tide Brook (M702) પર નાનું વોટર ક્લોક બેજ (ઉદા. "2 moves to reverse").
- **Lazy River Loop Directional Flow:**
  - Lazy River (M704) ના ચારેય ખૂણાઓ પર હળવા ફરતા જળ-વમળ એનિમેશન.
- **Tutorial Overlay Cards:**
  - L7001: "Brook & Rails — Flowing streams drift resting ants forward with the water current!"
  - L7011: "Brook Fork — Water branches in two ways. Sluice gates choose the ant's route."
  - L7131: "Tide Brook — The garden tide turns! River flow reverses direction periodically."
  - L7251: "Sluice Lever — Tap the wooden lever to reroute river forks and open canal gates."
  - L7371: "Lazy River — Closed water loop! Ants orbit smoothly until you tap them to exit."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Water Drift (M701) | `lane_warp` | Ant line glides effortlessly along stream with tiny white foam wakes (180 ms). |
| Sluice Gate Flip (M703)| `state_toggle` | Sturdy wooden gate pivots with hollow clunk, splashing sparkling water spray. |
| Tidal Reversal (M702)| `lane_warp` | Stream ripples decelerate, pause for 1 frame, and wash forcefully in reverse with bubbly foam. |
| Lazy Orbit (M704) | `state_toggle` | Serene circular water ripples accompany orbiting insects with floating water-lily petals. |
| L7500 Finale Win | `win_confetti` | Grand Rushing Waters Gala: geyser-like water fountains, shimmering iridescent bubbles, confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Conveyor Drift Budget:** Graph-based conveyor drift step completes in $\le 0.2\text{ ms}$ on mobile CPU.
- **CI Pre-Validation:** L7001–7500 ના તમામ 500 levels conveyor solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 15 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P15-QA-01** | Ant brook drift | Ant resting on brook tile drifts exactly 1 tile per turn in flow direction. | Not run |
| **P15-QA-02** | Bee brook immunity | Worker and canopy bees cross brook tiles without any drift displacement. | Not run |
| **P15-QA-03** | Obstacle drift blockage | Ant drifting into occupied tile halts immediately without bonk or injury. | Not run |
| **P15-QA-04** | Tidal flow reversal | River reverses direction strictly according to moveCount % reverseEvery. | Not run |
| **P15-QA-05** | Lazy river loop traversal | Ant line orbits loop continuously until valid exit tap is executed. | Not run |
| **P15-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P15-QA-07** | L7500 Rushing Waters Gala | Finale solvable, awards Royal Honey Chest and River Master badge. | Not run |
| **P15-QA-08** | Offline conveyor generation | Seed-based generation works seamlessly offline across all devices. | Not run |

