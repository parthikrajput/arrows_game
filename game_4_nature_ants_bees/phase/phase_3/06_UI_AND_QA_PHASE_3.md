# 06 — UI, VFX & QA, Phase 3 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Day & Night Sun/Moon Dial HUD, Cycles & M101–M104 visual effects, particle limits, CI generator validation, performance budgets અને Phase 3 QA checklist.

**Related docs:** [Phase 3 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. UI Components for Day & Night Cycles
- **Sun & Moon Dial HUD:**
  - Gameplay ટોપ બારમાં Move counter ની પાસે ગોઠવાયેલું 5-સેગમેન્ટ ગોળ ડાયલ.
  - સેગમેન્ટ્સ 1 થી 5 સુધી ક્રમશઃ ભરાય છે.
  - 5મા પગલે: સૂર્ય અસ્ત પામે છે અને સોનેરી કિરણો ધીમેથી નીલી ચાંદનીમાં પરિવર્તિત થાય છે (250 ms easeInOutCubic rotation).
  - Night mode માં ચાંદો અને ચમકતા આગિયા દેખાય છે.
- **Tutorial Overlay Cards:**
  - L1001: "Day & Night Garden — The garden cycles between day and night every 5 moves."
  - L1011: "Sunrise Gate — Open during the sunny day, closed at night."
  - L1131: "Moonlit Twig Bridge — Shimmers into a bridge only under the moonlight."
  - L1251: "Dawn Burrow — Portals active only in the morning sun."
  - L1371: "Day-Bloom Line — Petal colors transform as day turns to night."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Day → Night Flip | `state_toggle` (global) | 300 ms screen ambient tint sweep (warm lawn `#81C784` $\rightarrow$ twilight slate `#37474F`). |
| Night → Day Flip | `state_toggle` (global) | 300 ms golden dawn rays sweep across board (`BlendMode.plus`, alpha 0.25). |
| Sunrise Gate (M101) | `state_toggle` | Golden sunflower petals open at dawn, fold tight with dew drops at dusk. |
| Moonlit Bridge (M102)| `beam_glow` | Bridge glows with ethereal silver-blue moonlight when night falls. |
| Dawn Burrow (M103) | `lane_warp` | Warm amber sparkle swirl above burrow entrance during daytime. |
| Day-Bloom Line (M104)| `morph_flash` | Line abdomen/bands smoothly crossfade colors over 200 ms with tiny pollen sparkle. |
| L1500 Finale Win | `win_confetti` | Dual sun-and-moon fireworks: golden honey flakes and silvery starlight petals within tier caps. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **CI Pre-Validation:** L1001–1500 ના તમામ 500 levels CI validator માં 0 hearts lost અને 0 boosters થી સોલ્વ થવા જોઈએ.
- **On-Device Generator Budget:**
  - Background isolate માં level generation સમય $\le 300\text{ ms}$ on mid-tier hardware.
  - Active level રમતી વખતે આગળના 2 levels prefetch થઈને Hive કેશમાં સ્ટોર થાય છે.
- **Static Board Frame Cost:** Idle board પર Ticker બંધ થઈ જતાં 0 fps જાળવી રાખે છે.

## 4. Phase 3 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P3-QA-01** | Move counting parity | Dial increments strictly on moves; boosters and preview do not advance dial. | Not run |
| **P3-QA-02** | Cycle state flip at Move 5 | Day flips to Night exactly after 5th move finishes animation. | Not run |
| **P3-QA-03** | Sunrise Gate blocking | M101 blocks ants at night; tall M101 blocks bees and canopy scouts. | Not run |
| **P3-QA-04** | Moonlit Bridge crossing | M102 acts as bridge at night; plain ground in day (collides if occupied). | Not run |
| **P3-QA-05** | Dawn Burrow portal | M103 teleports lines in day; inert cells at night. | Not run |
| **P3-QA-06** | Day-Bloom color matching | M104 matches color A gates in day, color B gates at night. | Not run |
| **P3-QA-07** | Deterministic seed generation | ARM64 mobile and x64 CI produce identical level JSON for all seeds. | Not run |
| **P3-QA-08** | L1500 Solstice Gala Finale | Solvable with 0 hearts and 0 boosters; awards Royal Honey Chest. | Not run |
| **P3-QA-09** | Battery Saver profile | Enforces Low VFX profile immediately, cycles continue smoothly. | Not run |
| **P3-QA-10** | Offline generation | Generates and loads levels 1001–1500 seamlessly without network connection. | Not run |

