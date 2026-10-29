# 06 — UI, VFX & QA, Phase 18 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Hybrid Remix UI indicators, Festival lantern VFX, CI validation, performance budgets અને Phase 18 QA checklist.

**Related docs:** [Phase 18 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md)

---

## 1. UI Components for Garden Festival I
- **Cycle-Floor Dual Badge:**
  - Day-Night Terrace (M851) પર સૂર્ય/ચંદ્રનું આઇકન સાથે ફ્લોર નંબર (Floor 1 $\to$ Floor 2).
- **Prism Acorn Reflection Cue:**
  - Sunlit Acorn (M852) પર કાચનો ચમકતો પ્રિઝમ જે સૂર્યકિરણ પડતાં રીફ્લેક્શન પાથ દર્શાવે છે.
- **Shaded Stairs Illumination Ring:**
  - Shaded Stairs (M853) પર અંધકાર વચ્ચે લાલ લૉક જે કિરણ પડતાં સોનેરી પગથિયાંમાં ફેરવાય છે.
- **Dawn Marble Solid/Slide Marker:**
  - Dawn Marble (M854) પર દિવસ દરમિયાન પાણીનું ટીપું (Sliding) અને રાત્રે નક્કર પથ્થરનું ચિહ્ન (Stationary).
- **Tutorial Overlay Cards:**
  - L8501: "Garden Festival I — Experience the ultimate fusion of garden cycles, terraces, physics, and beams!"
  - L8511: "Day-Night Terrace — These stairs only carry insects upstairs during the sunny day state!"
  - L8631: "Sunlit Acorn — Push this acorn into light beams to redirect sunlight across the garden."
  - L8751: "Shaded Stairs — Shrouded in darkness! Direct a light beam onto these stairs to climb up."
  - L8871: "Dawn Marble — Slides smoothly during daylight, but freezes into solid immovable rock at night."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Terrace Cycle Shift (M851)| `state_toggle` | Daylight terrace blooms upwards with golden sun flares; at night sinks into ground with cool mist. |
| Acorn Beam Deflect (M852)| `glow_burst` | Brilliant prismatic flash as rolling acorn redirects beam with chromatic particle spray. |
| Shaded Stair Light (M853)| `glow_burst` | Darkness vaporizes as solar beam hits stairs, leaving sparkling steps of pure light. |
| Marble State Shift (M854)| `state_toggle` | Slick water droplet crystallizes into rough gray granite rock with frosty crackle. |
| L9000 Finale Win | `win_confetti` | Grand Festival of Sunlight & Shadows: glowing paper lanterns, golden sunbursts, fireworks. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Hybrid Solver Budget:** Multi-floor and beam raycasting combined state step completes in $\le 0.3\text{ ms}$.
- **CI Pre-Validation:** L8501–9000 ના તમામ 500 levels hybrid solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 18 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P18-QA-01** | Day-night terrace temporal climb | Insects climb to floor 2 in Day state; blocked in Night state (lawn cell). | Not run |
| **P18-QA-02** | Sunlit acorn push and reflect | Pushing acorn updates beam deflection angle accurately in same turn. | Not run |
| **P18-QA-03** | Shaded stairs beam requirement | Stairs remain untraversable until illuminated by matching layer beam. | Not run |
| **P18-QA-04** | Dawn marble state-dependent physics | Slides freely on grass in Day; completely stationary and immovable at Night. | Not run |
| **P18-QA-05** | Floor and beam layer alignment | Beams on floor 1 do not illuminate stairs on floor 2 without optical portals. | Not run |
| **P18-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P18-QA-07** | L9000 Festival Gala | Finale solvable, awards Royal Honey Chest and Festival Grandee badge. | Not run |
| **P18-QA-08** | Offline hybrid generation | Seed-based generation works seamlessly offline across all devices. | Not run |
