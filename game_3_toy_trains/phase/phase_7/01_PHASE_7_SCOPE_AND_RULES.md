# 01 · Phase 7 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 7 (Levels 3001–3500) ના નિયમો, Rotation (Turntable Yards+) signature system, sub-board matrix transformation, spinning edges, tangled logic અને Remote Config keys.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. Scope (પ્રમાણ)
Phase 7 એ Toy Trains નું સાતમું content update છે જે Levels 3001 થી 3500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 6 (2501–3000) | Phase 7 (3001–3500) |
|---|---|---|
| Levels | 2501–3000 | **3001–3500 (On-device generated via seed)** |
| Signature System | Signal Lights+ (Optics & Beams) | **Turntable Yards+ (Rotation)** |
| Sub-Board Rotation | None | **4×4 Sub-board Rotor (M301)** |
| Border Exits | Static edge openings | **Spinning Station Exits (M302) shifting CW** |
| Directional Shifting| Static train direction | **Spinner Engine (M303) rotates 90° CW per Move** |
| Rotation Interlocks | Standard locks | **Turntable Lock (M304) blocks rotor until key exits** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 28–40 trains | **28–40 trains** |

---

## 2. Signature System: Turntable Yards+ (Rotation Rules)
1. **Sub-Board Rotor (M301):**
   - 4×4 કદનો મોટો ગોળાકાર લાકડાનો ટર્નટેબલ બ્લોક.
   - લીવર પર tap કરવાથી (1 Move) 4×4 ક્ષેત્રની અંદર રહેલા તમામ સેલ્સ, પાટા અને સંપૂર્ણ સમાયેલી ટ્રેનો 90° Clockwise ફરે છે.
   - જો કોઈ ટ્રેન આંશિક રીતે 4×4 ક્ષેત્રની અંદર અને આંશિક રીતે બહાર હોય, તો લીવર tap = locked tap (ફરતું નથી).
2. **Tangled Train Protection:**
   - પરિભ્રમણ પછી જો ટ્રેનનું એન્જિન પોતાના જ કેરેજ તરફ મુખ ધરાવતું થઈ જાય, તો ટ્રેન "Tangled" સ્ટેટમાં આવે છે (tap = locked tap, બમ્પ નહીં, કોઈ હાર્ટ લોસ નહીં) જ્યાં સુધી ફરીથી રોટેટ કરીને મુક્ત ન થાય.
3. **Spinning Station Exits (M302):**
   - ટેબલની કિનારી પરના ખુલ્લા એક્ઝિટ ગેપ્સ દર N Moves એ Clockwise દિશામાં 1 સેગમેન્ટ આગળ ખસે છે (Step 3 tick).
4. **Spinner Engine (M303):**
   - વિશેષ એન્જિન જે દર Move એ પોતાની દિશા આપોઆપ 90° CW ફેરવે છે (U -> R -> D -> L).
5. **Turntable Lock (M304):**
   - રોટેટિંગ યાર્ડ અથવા ટર્નટેબલ જ્યાં સુધી કી ટ્રેન બહાર ન નીકળે ત્યાં સુધી મિકેનિકલી લૉક રહે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `7` | Player માટે ઉપલબ્ધ મહત્તમ phase. `7` હોય ત્યારે જ L3001 unlock થાય. |
| `phase_7_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_7_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p7` | string | `"{}"` | Emergency overrides for failed seeds. |
