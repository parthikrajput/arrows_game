# 01 · Phase 9 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 9 (Levels 4001–4500) ના નિયમો, Split & Merge (Couple & Uncouple) signature system, ટ્રેન જોડાણ અને વિભાજન લોજિક, રીજોઇન ગેટ્સ અને Remote Config keys.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md)

---

## 1. Scope (પ્રમાણ)
Phase 9 એ Toy Trains નું નવમું content update છે જે Levels 4001 થી 4500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 8 (3501–4000) | Phase 9 (4001–4500) |
|---|---|---|
| Levels | 3501–4000 | **4001–4500 (On-device generated via seed)** |
| Signature System | Overgrown Branch Line (Growth) | **Couple & Uncouple (Split & Merge)** |
| Dynamic Merge | None | **Coupling Pad (M401) merges 2 trains into 1** |
| Dynamic Split | None | **Twin Split Train (M402) splits 1 train into 2** |
| Locking Logic | Foliage growth blocks | **Coupling Lock (M403) holds segment until key exits** |
| Gate Unlocking | Flower Arch (K ivy cells) | **Rejoin Arch (M404) unlocks when both twin halves pass** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 28–40 trains | **30–42 trains** |

---

## 2. Signature System: Couple & Uncouple (`S09` Rules)
1. **Coupling Pad (M401 Merger Pad):**
   - ટ્રેક પર સ્થાપિત જોડીદાર મેગ્નેટિક પેડ્સ (`padA`, `padB`).
   - જ્યારે બે લિન્ક્ડ ટ્રેનોના મુખ (Heads) બંને પેડ્સ પર આવીને ઊભા રહે છે, ત્યારે ખેલાડી ટેપ કરી શકે છે (1 Move).
   - ટેપ કરવાથી બંને ટ્રેનો જોડાઈને એક સિંગલ સંયુક્ત ટ્રેન બને છે (ફ્રન્ટ એન્જિન + રીઅર બોગીઓ). હવે બંને સંયુક્ત રૂપે એકસાથે ચાલે છે.
2. **Twin Split Train (M402 Twin Splitter):**
   - ખાસ ડબલ-વિડ્થ અથવા ડ્યુઅલ-બોગી ટ્રેન.
   - જ્યારે પાટા પર કોઈ અવરોધ ન હોય અને પ્લેયર આ ટ્રેન પર ટેપ કરે, ત્યારે તે 2 અલગ સમાંતર ટ્રેનોમાં વિભાજિત થાય છે (બંને સમાન દિશામાં મુખ ધરાવે છે).
   - વિભાજન 1 Move ગણાય છે. બંને ટ્રેનો ત્યારબાદ સ્વતંત્ર રીતે ટેપ કરી શકાય છે.
3. **Coupling Lock (M403 Segment Lock):**
   - ટ્રેનના પાછળના સેગમેન્ટને જકડી રાખતો રેલ્વે લોક.
   - જ્યાં સુધી ચોક્કસ કી-ટ્રેન (Key Train) બોર્ડમાંથી એક્ઝિટ ન થાય, ત્યાં સુધી આ સેગમેન્ટ અનકપલ થઈને મુક્ત થઈ શકતું નથી. લોક રહેલા સેગમેન્ટ પર ટેપ કરવાથી તે બ્લોક્ડ ટેપ ગણાય છે (વિગલ એનિમેશન).
4. **Rejoin Arch (M404 Rejoin Gate):**
   - વિશિષ્ટ કમાન જે શરૂઆતમાં અન્ય તમામ ટ્રેનો માટે બંધ રહે છે.
   - વિભાજિત થયેલી ટ્વિન ટ્રેન (M402) નો પ્રથમ ભાગ આ કમાનમાંથી પસાર થઈ શકે છે. જ્યારે તેનો બીજો ભાગ પણ આ કમાનમાંથી સફળતાપૂર્વક પસાર થાય છે, ત્યારે કમાન કાયમી ધોરણે સંપૂર્ણ ખુલી જાય છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `9` | Player માટે ઉપલબ્ધ મહત્તમ phase. `9` હોય ત્યારે જ L4001 unlock થાય. |
| `phase_9_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_9_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p9` | string | `"{}"` | Emergency overrides for failed seeds in Phase 9. |
