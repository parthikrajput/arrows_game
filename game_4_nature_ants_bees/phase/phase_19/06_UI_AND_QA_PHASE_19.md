# 06 — UI, VFX & QA, Phase 19 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Kinetic Hybrid UI indicators, Wind & Blossom vortex VFX, CI validation, performance budgets અને Phase 19 QA checklist.

**Related docs:** [Phase 19 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md)

---

## 1. UI Components for Garden Festival II
- **Gravity-Growth Composite Indicator:**
  - Falling Vines (M901) પર નાનું તીર જે દર્શાવે છે કે વેલ કઈ દિશામાં સરકશે અને ક્યારે વધશે.
- **Rhythm Rotor Beat Halo:**
  - Rhythm Rotor (M902) ના કેન્દ્રમાં મ્યુઝિકલ નોટ જે દર Move સાથે તેજસ્વી બને છે ("Rotates on next beat!").
- **Cross-Board Fork Portals:**
  - Twin-Garden Fork (M903) ની એક શાખા પર બોર્ડ B તરફ નિર્દેશ કરતો લિંક પોર્ટલ ગ્લો.
- **Local Gravity Sector Compass:**
  - Gravity Turntable (M904) ના ખૂણે નાનો સ્થાનિક કંપાસ જે સેક્ટરના પોતાના ગુરુત્વાકર્ષણની દિશા દર્શાવે છે.
- **Tutorial Overlay Cards:**
  - L9001: "Garden Festival II — Advanced harmony of rotation, growth, splits, rhythm, and gravity!"
  - L9011: "Falling Vines — Spreading vines that also drift with gravity. Clear lanes before they fall!"
  - L9131: "Rhythm Rotor — This garden turntable turns automatically on the beat of the rhythm!"
  - L9251: "Twin-Garden Fork — Split your insects across two completely separate garden boards!"
  - L9371: "Gravity Turntable — Rotating this sector changes the direction of gravity within it."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Falling Vine Slide (M901)| `dust_puff` + `lane_warp`| Spreading shoots slide downwards with leafy dust puffs and organic rustling sounds. |
| Auto-Rotor Turn (M902)| `state_toggle` | Resonant cello chord chimes as the 4x4 sector snaps 90° CW surrounded by golden ring. |
| Cross-Board Split (M903)| `lane_warp` | Insect cleanly divides; one half dashes locally while other teleports via sparkling portal to Board B. |
| Gravity Turntable (M904)| `state_toggle` | Wind vortex sweeps circular region; loose debris settles into newly aligned gravity direction. |
| L9500 Finale Win | `win_confetti` | Grand Festival of Winds & Blooms: massive whirlwind of cherry blossoms, golden honey sparks, confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Kinetic Engine Budget:** Multi-system kinetic settlement (rotor + gravity + growth) completes in $\le 0.3\text{ ms}$.
- **CI Pre-Validation:** L9001–9500 ના તમામ 500 levels hybrid solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 19 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P19-QA-01** | Falling vines multi-step | Vines expand orthogonally and slide with gravity according to tick order. | Not run |
| **P19-QA-02** | Rhythm rotor auto rotation | Sub-grid sector turns 90° CW strictly on modulo beats without player tap. | Not run |
| **P19-QA-03** | Twin-garden fork division | One half moves within Board A; second half exits into matching Board B tile. | Not run |
| **P19-QA-04** | Gravity turntable sector shift | Local items slide according to sector's rotated gravity vector independently. | Not run |
| **P19-QA-05** | Order of settlement verification| Player move $\to$ rotor turn $\to$ gravity drift $\to$ vine growth settles cleanly. | Not run |
| **P19-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P19-QA-07** | L9500 Winds & Blooms Gala | Finale solvable, awards Royal Honey Chest and Master Composer badge. | Not run |
| **P19-QA-08** | Offline kinetic generation | Seed-based generation works seamlessly offline across all devices. | Not run |
