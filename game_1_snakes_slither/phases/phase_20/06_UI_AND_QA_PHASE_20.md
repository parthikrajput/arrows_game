# Phase 20 — UI, Audio-Visual Feedback and QA Master Test Plan
**Phase:** 20 (Levels 9501–10,000)  
**System:** Grand Jungle Master & Level 10,000 Grand Finale  
**Related Documents:** [01_PHASE_20_SCOPE_AND_RULES.md](01_PHASE_20_SCOPE_AND_RULES.md), [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md](03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md), [../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md)

---

## 1. UI Layout & Signature Visual Elements

Phase 20 માં Boss Encounters, 14-system convergence અને Level 10,000 Grand Finale હોવાથી UI એ supreme clarity, instant threat telegraphing અને celebratory majesty પ્રદાન કરવાની જરૂર છે.

### 1.1 Climax Boss & Vortex HUD
- **Apex Boss Threat Indicator (M951):**
  - Mongoose Boss ની line-of-sight corridor tiles પર bright translucent red ground glyphs ($\times \times \times$) પ્રગટ થાય છે.
  - Boss portrait top-center માં mini-boss status badge સાથે દેખાય છે (Normal, Roaring/Telegraphing, Stunned with circular star icon).
- **Prismatic Master Key Counter (M952):**
  - HUD પર pulsing iridescent diamond icon જે બતાવે છે કે master key acquired છે કે નહીં.
- **Convergence Vortex Orbital Markers (M953):**
  - Entry અને exit vortex tiles rotating neon cyan spirals સાથે render થાય છે, જેમાં matching roman numerals (`I`, `II`, `III`) linked pairs identify કરે છે.
- **Crown Pedestal Shimmer (M954):**
  - Board center પર રહેલ Crown Pedestal સૂર્યપ્રકાશના radiant vertical beam સાથે shine કરે છે. Remaining required apples count pedestal ની ઉપર 3D floating badge તરીકે દેખાય છે.

---

## 2. Visual Effects (VFX) Specifications

| Event | VFX Description | Particle Count / Duration | Performance Budget |
| :--- | :--- | :--- | :--- |
| **M951 Boss Strike & Slam** | Boss dash trail માં red speed streaks; wall impact પર stone debris puffs અને yellow stun stars. | 22 particles / 400ms | Dynamic quad instancing |
| **M952 Master Key Bloom** | Key collect થતાં kaleidoscopic rainbow light burst જે તમામ gate locks તરફ rays શૂટ કરે છે. | 32 prism particles / 500ms | Additive color blend shader |
| **M953 Vortex Transit** | સાપ vortex માં પ્રવેશતાં cosmic spiral suction swirl અને exit tile પર starfield ejection. | 28 glow particles / 300ms | 0.4ms CPU frame budget |
| **M954 Crown Descent** | સાપ pedestal પર ચઢતાં golden crown આકાશમાંથી ઉતરીને સાપના માથા પર બેસે છે. | 40 golden glitter motes / 1200ms| Unlit particle system |
| **L10000 Grand Finale Celebration** | Level 10,000 clear થતાં royal fireworks, golden serpents soaring, confetti deluge અને "JUNGLE SOVEREIGN" banner. | 120 grand celebratory particles / 3500ms | Capped at 150 particles peak |

---

## 3. Audio & SFX Hierarchy

Epic orchestral jungle instrumentation balanced with precise mechanical feedback:

1. **Boss Roar & Rush (`sfx_boss_charge.ogg`):** Guttural predator roar followed by rapid heavy paw steps (Priority: High, 85dB LUFS).
2. **Boss Stun Clang (`sfx_boss_dazed.ogg`):** Resonant metallic gong impact with dazed tweeting birds (Priority: High, 83dB LUFS).
3. **Master Key Chime (`sfx_prismatic_unlock.ogg`):** Harmonious multi-octave crystal chime (Priority: Medium-High, 80dB LUFS).
4. **Vortex Dimensional Warp (`sfx_vortex_whoosh.ogg`):** Deep spatial bass suction followed by pleasant cosmic chime (Priority: High, 82dB LUFS).
5. **Level 10,000 Royal Fanfare (`mus_grand_sovereign_theme.ogg`):** Majestic brass and tribal drum triumph symphony playing upon Level 10,000 victory.

---

## 4. Accessibility & Readability Standards

- **Colorblind Support (Deuteranopia, Protanopia, Tritanopia):**
  - Boss telegraph tiles માત્ર red color પર નિર્ભર નથી; sharp claw crosshatch patterns ($\times \times \times$) ધરાવે છે.
  - Linked vortex portals matching geometric shapes ધરાવે છે: Pair 1 (Triangle), Pair 2 (Square), Pair 3 (Diamond).
- **High-Contrast Boss Telegraph Mode:**
  - Settings માં toggle: Boss danger zones ને 100% opaque yellow-black hazard stripes માં દર્શાવી શકાય છે.
- **Haptic Feedback:**
  - Boss telegraph: 15ms warning double-tap.
  - Boss wall crash: 50ms heavy rumble.
  - Crown pedestal clear: 80ms triumphant triple pulse.

---

## 5. Performance Budgets & Device Compatibility

- **Target Framerate:** 60 FPS on mid-range Android (Snapdragon 680, 4GB RAM) અને iPhone 8+. Low-end Android fallback: solid 30 FPS.
- **Draw Call Limits:** Max 35 draw calls even during Level 10,000 multi-system climax.
- **VRAM / Texture Atlas:** Under 85 MB active texture memory.
- **Heap Memory Cap:** Peak allocated memory $< 180\text{ MB}$. 150-level stress loop test with zero memory leaks.

---

## 6. Comprehensive QA Test Checklist

QA Engineers must verify all 10 test scenarios before certifying Phase 20 and signing off the 10,000-level release:

- [ ] **P20-QA-01 (M951 Boss Line-of-Sight Telegraph):** સાપ boss ના 4-tile linear corridor માં આવતાં બરાબર 1 turn અગાઉ claw warning tiles દેખાય છે કે નહીં.
- [ ] **P20-QA-02 (M951 Boss Trapdoor / Obstacle Stun):** સાપ બાજુ પર ખસતાં boss straight rush કરીને wall અથવા trapdoor સાથે અથડાઈને 3 turns માટે stunned થાય છે કે નહીં.
- [ ] **P20-QA-03 (M951 Turn-Based Determinism):** Player swipe કર્યા વગર ગમે તેટલો સમય રાહ જુએ તો પણ boss real-time attack કરતો નથી તે verify કરો.
- [ ] **P20-QA-04 (M952 Master Key Simultaneous Unlock):** Master Key pickup થતાં બોર્ડ પરના તમામ પ્રકારના locks (burrow, river, drum, prism) એક જ turn માં open થાય છે કે નહીં.
- [ ] **P20-QA-05 (M953 Vortex Transit Tail Continuity):** 8-segment સાપ vortex માંથી પસાર થતાં tail segments break થયા વગર smooth path follow કરે છે કે નહીં.
- [ ] **P20-QA-06 (M953 Vortex Infinite Loop Prevention):** વિરુદ્ધ દિશાના vortices વચ્ચે per-turn max 1 transit cap કડક રીતે લાગુ થાય છે કે નહીં.
- [ ] **P20-QA-07 (M954 Crown Pedestal Win Condition):** જ્યાં સુધી બોર્ડના તમામ golden apples એકત્ર ન થાય ત્યાં સુધી pedestal locked રહે છે કે નહીં અને છેલ્લું apple લીધા પછી unlock થાય છે કે નહીં.
- [ ] **P20-QA-08 (Level 10,000 14-System Concurrency):** Level 10,000 માં તમામ 14 signature mechanics એકસાથે active હોય ત્યારે frame rate 55 FPS થી નીચે ન જવું જોઈએ.
- [ ] **P20-QA-09 (L10000 Climax Chest & Reward Grants):** Level 10,000 victory screen પર 5,000 coins + 5 Hint + 5 Shield + 5 Hammer + Sovereign Skin + Crown Badge 100% ચોક્કસાઈ સાથે credit થાય છે કે નહીં.
- [ ] **P20-QA-10 (Endless Mastery Mode & Leaderboard Activation):** L10000 clear થયા પછી Main Menu પર Endless Mastery Mode અને Global Crown Leaderboard seamlessly unlock થાય છે કે નહીં.
