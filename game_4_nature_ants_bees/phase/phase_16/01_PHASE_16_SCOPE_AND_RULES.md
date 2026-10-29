# 01 — Phase 16 Scope & Rule Changes (ફેઝ 16 નિયમો)
> Levels 7501–8000 માટે Keys Deluxe (Royal Keyring) ના નિયમો, ચાવી શ્રૃંખલા, કી ક્રાફ્ટિંગ, સ્કેલેટન ચાવી અને Phase 16 limits.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 16 (નવું શું છે)
1. **Keys Deluxe (Royal Keyring):**
   - પઝલમાં ચાવી અને તાળાના પરંપરાગત 1-to-1 નિયમો વધુ ગહન અને બહુસ્તરીય બને છે:
     - **Dew Key Chain (M751):** પ્રથમ લૉક ખુલતાં જ તેની સાથે જોડાયેલી લાઈન પર ચાવીનું નવું આઇકન ટ્રાન્સફર થાય છે; તે લાઈન બહાર નીકળતાં બીજું લૉક ખુલે છે (મલ્ટિ-સ્ટેજ ચેઇન).
     - **Key-Crafting Flower (M752):** સંયુક્ત ચાવીનું ફૂલ. બે અલગ-અલગ અર્ધ-ચાવી (Half-Key) ધરાવતી લાઈનો બહાર નીકળે ત્યારે બંને જોડાઈને સંયુક્ત રંગનું મોટું તાળું ખોલે છે.
     - **Skeleton Dew Key (M753):** માસ્ટર કીડી; તે બહાર નીકળતાં તેના પ્રારંભિક હેડ સેલની સંપૂર્ણ હરોળ અને સ્તંભમાં રહેલા તમામ કાંટાળા તાળાઓ એકસાથે અનલૉક થઈ જાય છે.
     - **Key Swap Pad (M754):** કંટ્રોલ પેડ ટેપ કરવાથી ($1$ Move વપરાય છે) બે લિંક્ડ લાઈનો વચ્ચે ચાવીના આઇકન્સ અદલાબદલી (swap) થાય છે.
2. **Cross-Layer Key Compatibility:**
   - ચાવીઓ ગ્રાઉન્ડ કીડીઓ, વર્કર બીઝ કે કેનોપી સ્કાઉટ્સ કોઈપણ લેયરની લાઈન દ્વારા વહન કરી શકાય છે.
3. **4 New Base Mechanics (M751–M754):**
   - Dew Key Chain (M751), Key-Crafting Flower (M752), Skeleton Dew Key (M753), Key Swap Pad (M754).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 16`: Phase 16 content unlock કરવા માટે.
- `p16_skeleton_sweep_speed_ms = 120`: Skeleton key unlock wave duration.

