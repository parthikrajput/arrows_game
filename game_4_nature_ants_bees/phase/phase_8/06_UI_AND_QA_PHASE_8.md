# 06 — UI, VFX & QA, Phase 8 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Growth UI indicators, Vine spreading and shears VFX, CI validation, performance budgets અને Phase 8 QA checklist.

**Related docs:** [Phase 8 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. UI Components for Bloom Season
- **Vine Spreading Pulse Indicator:**
  - આગામી ટર્નમાં વેલ વિસ્તરવાની હોય ત્યારે મોર્નિંગ ગ્લોરી કળીઓ પર હળવો લીલો ધબકારો (pulsing green glow).
- **Shears Snip UI Cue:**
  - Garden Shears (M352) પર નાની ચમકતી ચાંદીની ધાર ("Pass through to prune neighbouring vines").
- **Seed Countdown Badge:**
  - Seed-Dropping Line (M353) દ્વારા મુકાયેલા બીજ પર બાકી Moves નું કાઉન્ટર બેજ (ઉદા. "3 moves to sprout").
- **Pollination Gate Progress:**
  - Pollination Gate (M354) ની પાંખડીઓ પર પરાગરજ મીટર (ઉદા. "1/3 pollinated") જે દરેક નજીકના એક્ઝિટ સાથે ભરાય છે.
- **Tutorial Overlay Cards:**
  - L3501: "Bloom Season — Living vines and flowers grow dynamically as you make moves!"
  - L3511: "Morning Glory Vine — Spreads in 4 directions every few moves. Clear paths before it blocks exits!"
  - L3631: "Garden Shears — Guide any ant or bee across the shears to snip away adjacent vines."
  - L3751: "Seed-Dropping Line — Drops a seed upon exit. Pass over it before it sprouts into a blocker!"
  - L3871: "Pollination Gate — Guide insects out from adjacent lanes to pollinate and bloom open the gate."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Vine Expansion (M351) | `state_toggle` | Rapid creeping green shoot with a cheerful pop of purple morning glory blossoms. |
| Shears Snip (M352) | `lane_warp` | Crisp metallic snip with green leaf shreds and sparkling dew scattering outwards. |
| Seed Drop (M353) | `dust_puff` | Soft earthy puff as glowing golden acorn/seed drops onto start head tile. |
| Seed Sprout (M353) | `state_toggle` | Seed cracks open with green vegetative burst, hardening into a weathered pebble blocker. |
| Gate Pollination (M354)| `state_toggle` | Golden pollen sparkles drift onto closed buds; petals gracefully unfurl with sweet chime. |
| L4000 Finale Win | `win_confetti` | Grand Eternal Bloom Gala: giant floral petal fireworks, golden pollen clouds, honey sparkles. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Vine Expansion Budget:** Cross-expansion BFS on 14×14 grid completes in $\le 0.4\text{ ms}$.
- **CI Pre-Validation:** L3501–4000 ના તમામ 500 levels growth simulation solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 8 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P8-QA-01** | Morning glory cross-expansion | Vines grow exactly 1 cell into free orthogonal cells every N moves. | Not run |
| **P8-QA-02** | Shears vine pruning | Passing lane over shears removes all 4 orthogonally adjacent vine cells. | Not run |
| **P8-QA-03** | Seed line drop & countdown | Exiting line drops seed at head cell; counts down N moves to blocker. | Not run |
| **P8-QA-04** | Seed lane trample | Passing same-layer line over unsprouted seed removes the seed safely. | Not run |
| **P8-QA-05** | Pollination gate requirement | Exactly K adjacent exits required to permanently open pollination gate. | Not run |
| **P8-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P8-QA-07** | L4000 Eternal Bloom Gala | Finale solvable, awards Royal Honey Chest and Master Florist badge. | Not run |
| **P8-QA-08** | Offline growth generation | Seed-based generation works seamlessly offline on all supported devices. | Not run |
