# 02 — Level Progression (Levels 501–1000)
> Phase 2 ના 500 levels ની ગોઠવણ: P2-A/P2-B tiers અને biomes, L501–510 zoom onboarding (level-by-level), પૂરું 50-block table અને L1000 Finale "Mongoose Emperor's Sun Temple".

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §9, §12](../../SHARED_CORE_STANDARD.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [Phase 1 Progression](../phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Principles (સિદ્ધાંતો)
1. **દર 10 levels એ નવું:** L501–510 onboarding (કોઈ નવું mechanic નહીં), પછી block `N1…N0` ના x1 slot પર M051 (L511) … M099 (L991).
2. **Fair:** દરેક level 0 hearts lost + 0 boosters થી solvable (CI validator + solver, standard §12).
3. **Difficulty ઘટે નહીં:** Phase 2 નો સૌથી નીચો target D = **45** (= T5 mid, standard §9.3). Block ની અંદર માત્ર x5 breather અને x0 milestone આરામ.
4. **Turn-based:** કોઈ seconds limit નહીં; Lantern/Toadstool gates Moves થી ચાલે.
5. **Hand-tuned:** L501–510, દરેક x1 intro, દરેક x9 Hard, L1000 Finale. બાકી `tools/levelgen` + designer review.
6. **Zoom-aware design:** ≥ 12×12 boards પર પણ x1 intro નું નવું mechanic fit-scale પર દેખાય તેમ board ના center 8×8 માં મૂકવું.

## 2. Tier Table & Biomes
| Tier | Levels | Biome | Board tint | Grid | Snakes | Max obstacle instances | D band |
|---|---|---|---|---|---|---|---|
| P2-A | 501–600 | Waterfall Gorge | `#E0F2F1` | 10×10–12×12 | 24–30 | 6–9 | 45–53 |
| P2-A | 601–700 | Sunbeam Rainforest | `#F1F8E9` | 11×11–13×13 | 26–32 | 7–11 | 49–57 |
| P2-A | 701–750 | Treetop Village | `#EFF5E6` | 12×12–13×13 | 30–34 | 9–12 | 54–60 |
| P2-B | 751–850 | Ancient Ruins | `#F3EEE4` | 12×12–13×13 | 28–34 | 8–12 | 54–62 |
| P2-B | 851–950 | Crystal Caves | `#E8EAF6` | 13×13–14×14 | 32–38 | 10–14 | 58–67 |
| P2-B | 951–1000 | Sun Temple | `#FFF3E0` | 14×14 | 36–40 | 12–14 | 64–70 (L1000 ≈ 84) |

- બધી ranges standard §9.3 ની P2-A (10×10–13×13, 24–34, 6–12, 45–60) અને P2-B (12×12–14×14, 28–40, 8–14, 52–70) ની **અંદર** છે.
- P2-A band 45 થી શરૂ (standard §9.3 = T5 mid, non-decrease rule).
- **Instance counting:** marker entries (M051 Sidewinder list, M069 Treetop Tiers, M078 Walled Garden) `O` માં ગણાતી નથી; બાકીની દરેક `mechanics[]` entry = 1 instance (lever + તેના linked gates = 1).

## 3. Onboarding — Levels 501–510 (level-by-level)
કોઈ નવું mechanic નહીં; Phase 1 mechanics નું review mix. Goal: zoom/pan શીખવવું. D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S (standard §9.4).

| L | Grid | P | C | O | N | S | D | Slot / tag | Phase 1 mechanics used | Tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|---|---|---|---|
| 501 | 12×12 | 24 | 8 | 6 | 2 | 1 | 45.4 | intro / normal | M001 ×2, M002 ×2, M009 (1 lever), M007 | `p2_1_pinch`: Grandpa Tortoise card "The garden grew!"; board auto-fit; hand pinch animation — player એક વાર pinch-zoom કરે ત્યારે step પૂરું. Fit button pulse |
| 502 | 12×12 | 24 | 8 | 7 | 2 | 1 | 47.4 | practice / normal | M004, M008, M001 ×3, M009, M017 | `p2_2_pan`: zoomed view માં 1 snake off-screen; edge arrow ⇒ "Drag to look around" (1-finger zoomed / 2-finger) |
| 503 | 12×12 | 25 | 8 | 7 | 2 | 2 | 49.0 | practice / normal | M010, M014 ×2, M016, M019, M013, M001 | `p2_3_fit`: Fit 🔍 button tooltip; tight-cluster snake પર ambiguous tap guard toast "Zoom in to pick" એક વાર બતાવો |
| 504 | 12×12 | 26 | 8 | 7 | 2 | 2 | 49.6 | practice / normal | M020, M026 (3 gems), M028, M025, M002, M001 ×2 | `p2_4_preview_zoomed`: zoomed long-press preview, lane off-screen જાય ત્યારે dotted line + edge arrow |
| 505 | 11×11 | 24 | 8 | 6 | 1 | 1 | 42.4 | breather / **easy** | M001 ×3, M006, M038, M027 | `p2_5_no_zoom`: tooltip "Smaller gardens fit the screen — no zoom needed" (zoom disabled < 12×12) |
| 506 | 12×12 | 27 | 8 | 7 | 2 | 2 | 50.2 | ramp / normal | M032 (2 canopy), M033, M011, M031, M001 ×2, M045 | `p2_6_offscreen_bump`: off-screen blocker red chevron tooltip |
| 507 | 12×12 | 27 | 9 | 7 | 2 | 1 | 50.7 | ramp / normal | M035, M036, M037, M019, M042, M002, M041 | `p2_7_hint_camera`: Glow Firefly Hint use થાય ત્યારે camera target પર pan (tooltip only, Hint ફરજિયાત નહીં) |
| 508 | 12×12 | 28 | 9 | 7 | 2 | 1 | 51.3 | ramp / normal | M043, M044, M046, M047, M001 ×2, M009 | `p2_8_remember_zoom`: Settings tip "Remember zoom" (optional) |
| 509 | 12×12 | 28 | 10 | 8 | 2 | 2 | 55.8 | hard / **hard** | M049, M048, M039, M034, M010, M016, M001 ×2 | — (red paw badge) |
| 510 | 12×12 | 26 | 8 | 7 | 2 | 1 | 48.6 | milestone / normal | M004, M013, M020, M026, M029, M001 ×2 | Jungle Gift Basket **300 + 1 Safety Shell Shield** (51 mod 4 = 3) + Sticker Album Vol 4 sticker #1 |

- L509 Hard target = 51 × 1.1 ≈ 56 (block band max 51). L505 breather = band low (45) − 2.6, ±3 tolerance ની અંદર.
- Guided steps (L501 pinch) skip નથી, પણ 2 s inactivity પછી hand ફરી pulse; device multitouch report ન કરે (accessibility switch access) ⇒ step "Got it" થી પૂરું, Fit/＋/− buttons દેખાય ([06 §3.4](./06_FRONTEND_AND_QA_PHASE_2.md#34-accessibility-zoom-buttons)).
- Phase 2 Cosmetics teaser: L501 win screen પર એક વાર "New: Style shop" chip (popup નહીં).

## 4. 10-Level Block Pattern (unchanged, standard §9.2)
| Slot | Role | Target (block D band) | Tag (coins) | Map UI |
|---|---|---|---|---|
| x1 | Intro: નવું mechanic + ≤ 1 જૂનું mechanic type, Grandpa Tortoise card + tutorial hand | band low (નીચલો 25%) | Normal (20) | "NEW!" leaf badge |
| x2–x4 | Practice | low → mid | Normal | — |
| x5 | Breather | low | **Easy (15)** | — |
| x6–x8 | Ramp | mid → high | Normal | — |
| x9 | Hard | band max × 1.1 | **Hard (30)** | Red paw badge |
| x0 | Milestone (Jungle Gift Basket 300 + booster + sticker) | mid | Normal | Gift basket icon |

- Mechanic pool (x2–x0): block નું નવું mechanic દરેક level માં ≥ 1 instance; બાકીના instances: છેલ્લા 5 unlocked mechanics 50%, બાકીના Phase 2 mechanics 30%, Phase 1 mechanics 20% (Phase 1 skills ભૂલાય નહીં).
- `slot` / `tag` JSON fields Phase 1 જેવા (standard §16.15).

## 5. Intro Level (x1) Rules — Phase 2
- x1 grid = block range નું નીચલું size; નવું mechanic board ના center 8×8 માં (fit-scale પર ઓળખાય).
- Instances: intro mechanic 1–3 + ≤ 1 જૂનું mechanic type (validator, standard §12). Tier min instance count x1 માં લાગુ પડતો નથી (D ±3 tolerance માં રહેવું).
- Intro card (Grandpa Tortoise): themed name, 1-line rule, 3-frame loop animation. Settings → "Jungle Guide" માં ફરી જોવાય.
- Tutorial hand: `solution[0]`; mechanic interactive હોય (lever, swap stone, totem) તો hand તેના પર. Hand target off-screen ⇒ camera auto-pan 300 ms.

## 6. Block Table — Levels 501–1000 (all 50 blocks)
- **Gift (x0):** 300 coins + 1 booster `(L/10) mod 4` → 1 Hint · 2 Hammer · 3 Shield · 0 Undo (Glow Firefly Hint / Magic Stone Hammer / Safety Shell Shield / Coil-Back Undo).
- **Golden Slither Rush:** level number નથી; marked level first clear પછી, 30 snakes. x0 level પર હોય તો Gift Basket પહેલાં, પછી Rush.
- **Obs** = max obstacle instances (block range). Hard = x9.

| Block | Levels | Tier | New mechanic (x1) | Grid | Snakes | Obs | D band | Gift (x0) | Rush | Hard |
|---|---|---|---|---|---|---|---|---|---|---|
| 51 | 501–510 | P2-A | — Onboarding (zoom/pan, 12×12) | 11×11–12×12 | 24–28 | 6–8 | 45–51 | 300 + Shield | — | L509 |
| 52 | 511–520 | P2-A | L511 · M051 Sidewinder Snake | 10×10–12×12 | 24–28 | 6–8 | 45–51 | 300 + Undo | — | L519 |
| 53 | 521–530 | P2-A | L521 · M052 Rubber Root Bumper | 10×10–12×12 | 24–28 | 6–8 | 45–51 | 300 + Hint | after L525 | L529 |
| 54 | 531–540 | P2-A | L531 · M053 Rolling Coconut | 10×10–12×12 | 24–28 | 6–8 | 45–51 | 300 + Hammer | — | L539 |
| 55 | 541–550 | P2-A | L541 · M054 Slick Moss | 10×10–12×12 | 24–28 | 6–8 | 45–51 | 300 + Shield | after L550 | L549 |
| 56 | 551–560 | P2-A | L551 · M055 Coconut Cradle | 11×11–12×12 | 26–30 | 7–9 | 47–53 | 300 + Undo | — | L559 |
| 57 | 561–570 | P2-A | L561 · M056 Liana Ramp | 11×11–12×12 | 26–30 | 7–9 | 47–53 | 300 + Hint | — | L569 |
| 58 | 571–580 | P2-A | L571 · M057 Firefly Lantern Gate | 11×11–12×12 | 26–30 | 7–9 | 47–53 | 300 + Hammer | after L575 | L579 |
| 59 | 581–590 | P2-A | L581 · M058 Spinning Leaf Arrow | 11×11–12×12 | 26–30 | 7–9 | 47–53 | 300 + Shield | — | L589 |
| 60 | 591–600 | P2-A | L591 · M059 Berry Paint Puddle | 11×11–12×12 | 26–30 | 7–9 | 47–53 | 300 + Undo | after L600 | L599 |
| 61 | 601–610 | P2-A | L601 · M060 Toad Swap Stone | 11×11–12×12 | 26–30 | 7–10 | 49–55 | 300 + Hint | — | L609 |
| 62 | 611–620 | P2-A | L611 · M061 Sleepy Den | 11×11–12×12 | 26–30 | 7–10 | 49–55 | 300 + Hammer | — | L619 |
| 63 | 621–630 | P2-A | L621 · M062 Picnic Exit Quota | 11×11–12×12 | 26–30 | 7–10 | 49–55 | 300 + Shield | after L625 | L629 |
| 64 | 631–640 | P2-A | L631 · M063 Honey Pot | 11×11–12×12 | 26–30 | 7–10 | 49–55 | 300 + Undo | — | L639 |
| 65 | 641–650 | P2-A | L641 · M064 Seesaw Branch Gates | 11×11–12×12 | 26–30 | 7–10 | 49–55 | 300 + Hint | after L650 | L649 |
| 66 | 651–660 | P2-A | L651 · M065 Buried Leaf-Key | 12×12–13×13 | 28–32 | 8–11 | 52–57 | 300 + Hammer | — | L659 |
| 67 | 661–670 | P2-A | L661 · M066 Vine-Tied Triplets | 12×12–13×13 | 28–32 | 8–11 | 52–57 | 300 + Shield | — | L669 |
| 68 | 671–680 | P2-A | L671 · M067 Crumbly Soil | 12×12–13×13 | 28–32 | 8–11 | 52–57 | 300 + Undo | after L675 | L679 |
| 69 | 681–690 | P2-A | L681 · M068 Slime Trail Snake | 12×12–13×13 | 28–32 | 8–11 | 52–57 | 300 + Hint | — | L689 |
| 70 | 691–700 | P2-A | L691 · M069 Treetop Tiers | 12×12–13×13 | 28–32 | 8–11 | 52–57 | 300 + Hammer | after L700 | L699 |
| 71 | 701–710 | P2-A | L701 · M070 Wind Totem Lever | 12×12–13×13 | 30–34 | 9–12 | 54–60 | 300 + Shield | — | L709 |
| 72 | 711–720 | P2-A | L711 · M071 Counting Hedge Gate | 12×12–13×13 | 30–34 | 9–12 | 54–60 | 300 + Undo | — | L719 |
| 73 | 721–730 | P2-A | L721 · M072 Rainbow Parade | 12×12–13×13 | 30–34 | 9–12 | 54–60 | 300 + Hint | after L725 | L729 |
| 74 | 731–740 | P2-A | L731 · M073 Dew Bubble Snake | 12×12–13×13 | 30–34 | 9–12 | 54–60 | 300 + Hammer | — | L739 |
| 75 | 741–750 | P2-A | L741 · M074 Temple Stone Wall | 12×12–13×13 | 30–34 | 9–12 | 54–60 | 300 + Shield | after L750 | L749 |
| 76 | 751–760 | P2-B | L751 · M075 Creeping Mist | 12×12–13×13 | 28–34 | 8–12 | 54–60 | 300 + Undo | — | L759 |
| 77 | 761–770 | P2-B | L761 · M076 Burrow Network | 12×12–13×13 | 28–34 | 8–12 | 54–60 | 300 + Hint | — | L769 |
| 78 | 771–780 | P2-B | L771 · M077 Boom Puffball | 12×12–13×13 | 28–34 | 8–12 | 54–60 | 300 + Hammer | after L775 | L779 |
| 79 | 781–790 | P2-B | L781 · M078 Walled Garden | 12×12–13×13 | 28–34 | 8–12 | 54–60 | 300 + Shield | — | L789 |
| 80 | 791–800 | P2-B | L791 · M079 Whirlwind Garden | 12×12–13×13 (square) | 28–34 | 8–12 | 54–60 | 300 + Undo | after L800 | L799 |
| 81 | 801–810 | P2-B | L801 · M080 Twin Bamboo Cages | 12×12–13×13 | 30–34 | 9–12 | 56–62 | 300 + Hint | — | L809 |
| 82 | 811–820 | P2-B | L811 · M081 Copycat Snake | 12×12–13×13 | 30–34 | 9–12 | 56–62 | 300 + Hammer | — | L819 |
| 83 | 821–830 | P2-B | L821 · M082 River Current | 12×12–13×13 | 30–34 | 9–12 | 56–62 | 300 + Shield | after L825 | L829 |
| 84 | 831–840 | P2-B | L831 · M083 Heavy Mossy Stone | 12×12–13×13 | 30–34 | 9–12 | 56–62 | 300 + Undo | — | L839 |
| 85 | 841–850 | P2-B | L841 · M084 Sunbeam Crystal | 12×12–13×13 | 30–34 | 9–12 | 56–62 | 300 + Hint | after L850 | L849 |
| 86 | 851–860 | P2-B | L851 · M085 Sunflower Receiver | 13×13 | 32–36 | 10–13 | 58–64 | 300 + Hammer | — | L859 |
| 87 | 861–870 | P2-B | L861 · M086 Dewdrop Mirror Leaf | 13×13 | 32–36 | 10–13 | 58–64 | 300 + Shield | — | L869 |
| 88 | 871–880 | P2-B | L871 · M087 Tree Sap Puddle | 13×13 | 32–36 | 10–13 | 58–64 | 300 + Undo | after L875 | L879 |
| 89 | 881–890 | P2-B | L881 · M088 Thorny Burr Trap | 13×13 | 32–36 | 10–13 | 58–64 | 300 + Hint | — | L889 |
| 90 | 891–900 | P2-B | L891 · M089 Crystal Prism Flower | 13×13 | 32–36 | 10–13 | 58–64 | 300 + Hammer | after L900 | L899 |
| 91 | 901–910 | P2-B | L901 · M090 Tick-Tock Toadstool Gate | 13×13–14×14 | 34–38 | 11–14 | 61–67 | 300 + Shield | — | L909 |
| 92 | 911–920 | P2-B | L911 · M091 Great Whirl Stump | 13×13–14×14 | 34–38 | 11–14 | 61–67 | 300 + Undo | — | L919 |
| 93 | 921–930 | P2-B | L921 · M092 Bead Millipede | 13×13–14×14 | 34–38 | 11–14 | 61–67 | 300 + Hint | after L925 | L929 |
| 94 | 931–940 | P2-B | L931 · M093 Fork-Tail Splitter | 13×13–14×14 | 34–38 | 11–14 | 61–67 | 300 + Hammer | — | L939 |
| 95 | 941–950 | P2-B | L941 · M094 Berry Mixer Puddle | 13×13–14×14 | 34–38 | 11–14 | 61–67 | 300 + Shield | after L950 | L949 |
| 96 | 951–960 | P2-B | L951 · M095 Rainbow Hedge Gates | 14×14 | 36–40 | 12–14 | 64–70 | 300 + Undo | — | L959 |
| 97 | 961–970 | P2-B | L961 · M096 Shadow Snake | 14×14 | 36–40 | 12–14 | 64–70 | 300 + Hint | — | L969 |
| 98 | 971–980 | P2-B | L971 · M097 Bamboo Domino Poles | 14×14 | 36–40 | 12–14 | 64–70 | 300 + Hammer | after L975 | L979 |
| 99 | 981–990 | P2-B | L981 · M098 Prowling Mongoose | 14×14 | 36–40 | 12–14 | 64–70 | 300 + Shield | — | L989 |
| 100 | 991–1000 | P2-B | L991 · M099 Sun Temple Master Lock · **L1000 Finale** | 14×14 | 36–40 | 12–14 | 64–70 (L1000 ≈ 84) | **Jungle Treasure Chest** (L1000): 1,000 + 2× each booster + Phase 2 badge | after L1000 | L999 |

### 6.1 Block Table Notes
- 20 Golden Slither Rush rounds (L525 … L1000), 49 Gift Baskets (L510 … L990), 1 Treasure Chest (L1000), 50 stickers (L510 … L1000, [04 §2](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#2-jungle-sticker-album)).
- Block 80 (M079 Whirlwind Garden): board **square** હોવું ફરજિયાત (rotation).
- Tier boundary L750 → L751: L750 milestone ≈ 57, L751 intro ≈ 54 (band low) ⇒ jump નાનો.
- Gift / Chest / Rush / sticker માત્ર **first clear** પર.
- M051 (diagonal) પછીના બધા levels માં 0–40% snakes diagonal (generator weight 25%).

## 7. Phase Finale — L1000 "Mongoose Emperor's Sun Temple"
| Field | Value |
|---|---|
| Slot / tag | `finale` / `finale` (50 coins) |
| Grid | 14×14, `layers: 2` (Ground + Canopy; Treetop નહીં — readability) |
| Snakes | 40 (8 caterpillar skins, 10 diagonal Sidewinders) |
| Target D | P2-B high 70 × 1.2 = **84** (±3) |
| Obstacle instances | 13 ≤ 14 = M098 Prowling Mongoose (Emperor) + 12 mechanics (standard: "Moving Guardian + ≥ 10 mixed") |
| Hearts | 3 (normal Second Chance rules) |
| Par | ≈ 46 Moves (40 snakes + 1 Temple lever + 2 coconut pushes + 3 extra) |
| Reward | 50 clear coins (+20 first ★★★) ⇒ **Jungle Treasure Chest** (1,000 coins + 2 Glow Firefly Hint + 2 Coil-Back Undo + 2 Safety Shell Shield + 2 Magic Stone Hammer + "Sun Temple Hero" badge) ⇒ Golden Slither Rush (30 snakes) ⇒ Phase Complete screen (standard §16.20) |

D check: P 40 (24.0) + C 12 (18.0) + O 13 (26.0) + N 4 (12.0: Lantern Gate, Seesaw, Rolling Coconut, Prowling Mongoose) + S 4 (4.0) = **84.0**.

### 7.1 Mechanics Used (13 instances)
| # | Mechanic | Role in finale |
|---|---|---|
| 1 | M098 Prowling Mongoose (Emperor skin, 3×3, HP 8) | Center ring loop (4 positions, clockwise); 8 linked snakes |
| 2 | M053 Rolling Coconut | Push 2× ⇒ cradle પર |
| 3 | M055 Coconut Cradle | Coconut રહે ત્યાં સુધી west gate open |
| 4 | M057 Firefly Lantern Gate (n = 3) | North corridor timing (Moves) |
| 5 | M064 Seesaw Branch Gates | East: કઈ બાજુ પહેલાં ખોલવી choice |
| 6 | M065 Buried Leaf-Key | Canopy snake નીચે; Master Lock key 1 |
| 7 | M072 Rainbow Parade (red → blue → yellow) | Outer ring ordering (12 snakes) |
| 8 | M074 Temple Stone Wall (+ lever) | South-west treasury wall, lever one-shot |
| 9 | M076 Burrow Network (A→B→C) | Ruins ⇒ center ferry |
| 10 | M084 Sunbeam Crystal | North-east, beam west તરફ |
| 11 | M086 Dewdrop Mirror Leaf | Beam ને south વાળે |
| 12 | M085 Sunflower Receiver | Lit ⇒ Master Lock condition |
| 13 | M099 Sun Temple Master Lock | Keys: key-snake p31 + Buried Leaf-Key o6 + built-in sun slot lit by Sunbeam Crystal (standard §17.32) |

### 7.2 Flow (designer intent, 3 acts)
1. **Act 1 — Ruins Gate:** Rainbow Parade order સાથે outer ring ખાલી કરો; Rolling Coconut 2 pushes ⇒ Coconut Cradle ⇒ west gate. Seesaw choice: ખોટી બાજુ ⇒ Coil-Back Undo અથવા બીજી lane થી ફરી flip (solvable without Undo).
2. **Act 2 — Sun Path:** Temple lever ⇒ Stone Wall દૂર; sunbeam ને રોકતો canopy snake exit ⇒ beam Mirror Leaf થી Sunflower Receiver પર ⇒ lit; Buried Leaf-Key ઉપરનો snake exit ⇒ key reveal ⇒ lane collect.
3. **Act 3 — The Emperor:** 8 linked snakes (Burrow Network મારફતે) exit ⇒ HP 8 → 0 ⇒ Emperor bows & leaves; Master Lock (keys + lit sun slot) ખુલે ⇒ છેલ્લા center snakes બહાર.

### 7.3 Presentation
- Map પર L1000 node = golden Sun Temple; L991 clear પછી "The Emperor awaits" banner.
- Start card: "The Mongoose Emperor guards the Sun Temple. Light the sunflower and free his 8 friends!"
- `music_finale_p2.m4a`; Emperor ઉપર 8 HP pips; patrol next-position ghost outline (fairness).
- Win: Emperor crown ઉતારી Pip ને આપે (friendly) ⇒ Treasure Chest ⇒ Rush ⇒ Phase Complete ("Phase 3 coming soon" જો `maxPhase = 2`).

## 8. Level Data & Validation
File: `assets/levels/phase_2.json.gz` (500 levels, schema v3). Example (L511 intro, Sidewinder):
```json
{
  "schema": 3, "level": 511, "phase": 2, "seed": "0x01FF00A1B2C3D4E5",
  "tag": "normal", "slot": "intro", "grid": [10, 10], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "green", "dir": "UR", "body": [[4,5],[3,6],[2,7]], "layer": 0, "mods": {}},
    {"id": "p2", "color": "blue",  "dir": "R",  "body": [[5,4],[4,4],[3,3]], "layer": 0, "mods": {"skin": "caterpillar"}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M051", "cells": [], "params": {"paths": ["p1"]}, "hammerable": false}
  ],
  "goals": {"gems": 0},
  "par_moves": 26, "difficulty": 44.6,
  "solution": ["p2", "p1"]
}
```
(Example truncated to 2 snakes for readability; real L511 has 24.)

CI validator (standard §12 + Phase 2 additions): 0-heart/0-booster solvable · D in slot band ±3 (x9/Finale multipliers) · no forever-locked snake · Phase 2 cell rule `fitCell ≥ 22 dp` ([01 §2.4](./01_PHASE_2_SCOPE_AND_RULES.md#24-cell-size-rule-phase-2)) · x1 = intro mechanic + ≤ 1 earlier type · `body[1] = body[0] − dir` · 8-connected bodies · combo bans ([03 §4](./03_OBSTACLE_CATALOG_PHASE_2.md#4-combo-rules-validator)) · beam/lane loop check · M079 square boards · Finale cap 14.

## 9. Progression Analytics
Events standard §15 + `zoom_used{level, max_scale}`, `fit_tap{level}`, `ambiguous_tap{level}`. Review trigger (Phase 1 જેવું): win rate < 35% (x9: < 25%) ⇒ designer review; fix = pre-validated alternate (`phase_2_alt.json.gz`, Remote Config `levelOverrides`). Zoom analytics: L501–504 પછી `zoom_used` rate ઓછો હોય તો tutorial copy A/B.
