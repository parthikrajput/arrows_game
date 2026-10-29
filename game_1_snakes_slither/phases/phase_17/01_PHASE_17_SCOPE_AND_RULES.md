# Phase 17: Scope and Rules (લેવલ 8001 થી 8500)

> આ દસ્તાવેજ **Phase 17 (Mongoose Clan: Guardians)** નું કાર્યક્ષેત્ર, એન્જિન નિયમો, બોસ ગાર્ડિયન સિસ્ટમ, ગ્રીડ મર્યાદાઓ અને ડિફિકલ્ટી બેન્ડ નિર્ધારિત કરે છે.

**Related docs:** [Phase 17 Index](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. ક્ષેત્ર અને હેતુ (Scope & Objective)
Phase 17 માં ખેલાડીઓ સાપોના પારંપરિક શત્રુ નોળિયા કુળ (Mongoose Clan) નો સામનો કરે છે. સામાન્ય સ્થિર અવરોધોના સ્થાને, આ તબક્કામાં સક્રિય ગાર્ડિયન્સ (Boss Guardians) રજૂ થાય છે:
- બે જોડિયા નોળિયાઓ જે એક જ આયુષ્ય (Shared HP Pool) વહેંચે છે (M801 Mongoose Twins).
- ઢાલવાળો આર્માડિલો જે લિંક્ડ લિવર બંધ કર્યા વિના ડેમેજ લેતો નથી (M802 Armadillo Guardian).
- મામા મોંગુઝ જે દર થોડા મૂવ્સે બોર્ડ પર નવા પથ્થર પેદા કરે છે (M803 Spawner Guardian).
- મોંગુઝ ડેન કોર જે માત્ર ચોક્કસ દિશામાંથી બહાર નીકળતા સાપોથી જ ઘવાય છે (M804 Guardian Core).

---

## 2. પ્રગતિ મર્યાદાઓ અને પરિમાણો (Limits & Progression)

| પેરામીટર | Phase 17 વેલ્યુ | સંદર્ભ / સ્ટાન્ડર્ડ |
| :--- | :--- | :--- |
| **લેવલ રેન્જ (Level Range)** | 8001 થી 8500 (500 ઓન-ડિવાઇસ લેવલ્સ) | SCALING §2–§4 |
| **ડિફિકલ્ટી બેન્ડ (Plateau D)** | ફિક્સ્ડ **60–76** (બ્લોક 801–849); x9 Hard $\approx 84$; Finale L8500 $\approx 91$ | Standard §17.24, SCALING §3.5 |
| **મહત્તમ ગ્રીડ સાઇઝ (Max Grid)** | 12×12 થી 14×14 (Pan + Pinch Zoom સક્ષમ) | Standard §9.3, §17.23 |
| **સાપની સંખ્યા (Snakes Count)** | 28 થી 42 સાપો | SCALING §3.5 |
| **અવરોધોની સંખ્યા (Obstacles)** | 8 થી 15 ગાર્ડિયન્સ, શીલ્ડ્સ અને પથ્થરો | SCALING §3.5 |
| **રિમોટ કન્ફિગ ફ્લેગ (Remote Config)**| `maxPhase = 17` (રોલઆઉટ કંટ્રોલ) | Standard §15.2 |
| **સબ-ટિયર્સ (Sub-Tiers)** | P17-A (L8001–8250) · P17-B (L8251–8500) | SCALING §3.5 |

---

## 3. થીમ અને બાયોમ્સ (Biomes)

Phase 17 પથરાળ ગઢ અને નોળિયાઓના ગુપ્ત અડ્ડાની થીમ પર આધારિત છે:
1. **Mongoose Outpost (લેવલ 8001–8250):**
   - બેકગ્રાઉન્ડ પેલેટ: `#EFEBE9` (હળવો પથરાળ માટીનો રંગ, લાકડાના ટેન્ટ્સ).
   - વિશેષતા: M801 Mongoose Twins અને M802 Armadillo Guardian નો પરિચય.
2. **Den of the Clan (લેવલ 8251–8500):**
   - બેકગ્રાઉન્ડ પેલેટ: `#D7CCC8` (ઘેરો માટીનો રંગ, પ્રાચીન પથ્થરના ગઢ).
   - વિશેષતા: M803 Mama Mongoose અને M804 Den Core સાથે ઉચ્ચ સ્તરની બોસ ચેલેન્જ.

---

## 4. એન્જિન આર્કિટેક્ચર અપડેટ્સ (Guardian HP Engine State)

`puzzle_core` એન્જિનમાં ગાર્ડિયન્સના આયુષ્ય અને વર્તન માટે નીચે મુજબનું મોડેલ ઉમેરવામાં આવ્યું છે:

### 4.1 ગાર્ડિયન એન્ટિટી સ્ટેટ: `GuardianState`
```dart
class GuardianEntity {
  final int id;
  int currentHp;
  final int maxHp;
  final int? sharedHpGroupId; // Linked to M801 Twins
  bool isShielded;           // Controlled by M802 Shield Lever
  final int spawnInterval;    // Linked to M803 Spawner
  int activeSpawnCount;       // Max cap = 3
}
```

### 4.2 ડેમેજ અને રીટ્રીટ મિકેનિઝમ (Defeat & Retreat)
- જ્યારે નિયુક્ત સાપ સફળતાપૂર્વક બોર્ડમાંથી બહાર નીકળે છે, ત્યારે ગાર્ડિયન 1 HP ગુમાવે છે.
- જ્યારે $\text{currentHp} \le 0$ થાય છે, ત્યારે ગાર્ડિયન બોર્ડ પરથી હસીને જંગલમાં ભાગી જાય છે (`Defeated`), અને તેનો સેલ સાપો માટે કાયમી ખુલ્લો રસ્તો બની જાય છે.

---

## 5. સોલ્વેબિલિટી અને શૂન્ય નુકસાન (Zero-Damage Solvability)

- તમામ 500 લેવલ્સ **0 Hearts Lost** અને **0 Boosters** સાથે ૧૦૦% સોલ્વેબલ છે.
- ગાર્ડિયન સાથે અથડાતાં સાપ ક્યારેય મરતો નથી કે ખેલાડીનું હાર્ટ કપાતું નથી; સાપ માત્ર માથું બોંક કરીને પાછો આવે છે.
- M803 દ્વારા પેદા થતા પથ્થરો ક્યારેય તમામ એક્ઝિટ લેન એકસાથે બ્લોક કરતા નથી (મહત્તમ કેપ = 3 પથ્થરો).

