# 06 · UI & QA Phase 16 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 16 ના UI ઘટકો (Ticket Stub HUD, Golden Master Pass Aura, Key Swap Links), VFX (`ticket_punch`, `chain_unlock`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Multi-Key Logistics & Crafting Visualizers
- **Ticket Stub HUD Widget:** સ્ક્રીનની ટોચ પર નાનું ઇન્વેન્ટરી બોક્સ જે ડાબી (🎟️L) અને જમણી (🎟️R) અર્ધ-ટિકિટો દર્શાવે છે. જ્યારે બંને પ્રાપ્ત થાય છે ત્યારે તેઓ સોનેરી સ્પાર્ક સાથે જોડાઈને ૧ પૂર્ણ ટિકિટ તરીકે ચમકે છે.
- **Master Pass Golden Aura:** Master Pass (M753) ટ્રેનની આસપાસ સોનેરી ક્રાઉન અને તેજસ્વી રોશનીનું વર્તુળ ચમકે છે, જે દર્શાવે છે કે તે યુનિવર્સલ સ્કેલેટન કી છે.
- **Key Swap Transfer Beams:** જ્યારે બે ટ્રેનો Swap Pad પર આવે છે, ત્યારે તેમની વચ્ચે ગોળ આકારના ચાવી ટ્રાન્સફર એરોઝ ચમકે છે.
- **Ticket Chain Domino Links:** સાંકળિત બેરિયર્સ વચ્ચે આછી ગોલ્ડન લિંકિંગ લાઇન પ્રદર્શિત થાય છે જેથી ખેલાડી ચેઇનનો ક્રમ સમજી શકે.

### 1.2 Tutorial Cards
- **L7511 (M751):** Ticket Chain પરિચય ("Unlocking this barrier releases a new key cart to unlock the next gate in the chain!").
- **L7631 (M752):** Ticket Punch પરિચય ("Collect both half-ticket stubs and punch them together to craft a full golden train ticket!").
- **L7751 (M753):** Master Pass પરિચય ("This rare golden master pass locomotive can unlock any single barrier on the board!").
- **L7871 (M754):** Ticket Swap Pad પરિચય ("Park two trains on these pads to swap their carried ticket keys in one move!").

---

## 2. Phase 16 Visual Effects (VFX)
- **Ticket Punch Stamp:** પંચ સ્ટેશન પર ટિકિટ સ્ટેમ્પ થતાં કાગળની ગોલ્ડન રજકણો અને સ્ટેમ્પ 'ઠક' સાઉન્ડ.
- **Master Skeleton Unlock:** માસ્ટર પાસ વડે ગેટ ખુલતાં તેજસ્વી સોનેરી વિસ્ફોટ અને સાંકળ તૂટવાની ઇફેક્ટ (`BlendMode.plus`).
- **Swap Pad Switch Woosh:** ચાવીઓ બદલાતી વખતે બે ટ્રેનો વચ્ચે સ્પાર્કલિંગ સ્વાઇપ લાઇન.
- **Chained Barrier Release:** એક દરવાજો ખુલતાં અંદરથી નવી ટિકિટ સ્પ્રિંગ-આઉટ થવાની મજેદાર એનિમેશન.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 16)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P16-QA-01 | L7501–8000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P16-QA-02 | Ticket Chain Sequential Release | બેરિયર A ખુલતાં જ નવી ટિકિટ B પાટા પર રિલીઝ થાય. | Not run |
| P16-QA-03 | Ticket Punch Half-Key Crafting | બંને અર્ધ-ટિકિટો પંચ થતાં જ ૧ માન્ય પૂર્ણ ટિકિટ બને; અડધી ટિકિટથી ગેટ ન ખુલે. | Not run |
| P16-QA-04 | Master Pass Single Barrier Open | માસ્ટર પાસ કોઈ પણ એક બેરિયર ખોલે અને વપરાઈ જાય (સિંગલ યુઝ). | Not run |
| P16-QA-05 | Ticket Swap Key Exchange | પેડ પર ટેપ કરતાં બંને ટ્રેનો વચ્ચે ચાવીઓ ચોક્કસ અદલાબદલી થાય (1 Move). | Not run |
| P16-QA-06 | Deadlock-Free Key Topology | જનરેટ થયેલા તમામ લેવલ્સમાં ચાવીઓનો કોઈ અશક્ય સર્ક્યુલર ડેડલોક ન હોય. | Not run |
| P16-QA-07 | 60 fps Multi-Key HUD Budget | ઇન્વેન્ટરી અને અનેક બેરિયર્સ સ્ક્રીન પર હોવા છતાં 60 fps જળવાય. | Not run |
| P16-QA-08 | Remote Config Rollout | `maxPhase < 16` હોય ત્યારે L7501 લોક રહે; `16` થતાં જ અનલૉક થાય. | Not run |
