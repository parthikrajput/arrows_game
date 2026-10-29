# 06 — UI, VFX & QA, Phase 7 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Rotation UI controls, Whirling vortex VFX, CI validation, performance budgets અને Phase 7 QA checklist.

**Related docs:** [Phase 7 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. UI Components for Whirling Garden
- **Turntable Rotate Button HUD:**
  - $4\times 4$ કે $5\times 5$ સબ-ગ્રીડના કેન્દ્રમાં સોનેરી ગોળાકાર તીર ("Rotate 90° CW") ધરાવતું ફ્લોરલ કંટ્રોલ બટન.
- **Perimeter Shift Indicator:**
  - Turning Hedge (M302) ના ખૂણાઓ પર નાના દિશા-સૂચક તીર જે આગામી શિફ્ટની દિશા દર્શાવે છે.
- **Spinning Top Wing Indicator:**
  - Spinning Top Lines (M303) ની પાછળ હળવા ફરતા પાંખોના એનિમેશન ("Ready to spin next turn").
- **Pinned Daisy Anchor Visual:**
  - Pinned Daisy (M304) લાઈન પર જમીનમાં ખૂંપેલું સફેદ ડેઇઝી જે ટર્નટેબલ લૉક હોય ત્યારે સ્પષ્ટ લાલ લૉક આઇકન દર્શાવે છે.
- **Tutorial Overlay Cards:**
  - L3001: "Whirling Garden — Garden sectors turn 90 degrees to unlock new exit lanes!"
  - L3011: "Flower-Bed Turntable — Tap the center flower to rotate this sector and its insects."
  - L3131: "Turning Hedge — Border hedge walls shift clockwise as you make moves."
  - L3251: "Spinning Top Line — This insect rotates 90° CW on turns when it doesn't move."
  - L3371: "Pinned Daisy — Rooted firmly! Cannot rotate, and locks any turntable containing it."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Turntable Rotate (M301)| `state_toggle` | Swirling vortex of flower petals and green leaves as the 4x4 sub-grid turns 90° CW (250 ms). |
| Turning Hedge Shift (M302)| `lane_warp` | Green thorny vines creep 1 tile forward with rustling foliage and small wooden creaks. |
| Spinning Top Turn (M303)| `state_toggle` | Crisp 90° CW spin with subtle floral pollen spiral trailing behind insect wings. |
| Pinned Daisy Rejection (M304)| `shake_soft` | Unyielding rooted shudder with tiny soil particles scattering when locked turntable is tapped. |
| L3500 Finale Win | `win_confetti` | Grand Whirling celebration: spiral petal cyclones, floating pollen fireworks, golden honey droplets. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Rotation Transform Budget:** 90° CW coordinate transform and line heading updates complete in $\le 0.2\text{ ms}$ on mobile.
- **CI Pre-Validation:** L3001–3500 ના તમામ 500 levels rotation solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 7 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P7-QA-01** | Turntable 90° CW transform | Sub-grid cells, lines, and directional headings rotate exactly 90° clockwise. | Not run |
| **P7-QA-02** | Turntable boundary containment | Line partially outside turntable blocks rotation button tap. | Not run |
| **P7-QA-03** | Turning hedge perimeter shift | Edge wall segments advance 1 tile clockwise strictly after N player moves. | Not run |
| **P7-QA-04** | Spinning top direction change | Insect rotates 90° CW only on turns where player moves another line. | Not run |
| **P7-QA-05** | Pinned Daisy turntable lock | Turntable containing pinned daisy cannot be activated until line exits. | Not run |
| **P7-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P7-QA-07** | L3500 Whirling Blossom Gala | Finale solvable, awards Royal Honey Chest and Whirling Botanist badge. | Not run |
| **P7-QA-08** | Offline rotation generation | Seed-based generation works seamlessly offline across all device tiers. | Not run |
