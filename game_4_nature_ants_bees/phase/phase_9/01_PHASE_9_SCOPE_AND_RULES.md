# 01 — Phase 9 Scope & Rule Changes (ફેઝ 9 નિયમો)
> Levels 4001–4500 માટે Split & Merge (Swarm Splits) ના નિયમો, લાઈન વિભાજન, મર્જ પેડ્સ, સેગમેન્ટ ક્લેસ્પ અને Phase 9 limits.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 9 (નવું શું છે)
1. **Split & Merge (Swarm Splits):**
   - કીડીઓ અને મધમાખીઓની લાઈનો સ્થિર આકાર છોડીને ગતિશીલ રીતે વિભાજિત થાય છે અથવા જોડાય છે:
     - **Honey Merge Pad (M401):** પ્રથમ લાઈન પેડ પર પહોંચીને અટકે છે. બીજી લિંક્ડ લાઈન પહોંચતાં તે પ્રથમની પાછળ જોડાઈ જાય છે અને સંયુક્ત કારવાં બનીને બીજી લાઈનની દિશામાં આગળ વધે છે.
     - **Fork Twig (M402):** ટ્વિગ પર પહોંચતાં લાઈન સમાન બે અર્ધભાગમાં વહેંચાય છે જે ડાબી અને જમણી બાજુ 90° એક્ઝિટ લે છે. બંને લેન સંપૂર્ણપણે ક્લિયર હોવી જરૂરી છે, નહિતર bonk થાય છે.
     - **Segment Clasp (M403):** કારવાંના પાછળના સેગમેન્ટ્સ ક્લેસ્પ વડે લૉક રહે છે જ્યાં સુધી લિંક્ડ કી-લાઈન બોર્ડમાંથી બહાર ન નીકળે.
     - **Reunion Arch (M404):** વિભાજિત થયેલી લાઈનના બંને અર્ધભાગ સફળતાપૂર્વક બહાર નીકળી જાય ત્યાર પછી જ આ આર્ચ ગેટ ખુલે છે.
2. **Simultaneous Dual Branch Verification:**
   - Fork Twig માં બંને શાખાઓમાં કોઈપણ અવરોધ કે લાઈન ન હોવી જોઈએ (એટોમિક ઓલ-ઓર-નથિંગ એક્ઝિટ).
3. **4 New Base Mechanics (M401–M404):**
   - Honey Merge Pad (M401), Fork Twig (M402), Segment Clasp (M403), Reunion Arch (M404).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 9`: Phase 9 content unlock કરવા માટે.
- `p9_split_stagger_ms = 0`: Fork split animation synchronous mode.

