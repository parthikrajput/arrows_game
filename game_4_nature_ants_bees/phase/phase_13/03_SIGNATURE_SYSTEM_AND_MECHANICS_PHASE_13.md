# 03 — Signature System & Mechanics, Phase 13 (M601–M604)
> Mystery Meadow (Hidden Info architecture), Chebyshev fog clearing, illusionary obstacles અને M601–M604 base mechanics cards.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_13_SCOPE_AND_RULES.md)

---

## 1. Signature System: Mystery Meadow (Hidden Info)
- **Core Concept:** બગીચાના અમુક ભાગો ગાઢ સવારના ધુમ્મસ (fog of war) થી ઢંકાયેલા હોય છે. પ્લેયરે સ્કાઉટિંગ કીડીઓ મોકલીને, સનલિટ પ્લેટ્સ પર ઊભા રહીને અને ભ્રામક અવરોધોને પારખીને છુપાયેલી લાઈનોને અનાવૃત કરવી પડે છે.
- **Fog & Line Concealment:**
  - ધુમ્મસવાળા સેલ્સ પર રહેલી લાઈનો અદ્રશ્ય અથવા ઝાંખી હોય છે અને તેના પર ટેપ કરી શકાતું નથી ("Scout needed!").
  - **Chebyshev Fog Radius (M601):** સ્કાઉટ લાઈન જે પાથ પરથી પસાર થાય છે, તે પાથના તમામ સેલ્સથી $\le 2$ ચેબીશેવ અંતર ધરાવતા સેલ્સ કાયમી અનાવૃત થાય છે:
    $$\max(|x - x_{\text{path}}|, |y - y_{\text{path}}|) \le 2$$
- **Illusionary Obstacles (M603):**
  - પેઇન્ટેડ પેબલ દેખાવમાં સામાન્ય પથ્થર જેવો લાગે છે, પરંતુ તે પોકળ છે. લાઈન કોઈપણ નુકસાન વગર તેમાંથી પસાર થઈ જાય છે (Scent Trail Preview માં "?" ચિહ્ન દર્શાવે છે).
- **Plate-Driven Global Beam Reveal (M604):**
  - જ્યાં સુધી કોઈ કીડીનું શરીર Sunlit Plate પર સ્થિર રહે છે, ત્યાં સુધી તે જ પ્લેટની સંપૂર્ણ હરોળ અને સ્તંભના સેલ્સ ધુમ્મસમુક્ત રહે છે.

---

## 2. Base Mechanics Cards (M601–M604)

### M601 — Scout Ant (Scout Path)
| Field | Value |
|---|---|
| ID | `M601` |
| Themed Name | **Scout Ant** (સ્કાઉટ કીડી) — Generic: Scout Path |
| Category | P / T — Reconnaissance Insect Line |
| Intro Level | **L6011** (Block 2 x1) |
| Rule | આંખો પર નાનો એન્ટેના સ્પેક પહેરેલી સ્કાઉટ કીડી. જ્યારે તે બોર્ડમાંથી બહાર નીકળે છે, ત્યારે તેના સમગ્ર એક્ઝિટ માર્ગથી 2 સેલની ત્રિજ્યામાં રહેલા તમામ ધુમ્મસના સેલ્સ કાયમી સાફ થઈ જાય છે અને છુપાયેલી લાઈનો ટેપ કરવા યોગ્ય બને છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંને સ્કાઉટ લાઈન હોઈ શકે છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M602 — Mirage Mist (Mimic Fog)
| Field | Value |
|---|---|
| ID | `M602` |
| Themed Name | **Mirage Mist** (મૃગજળ ધુમ્મસ) — Generic: Mimic Fog |
| Category | D / T — Reactive Concealment Tile |
| Intro Level | **L6131** (Block 14 x1) |
| Rule | સામાન્ય લીલા ઘાસ જેવો દેખાતો પ્રપંચી સેલ. જ્યારે કોઈપણ લાઈન તેની અડીને (orthogonally adjacent) પસાર થાય છે, ત્યારે તે સક્રિય થઈને તેની આસપાસ $3\times 3$ વિસ્તારમાં ગાઢ ધુમ્મસ ફેલાવી દે છે, જેથી આસપાસની લાઈનો ફરી છુપાઈ જાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેની મૂવમેન્ટથી ટ્રિગર થાય છે. |
| Tall | `true` (બધા લેયર્સને છુપાવે છે). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M603 — Painted Pebble (False Wall)
| Field | Value |
|---|---|
| ID | `M603` |
| Themed Name | **Painted Pebble** (ચિતરેલો કાંકરો) — Generic: False Wall |
| Category | B / T — Illusionary Obstacle |
| Intro Level | **L6251** (Block 26 x1) |
| Rule | સામાન્ય પથ્થર બ્લોકર જેવો દેખાતો પોકળ કાંકરો. જો કોઈ કીડી કે મધમાખી આ સેલ તરફ દોડે છે, તો તે અથડાવાને બદલે તેના ઉપરથી સહેલાઈથી પસાર થઈ જાય છે (bonk થતું નથી). પસાર થતાં જ કાંકરાનું કવચ તૂટી જાય છે અને તે ખુલ્લો સેલ બની જાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેની લેન માટે ખુલ્લો રહે છે. |
| Tall | Per instance. |
| Hammerable | Yes (Leaf Blower થી ઉડી શકે છે). |
| Non-Monotone (N)| Yes. |

### M604 — Sunlit Plate (Reveal Plate)
| Field | Value |
|---|---|
| ID | `M604` |
| Themed Name | **Sunlit Plate** (સૂર્યપ્રકાશ પ્લેટ) — Generic: Reveal Plate |
| Category | T / D — Persistent Cross-Axis Reveal Tile |
| Intro Level | **L6371** (Block 38 x1) |
| Rule | જમીન પર બેસાડેલી સોનેરી ધાતુની પ્લેટ. જ્યાં સુધી કોઈ કીડીનું શરીર આ પ્લેટ પર ઊભું રહે છે, ત્યાં સુધી આખી પ્લેટની હરોળ (row) અને સ્તંભ (column) ની તમામ છુપાયેલી લાઈનો અને મિકેનિક્સ સ્પષ્ટ દેખાય છે અને ટેપ કરી શકાય છે. કીડી ખસી જતાં તે ફરી અંધારામાં જાય છે. |
| Ants / Bees | કીડીઓ જમીન પરથી પ્લેટ દબાવે છે; મધમાખીઓ પણ પ્લેટ ઉપરથી લાભ મેળવે છે. |
| Tall | Ground plate. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

