# 01 — Phase 5 Scope & Rule Changes (ફેઝ 5 નિયમો)
> Levels 2001–2500 માટે Push Physics+ (Acorn Physics) ના નિયમો, મોમેન્ટમ, હોલ-ફિલિંગ, વેઇટ મિકેનિક્સ અને Phase 5 limits.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- Solvability: 0 hearts lost અને 0 boosters required (CI verified).

## 2. What's New in Phase 5 (નવું શું છે)
1. **Push Physics+ (Acorn Physics):**
   - પુશ બ્લોક્સ માત્ર એક ડગલું ખસવાને બદલે જમીનની સપાટી મુજબ વર્તે છે:
     - ઘર્ષણ વિનાની સપાટી પર સતત સ્લાઇડ થવું (Dewdrop Marble).
     - ખાડાઓ (Mole Holes) માં પડીને જમીનને સપાટ બનાવવી, જેથી પાછળની લાઈનો માટે નવો રસ્તો ખુલે.
     - કી પોડ્સ દ્વારા મેચિંગ સોકેટ્સ અનલૉક કરવા.
     - ભારે પથ્થરના કોળા (Stone Pumpkins) જેને ખસેડવા માટે ડબલ-ફાઇલ લાઈનો અથવા સામૂહિક તાકાત જરૂરી બને.
2. **Push Chain Mechanics:**
   - બ્લોક $A$ ને ધકેલતાં જો તેની આગળ બ્લોક $B$ હોય અને $B$ નો આગળનો રસ્તો ખાલી હોય, તો બંને બ્લોક્સ 1 ડગલું આગળ વધે છે (મર્યાદા: મહત્તમ 2 બ્લોક્સની ચેઇન). જો આગળ દીવાલ હોય તો bonk થાય છે (-1 Heart).
3. **4 New Base Mechanics (M201–M204):**
   - Mole Hole (M201), Dewdrop Marble (M202), Seed Key Pod (M203), Stone Pumpkin (M204).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 5`: Phase 5 content unlock કરવા માટે.
- `p5_max_push_chain = 2`: Maximum pushable block chain depth.

