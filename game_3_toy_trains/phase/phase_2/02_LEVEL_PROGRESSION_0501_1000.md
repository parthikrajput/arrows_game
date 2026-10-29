# 02 · Level Progression 0501–1000 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 ના 500 levels નું structure — P2-A/P2-B tiers, 10-level block pattern, L501–510 onboarding (level-by-level), દરેક 50 blocks નું full table, Depot Sticker Album milestones અને L1000 Grand Terminus Finale.

**Related docs:** [Shared Core Standard §9, §10, §16](../../SHARED_CORE_STANDARD.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [Phase 1 Progression](../phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [Scaling to 10,000](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Principles (સિદ્ધાંતો)

- **દર 10 levels એ નવું:** L501–510 onboarding (કોઈ નવું mechanic નહીં), પછી દરેક block ના **x1** પર નવું mechanic: L511 (M051) … L991 (M099). કુલ 49 mechanics + L1000 Finale.
- Block pattern Phase 1 જેવો જ (x1 intro · x2–x4 practice · x5 breather · x6–x8 ramp · x9 Hard · x0 milestone).
- દરેક level 0 hearts + 0 boosters થી solvable (CI solver). Hand-tuned: **L501–510, દરેક x1 intro, દરેક x9 Hard, L1000**; બાકી `tools/levelgen` + designer review.
- Intro (x1) levels = intro mechanic + ≤ 1 જૂનું mechanic (validator). Composite mechanics (M054, M055, M085, M086, M089, M099 …) તેમનો જરૂરી partner (Push Cart / Signal Lamp) એ "1 earlier" slot માં વાપરે — [03 §1](./03_OBSTACLE_CATALOG_PHASE_2.md).
- Levels shipped as `assets/levels/phase_2.json.gz` (schema v3). JSON માં `slot` (block role) અને `tag` (coins) બંને — standard §16.15.

## 2. Tiers, Slots & Tags

| Tier | Levels | Grid | Trains | Max obstacle instances | D band | low / mid / high | x9 Hard target |
|---|---|---|---|---|---|---|---|
| P2-A | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 44–60 | 44–49.3 / 49.3–54.7 / 54.7–60 | 66 ±3 |
| P2-B | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 | 52–58 / 58–64 / 64–70 | 77 ±3 |

L1000 Finale target = 70 × 1.2 = **84 ±3**.

| Slot | `slot` | `tag` | Coins (first clear) | Difficulty |
|---|---|---|---|---|
| x1 | `intro` | `normal` | 20 | low |
| x2–x4 | `practice` | `normal` | 20 | low → mid |
| x5 | `breather` | `easy` | 15 | low |
| x6–x8 | `ramp` | `normal` | 20 | mid → high |
| x9 | `hard` | `hard` | 30 (red "Hard" badge) | high × 1.1 |
| x0 | `milestone` | `normal` | 20 + **Conductor's Gift Crate 300** + 1 booster + 1 album sticker | mid |
| L1000 | `finale` | `finale` | 50 + **Grand Central Chest** | high × 1.2 |

Zoom/pan: grid ≥ 12×12 ⇒ on ([01 §2](./01_PHASE_2_SCOPE_AND_RULES.md)). P2-A ના 10×10–11×11 levels zoom વગર (cell ≥ 29 dp).

## 3. Onboarding L501–510 (level-by-level)

બધા **12×12**, **કોઈ નવું mechanic નહીં** — Phase 1 mechanics નો mix. હેતુ: મોટા board, zoom/pan, Hint auto-pan શીખવવું. D values = formula ના worked examples (CI final values ±3).

| L | Slot / tag | Trains | Obstacles (instances) | C | N | S | D | Tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|---|---|
| 501 | intro / normal | 24 | M001 Buffer Stop ×6 (only 1 mechanic type) | 11 | 0 | 0 | 14.4 + 16.5 + 12 = **42.9** | `p2_zoom_pinch`: Welcome card "Bigger yards ahead!" ⇒ hand pinches ⇒ "Pinch to zoom in. The board always starts fitted." |
| 502 | practice / normal | 25 | M002 ×3, M004 ×2, M008 ×2 | 11 | 0 | 0 | 15 + 16.5 + 14 = **45.5** | `p2_pan_drag`: "Drag with one finger to look around." (this step starts at 1.5× zoom) |
| 503 | practice / normal | 26 | M002 ×3, M005 ×3, M009 ×1 | 10 | 1 | 1 | 15.6 + 15 + 14 + 3 + 1 = **48.6** | `p2_peek_zoom`: Route Peek at zoom ⇒ "Track continues →" edge chip |
| 504 | practice / normal | 26 | M001 ×3, M006 ×3, M013 ×1, M018 ×1 | 10 | 2 | 2 | 15.6 + 15 + 16 + 6 + 2 = **54.6** | `p2_hint_autopan`: Green Signal Hint (Hint) target off-screen ⇒ camera glides to it |
| 505 | breather / easy | 24 | M001 ×4, M002 ×2 | 10 | 0 | 0 | 14.4 + 15 + 12 = **41.4** | `p2_fit_button`: "Tap ⤢ Fit to see the whole table." |
| 506 | ramp / normal | 28 | M004 ×2, M007 ×2, M019 ×1, M029 ×3 | 11 | 1 | 0 | 16.8 + 16.5 + 16 + 3 = **52.3** | none |
| 507 | ramp / normal | 29 | M008 ×2, M009 ×1, M013 ×1, M014 ×3, M026 ×2 | 11 | 2 | 2 | 17.4 + 16.5 + 18 + 6 + 2 = **59.9** | none |
| 508 | ramp / normal | 30 | M010 ×2, M016 ×3, M018 ×1, M032 ×1, M033 ×2 | 11 | 2 | 2 | 18 + 16.5 + 18 + 6 + 2 = **60.5** | none |
| 509 | hard / hard | 32 | M004 ×2, M009 ×1, M013 ×1, M018 ×1, M028 ×1, M042 ×2, M049 ×1, M014 ×1 | 11 | 3 | 3 | 19.2 + 16.5 + 20 + 9 + 3 = **67.7** (target 66 ±3) | none (red Hard badge) |
| 510 | milestone / normal | 27 | M001 ×4, M008 ×2, M009 ×1, M026 ×1 | 10 | 1 | 1 | 16.2 + 15 + 16 + 3 + 1 = **51.2** | `p2_album_vol4`: first Vol 4 sticker + Gift Crate (300 + 1 Cowcatcher Shield) |

- L501 x1 slot છે પણ નવું mechanic નથી ⇒ validator intro rule "≤ 1 earlier mechanic type" (M001 only) ✓.
- L505 (41.4) low band 44 ના −3 tolerance (≥ 41) ની અંદર ✓.
- L500 પછીનું Phase Complete screen "Next line: Grand Terminus" બતાવે અને L501 node map પર unlock કરે ([Phase 1 06 §5.18](../phase_1/06_UI_UX_SCREENS.md)).

## 4. Feature & Reward Timeline (Phase 2)

| Level | Event |
|---|---|
| L501–505 | Zoom/pan tutorial steps (§3) |
| L510 | First Phase 2 Gift Crate (300 + Cowcatcher Shield) + Vol 4 sticker #1 |
| L511 | First diagonal train (M051 Diagonal Express) |
| L525 | First Phase 2 Golden Express Coin Rush (30 trains) |
| L531 / L541 / L551 | Push Cart → Frosty Rails → Cart Weighbridge |
| L691 | Triple-Deck Viaduct (3 layers) |
| L750 | Vol 4 complete (all 25 Vol 4 milestones cleared) |
| L751 | Tier P2-B begins (12×12–14×14) |
| L841 / L851 / L861 / L891 | Signal Lamp → Light Sensor Box → Signal Mirror → Crystal Prism |
| L1000 | Grand Terminus Finale ⇒ Grand Central Chest → Coin Rush → Phase Complete (Vol 5 sticker #25 + Vol 5 reward shown on Phase Complete) |

## 5. Full Block Table (50 blocks)

`x0 reward` = Conductor's Gift Crate **300 coins** + booster by `(L/10) mod 3` (1 = Green Signal Hint, 2 = Track Crane, 0 = Cowcatcher Shield). Coin Rush = **after** that level's first clear (25 ના દરેક multiple, 30 trains). Hard = x9 (30 coins). Sticker = Depot Sticker Album slot granted at x0.

| # | Levels | Tier | New mechanic at x1 | Grid | Trains | D band | x0 reward | Coin Rush | Hard (x9) | Sticker (x0) |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 501–510 | P2-A | — (Onboarding: zoom/pan, no new mechanic) | 12×12 | 24–34 | 44–60 | L510: 300 + 1 Cowcatcher Shield | — | L509 | Vol 4 #1 |
| 2 | 511–520 | P2-A | **M051** Diagonal Express (L511) | 10×10–13×13 | 24–34 | 44–60 | L520: 300 + 1 Green Signal Hint | — | L519 | Vol 4 #2 |
| 3 | 521–530 | P2-A | **M052** Corner Buffer (L521) | 10×10–13×13 | 24–34 | 44–60 | L530: 300 + 1 Track Crane | after L525 | L529 | Vol 4 #3 |
| 4 | 531–540 | P2-A | **M053** Push Cart (L531) | 10×10–13×13 | 24–34 | 44–60 | L540: 300 + 1 Cowcatcher Shield | — | L539 | Vol 4 #4 |
| 5 | 541–550 | P2-A | **M054** Frosty Rails (L541) | 10×10–13×13 | 24–34 | 44–60 | L550: 300 + 1 Green Signal Hint | after L550 | L549 | Vol 4 #5 |
| 6 | 551–560 | P2-A | **M055** Cart Weighbridge (L551) | 10×10–13×13 | 24–34 | 44–60 | L560: 300 + 1 Track Crane | — | L559 | Vol 4 #6 |
| 7 | 561–570 | P2-A | **M056** Viaduct Ramp (L561) | 10×10–13×13 | 24–34 | 44–60 | L570: 300 + 1 Cowcatcher Shield | — | L569 | Vol 4 #7 |
| 8 | 571–580 | P2-A | **M057** Alternating Signal (L571) | 10×10–13×13 | 24–34 | 44–60 | L580: 300 + 1 Green Signal Hint | after L575 | L579 | Vol 4 #8 |
| 9 | 581–590 | P2-A | **M058** Spinning Arrow Rail (L581) | 10×10–13×13 | 24–34 | 44–60 | L590: 300 + 1 Track Crane | — | L589 | Vol 4 #9 |
| 10 | 591–600 | P2-A | **M059** Paint Shed (L591) | 10×10–13×13 | 24–34 | 44–60 | L600: 300 + 1 Cowcatcher Shield | after L600 | L599 | Vol 4 #10 |
| 11 | 601–610 | P2-A | **M060** Swap Platform (L601) | 10×10–13×13 | 24–34 | 44–60 | L610: 300 + 1 Green Signal Hint | — | L609 | Vol 4 #11 |
| 12 | 611–620 | P2-A | **M061** Small Engine Shed (L611) | 10×10–13×13 | 24–34 | 44–60 | L620: 300 + 1 Track Crane | — | L619 | Vol 4 #12 |
| 13 | 621–630 | P2-A | **M062** Delivery Platform Quota (L621) | 10×10–13×13 | 24–34 | 44–60 | L630: 300 + 1 Cowcatcher Shield | after L625 | L629 | Vol 4 #13 |
| 14 | 631–640 | P2-A | **M063** Magnet Post (L631) | 10×10–13×13 | 24–34 | 44–60 | L640: 300 + 1 Green Signal Hint | — | L639 | Vol 4 #14 |
| 15 | 641–650 | P2-A | **M064** Seesaw Barriers (L641) | 10×10–13×13 | 24–34 | 44–60 | L650: 300 + 1 Track Crane | after L650 | L649 | Vol 4 #15 |
| 16 | 651–660 | P2-A | **M065** Hidden Ticket (L651) | 10×10–13×13 | 24–34 | 44–60 | L660: 300 + 1 Cowcatcher Shield | — | L659 | Vol 4 #16 |
| 17 | 661–670 | P2-A | **M066** Triple-Coupled Engines (L661) | 10×10–13×13 | 24–34 | 44–60 | L670: 300 + 1 Green Signal Hint | — | L669 | Vol 4 #17 |
| 18 | 671–680 | P2-A | **M067** Worn Sleepers (L671) | 10×10–13×13 | 24–34 | 44–60 | L680: 300 + 1 Track Crane | after L675 | L679 | Vol 4 #18 |
| 19 | 681–690 | P2-A | **M068** Smoke Trail Train (L681) | 10×10–13×13 | 24–34 | 44–60 | L690: 300 + 1 Cowcatcher Shield | — | L689 | Vol 4 #19 |
| 20 | 691–700 | P2-A | **M069** Triple-Deck Viaduct (L691) | 10×10–13×13 | 24–34 | 44–60 | L700: 300 + 1 Green Signal Hint | after L700 | L699 | Vol 4 #20 |
| 21 | 701–710 | P2-A | **M070** Roundhouse Lever (L701) | 10×10–13×13 | 24–34 | 44–60 | L710: 300 + 1 Track Crane | — | L709 | Vol 4 #21 |
| 22 | 711–720 | P2-A | **M071** Departure Quota Gate (L711) | 10×10–13×13 | 24–34 | 44–60 | L720: 300 + 1 Cowcatcher Shield | — | L719 | Vol 4 #22 |
| 23 | 721–730 | P2-A | **M072** Colour Timetable (L721) | 10×10–13×13 | 24–34 | 44–60 | L730: 300 + 1 Green Signal Hint | after L725 | L729 | Vol 4 #23 |
| 24 | 731–740 | P2-A | **M073** Cushion Train (L731) | 10×10–13×13 | 24–34 | 44–60 | L740: 300 + 1 Track Crane | — | L739 | Vol 4 #24 |
| 25 | 741–750 | P2-A | **M074** Iron Girder Wall (L741) | 10×10–13×13 | 24–34 | 44–60 | L750: 300 + 1 Cowcatcher Shield | after L750 | L749 | Vol 4 #25 |
| 26 | 751–760 | P2-B | **M075** Creeping Steam (L751) | 12×12–14×14 | 28–40 | 52–70 | L760: 300 + 1 Green Signal Hint | — | L759 | Vol 5 #1 |
| 27 | 761–770 | P2-B | **M076** Tunnel Network (L761) | 12×12–14×14 | 28–40 | 52–70 | L770: 300 + 1 Track Crane | — | L769 | Vol 5 #2 |
| 28 | 771–780 | P2-B | **M077** Popper Crate (L771) | 12×12–14×14 | 28–40 | 52–70 | L780: 300 + 1 Cowcatcher Shield | after L775 | L779 | Vol 5 #3 |
| 29 | 781–790 | P2-B | **M078** Island Station (L781) | 12×12–14×14 | 28–40 | 52–70 | L790: 300 + 1 Green Signal Hint | — | L789 | Vol 5 #4 |
| 30 | 791–800 | P2-B | **M079** Spinning Playmat (L791) | 12×12–14×14 | 28–40 | 52–70 | L800: 300 + 1 Track Crane | after L800 | L799 | Vol 5 #5 |
| 31 | 801–810 | P2-B | **M080** Twin Ticket Barriers (L801) | 12×12–14×14 | 28–40 | 52–70 | L810: 300 + 1 Cowcatcher Shield | — | L809 | Vol 5 #6 |
| 32 | 811–820 | P2-B | **M081** Copycat Engine (L811) | 12×12–14×14 | 28–40 | 52–70 | L820: 300 + 1 Green Signal Hint | — | L819 | Vol 5 #7 |
| 33 | 821–830 | P2-B | **M082** Conveyor Track (L821) | 12×12–14×14 | 28–40 | 52–70 | L830: 300 + 1 Track Crane | after L825 | L829 | Vol 5 #8 |
| 34 | 831–840 | P2-B | **M083** Heavy Weighbridge (L831) | 12×12–14×14 | 28–40 | 52–70 | L840: 300 + 1 Cowcatcher Shield | — | L839 | Vol 5 #9 |
| 35 | 841–850 | P2-B | **M084** Signal Lamp (L841) | 12×12–14×14 | 28–40 | 52–70 | L850: 300 + 1 Green Signal Hint | after L850 | L849 | Vol 5 #10 |
| 36 | 851–860 | P2-B | **M085** Light Sensor Box (L851) | 12×12–14×14 | 28–40 | 52–70 | L860: 300 + 1 Track Crane | — | L859 | Vol 5 #11 |
| 37 | 861–870 | P2-B | **M086** Signal Mirror (L861) | 12×12–14×14 | 28–40 | 52–70 | L870: 300 + 1 Cowcatcher Shield | — | L869 | Vol 5 #12 |
| 38 | 871–880 | P2-B | **M087** Jam Spill (L871) | 12×12–14×14 | 28–40 | 52–70 | L880: 300 + 1 Green Signal Hint | after L875 | L879 | Vol 5 #13 |
| 39 | 881–890 | P2-B | **M088** Track Clamp (L881) | 12×12–14×14 | 28–40 | 52–70 | L890: 300 + 1 Track Crane | — | L889 | Vol 5 #14 |
| 40 | 891–900 | P2-B | **M089** Crystal Prism (L891) | 12×12–14×14 | 28–40 | 52–70 | L900: 300 + 1 Cowcatcher Shield | after L900 | L899 | Vol 5 #15 |
| 41 | 901–910 | P2-B | **M090** Tick-Tock Gate (L901) | 12×12–14×14 | 28–40 | 52–70 | L910: 300 + 1 Green Signal Hint | — | L909 | Vol 5 #16 |
| 42 | 911–920 | P2-B | **M091** Rotating Yard 3×3 (L911) | 12×12–14×14 | 28–40 | 52–70 | L920: 300 + 1 Track Crane | — | L919 | Vol 5 #17 |
| 43 | 921–930 | P2-B | **M092** Uncoupling Train (L921) | 12×12–14×14 | 28–40 | 52–70 | L930: 300 + 1 Cowcatcher Shield | after L925 | L929 | Vol 5 #18 |
| 44 | 931–940 | P2-B | **M093** Splitting Train (L931) | 12×12–14×14 | 28–40 | 52–70 | L940: 300 + 1 Green Signal Hint | — | L939 | Vol 5 #19 |
| 45 | 941–950 | P2-B | **M094** Paint Mixer Shed (L941) | 12×12–14×14 | 28–40 | 52–70 | L950: 300 + 1 Track Crane | after L950 | L949 | Vol 5 #20 |
| 46 | 951–960 | P2-B | **M095** Colour Quota Gate (L951) | 12×12–14×14 | 28–40 | 52–70 | L960: 300 + 1 Cowcatcher Shield | — | L959 | Vol 5 #21 |
| 47 | 961–970 | P2-B | **M096** Shadow Train (L961) | 12×12–14×14 | 28–40 | 52–70 | L970: 300 + 1 Green Signal Hint | — | L969 | Vol 5 #22 |
| 48 | 971–980 | P2-B | **M097** Domino Crates (L971) | 12×12–14×14 | 28–40 | 52–70 | L980: 300 + 1 Track Crane | after L975 | L979 | Vol 5 #23 |
| 49 | 981–990 | P2-B | **M098** Marching Clock Tower (L981) | 12×12–14×14 | 28–40 | 52–70 | L990: 300 + 1 Cowcatcher Shield | — | L989 | Vol 5 #24 |
| 50 | 991–1000 | P2-B | **M099** Master Station Gate (L991) | 12×12–14×14 | 28–40 | 52–70 | L1000: **Grand Central Chest:** 1,000 + 2× each booster + badge | after L1000 | L999 | Vol 5 #25 |

**Totals:** 49 mechanics (M051–M099) · 50 Hard levels (L509, L519 … L999) · 49 Gift Crates (L510 … L990) + 1 Grand Central Chest (L1000) · **20 Coin Rushes** (after L525, 550 … 1000) · 50 stickers (Vol 4 ×25, Vol 5 ×25).

### 5.1 Example block walkthrough — Block 4 (L531–540, M053 Push Cart)

| L | Slot | Content |
|---|---|---|
| 531 | x1 Intro | 11×11, 24 trains, 6 Push Carts + M001 ×2 (the 1 earlier mechanic). Tutorial hand: "A train can shove a Push Cart one cell if the space behind it is free. The train stays put." Push = 1 Move, no heart |
| 532–534 | Practice | 11×11–12×12, 25–28 trains, carts + Buffer Stops + Ticket barriers; one cart must be shoved off a lane before a key train can leave |
| 535 | Breather | 11×11, 24 trains, 4 carts, tag easy |
| 536–538 | Ramp | 12×12–13×13, 28–32 trains, carts + Diagonal Express (diagonal shoves) + Corner Buffers |
| 539 | Hard | 13×13, 33 trains, 10 obstacle instances, D ≈ 66 ±3 |
| 540 | Milestone | 12×12, 28 trains — Gift Crate 300 + 1 Cowcatcher Shield (54 mod 3 = 0) + Vol 4 sticker #4 |

### 5.2 Tier notes (designer guidance)

| Range | Focus |
|---|---|
| 501–560 | Big-board reading, diagonals, push physics (carts, ice, cart plates), first layer change (ramp) |
| 561–660 | Periodic & rotating tiles (signal, arrow), colour change (paint), swaps, capacity/quota goals, magnets, seesaw, hidden tickets, triple coupling |
| 661–750 | Floor wear & trails, 3 layers, board-wide rotation lever, quota gates, colour sequences, cushions, iron girders |
| 751–850 | P2-B: creeping steam, tunnel networks, popper crates, island stations, spinning playmat, twin barriers, copycat, conveyors, heavy plates, first Signal Lamp |
| 851–1000 | Light puzzles (sensor, mirror, prism), jam, clamps, parity, 3×3 yards, uncoupling/splitting, mixing, colour quota, shadows, dominos, Marching Clock Tower, Master Station Gate |

## 6. L1000 — Phase 2 Finale: "Grand Terminus"

| Field | Value |
|---|---|
| `slot` / `tag` | `finale` / `finale` (50 coins first clear) |
| Grid | **14×14**, `layers: 3` |
| Trains | **40** (engine + 1–4 carriages; 8 diagonal) |
| Boss | **M098 Marching Clock Tower** — 2×2 tower patrolling a 10-step loop around the central concourse, **HP 8** (8 linked trains, gold clock-hand badge) |
| Mechanics (≥ 10 besides boss) | M051 Diagonal Express (8 trains), M052 Corner Buffer ×2, M053 Push Cart ×1, M055 Cart Weighbridge ×1, M057 Alternating Signal ×1, M065 Hidden Ticket ×1, M069 Triple-Deck Viaduct (board), M074 Iron Girder Wall ×1 (+ its lever), M076 Tunnel Network ×1 (3 tunnels), M084 Signal Lamp ×1, M086 Signal Mirror ×1, M099 Master Station Gate ×1 (built-in sensor) + M098 ×1 = **13 mechanic types besides the boss**, **14 obstacle instances** (P2-B max) |
| D target | 84 ±3. Worked: P 40, C 9, O 14, N 5 (cart, cart plate, signal, beam, marching tower), S 6 ⇒ 24 + 13.5 + 28 + 15 + 6 = **86.5** ✓ |
| Solution | **46 Moves** = 40 exits + 5 cart pushes (3 onto the Cart Weighbridge, later 2 more to roll it off the open bottom edge so the pusher can leave) + 1 girder lever ⇒ S = 46 − 40 = 6; solver-verified, 0 hearts, 0 boosters. Alternating Signal timing is solved by exit order only (no idle Moves exist in the game) |
| Act 1 | Top deck (layer 2) Diagonal Expresses depart via Corner Buffers ⇒ mid deck uncovered |
| Act 2 | Push Cart shoved 3 times onto the Cart Weighbridge ⇒ gate opens ⇒ girder lever ⇒ Signal Lamp beam bounces via Signal Mirror into the Master Station Gate sensor; Hidden Ticket revealed under a departing train and collected |
| Act 3 | 8 linked trains leave through the Tunnel Network as the Clock Tower marches; HP 8 → 0, tower folds into toy box, final trains depart through the concourse |
| Hearts/revive | Standard 3 hearts; ad revive 1/level; Heart Refill 120 × max 2/attempt |
| Rewards order | **Grand Central Chest** (1,000 + 2 Hint + 2 Shield + 2 Hammer + "Phase 2 Conductor" badge) → **Golden Express Coin Rush** → **Phase Complete** (Vol 5 sticker #25 + Vol 5 completion reward shown on this screen, standard §16.20 order unchanged) |
| Ads | No interstitial on this win (reward screens defer) |
| Readability | Night Run (M040), Creeping Steam (M075), Shadow Train (M096) **excluded** from finale |

## 7. Level Content Rules (CI checklist summary)

- Solvable with 0 hearts / 0 boosters (solver node limit 2M, depth ≤ 3×P).
- D in slot band ±3 (x9 = high × 1.1, Finale = high × 1.2 allowed above band — standard §16.13).
- Grid, trains, obstacle instances within tier.
- No train initially locked forever; every pushing train has a later way out (cart pushed off an open edge, lateral push, rotation); no beam that permanently blocks a required lane.
- Intro levels: intro mechanic + ≤ 1 earlier mechanic.
- Grid ≥ 12×12 ⇒ zoom enabled automatically; ≤ 11×11 ⇒ min cell ≥ 29 dp at 360 dp.
- M079 Spinning Playmat levels: square grid only (all Phase 2 grids are square).
- `solution` + `par_moves` stored (Hint, Tuesday Par, Star Race plausibility).
