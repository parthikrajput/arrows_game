# 01 — Phase 4 Scope & Rule Changes (ફેઝ 4 નિયમો)
> Levels 1501–2000 માટે Multi-floor system (Garden Terraces), vertical transitions, camera/floor navigation અને Phase 4 gameplay limits.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based deterministic forward simulation; zero wall-clock timer (30s Golden Nectar Rush સિવાય).
- 3 Hearts, 1 ad revive per level, Honey Heart Refill 120 coins (max 2/attempt).
- Boosters (Hint, Shield, Hammer, Preview) pricing, caps અને functions યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy). Bees ground ants સાથે collide થતાં નથી; `tall: true` obstacles ત્રણેય layers ને block કરે છે.
- 0 hearts lost અને 0 boosters solvability guarantee.

## 2. What's New in Phase 4 (નવું શું છે)
1. **Multi-Floor Architecture (Garden Terraces):**
   - પઝલ બોર્ડ 2 અથવા 3 વર્ટિકલ ફ્લોર્સમાં વહેંચાયેલું છે:
     - Floor 0: **Lower Terrace** (ભૂગર્ભીય અથવા નીચલો બગીચો)
     - Floor 1: **Main Garden** (મુખ્ય પુષ્પ વાટિકા)
     - Floor 2: **Upper Canopy** (વૃક્ષોની ટોચ અને છત્ર)
   - દરેક ફ્લોરનું પોતાનું $W \times H$ ગ્રીડ હોય છે (સામાન્ય રીતે 10×10 થી 12×12).
2. **Floor Navigation:**
   - HUD માં **Floor Switcher Tabs** (F1, F2, F3) સાથે એક લઘુ Mini-Map. ટેબ પર tap કરવાથી કૅમેરા તે ફ્લોર પર સ્મૂથ વર્ટિકલ સ્લાઇડ (200 ms) સાથે ફોકસ કરે છે.
   - Floor switch એ **Move નથી** (કાઉન્ટર વધતો નથી, લાઈનો હલતી નથી).
3. **Vertical Lane Traversal:**
   - લાઈનો Root Stairs (M151) અથવા Rabbit Holes (M153) દ્વારા એક ફ્લોર પરથી બીજા ફ્લોર પર પહોંચી શકે છે.
   - જ્યારે કોઈ લાઈન બીજા ફ્લોર પર ઉતરે છે ત્યારે તેનો આગળનો રસ્તો તે નવા ફ્લોરની ગ્રીડ પર ચકાસાય છે.
4. **4 New Base Mechanics (M151–M154):**
   - Root Stairs (M151), Dew-Glass Terrace (M152), Rabbit Hole (M153), Acorn Lift (M154).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 10×10 થી 12×12 per floor (કુલ એરિયા ક્યારેય $3 \times 144$ સેલ્સથી વધુ નહીં).
- **Line Count:** 28 થી 40 lines (તમામ ફ્લોર્સ વચ્ચે વહેંચાયેલ).
- **Obstacle Count:** 8 થી 14 instances કુલ.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 4`: Phase 4 content unlock કરવા માટે.
- `p4_max_floors = 3`: Maximum supported active floors.

