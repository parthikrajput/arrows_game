# 01 · Phase 20 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 20 (Levels 9501–10000) ના નિયમો, Omni-System Convergence (Grand Master) signature system, L10000 Marching Clock Tower Boss અને Remote Config keys.

**Related docs:** [Phase 20 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §9, §10](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md)

---

## 1. Scope (પ્રમાણ)
Phase 20 એ Toy Trains નું વીસમું અને અંતિમ content update છે જે Levels 9501 થી 10000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 19 (9001–9500) | Phase 20 (9501–10000) |
|---|---|---|
| Levels | 9001–9500 | **9501–10000 (On-device generated via seed)** |
| Signature System | Remix B (P7–P12 Systems) | **Grand Master (All 19 Systems Convergence)** |
| Base Mechanics Type | Mid-Era Data Combos | **4 Supreme Combo Base Mechanics (M951–M954)** |
| Climax Level | Normal Plateau Finale | **L10000 "The Grand Sovereign Terminus" (Marching Boss)** |
| Difficulty Range | Plateau D 60–76 | **Plateau D 60–76 (L9501–9990), L10000 Finale D ≈ 91** |
| Board Grids | 12×12 થી 14×14 | **14×14 Ultimate Board** |
| Trains Count | 38–54 trains | **40–56 trains (L10000: 56 trains)** |

---

## 2. Signature System: Grand Master (`S20` Rules)
1. **Omni-System Convergence:**
   - Phase 20 એ સમગ્ર ગેમની તમામ 19 સિગ્નેચર સિસ્ટમ્સ (Day/Night, Multi-Floor Platforms, Shunting Carts, Beams, Turntables, Ivy Growth, Split & Merge, Metronomes, Twin Tables, Gravity Incline, Fog of War, Alpine Mirror, Conveyors, Ticket Chains, Clock Towers) નો ત્રિવેણી સંગમ છે.
2. **M951: Clockwork Conveyor Guardian:**
   - મોટરાઇઝ્ડ કન્વેયર રીંગ (P15) જે એક ક્લોક ટાવર ગાર્ડિયન (P17) ની આસપાસ સતત ગોળ ફરે છે. ટાવરને ડેમેજ આપવા માટે ટ્રેનોને કન્વેયર પરથી સમયસર એક્ઝિટ લેવડાવવી પડે છે.
3. **M952: Gravity Mirror Relay:**
   - ટિલ્ટ લીવર (P12) જે બે જોડાયેલા ટેબલ્સ (P11) પર કેન્દ્રીય આલ્પાઇન મિરર અક્ષ (P14) ની સામસામે વિરુદ્ધ ગુરુત્વાકર્ષણ પ્રવાહ ઉત્સર્જિત કરે છે (Table A ઢાળ નીચે, Table B ઢાળ ઉપર).
4. **M953: Day/Night Ticket Master Pass:**
   - વિશિષ્ટ માસ્ટર પાસ ટ્રેન (P16). દિવસના સમયે (Day Phase A) તે માત્ર સામાન્ય દરવાજા ખોલે છે, પરંતુ રાત્રિના સમયે (Night Phase B) તે સુપર સ્કેલેટન કી બનીને કોઈપણ જટિલ બેરિયરને એક ઝાટકે ખોલી નાખે છે.
5. **M954: Prism Bloom Arch:**
   - બ્લૂમ કમાન (P8) જેની ઉપર પ્રિઝમ લેન્સ (P6) જડેલો છે. કમાન ત્યારે જ કાયમી ખુલે છે જ્યારે બોર્ડની K વેલ તેને અડે **અને** ચોક્કસ રંગનો સિગ્નલ લાઇટ બીમ સીધો પ્રિઝમમાંથી પસાર થઈને કમાન પર પડે.

---

## 3. Level 10000: Marching Clock Tower Boss (`S20 Boss Rules`)
- **L10000 Ultimate Board (14×14 Grid):**
  - કેન્દ્રમાં સ્થિત વિશાળ $3\times 3$ Marching Clock Tower Boss (12 HP).
  - દર 5 મૂવે (Step 3 tick), ટાવર પોતાની નીચેના પાટાને કચડીને 1 સેલ આગળ માર્ચ કરે છે.
  - ખેલાડીએ કન્વેયર બેલ્ટ્સ, ડે/નાઇટ ટનલ્સ અને પ્રિઝમ બીમ્સનો ઉપયોગ કરીને 56 ટ્રેનોને સમયસર બહાર કાઢીને ટાવરનું HP 0 કરવું પડે છે.

---

## 4. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `20` | Player માટે ઉપલબ્ધ મહત્તમ phase. `20` હોય ત્યારે L9501–10000 અનલૉક થાય છે. |
| `phase_20_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_20_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p20` | string | `"{}"` | Emergency overrides for failed seeds in Phase 20. |

