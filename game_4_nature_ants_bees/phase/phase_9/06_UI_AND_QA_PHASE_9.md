# 06 — UI, VFX & QA, Phase 9 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Split & Merge UI indicators, Swarm fusion and fork VFX, CI validation, performance budgets અને Phase 9 QA checklist.

**Related docs:** [Phase 9 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md)

---

## 1. UI Components for Swarm Splits
- **Merge Pad Sticky Pool:**
  - Honey Merge Pad (M401) પર પારદર્શક ગોલ્ડન મધનું કૂંડાળું જે લાઈન પહોંચતાં હળવા વમળો (ripples) દર્શાવે છે.
- **Fork Branch Trajectory Preview:**
  - Scent Trail Preview (long-press 350 ms) Fork Twig (M402) પર ડાબી અને જમણી બંને શાખાઓના રસ્તા અલગ રંગના ટપકાંથી દર્શાવે છે.
- **Segment Clasp Buckle:**
  - Segment Clasp (M403) લાઈનના લૉક થયેલા સેગમેન્ટ્સ પર નાનો ગોલ્ડન બકલ અને કી-લાઈન આઇકન દર્શાવે છે.
- **Reunion Arch Progress Meter:**
  - Reunion Arch (M404) ની બંને બાજુ અડધી-અડધી પાંખડી પ્રગતિ દર્શાવે છે (Left exited / Right exited).
- **Tutorial Overlay Cards:**
  - L4001: "Swarm Splits — Ants and bees split into branches or unite into large caravans!"
  - L4011: "Honey Merge Pad — Move lines onto the sticky pad to combine them into one long caravan."
  - L4131: "Fork Twig — Divides the line into two halves exiting left and right. Both paths must be clear!"
  - L4251: "Segment Clasp — Clasp locks the back segments until the linked key insect escapes."
  - L4371: "Reunion Arch — Both split halves must exit safely before this majestic arch will open."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Merge Fusion (M401) | `state_toggle` | Honey bond snaps lines together with golden droplet burst and cheerful stick sound. |
| Fork Split (M402) | `lane_warp` | Line cleanly divides into two neat columns with crisp leaf snap and divergent trails. |
| Clasp Unlock (M403) | `state_toggle` | Golden clasp pops open with bright chime, releasing back segments with yellow sparkle. |
| Arch Opening (M404) | `state_toggle` | Dense ivy arch unfurls into blooming floral canopy with sweet resonant chord. |
| L4500 Finale Win | `win_confetti` | Grand Swarm Reunion: converging firefly streams, golden honey fireworks, festive petals. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Branch Routing Engine Budget:** Dual branch lane clearance verification across 14×14 grid completes in $\le 0.3\text{ ms}$.
- **CI Pre-Validation:** L4001–4500 ના તમામ 500 levels split/merge solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 9 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P9-QA-01** | Merge pad coupling | First line halts on pad; second line attaches behind and exits together. | Not run |
| **P9-QA-02** | Fork twig atomic clearance | If either branch is blocked, move aborts with bonk (-1 Heart); no line splits. | Not run |
| **P9-QA-03** | Fork twig line division | Even length splits into exact halves; odd length splits into ceil/floor lengths. | Not run |
| **P9-QA-04** | Segment clasp hold | Front segment moves while clasped back segments remain stationary. | Not run |
| **P9-QA-05** | Reunion arch dual check | Arch stays firmly shut after 1 branch exits; opens immediately upon 2nd branch exit. | Not run |
| **P9-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P9-QA-07** | L4500 Great Swarm Reunion | Finale solvable, awards Royal Honey Chest and Swarm Conductor badge. | Not run |
| **P9-QA-08** | Offline split generation | Seed-based generation works seamlessly offline across all devices. | Not run |

