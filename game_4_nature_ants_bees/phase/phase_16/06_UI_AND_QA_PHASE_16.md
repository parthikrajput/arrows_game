# 06 — UI, VFX & QA, Phase 16 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Keyring UI indicators, Key crafting synthesis VFX, CI validation, performance budgets અને Phase 16 QA checklist.

**Related docs:** [Phase 16 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md)

---

## 1. UI Components for Royal Keyring
- **Keyring Inventory HUD Bar:**
  - ટોચ પર શાહી ચાવીઓનો રિંગ આઇકન જે દર્શાવે છે કે કયા રંગની ચાવીઓ અને અર્ધ-ચાવીઓ અનલૉક થઈ છે.
- **Key Crafting Fusion Indicator:**
  - Key-Crafting Flower (M752) ની પાંખડીઓ પર અર્ધ-ચાવીઓ પહોંચતાં રંગબેરંગી પરાગરજ પ્રકાશિત થાય છે.
- **Skeleton Crown Shimmer:**
  - Skeleton Dew Key (M753) ના માથા પર ચમકતો સોનેરી મુગટ ("Row & Column Master Key").
- **Key Swap Link Arcs:**
  - Key Swap Pad (M754) સાથે જોડાયેલી બે લાઈનો વચ્ચે ચમકતા સોનેરી કમાન-તીર (swapping link).
- **Tutorial Overlay Cards:**
  - L7501: "Royal Keyring — Unlock chains of keys, craft combined colors, and swap keys between insects!"
  - L7511: "Dew Key Chain — Opening one lock grants a new key to another waiting insect."
  - L7631: "Key-Crafting Flower — Exit both half-key insects to craft a combined-color master key!"
  - L7751: "Skeleton Dew Key — Master insect! Exiting shatters all locks in its starting row and column."
  - L7871: "Key Swap Pad — Tap to swap key possession between two linked insects to clear tricky paths."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Chain Key Pass (M751)| `state_toggle` | Golden key hops from opened lock to next insect with high musical harp chime. |
| Key Crafting (M752) | `state_toggle` | Dual half-keys orbit central flower, fusing with radiant polychromatic flash and deep chord. |
| Skeleton Wave (M753) | `glow_burst` | Orthogonal golden light wave sweeps across row and column, disintegrating locks (120 ms). |
| Key Swap (M754) | `state_toggle` | Twin golden sparks trace looping arcs through the air, exchanging key icons between lines. |
| L8000 Finale Win | `win_confetti` | Grand Queen's Royal Lock Gala: showering golden filigree keys, royal crown fireworks, confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Key Graph Verification Budget:** Chained dependency graph resolution completes in $\le 0.1\text{ ms}$.
- **CI Pre-Validation:** L7501–8000 ના તમામ 500 levels key solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 16 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P16-QA-01** | Dew key chain progression | Opening lock 1 immediately bestows key 2 to linked insect. | Not run |
| **P16-QA-02** | Half-key synthesis completion | Gate opens strictly after BOTH required half-key insects exit the board. | Not run |
| **P16-QA-03** | Skeleton key cross-axis sweep | Exiting skeleton key clears all locks in starting row and column accurately. | Not run |
| **P16-QA-04** | Key swap allocation | Tapping swap pad exchanges key types between the two target lines. | Not run |
| **P16-QA-05** | Cross-layer key carry | Worker bees and ground ants carry and utilize keys with identical logic. | Not run |
| **P16-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P16-QA-07** | L8000 Queen's Royal Lock Gala | Finale solvable, awards Royal Honey Chest and Master Keywright badge. | Not run |
| **P16-QA-08** | Offline key generation | Seed-based generation works seamlessly offline across all devices. | Not run |

