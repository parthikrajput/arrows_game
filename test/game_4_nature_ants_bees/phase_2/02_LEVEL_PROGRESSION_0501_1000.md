# 02 — Level Progression, Levels 501–1000 (લેવલ પ્રોગ્રેશન, ફેઝ 2)
Phase 2 ના 500 levels નું blueprint: P2-A/P2-B tiers, layer/diagonal schedule, L501–510 onboarding (level-by-level), દરેક 10-level block નો full table અને L1000 Finale.

**Related docs:** [Shared Core Standard §9, §10, §12](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Obstacle Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [Phase 1 Progression](../phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Tier Table (ટિયર)

| Tier | Levels | Grid | Lines (paths) | Max obstacle instances | D band |
|---|---|---|---|---|---|
| **P2-A** | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| **P2-B** | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

- Grid ≥ 12×12 ⇒ pinch-zoom + pan, auto-fit start ([01 §4](./01_PHASE_2_SCOPE_AND_RULES.md)).
- Block D bands: P2-A blocks 45 → 60, P2-B blocks 52 → 70 (Phase 1 જેમ tier boundary પર band tier low પર reset, grid/mechanics વધે). P2-A નું lower bound 45 (T5 mid) — Standard "difficulty decreases નહીં".
- Hard (x9) = block high × 1.1; Finale = 70 × 1.2 = **84** (Standard §16.13 allow કરે).

## 2. The 10-Level Block Pattern (Phase 1 જેવું)

| Slot | JSON `slot` | Role | Difficulty | JSON `tag` | Clear coins |
|---|---|---|---|---|---|
| x1 | `intro` | નવું mechanic + ≤ 1 જૂનું; tutorial card | band low | `normal` | 20 |
| x2–x4 | `practice` | નવું + જૂના mix | low → mid | `normal` | 20 |
| x5 | `breather` | સરળ | low | `easy` | 15 |
| x6–x8 | `ramp` | mid → high | mid → high | `normal` | 20 |
| x9 | `hard` | red Hard badge | high × 1.1 | `hard` | 30 |
| x0 | `milestone` | **Queen's Gift Box 300** + sticker | mid | `normal` | 20 |
| L1000 | `finale` | Queen's Midsummer Jubilee | high × 1.2 | `finale` | 50 |

`slot` ↔ `tag` mapping Standard §16.15 મુજબ (breather ⇒ easy; intro/practice/ramp/milestone ⇒ normal; hard ⇒ hard; finale ⇒ finale). L501–510 onboarding block પણ આ જ pattern (x1 = zoom tutorial, mechanic નહીં).

## 3. Layer, Diagonal & Beam Schedule

| Levels | Layers | Bee (air) share | Canopy share | Diagonal share | Notes |
|---|---|---|---|---|---|
| 501–510 | 2 | 30–40% | 0 | 0 | Onboarding: Phase 1 mechanics only, 12×12 |
| 511–520 | 2 | 30–40% | 0 | intro 4–6 lines → 10–20% | **M051 Diagonal Dash Lines** |
| 521–690 | 2 (≥ 85% levels) | 30–45% | 0 | 10–30% | Push family L531–551, ramps L561 (`[0,1]` only) |
| 691–700 | **3** | 30–40% | **intro: 3 lines** | 10–20% | **M069 Canopy Scout Bees** |
| 701–1000 | 3 (≥ 60% levels) | 30–45% | 10–20% | 10–30% | Warm Updraft `[1,2]` ramps; beams L841+ (air/canopy beams need tall devices) |

- x5 breather: bees ≤ 30%, canopy ≤ 10%, diagonal ≤ 15%.
- દરેક x1 intro **hand-tuned**; x9 Hard, L1000 Finale પણ hand-tuned (Standard §12). બાકી `tools/levelgen` + designer pass ⇒ `assets/levels/phase_2.json.gz`.

## 4. Onboarding — Levels 501–510 (level-by-level)

Goal: મોટા boards (12×12) અને **pinch-zoom/pan** શીખવવું; **કોઈ નવું mechanic નહીં** (Standard §10). Phase 1 ના mechanics જ — ખેલાડી ને ઓળખીતાં, પણ મોટા board પર. Coins/ads rules સામાન્ય (interstitial counter ચાલુ).

| L | Grid | Lines (ants/bees) | D | Slot / tag | Mechanics (Phase 1) | Teaches / tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|
| 501 | 12×12 | 24 (16/8) | 45 | intro / normal | M001, M002 (few) | "Welcome to the Big Garden" card → **pinch tutorial**: hand pinch-out on a cluster, then tap a line while zoomed (`p2_zoom_pinch`) |
| 502 | 12×12 | 24 (15/9) | 45 | practice / normal | M005, M014 | **Pan tutorial**: blocker on far corner; hand drag (`p2_zoom_pan`). Off-screen lane edge-arrow tooltip |
| 503 | 12×12 | 25 (15/10) | 46 | practice / normal | M010, M013 | **Fit button** tooltip (`p2_zoom_fit`; double-tap zoom નથી, Standard §17.23); long-press preview while zoomed |
| 504 | 12×12 | 25 (15/10) | 46 | practice / normal | M019, M020 | Long chains across board halves; "Scent Trail Preview works at any zoom" |
| 505 | 12×12 | 24 (17/7) | 45 | breather / easy | M001 only | Breather; no tutorial |
| 506 | 12×12 | 25 (15/10) | 46 | ramp / normal | M028, M037 | Two-zone planning (ants left, bees right) |
| 507 | 12×12 | 26 (16/10) | 46 | ramp / normal | M033, M041 | Color planning on big board |
| 508 | 12×12 | 26 (15/11) | 47 | ramp / normal | M004, M043 | Keys far from locks (pan needed) |
| 509 | 12×12 | 26 (15/11) | 52 | hard / hard | M049 + M009 + M026 | First Phase 2 Hard; Great Orb Spider on 12×12 |
| 510 | 12×12 | 25 (15/10) | 46 | milestone / normal | M013, M038 | **Queen's Gift Box 300 + Queen's Royal Shield** (`(510/10) mod 4 = 3`); **Flora & Fauna Compendium Vol 4 sticker #1** |

- L501 પહેલાં one-time "Garden Trails II" intro screen: new features (zoom, diagonals, canopy, Album, Star Race) — skip allowed.
- Zoom tutorial analytics: `ftue_step{step: "p2_zoom_pinch" | "p2_zoom_pan" | "p2_zoom_fit"}`.
- Reduce Motion ON ⇒ tutorial hand ની જગ્યાએ static arrows.

## 5. Full Block Table, L501–1000 (દરેક 10-level block)

Columns: **New mechanic** = x1 intro (ID + themed name). **Grid / Lines / D band** = block x1→x8 target range (slot band ±3). **Hard** = x9 + target D (block high × 1.1). **Gift Box** = x0 reward (300 coins + booster `(L/10) mod 4`: 1 = Nectar Glow Hint, 2 = Leaf Blower, 3 = Queen's Royal Shield, 0 = Dewdrop Rewind). **Rush** = Golden Nectar Rush (30 lines). **Layers** = ant/bee/canopy mix.

| # | Levels | New mechanic (x1) | Grid | Lines | D band | Hard (x9) | Gift Box (x0) | Coin Rush | Layers |
|---|---|---|---|---|---|---|---|---|---|
| 51 | 501–510 | — (Onboarding: pinch-zoom/pan, 12×12, Phase 1 mechanics only) | 12×12 | 24–26 | 45–47 | L509 (D 52) | 300 + Queen's Royal Shield | — | 30–40% bees |
| 52 | 511–520 | **M051** Diagonal Dash Lines | 10×10–11×11 | 24–25 | 45–46 | L519 (D 51) | 300 + Dewdrop Rewind | — | 30–45% bees |
| 53 | 521–530 | **M052** Pinecone Bumper | 10×10–11×11 | 24–25 | 46 | L529 (D 51) | 300 + Nectar Glow Hint | after L525 | 30–45% bees |
| 54 | 531–540 | **M053** Rolling Acorn | 10×10–11×11 | 24–26 | 46–47 | L539 (D 52) | 300 + Leaf Blower | — | 30–45% bees |
| 55 | 541–550 | **M054** Dew-Slick Lily Leaf | 10×10–11×11 | 25–26 | 47–48 | L549 (D 53) | 300 + Queen's Royal Shield | after L550 | 30–45% bees |
| 56 | 551–560 | **M055** Seed Socket Plate | 10×10–11×11 | 25–27 | 48 | L559 (D 53) | 300 + Dewdrop Rewind | — | 30–45% bees |
| 57 | 561–570 | **M056** Dandelion Lift | 10×10–11×11 | 26–27 | 48–49 | L569 (D 54) | 300 + Nectar Glow Hint | — | 30–45% bees |
| 58 | 571–580 | **M057** Sleepy Tulip Gate | 10×10–11×11 | 26–27 | 49 | L579 (D 54) | 300 + Leaf Blower | after L575 | 30–45% bees |
| 59 | 581–590 | **M058** Spinning Seed Arrow | 10×10–11×11 | 26–28 | 49–50 | L589 (D 55) | 300 + Queen's Royal Shield | — | 30–45% bees |
| 60 | 591–600 | **M059** Pollen Paint Patch | 11×11–12×12 | 27–28 | 50–51 | L599 (D 56) | 300 + Dewdrop Rewind | after L600 | 30–45% bees |
| 61 | 601–610 | **M060** Twin Mushroom Swap | 11×11–12×12 | 27–29 | 51 | L609 (D 56) | 300 + Nectar Glow Hint | — | 30–45% bees |
| 62 | 611–620 | **M061** Little Anthill & Mini Hive | 11×11–12×12 | 28–29 | 51–52 | L619 (D 57) | 300 + Leaf Blower | — | 30–45% bees |
| 63 | 621–630 | **M062** Flower Bed Delivery | 11×11–12×12 | 28–29 | 52 | L629 (D 57) | 300 + Queen's Royal Shield | after L625 | 30–45% bees |
| 64 | 631–640 | **M063** Sugar Cube Lure | 11×11–12×12 | 29–30 | 52–53 | L639 (D 58) | 300 + Dewdrop Rewind | — | 30–45% bees |
| 65 | 641–650 | **M064** Seesaw Twig Gates | 11×11–12×12 | 29–30 | 53–54 | L649 (D 59) | 300 + Nectar Glow Hint | after L650 | 30–45% bees |
| 66 | 651–660 | **M065** Buried Dew Key | 11×11–12×12 | 29–31 | 54 | L659 (D 59) | 300 + Leaf Blower | — | 30–45% bees |
| 67 | 661–670 | **M066** Petal-Linked Trio | 11×11–12×12 | 30–31 | 54–55 | L669 (D 61) | 300 + Queen's Royal Shield | — | 30–45% bees |
| 68 | 671–680 | **M067** Crumbling Soil Patch | 12×12–13×13 | 30–32 | 55–56 | L679 (D 62) | 300 + Dewdrop Rewind | after L675 | 30–45% bees |
| 69 | 681–690 | **M068** Honey-Drip Line | 12×12–13×13 | 31–32 | 56 | L689 (D 62) | 300 + Nectar Glow Hint | — | 30–45% bees |
| 70 | 691–700 | **M069** Canopy Scout Bees | 12×12–13×13 | 31–32 | 56–57 | L699 (D 63) | 300 + Leaf Blower | after L700 | **canopy intro** (3 canopy lines) |
| 71 | 701–710 | **M070** Compass Flower Lever | 12×12–13×13 | 31–33 | 57–58 | L709 (D 64) | 300 + Queen's Royal Shield | — | 30–45% bees, 10–20% canopy |
| 72 | 711–720 | **M071** Counting Hedge Gap | 12×12–13×13 | 32–33 | 58 | L719 (D 64) | 300 + Dewdrop Rewind | — | 30–45% bees, 10–20% canopy |
| 73 | 721–730 | **M072** Garland Order | 12×12–13×13 | 32–34 | 58–59 | L729 (D 65) | 300 + Nectar Glow Hint | after L725 | 30–45% bees, 10–20% canopy |
| 74 | 731–740 | **M073** Dew Bubble Line | 12×12–13×13 | 33–34 | 59 | L739 (D 65) | 300 + Leaf Blower | — | 30–45% bees, 10–20% canopy |
| 75 | 741–750 | **M074** Old Stone Wall | 12×12–13×13 | 33–34 | 59–60 | L749 (D 66) | 300 + Queen's Royal Shield | after L750 | 30–45% bees, 10–20% canopy |
| 76 | 751–760 | **M075** Creeping Mist | 12×12–13×13 | 28–29 | 52–53 | L759 (D 58) | 300 + Dewdrop Rewind | — | 30–45% bees, 10–20% canopy |
| 77 | 761–770 | **M076** Burrow Network | 12×12–13×13 | 28–29 | 53 | L769 (D 58) | 300 + Nectar Glow Hint | — | 30–45% bees, 10–20% canopy |
| 78 | 771–780 | **M077** Puffball Mushroom | 12×12–13×13 | 28–30 | 53–54 | L779 (D 59) | 300 + Leaf Blower | after L775 | 30–45% bees, 10–20% canopy |
| 79 | 781–790 | **M078** Greenhouse Garden | 12×12–13×13 | 29–30 | 54–55 | L789 (D 61) | 300 + Queen's Royal Shield | — | 30–45% bees, 10–20% canopy |
| 80 | 791–800 | **M079** Turning Flower Bed | 12×12–13×13 | 29–31 | 55–56 | L799 (D 62) | 300 + Dewdrop Rewind | after L800 | 30–45% bees, 10–20% canopy |
| 81 | 801–810 | **M080** Twin Thorn Locks | 12×12–13×13 | 30–31 | 56 | L809 (D 62) | 300 + Nectar Glow Hint | — | 30–45% bees, 10–20% canopy |
| 82 | 811–820 | **M081** Copycat Line | 12×12–13×13 | 30–32 | 56–57 | L819 (D 63) | 300 + Leaf Blower | — | 30–45% bees, 10–20% canopy |
| 83 | 821–830 | **M082** Trickling Brook | 12×12–13×13 | 31–32 | 57–58 | L829 (D 64) | 300 + Queen's Royal Shield | after L825 | 30–45% bees, 10–20% canopy |
| 84 | 831–840 | **M083** Stone Slab Plate | 12×12–13×13 | 31–33 | 58 | L839 (D 64) | 300 + Dewdrop Rewind | — | 30–45% bees, 10–20% canopy |
| 85 | 841–850 | **M084** Sunbeam Lens | 12×12–13×13 | 32–33 | 58–59 | L849 (D 65) | 300 + Nectar Glow Hint | after L850 | 30–45% bees, 10–20% canopy |
| 86 | 851–860 | **M085** Sun-Seeker Sunflower | 12×12–13×13 | 32–34 | 59–60 | L859 (D 66) | 300 + Leaf Blower | — | 30–45% bees, 10–20% canopy |
| 87 | 861–870 | **M086** Beetle-Shell Mirror | 12×12–13×13 | 33–34 | 60–61 | L869 (D 67) | 300 + Queen's Royal Shield | — | 30–45% bees, 10–20% canopy |
| 88 | 871–880 | **M087** Tree Sap Drop | 12×12–14×14 | 33–35 | 61 | L879 (D 67) | 300 + Dewdrop Rewind | after L875 | 30–45% bees, 10–20% canopy |
| 89 | 881–890 | **M088** Bramble Snare | 13×13–14×14 | 34–35 | 61–62 | L889 (D 68) | 300 + Nectar Glow Hint | — | 30–45% bees, 10–20% canopy |
| 90 | 891–900 | **M089** Dew Prism | 13×13–14×14 | 34–36 | 62–63 | L899 (D 69) | 300 + Leaf Blower | after L900 | 30–45% bees, 10–20% canopy |
| 91 | 901–910 | **M090** Firefly Lantern Gate | 13×13–14×14 | 35–36 | 63–64 | L909 (D 70) | 300 + Queen's Royal Shield | — | 30–45% bees, 10–20% canopy |
| 92 | 911–920 | **M091** Giant Lily-Pad Rotor | 13×13–14×14 | 35–37 | 64 | L919 (D 70) | 300 + Dewdrop Rewind | — | 30–45% bees, 10–20% canopy |
| 93 | 921–930 | **M092** Caravan Line | 13×13–14×14 | 36–37 | 64–65 | L929 (D 72) | 300 + Nectar Glow Hint | after L925 | 30–45% bees, 10–20% canopy |
| 94 | 931–940 | **M093** Scatter Line | 13×13–14×14 | 36–38 | 65–66 | L939 (D 73) | 300 + Leaf Blower | — | 30–45% bees, 10–20% canopy |
| 95 | 941–950 | **M094** Petal Mixing Bowl | 13×13–14×14 | 37–38 | 66 | L949 (D 73) | 300 + Queen's Royal Shield | after L950 | 30–45% bees, 10–20% canopy |
| 96 | 951–960 | **M095** Colored Hedge Gap | 13×13–14×14 | 37–39 | 66–67 | L959 (D 74) | 300 + Dewdrop Rewind | — | 30–45% bees, 10–20% canopy |
| 97 | 961–970 | **M096** Dusk Shadow Line | 13×13–14×14 | 38–39 | 67–68 | L969 (D 75) | 300 + Nectar Glow Hint | — | 30–45% bees, 10–20% canopy |
| 98 | 971–980 | **M097** Toppling Toadstools | 13×13–14×14 | 38–40 | 68–69 | L979 (D 76) | 300 + Leaf Blower | after L975 | 30–45% bees, 10–20% canopy |
| 99 | 981–990 | **M098** Great Stag Beetle | 13×13–14×14 | 39–40 | 69 | L989 (D 76) | 300 + Queen's Royal Shield | — | 30–45% bees, 10–20% canopy |
| 100 | 991–1000 | **M099** Royal Hive Door | 13×13–14×14 | 39–40 | 69–70 | L999 (D 77) | **Royal Honey Chest** (1,000 + 2 each booster + badge) | after L1000 | 30–45% bees, 10–20% canopy |

Notes:
- દરેક x0 (L510 … L990) પર **Gift Box 300** + booster + **1 sticker** ([04 §2](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)); L1000 પર Gift Box ની જગ્યાએ **Royal Honey Chest** (+ sticker).
- Coin Rush = દર 25 levels (525, 550, …, 1000), first clear only; x0 levels (550, 600, …) પર પહેલાં Gift Box/Chest, પછી Rush.
- Tier boundary L751: lines/D band P2-B low પર, grid 12×12+ — overall difficulty grid + 3 layers + mechanics count થી વધે.
- Max obstacle instances per level: P2-A 6–12, P2-B 8–14 (intro levels: intro mechanic + ≤ 1 earlier mechanic).

## 6. Post-Level Reward Order (Phase 2)

Win પછી screens નો ક્રમ (એક જ win પર):

1. **Level Complete** (stars, coins, 2X Win rewarded option) + chips: Golden Honeycomb Bank +10 (first clear, L31+), Weekly Star Race progress (race active હોય તો).
2. **Queen's Gift Box** (x0) + **sticker reveal** (Flora & Fauna Compendium). L1000 પર **Royal Honey Chest**.
3. **Golden Nectar Rush** (25 નો ગુણાંક).
4. **Phase Complete** (L1000 only; Standard §16.20: Chest → Rush → Phase Complete).
5. Next level / Level Map.

- Reward screen હોય ⇒ interstitial defer; Rush પછી ક્યારેય નહીં (Phase 1 rules).
- Replay wins: Gift Box, sticker, Rush, Bank deposit **ફરી નહીં** (first clear only).

## 7. L1000 Phase 2 Finale — "Queen's Midsummer Jubilee"

| Item | Spec |
|---|---|
| Grid | 14×14 (zoom on) |
| Lines | 38–40 — ground ≥ 40%, air ≥ 30%, canopy ≥ 10%; ≥ 6 diagonal |
| D | **84** (P2-B high 70 × 1.2) — validator band 81–87 |
| Boss | **Great Stag Beetle (M098)** 2×2, patrol loop around centre (4 positions), HP = 4 linked lines (2 ants, 1 bee, 1 canopy) |
| Mechanics mix (≥ 10) | M053 Rolling Acorn + M055 Seed Socket Plate, M056 Dandelion Lift, M064 Seesaw Twig Gates, M070 Compass Flower Lever, M075 Creeping Mist, M084 Sunbeam Lens + M086 Beetle-Shell Mirror + M085 Sun-Seeker Sunflower, M092 Caravan Line, **M099 Royal Hive Door** (designer ≥ 10 પસંદ કરે; આ reference set છે) |
| Flow | (1) Mist ફેલાય તે પહેલાં ground ants ખાલી કરી Acorn ને socket પર ધકેલો ⇒ tall gate open · (2) Compass Flower થી bees ને સાચી દિશામાં ફેરવો; Dandelion Lift થી ant ને air માં · (3) line ખસેડી sunbeam ને Mirror થી Sunflower સુધી પહોંચાડો + keys ⇒ Royal Hive Door open · (4) Beetle ની linked lines exit ⇒ beetle ચાલ્યો જાય · (5) canopy scouts ઉજવણી fly-off |
| Visual / audio | Midsummer festival: lantern flowers, ribbon garlands, Queen Bee cameo on the Royal Hive Door; finale music sting |
| Reward | Clear coins **50** + **Royal Honey Chest**: 1,000 coins + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + "Garden Trails II" badge; Vol 5 sticker #25; પછી Golden Nectar Rush (30 lines); પછી **Phase Complete** |
| After | Phase Complete screen: "Garden Trails II complete"; Phase 3 locked until app update + Remote Config `maxPhase ≥ 3` ([Scaling](../SCALING_TO_10000_LEVELS.md)) |

Validator: 0 hearts / 0 boosters solvable, node limit 2M, depth ≤ 3×P, ≥ 10 distinct Phase 2 mechanic IDs + M098.

## 8. Level Pipeline (ટૂંકમાં)

- `tools/levelgen` (Dart CLI, `puzzle_core`) ⇒ `assets/levels/phase_2.json.gz`, schema v3 + `slot`, `layer: 0|1|2`, `tall`.
- Reverse construction **per layer** (3 layers), diagonal lanes સહિત; stateful mechanics (C, T, K, X + push/beam) ⇒ solver mandatory.
- CI validator: Phase 1 checks + Phase 2 additions ([03 §4](./03_OBSTACLE_CATALOG_PHASE_2.md)).
- Release gate: Phase 2 bundle app update માં ship; Remote Config `maxPhase = 2` ⇒ L501 unlock ([README](./README.md)).
