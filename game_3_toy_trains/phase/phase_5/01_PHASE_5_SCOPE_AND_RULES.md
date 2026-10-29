# 01 · Phase 5 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 5 (Levels 2001–2500) ના નિયમો, Push Physics+ (Yard Shunting+) signature system, momentum/inertia rules, cart interaction અને Remote Config keys.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. Scope (પ્રમાણ)
Phase 5 એ Toy Trains નું પાંચમું content update છે જે Levels 2001 થી 2500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 4 (1501–2000) | Phase 5 (2001–2500) |
|---|---|---|
| Levels | 1501–2000 | **2001–2500 (On-device generated via seed)** |
| Signature System | Station Floors (Multi-Floor) | **Yard Shunting+ (Push Physics+)** |
| Push Physics | None (direct exits only) | **Shunting carts, inertia, pit-filling & heavy ballast** |
| Cart Types | None | **Regular Carts, Ice Carts, Ticket Carts, Ballast Carts** |
| Terrain Modification | Static board layers | **Dynamic Bridges: ખાડામાં કાર્ટ પૂરીને ટ્રેક બનાવવો** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 28–40 trains | **28–40 trains** |

---

## 2. Signature System: Yard Shunting+ (Push Physics Rules)
1. **Shunting Push:**
   - જ્યારે કોઈ ટ્રેન પોતાની exit lane માં રહેલા કાર્ટ (Cart) ને સ્પર્શે છે, ત્યારે કાર્ટ ટ્રેનની દિશામાં આગળ ધકેલાય છે.
   - જો કાર્ટની આગળનો સેલ ખાલી હોય, તો કાર્ટ 1 સેલ આગળ ખસે છે અને ટ્રેન પોતાની સામાન્ય યાત્રા ચાલુ રાખે છે (1 Move).
   - જો કાર્ટ આગળ દીવાલ, અન્ય ટ્રેન કે અવરોધ સાથે અથડાય અને ખસી ન શકે, તો ટ્રેન બફર ક્લેક બમ્પ કરે છે (−1 Heart).
2. **Inertia & Sliding (M202 Ice Block Cart):**
   - સામાન્ય કાર્ટ માત્ર 1 સેલ ખસે છે.
   - આઇસ બ્લોક કાર્ટ (M202) ને ધકેલતાં તે જ્યાં સુધી અવરોધ, ટ્રેક એન્ડ કે ખાડો ન આવે ત્યાં સુધી પાટા પર લપસતું રહે છે (continuous slide).
3. **Pit Filling (M201 Cart Pit):**
   - ટ્રેક પરનો ખાડો (Pit) ટ્રેન માટે બ્લોકર છે.
   - જ્યારે કોઈ કાર્ટને ધકેલીને ખાડામાં નાખવામાં આવે છે, ત્યારે ખાડો પૂરાઈ જાય છે અને તે સેલ સામાન્ય પાટા (floor) માં રૂપાંતરિત થઈ જાય છે.
4. **Key Activation (M203 Ticket Cart):**
   - ટિકિટ કાર્ટને ધકેલીને મેળ ખાતા કલરના બેરિયર પેડ પર લાવવાથી બંધ રેલ્વે બેરિયર કાયમી રીતે ખુલી જાય છે.
5. **Heavy Push Resistance (M204 Ballast Cart):**
   - ભારે પથ્થરો ભરેલું બેલાસ્ટ કાર્ટ સામાન્ય એકલી ટ્રેનથી ખસતું નથી (સામાન્ય ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે).
   - બેલાસ્ટ કાર્ટને ધકેલવા માટે **Wide Load Freight (M024)** અથવા **Coupled Engines (M011)** ની સંયુક્ત શક્તિ જરૂરી છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `5` | Player માટે ઉપલબ્ધ મહત્તમ phase. `5` હોય ત્યારે જ L2001 unlock થાય. |
| `phase_5_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_5_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p5` | string | `"{}"` | Emergency overrides for failed seeds. |

