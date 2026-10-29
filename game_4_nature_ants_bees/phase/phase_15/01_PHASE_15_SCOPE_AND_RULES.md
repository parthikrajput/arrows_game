# 01 — Phase 15 Scope & Rule Changes (ફેઝ 15 નિયમો)
> Levels 7001–7500 માટે Conveyors & Tracks (Brook & Rails) ના નિયમો, ઝરણાં પ્રવાહ, બ્રૂક ફોર્ક, સ્લુઈસ લીવર અને Phase 15 limits.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 15 (નવું શું છે)
1. **Conveyors & Tracks (Brook & Rails):**
   - બગીચાની જમીન પર વહેતાં પાણીનાં નાળાં (Brooks) ઉમેરાય છે જે કીડીઓને આપમેળે આગળ વહાવે છે:
     - **Brook Fork (M701):** જ્યાં ઝરણું બે શાખાઓમાં વહેંચાય છે. સ્વિચ ગેટની સ્થિતિ મુજબ ડ્રિફ્ટ થતી કીડી ડાબી કે જમણી શાખામાં વહી જાય છે.
     - **Tide Brook (M702):** દર $N$ Moves એ આ ઝરણાંના પ્રવાહની દિશા આપમેળે $180^\circ$ ઉલટી થઈ જાય છે.
     - **Sluice Lever (M703):** કંટ્રોલ લીવર ટેપ કરવાથી ($1$ Move) ઝરણાંનો પ્રવાહ ચાલુ/બંધ થાય છે અથવા ફોર્ક સ્વિચ બદલાય છે.
     - **Lazy River (M704):** બંધ લૂપ ધરાવતું ગોળાકાર ઝરણું. જે કીડી સંપૂર્ણપણે આ લૂપ પર હોય તે દરેક Move સાથે $1$ સેલ ગોળાકાર પરિભ્રમણ કરે છે.
2. **Ant-Only Drift Physics:**
   - ઝરણું જમીન પર વહેતું હોવાથી માત્ર ગ્રાઉન્ડ કીડીઓ જ તેમાં વહે છે.
   - મધમાખીઓ (Worker Bees & Canopy Bees) હવામાં ઉડતી હોવાથી ઝરણાંની તેમના પર કોઈ અસર થતી નથી (Bees cross freely without drifting).
3. **4 New Base Mechanics (M701–M704):**
   - Brook Fork (M701), Tide Brook (M702), Sluice Lever (M703), Lazy River (M704).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 15`: Phase 15 content unlock કરવા માટે.
- `p15_brook_drift_anim_ms = 180`: Conveyor drift movement animation duration.

