# 06 — UI, VFX & QA, Phase 4 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Floor Switcher UI, Mini-Map, Multi-floor VFX for stairs and lifts, CI validation, performance budgets અને Phase 4 QA checklist.

**Related docs:** [Phase 4 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. UI Components for Garden Terraces
- **Floor Switcher Tabs (HUD):**
  - બોર્ડના ઉપર જમણી તરફ વર્ટિકલ ટેબ્સ: `F1` (Lower Terrace), `F2` (Main Garden), `F3` (Upper Canopy).
  - સક્રિય ફ્લોર સોનેરી ગાર્ડન બોર્ડર સાથે હાઇલાઇટ થાય છે.
  - ટેબ પર ટેપ કરવાથી કૅમેરા 200 ms સ્મૂથ વર્ટિકલ સ્લાઇડ સાથે સંબંધિત ફ્લોર પર સ્વિચ કરે છે.
- **Interactive Mini-Map:**
  - HUD ના ખૂણામાં 48×48 dp નો મિનિએચર 3D-સ્ટેક્ડ ફ્લોર પ્રિવ્યૂ, જેમાં બ્લોક થયેલા અને બાકી રહેલા ફ્લોર્સનો સારાંશ દેખાય છે.
- **Tutorial Overlay Cards:**
  - L1501: "Garden Terraces — Explore multiple garden floors using the floor switcher tabs!"
  - L1511: "Root Stairs — Enter stairs to climb up or down to the linked terrace."
  - L1631: "Dew-Glass Terrace — Insects on glass floors cast blocking shadows below."
  - L1751: "Rabbit Hole — Ants tumble through holes to the lower garden floor."
  - L1871: "Acorn Lift — Tap the lift to hoist insects up to higher garden branches."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Floor Transition | `lane_warp` (vertical) | 200 ms smooth parallax slide; inactive floor fades to 0.4 opacity before hiding. |
| Root Stairs (M151) | `lane_warp` | Green spiral leaf trail spiraling up/down through tree bark stairs. |
| Dew-Glass Floor (M152)| `beam_glow` | Translucent crystalline glass tile reflecting light with soft downward shadow projection. |
| Rabbit Hole (M153) | `dust_puff` + drop | Line head drops into hole with a playful soil puff and pops out below. |
| Acorn Lift (M154) | `rotate_swoosh` / lift| Golden acorn elevator ascends/descends with suspended leaf cable vibration. |
| L2000 Finale Win | `win_confetti` | Sky canopy celebration: 3-floor ascending confetti cascade and floral ribbons. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Multi-Floor Rendering:** એક સમયે માત્ર સક્રિય ફ્લોર જ draw થાય છે; નિષ્ક્રિય ફ્લોર્સની ગ્રીડ GPU મેમરીમાં કૅશ રહે છે પરંતુ render pass માં બાયપાસ થાય છે (60 fps જળવાઈ રહે છે).
- **CI Pre-Validation:** L1501–2000 ના તમામ 500 levels multi-floor solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 4 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P4-QA-01** | Floor switch tab tap | Camera smoothly shifts to tapped floor in 200 ms with 0 moves deducted. | Not run |
| **P4-QA-02** | Root Stairs traversal | Line enters stairs on Floor 1 and seamlessly exits onto Floor 2 at matching coordinates. | Not run |
| **P4-QA-03** | Dew-Glass shadow block | Body on Floor 2 glass tile bonks any line attempting to pass through Floor 1 below. | Not run |
| **P4-QA-04** | Rabbit Hole ant drop | Ants tumble down hole to lower floor; bees fly directly over hole with no effect. | Not run |
| **P4-QA-05** | Acorn Lift activation | Tapping lift transfers resting line to designated destination floor, costing 1 move. | Not run |
| **P4-QA-06** | Multi-floor solver validation | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P4-QA-07** | L2000 Sky Garden Gala | Finale solvable, awards Royal Honey Chest and Terrace Master badge. | Not run |
| **P4-QA-08** | Offline multi-floor play | Seed-based generation works seamlessly across 3 floors offline. | Not run |

