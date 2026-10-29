# 06 — UI, VFX & QA, Phase 10 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Sequencing UI indicators, Musical rhythm VFX, CI validation, performance budgets અને Phase 10 QA checklist.

**Related docs:** [Phase 10 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md)

---

## 1. UI Components for Garden Rhythm
- **Rhythm Cycle Indicator:**
  - Cricket Gate (M451) પર નાની મ્યુઝિકલ નોટ જે દરેક Move સાથે પલ્સ થાય છે અને ગેટ ખુલવાના બાકી Moves દર્શાવે છે.
- **Bead-String HUD Bar:**
  - સ્ક્રીનની ઉપર Bead-String Lock (M452) ની મોતીની માળા જેમાં યોગ્ય ક્રમમાં નીકળેલી લાઈનોના રંગો ચમકતા ગોળાકાર મોતી સ્વરૂપે ભરાય છે.
- **Queue Number Badges:**
  - Queue Hedge (M453) પર પિત્તળના ચમકતા 1, 2, 3 નંબર પ્લેટો જે આગામી કયો નંબર એક્ઝિટ થવા માટે તૈયાર છે તે હાઇલાઇટ કરે છે.
- **Echo Bloom Recording Overlay:**
  - Echo Bloom (M454) રેકોર્ડિંગ દરમિયાન જાંબલી પરાગ અને પ્લેબેક દરમિયાન સાયન ગ્લો દર્શાવે છે.
- **Tutorial Overlay Cards:**
  - L4501: "Garden Rhythm — Timing and exit order make the garden hum in harmony!"
  - L4511: "Cricket Gate — Opens only on specific rhythm moves (e.g. every 3rd move). Plan ahead!"
  - L4631: "Bead-String Lock — Exit insects in the exact color sequence shown on the bead string."
  - L4751: "Queue Hedge — Insects must exit in strict numerical order: 1, then 2, then 3."
  - L4871: "Echo Bloom — Memorize the first group's exit colors; the second group must match the echo!"

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Cricket Gate Pulse (M451)| `state_toggle` | Crisp musical cricket chirp with rhythmic green musical wave radiating outwards. |
| Bead Match (M452) | `state_toggle` | Glass bead illuminates with brilliant rainbow glint and high harp arpeggio note. |
| Queue Exit (M453) | `lane_warp` | Golden number plate dissolves in warm shimmer as correct line exits smoothly. |
| Echo Playback (M454) | `state_toggle` | Crystal bell tone resonates as matching color echoes, opening central flower petal. |
| L5000 Finale Win | `win_confetti` | Grand Mid-Season Symphony Gala: musical clef fireworks, golden music streamers, confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Rhythm Engine Budget:** Modulo check and FIFO color buffer comparison complete in $\le 0.1\text{ ms}$.
- **CI Pre-Validation:** L4501–5000 ના તમામ 500 levels sequence solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 10 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P10-QA-01** | Cricket gate modulo opening | Gate opens strictly when moveCount % P in S; closes on non-matching moves. | Not run |
| **P10-QA-02** | Bead-string color match | Gate opens only when consecutive exits match target color string exactly. | Not run |
| **P10-QA-03** | Bead-string wrong color reset | Wrong color exit resets progress without crash or invalid state. | Not run |
| **P10-QA-04** | Queue hedge order enforcement | Line entering out of numerical order bonks (-1 Heart); correct order passes. | Not run |
| **P10-QA-05** | Echo bloom playback tap guard | Tapping out-of-order color in playback phase shakes gently with zero heart loss. | Not run |
| **P10-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P10-QA-07** | L5000 Mid-Season Symphony | Finale solvable, awards Royal Honey Chest and Rhythm Maestro badge. | Not run |
| **P10-QA-08** | Offline rhythm generation | Seed-based generation works seamlessly offline across all devices. | Not run |

