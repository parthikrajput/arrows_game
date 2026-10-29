# Phase 19 — UI, Audio-Visual Feedback and QA Master Test Plan
**Phase:** 19 (Levels 9001–9500)  
**System:** Remix B — Phase 7 to Phase 12 Mechanics Synergy  
**Related Documents:** [01_PHASE_19_SCOPE_AND_RULES.md](01_PHASE_19_SCOPE_AND_RULES.md), [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md](03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md), [../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md)

---

## 1. UI Layout & Signature Visual Elements

Phase 19 માં dynamic winds, fast river currents, rhythmic drum pulses અને shockwaves એકસાથે ચાલતા હોવાથી UI readability અને calm information hierarchy અત્યંત મહત્વપૂર્ણ છે.

### 1.1 Rhythmic Current HUD (Top & Board Indicators)
- **Wind Direction & Velocity Compass:**
  - Board ના top-right corner માં minimalist compass glyph જે વર્તમાન Wind Vector ($\vec{W}$) અને intensity દર્શાવે છે.
  - Active wind corridor tiles ઉપર soft drifting air streaks render થાય છે.
- **Rhythm Beat Metronome (M903):**
  - HUD center-top પર 3-beat pulsing dots (`● ○ ○` $\rightarrow$ `○ ● ○` $\rightarrow$ `○ ○ ●`).
  - Beat 3 (downbeat) પર drum indicator golden flash આપે છે.
- **Echo Wave Radius Preview (M904):**
  - જ્યારે heavy python segment pressure tile ની નજીક આવે ત્યારે 4-tile shockwave circumference soft translucent white circle દ્વારા preview થાય છે.
- **River Siphon Flow Direction (M902):**
  - Water currents dynamic arrow animated textures સાથે downstream direction બતાવે છે. Reverse થતાં arrows fluidly flip થાય છે.

---

## 2. Visual Effects (VFX) Specifications

| Event | VFX Description | Particle Count / Duration | Performance Budget |
| :--- | :--- | :--- | :--- |
| **M901 Wind-Driven Vine Growth** | Vine tip માંથી sprouting green leaves અને wind direction માં blowing pollen drift. | 14 particles / 300ms | Billboard instancing, 1 Draw Call |
| **M902 Sluice Gate Siphon** | Water level rise/fall સાથે white foam water splash ripples અને shimmering spray. | 20 water droplets / 350ms | Simple additive sprite pool |
| **M903 Drumbeat Pulse** | Downbeat પર drum gate માંથી expanding concentric soundwave shock ring. | Mesh ring scale / 250ms | Single procedural quad mesh |
| **M904 Heavy Shockwave Impact** | Heavy python slam થતાં ground dust ripple wave અને stone fracture cracks. | 16 dust puffs / 200ms | Instanced unlit particle emitter |
| **L9500 Grand Current Vortex** | Sanctum of Currents clear થતાં rainbow waterspout, storm cloud parting અને golden banners. | 90 celebratory particles / 2000ms | Peak particle pool capped at 100 |

---

## 3. Audio & SFX Hierarchy

Clear mixing levels ensuring zero audio fatigue over 500 levels:

1. **Wind Shift Gust (`sfx_wind_whistle.ogg`):** Crisp atmospheric breeze gust (Priority: Medium-High, 78dB LUFS).
2. **Water Sluice Reverse (`sfx_water_whoosh.ogg`):** Heavy hydraulic water rush and splash (Priority: High, 82dB LUFS).
3. **Monsoon Drum Downbeat (`sfx_tribal_kick.ogg`):** Deep resonant bass drum kick with sub-bass resonance (Priority: High, 84dB LUFS).
4. **Echo Bell Resonate (`sfx_temple_chime.ogg`):** High harmonic bronze chime ringing for 1.2s (Priority: Medium, 80dB LUFS).
5. **Background Ambience (`bgm_phase19_monsoon.ogg`):** Dynamic organic tribal rhythms combined with monsoon rain showers (Looped, -19dB RMS).

---

## 4. Accessibility & Readability Standards

- **Colorblind Support (Deuteranopia, Protanopia, Tritanopia):**
  - Water current directions માત્ર blue color પર આધારિત નથી; distinct animated white chevrons ($\ggg$) embedded છે.
  - Wind corridors drifting white wind trail lines ધરાવે છે.
  - Drum Gate states: Open (Hollow circular glyph), Closed (Crossed stone bar glyph).
- **Audio Clue Independence:**
  - તમામ audio cues (drum beat, shockwave, bell) screen-edge subtle pulse અથવા haptic feedback સાથે 100% paired છે, જેથી muted audio પર પણ perfect gameplay શક્ય બને.
- **Haptic Feedback:**
  - Wind gust: 10ms micro pulse.
  - Drum beat 3: 25ms sharp tap.
  - Heavy shockwave slam: 40ms heavy rumble.

---

## 5. Performance Budgets & Device Compatibility

- **Target Framerate:** 60 FPS on mid-range Android (Snapdragon 680, 4GB RAM) અને iPhone 8+. Low-tier Android: stable 30 FPS.
- **Draw Call Limits:** Max 35 draw calls per active game board screen.
- **VRAM / Texture Budget:** Combined active texture atlas $< 85\text{ MB}$.
- **Heap Memory Cap:** Peak allocated memory $< 180\text{ MB}$. Zero memory leaks on 150 consecutive level reloads.

---

## 6. Comprehensive QA Test Checklist

QA Engineers must verify all 10 test scenarios before certifying Phase 19:

- [ ] **P19-QA-01 (M901 Wind Directional Constraint):** શું Wind vector South હોવા છતાં vine North અથવા East માં grow થવાનો પ્રયાસ કરે છે? (Must strictly fail/block).
- [ ] **P19-QA-02 (M901 Vine Wall Collision):** Vine growth path માં wall અથવા rock આવતાં growth safely suppress થાય છે કે નહીં.
- [ ] **P19-QA-03 (M902 Sluice Gate Flow Inversion):** Reflection pool lily switch trigger થતાં બંને rivers નો flow direction instantly synchronize થઈને reverse થાય છે કે નહીં.
- [ ] **P19-QA-04 (M902 Opposing Vectors Cancellation):** સાપ Northbound River માં તરતો હોય અને Southbound Wind active થાય ત્યારે સાપનું position neutral ($0$ drift) રહે છે કે નહીં.
- [ ] **P19-QA-05 (M903 Drum Beat 3 Synchronization):** Downbeat (Beat 3) પર Monsoon gust અને Drum gate toggle એક જ frame માં perfectly synchronized થાય છે કે નહીં.
- [ ] **P19-QA-06 (M903 Rhythm Undo Consistency):** Single-turn undo કરવાથી beat counter $(n-1) \pmod 3$ પર exact restore થાય છે કે નહીં.
- [ ] **P19-QA-07 (M904 Heavy Python Shockwave Radius):** Manhattan distance $r \le 4$ tiles ની અંદર જ Echo bells activate થાય છે કે નહીં; $r = 5$ tiles પર trigger block રહે છે કે નહીં.
- [ ] **P19-QA-08 (M904 Light Snake Trigger Failure):** Light/Standard snake pressure tile પર step કરવાથી shockwave emit થતી નથી તે verify કરો.
- [ ] **P19-QA-09 (L9500 Summit Performance Benchmark):** Level 9500 માં તમામ 4 systems (Wind + Water + Rhythm + Echo) simultaneously active હોય ત્યારે framerate 55 FPS થી નીચે ન જવું જોઈએ.
- [ ] **P19-QA-10 (Gift Basket & Golden Slither Economy Ledger):** L9010 થી L9490 ના 49 Gift Baskets (300 coins + cycling booster) અને Golden Slither Rush events (up to 250 coins) exact balance credit કરે છે કે નહીં.
