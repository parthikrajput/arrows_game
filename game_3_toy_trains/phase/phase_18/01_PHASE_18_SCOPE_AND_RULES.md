# 01 · Phase 18 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 18 (Levels 8501–9000) ના નિયમો, Early Era Analytics Remix (Remix A) signature system, ક્રોસ-સિસ્ટમ ફ્યુઝન, એનાલિટિક્સ આધારિત સિલેક્શન અને Remote Config keys.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §9, §10](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md)

---

## 1. Scope (પ્રમાણ)
Phase 18 એ Toy Trains નું અઢારમું content update છે જે Levels 8501 થી 9000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 17 (8001–8500) | Phase 18 (8501–9000) |
|---|---|---|
| Levels | 8001–8500 | **8501–9000 (On-device generated via seed)** |
| Signature System | Clock Towers (Guardians) | **Remix A (P1–P6 Systems Synergy)** |
| Base Mechanics Type | New single theme | **4 Data-Chosen Combo Mechanics (M851–M854)** |
| System Fusion | Boss guardian battle | **Multi-System Interlock (Day/Night + Floors + Light + Carts)** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 36–52 trains | **36–52 trains** |

---

## 2. Signature System: Remix A (`S18` Rules)
1. **Selection & Telemetry Criteria (§10):**
   - Remix A ના 4 કોમ્બોઝ Phase 1 થી 6 વચ્ચેના સૌથી વધુ વિન-રેટ, શ્રેષ્ઠ રિટર્ન-ટુ-પ્લે રેટ અને ન્યૂનતમ ક્વિટ-રેટ ધરાવતી સિસ્ટમ્સના આધારે નક્કી થાય છે.
2. **M851: Day/Night Ticket Cart (Cycle Key):**
   - ટિકિટ કાર્ટ (P5) ને શન્ટિંગ દ્વારા Day/Night Tunnel (P3) માં ધકેલવામાં આવે છે.
   - ટનલમાંથી બહાર નીકળતી વખતે કાર્ટનું સ્ટેટ સાયકલ A/B સાથે સિંક્રનાઇઝ થાય છે, જે ફક્ત ચોક્કસ ડે અથવા નાઇટ ફેઝમાં જ સંબંધિત બેરિયર ખોલે છે.
3. **M852: Station Floor Shunting Lift (Multi-Floor Cart Elevator):**
   - મલ્ટી-ફ્લોર એલિવેટર (P4) જે ભારે બેલાસ્ટ અથવા આઇસ કાર્ટ્સ (P5) ને ઉપલા અને નીચલા પ્લેટફોર્મ ફ્લોર વચ્ચે ટ્રાન્સફર કરે છે.
4. **M853: Prism Signal Sensor (Color Lens Sensor Gate):**
   - સિગ્નલ લાઇટ બીમ (P6) કલર્ડ લેન્સમાંથી પસાર થઈને સેન્સર ગેટ (P6) પર આપાત થાય છે જે પ્લેટફોર્મના ડ્રોબ્રિજ (P2) ને કાયમી ડાઉન કરે છે.
5. **M854: Ice Cart Blackout Chute (Drop Hole Shunting):**
   - આઇસ બ્લોક કાર્ટ (P5) ફ્રોસ્ટી રેલ્સ પર સરકીને ગુડ્સ ચ્યુટ (P4) માં પડે છે અને નીચેના અંધારા બ્લેકઆઉટ પેચ (P6) વાળા કાર્ટ પીટમાં ફીટ થઈ પાટો પૂર્ણ કરે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `18` | Player માટે ઉપલબ્ધ મહત્તમ phase. `18` હોય ત્યારે જ L8501 unlock થાય. |
| `phase_18_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_18_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p18` | string | `"{}"` | Emergency overrides for failed seeds in Phase 18. |

