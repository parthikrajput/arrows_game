# Phase 18 — UI, Audio-Visual Feedback and QA Master Test Plan
**Phase:** 18 (Levels 8501–9000)  
**System:** Remix A — Phase 1 to Phase 6 Mechanics Synergy  
**Related Documents:** [01_PHASE_18_SCOPE_AND_RULES.md](01_PHASE_18_SCOPE_AND_RULES.md), [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md](03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md), [../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md)

---

## 1. UI Layout & Signature Visual Elements

Phase 18 માં Phase 1 થી Phase 6 સુધીની 4 high-performing signature mechanics (M851 Cycle Floor Elevator, M852 Prism Coconut Roll, M853 Solar Burrow Portal, M854 Shadow Weight Drop) synergy સાથે કામ કરે છે. UI design માં uncluttered readability અને instant status feedback મુખ્ય ધ્યેય છે.

### 1.1 Synergy Status HUD (Top Screen Overlay)
- **Cycle Dial Indicator (M851):**
  - સ્ક્રીનના top-left માં miniature 4-phase circular dial (Spring $\rightarrow$ Summer $\rightarrow$ Autumn $\rightarrow$ Winter) જે વર્તમાન cycle status દર્શાવે છે.
  - Elevating floor tiles ઉપર dynamic height chevron ($\uparrow$ / $\downarrow$) glowing glyphs સાથે rendered છે જેથી player instant floor height identify કરી શકે.
- **Solar Beam & Prism Status (M852 & M853):**
  - Prism reflectors સૂર્યપ્રકાશ focus કરે ત્યારે grid edges પર ambient warm golden vignette display થાય છે.
  - Active color filter (Red/Green/Blue) reflector border glows દ્વારા visual indication આપે છે.
- **Shadow Burrow Portal Gate (M853 & M854):**
  - Portal entrance અને exit pairs matching pulsing runic rings સાથે glow થાય છે.
  - Heavy Coconut weight balance scale icon tiles ઉપર miniature weight badge (`1W`, `2W`, `3W`) સ્વરૂપે દર્શાવવામાં આવે છે.

---

## 2. Visual Effects (VFX) Specifications

| Event | VFX Description | Particle Count / Duration | Performance Budget |
| :--- | :--- | :--- | :--- |
| **M851 Floor Elevation** | Sub-floor elevator tile rise/fall સાથે earthy stone dust puffs અને golden mechanical gear sparks. | 16 particles / 350ms | Max 1 Draw Call, billboard instancing |
| **M852 Coconut Prism Roll** | Heavy coconut reflector tile પર crash થતાં prismatic glass fracture sparks અને directional light refraction ray. | 24 radiant particles / 400ms | Dynamic additive blend shader |
| **M853 Portal Teleportation** | સાપ burrow portal માં slide થતાં purple solar vortex swirl અને exit portal આગળ starburst trail. | 30 swirl particles / 250ms | Quad mesh particle system |
| **M854 Weight Plate Trigger** | 2-weight coconut pressure plate પર land થતાં ground dust ripple wave અને latch lock click animation. | 12 ground dust rings / 200ms | 0.5ms CPU render cost |
| **L9000 Finale Sunbeam Burst**| Sanctuary of the Golden Dawn clear થતાં golden solar nova explosion, rainbow light curtains અને victory banners. | 80 celebratory particles / 1800ms | Peak particle pool capped at 100 |

---

## 3. Audio & SFX Hierarchy

Audio balance mixing table - તમામ ધ્વનિ clean separation સાથે mix કરવામાં આવેલ છે:

1. **Cycle Transition Chime (`sfx_cycle_shift.ogg`):** Soft mechanical bronze bell chime (Priority: High, 80dB LUFS).
2. **Coconut Boulder Crash (`sfx_coconut_impact.ogg`):** Deep resonant wooden impact with stone scrape (Priority: Medium-High, 82dB LUFS).
3. **Solar Portal Teleport (`sfx_burrow_warp.ogg`):** High-frequency shimmer followed by deep low-frequency swoosh (Priority: High, 85dB LUFS).
4. **Weighted Trapdoor Drop (`sfx_trapdoor_clunk.ogg`):** Solid mechanical iron latch latching into place (Priority: Medium, 78dB LUFS).
5. **Background Ambience (`bgm_phase18_sanctuary.ogg`):** Ancient jungle stone temple ambience combined with gentle seasonal wind echoes (Looped, -18dB RMS).

---

## 4. Accessibility & Readability Standards

- **Colorblind Support (Deuteranopia, Protanopia, Tritanopia):**
  - Solar Beam colors માત્ર color પર આધારિત નથી; Red (Square glyph), Green (Triangle glyph), Blue (Circle glyph) runic markers ધરાવે છે.
  - Cycle seasons distinct icons ધરાવે છે: Spring (Sprout leaf), Summer (Sun symbol), Autumn (Falling acorn), Winter (Ice crystal).
- **High Contrast UI Mode:**
  - Active toggle: Grid edges અને snake bodies માટે 4.5:1 minimum contrast ratio. Elevating floors માટે distinct black border outline.
- **Haptic Feedback:**
  - 1-weight pressure plate: 15ms light click.
  - 2-weight coconut crunch: 30ms medium thud.
  - Finale level clear: 60ms double pulse celebration.

---

## 5. Performance Budgets & Device Compatibility

- **Target Framerate:** Solid 60 FPS on mid-range Android (Snapdragon 680, 4GB RAM) અને iPhone 8 or higher. Low-end fallback: stable 30 FPS.
- **Draw Call Limits:** Max 35 draw calls per active game board screen.
- **VRAM / Texture Budget:** Combined active texture atlas $< 85\text{ MB}$.
- **Heap Memory Cap:** Peak allocated memory $< 180\text{ MB}$. Memory leak test: 150 consecutive level reloads without garbage collection freeze.

---

## 6. Comprehensive QA Test Checklist

QA Engineers must verify all 10 test scenarios before certifying Phase 18:

- [ ] **P18-QA-01 (M851 Elevator Path Blocking):** સાપ elevated tile તરફ slide કરતી વખતે floor down state માં હોય તો solid wall collision ગણાય છે કે નહીં અને સાપ head bounce થાય છે કે નહીં તે ચકાસો.
- [ ] **P18-QA-02 (M851 Cycle Move Tick Sync):** Cycle counter બરાબર 4 moves પછી advance થાય છે કે નહીં અને snake move execution order સાથે glitch વગર sync થાય છે કે નહીં તે verify કરો.
- [ ] **P18-QA-03 (M852 Coconut Deflection Angle):** Rolling coconut prism reflector સાથે અથડાતાં 90 ડિગ્રી angle પર deflection path લે છે કે નહીં તે test કરો.
- [ ] **P18-QA-04 (M852 Coconut Self-Collision):** જો 2 coconuts એકસાથે roll થઈને same cell પર converge થાય તો single priority collision rules પ્રમાણે 1 coconut crack થઈને safe stop થાય છે કે નહીં તે check કરો.
- [ ] **P18-QA-05 (M853 Portal Teleport Tail Integrity):** લાંબો સાપ (Length 8) Burrow portal માં પ્રવેશે ત્યારે tail nodes discontinuous jump કર્યા વગર smooth snake segments line maintain કરે છે કે નહીં.
- [ ] **P18-QA-06 (M853 Blocked Portal Exit):** જો Portal exit tile પર obstacle અથવા અન્ય સાપ બેઠો હોય, તો entrance tile temporary closed state માં block થાય છે કે નહીં.
- [ ] **P18-QA-07 (M854 Weight Plate Multi-Step):** 2-weight pressure plate પર 1-weight coconut push કરવાથી plate partial press થાય છે અને 2nd coconut push કરવાથી full unlock trigger થાય છે કે નહીં.
- [ ] **P18-QA-08 (Remix Synergy Multi-System Cascade):** Elevator floor પરથી coconut roll થઈને prism reflector સાથે અથડાઈને weighted plate activate કરે તે multi-system chain reaction 60 FPS પર crash વગર execute થાય છે કે નહીં.
- [ ] **P18-QA-09 (L9000 Boss/Finale Sequence):** Level 9000 Sanctuary of the Golden Dawn માં તમામ 4 systems simultaneously active હોય ત્યારે framerate drop 55 FPS થી નીચે ન જાય તે benchmark કરો.
- [ ] **P18-QA-10 (Gift Basket & Golden Slither Economy):** L8510, L8520... L8990 ના Gift Baskets (300 coins + booster) અને Golden Slither Rush events (up to 250 coins) exact balance credit કરે છે કે નહીં.
