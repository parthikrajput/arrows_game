# 06 · UI & QA Phase 17 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 17 ના UI ઘટકો (Guardian Boss HP Gauge, Clock Face Ticker, Core Beam Reticle), VFX (`clock_tick`, `tower_crumble`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Guardian Boss Health & State Visualizers
- **Guardian HP Bar:** ટાવરની ટોચ પર લાકડાના ફ્રેમવાળો હેલ્થ બાર દેખાય છે (❤️ 6/6). દરેક ટ્રેન ક્લિયર થતાં HP બાર લાલ-સોનેરી ફ્લેશ સાથે ઘટે છે.
- **Ticking Clock Face:** ટાવરની છત પર એનિમેટેડ ક્લોક ડાયલ હોય છે. તેનો કાંટો દરેક મૂવ વખતે 'ટક-ટક' અવાજ સાથે ફરે છે.
- **Depot Spawn Target Highlight:** Depot Tower (M803) જે સેલમાં નવો બફર સ્ટોપ મૂકવાનો હોય તે સેલ પર ૧ મૂવ અગાઉ લાલ શેડો પ્રદર્શિત થાય છે જેથી ખેલાડી ચેતી શકે.
- **Core Beam Alignment Reticle:** Clock Core (M804) પર જ્યારે લાઇટ બીમ આપાત થાય છે ત્યારે સોનેરી ફોકસ રીંગ (Reticle) ચમકે છે.

### 1.2 Tutorial Cards
- **L8011 (M801):** Twin Clock Towers પરિચય ("These twin clock towers share a single HP pool! Clear trains near either tower to bring them down!").
- **L8131 (M802):** Armoured Clock Tower પરિચય ("This guardian is shielded! Trains must exit in the exact color sequence shown to damage it!").
- **L8251 (M803):** Depot Tower પરિચય ("This depot spawns buffer stops on adjacent tracks! Reduce its HP to stop the spawns!").
- **L8371 (M804):** Clock Core પરિચય ("Even with 0 HP, this core won't vanish until a signal light beam illuminates its center!").

---

## 2. Phase 17 Visual Effects (VFX)
- **Clock Tick Chime:** ટાવર પર ઘડિયાળનો કાંટો આગળ વધતાં મેલોડિક વુડન બેલ સાઉન્ડ.
- **Tower Damage & Crumble:** HP ઘટતાં ટાવરમાં તિરાડો (Cracks) પડે છે અને 0 થતાં લાકડાના ટુકડાઓ અને ધુમાડા સાથે તૂટી પડે છે (`crack_shards`).
- **Buffer Stop Drop:** ડિપો ટાવરમાંથી બફર સ્ટોપ જમીન પર પછડાતાં ડસ્ટ રિંગ વિસ્ફોટ.
- **Core Beam Vaporization:** લાઇટ બીમ કોર પર પડતાં જ તે સોનેરી કન્ફેટી અને પ્રકાશના સ્તંભ સાથે વિલીન થઈ જાય છે (`BlendMode.plus`).
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 17)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P17-QA-01 | L8001–8500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P17-QA-02 | Twin Towers Shared HP | કોઈ પણ એક ટાવર પાસે ટ્રેન એક્ઝિટ થતાં સંયુક્ત પૂલમાંથી ૧ HP ઘટે; 0 થતાં બંને નાશ પામે. | Not run |
| P17-QA-03 | Armoured Tower Sequence | માત્ર દર્શાવેલા રંગ ક્રમમાં ટ્રેન નીકળે તો જ ડેમેજ થાય; અન્યથા ઇમ્યુન રહે. | Not run |
| P17-QA-04 | Depot Tower Spawn Tick | દર N Moves એ ખાલી પાડોશી સેલમાં નવો બફર સ્ટોપ સ્પોન થાય (HP > 0 હોય ત્યાં સુધી). | Not run |
| P17-QA-05 | Clock Core Light Requirement | HP 0 થયા પછી પણ લાઇટ બીમ ન પડે ત્યાં સુધી સેલ બ્લોક રહે; બીમ પડતાં જ મુક્ત થાય. | Not run |
| P17-QA-06 | Multi-Modifier Stacking | ટાવર સાથે ફેઝિંગ કે આર્મ્ડ મોડિફાયરનું સુસંગત વર્તન. | Not run |
| P17-QA-07 | 60 fps Guardian Boss Budget | ટાવર તૂટવાના એનિમેશન અને સ્પોનિંગ વખતે લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P17-QA-08 | Remote Config Rollout | `maxPhase < 17` હોય ત્યારે L8001 લોક રહે; `17` થતાં જ અનલૉક થાય. | Not run |
