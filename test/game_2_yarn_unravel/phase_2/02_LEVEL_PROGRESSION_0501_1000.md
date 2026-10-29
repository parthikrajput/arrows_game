# 02 — Level Progression: Levels 0501–1000 (Phase 2)
> Purpose: Phase 2 ના 500 levels નું structure — tiers P2-A/P2-B, block pattern, L501–510 onboarding level-by-level, 50-block table (નવું mechanic, grid, threads, D band, Hard x9, Craft Basket, Golden Bobbin Rush) અને L1000 Finale design.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§6.1, §9, §10, §12, §16) · [./README.md](./README.md) · [./01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) · [./03_OBSTACLE_CATALOG_PHASE_2.md](./03_OBSTACLE_CATALOG_PHASE_2.md) · [../phase_1/02_LEVEL_PROGRESSION_0001_0500.md](../phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [../SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md)

---

## 1. Phase 2 at a glance

| Item | Value |
|---|---|
| Levels | 501–1000 (bundled `assets/levels/phase_2.json.gz`, schema v3, `"phase": 2`) |
| Onboarding | L501–510: zoom/pan tutorial, 12×12 boards, **no new mechanic** (Phase 1 mechanics only) |
| New mechanics | 49 (M051–M099) at x1: L511, 521 … 991 |
| Finale | L1000 "The Heirloom Tapestry" (M098 + ≥ 10 mixed mechanics) |
| Hand-tuned | L501–510 (all), દરેક x1 intro, દરેક x9 Hard, L1000. બાકી: `tools/levelgen` + designer pass (standard §12) |
| CI validator | Phase 1 checks + Phase 2 checks ([06 §7](./06_FRONTEND_AND_QA_PHASE_2.md)): diagonal no-crossing, beam loop guard, crate solver, 3-layer lock, board-rotator square grid |
| Unlock | Remote Config `maxPhase ≥ 2` અને L500 clear |

## 2. Tiers (standard §9.3)

| Tier | Levels | Grid | Threads | Max obstacle instances | D band |
|---|---|---|---|---|---|
| P2-A | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| P2-B | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

Clear coins (first clear, `tag`): Easy **15** · Normal **20** · Hard **30** · Finale **50**; first ★★★ **+20**.

## 3. Onboarding: Levels 501–510 (level-by-level)

Goal: મોટા boards પર zoom/pan આરામથી શીખવવું. નવું mechanic **નથી**; Phase 1 mechanics માંથી જ (max 2 અલગ mechanic types per level, L509 સિવાય). બધા boards 12×12 (standard). Tutorial step analytics: `ftue_step{step}` (Phase 2 steps prefix `p2_`).

| Level | Grid | Threads | D target | Mechanics used (Phase 1) | Tutorial / intent (`ftue_step`) |
|---|---|---|---|---|---|
| 501 | 12×12 | 24 | 45 | M001 Wooden Button, M014 Hook Deflector | `p2_pinch`: Purl બે paws થી pinch બતાવે — "Pinch to zoom in on the big board". Level start auto-fit |
| 502 | 12×12 | 24 | 46 | M002 Ruler Strip, M008 Pompom Tunnel | `p2_pan`: zoomed state માં "Drag to look around"; tunnel pair board ના સામસામા ખૂણે (pan જરૂરી) |
| 503 | 12×12 | 25 | 46 | M020 Yarn Basket, M029 Hem Wall | `p2_fit`: "Tap Fit to see everything" (Fit button pulse) |
| 504 | 12×12 | 25 | 47 | M004 Charm & Clasp, M010 Wool Fluff | `p2_peek_zoom`: zoomed state માં Thread Peek (long-press) — pan vs hold તફાવત |
| 505 | 12×12 | 24 | 45 | M001 Wooden Button | Breather (tag **Easy**) — મોટાભાગના lanes clear |
| 506 | 12×12 | 26 | 49 | M032 Double Fabric Layers, M015 Stitch Bridge | layers refresher (3 layers આગળ M069 માં આવશે) |
| 507 | 12×12 | 27 | 50 | M013 Spool Spinner, M028 Tagged Threads | `p2_hint_pan`: Needle Glow Hint off-screen target પર auto-pan |
| 508 | 12×12 | 28 | 52 | M009 Presser Lever, M019 Foot Pedal Plate | ramp |
| 509 | 12×12 | 29 | ≈58 (53 × 1.1) | M043 Multi-Clasp, M025 Rolling Yarn Ball, M041 Ombre Thread | **Hard** (tag Hard, red badge) |
| 510 | 12×12 | 26 | 49 | M022 Backstitch Thread, M038 Elastic Hop Pad | Milestone: **Craft Basket 300 Coins + 1 Thimble Shield** ((510/10) mod 4 = 3) + Scrapbook Vol 4 પહેલો sticker |

Onboarding rules:
- Tutorial overlay zoom/pan gesture ને block કરતું નથી; tooltip tap થી dismiss. L501 overlay માં "Skip" નથી; L502+ skip ok.
- 501–510 બધાનો D ≥ 45 (Phase 1 T5 mid; difficulty decreases નહીં — standard §9.3).
- L501 પહેલાં one-time "Phase 2 welcome" card: Scrapbook, Star Race, Knitted Piggy Bank, Wardrobe teasers. Retroactive album grant ([04 §2.4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) અહીં બતાવાય.

## 4. Block Pattern (unchanged, standard §9.2)

| Slot | Role | Difficulty | JSON `slot` / `tag` (§16.15) |
|---|---|---|---|
| x1 | Intro — નવું mechanic (+ ≤ 1 earlier mechanic), Purl tutorial card | block window low | `intro` / `normal` |
| x2–x4 | Practice | low → mid | `practice` / `normal` |
| x5 | Breather | low | `breather` / **`easy`** |
| x6–x8 | Ramp | mid → high | `ramp` / `normal` |
| x9 | Hard | block high ×1.1 | `hard` / **`hard`** |
| x0 | Milestone — Craft Basket (L1000: Grand Sewing Chest) + Scrapbook sticker | mid | `milestone` / `normal` (L1000: `finale` / `finale`) |

Intro level: નવા mechanic ના max 3 instances. Hard x9: hand-tuned, pre-level card પર mechanic icons.

## 5. Block Windows (how the table is derived)

Table ના values tier bands માંથી deterministic રીતે કાઢ્યા છે (Phase 1 table જેવી રીત):

| Column | P2-A (blocks i = 0…24) | P2-B (blocks i = 0…24) |
|---|---|---|
| D window | low = 45 + round(7·i/24), high = low + 8 ⇒ 45–53 … 52–60 | low = 53 + round(8·i/24), high = low + 9 ⇒ 53–62 … 61–70 |
| Threads window | low = 24 + round(5·i/24), high = low + 5 ⇒ 24–29 … 29–34 | low = 29 + round(5·i/24), high = low + 6 ⇒ 29–35 … 34–40 |
| Grid | 501–510: 12×12 · 511–600: 10×10–12×12 · 601–750: 11×11–13×13 | 751–870: 12×12–13×13 · 871–1000: 12×12–14×14 |
| x9 Hard | block D high × 1.1 | block D high × 1.1 |

- P2-A band 45–60, windows 45 થી શરૂ ⇒ T5 mid 45 rule satisfied. P2-B windows 53 થી (P2-A last block low 52 થી ઊંચું).
- Grid sub-ranges tier range ની અંદર; diagonal intro (L511) readability માટે 10×10 થી.
- Max obstacle instances: P2-A 6–12, P2-B 8–14 (x1 intro low end).

## 6. Craft Basket, Grand Sewing Chest & Golden Bobbin Rush

- **Craft Basket (Gift Box):** L510, 520 … 990 ⇒ **300 Coins** + 1 booster `(L/10) mod 4` ⇒ 1 = Needle Glow Hint, 2 = Golden Scissors, 3 = Thimble Shield, 0 = Seam Ripper Undo.
- **Grand Sewing Chest (Phase Chest):** L1000 ⇒ **1,000 Coins + 2 of each booster + Phase 2 badge** (Craft Basket ની જગ્યાએ).
- **Golden Bobbin Rush (Coin Rush):** L525, 550 … 1000 ના first-clear win પછી; **30 threads** (standard §16.9), 10 Coins/thread + 100 full clear ⇒ max 400. x0 અને 25 નો ગુણાંક બંને (L550, 600 … 1000): પહેલા Craft Basket/Chest, પછી Rush.
- Reward screen ⇒ interstitial defer (unchanged). Scrapbook sticker reveal Craft Basket પછી, Rush પહેલાં.

## 7. Full Block Table (all 50 blocks)

Columns: **Paths** = threads window · **D band** = x1–x8 slot targets (x1/x5 low, x6–x8 high, x0 mid) · **x9 Hard** = D target · **Coin Rush** = Golden Bobbin Rush trigger.

| Block | Tier | New mechanic (x1) | Grid | Paths | D band (x1–x8) | x9 Hard (D target) | x0 reward | Coin Rush |
|---|---|---|---|---|---|---|---|---|
| 501–510 | P2-A | — Onboarding: zoom/pan, 12×12 (no new mechanic) | 12×12 | 24–29 | 45–53 | L509 (≈58.3) | L510: Craft Basket 300 + 1 Thimble Shield | — |
| 511–520 | P2-A | M051 Bias-Cut Thread (L511) | 10×10–12×12 | 24–29 | 45–53 | L519 (≈58.3) | L520: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 521–530 | P2-A | M052 Felt Corner Bumper (L521) | 10×10–12×12 | 24–29 | 46–54 | L529 (≈59.4) | L530: Craft Basket 300 + 1 Needle Glow Hint | after L525 |
| 531–540 | P2-A | M053 Bobbin Crate (L531) | 10×10–12×12 | 25–30 | 46–54 | L539 (≈59.4) | L540: Craft Basket 300 + 1 Golden Scissors | — |
| 541–550 | P2-A | M054 Satin Glide Patch (L541) | 10×10–12×12 | 25–30 | 46–54 | L549 (≈59.4) | L550: Craft Basket 300 + 1 Thimble Shield | after L550 |
| 551–560 | P2-A | M055 Crate Dock Plate (L551) | 10×10–12×12 | 25–30 | 46–54 | L559 (≈59.4) | L560: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 561–570 | P2-A | M056 Pleat Ramp (L561) | 10×10–12×12 | 25–30 | 47–55 | L569 (≈60.5) | L570: Craft Basket 300 + 1 Needle Glow Hint | — |
| 571–580 | P2-A | M057 Loom Shuttle Gate (L571) | 10×10–12×12 | 25–30 | 47–55 | L579 (≈60.5) | L580: Craft Basket 300 + 1 Golden Scissors | after L575 |
| 581–590 | P2-A | M058 Spinning Stitch Arrow (L581) | 10×10–12×12 | 26–31 | 47–55 | L589 (≈60.5) | L590: Craft Basket 300 + 1 Thimble Shield | — |
| 591–600 | P2-A | M059 Dye Pot (L591) | 10×10–12×12 | 26–31 | 48–56 | L599 (≈61.6) | L600: Craft Basket 300 + 1 Seam Ripper Undo | after L600 |
| 601–610 | P2-A | M060 Swap Hoop (L601) | 11×11–13×13 | 26–31 | 48–56 | L609 (≈61.6) | L610: Craft Basket 300 + 1 Needle Glow Hint | — |
| 611–620 | P2-A | M061 Drawstring Pouch (L611) | 11×11–13×13 | 26–31 | 48–56 | L619 (≈61.6) | L620: Craft Basket 300 + 1 Golden Scissors | — |
| 621–630 | P2-A | M062 Sorting Hem (L621) | 11×11–13×13 | 26–31 | 49–57 | L629 (≈62.7) | L630: Craft Basket 300 + 1 Thimble Shield | after L625 |
| 631–640 | P2-A | M063 Magnet Pin Dish (L631) | 11×11–13×13 | 27–32 | 49–57 | L639 (≈62.7) | L640: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 641–650 | P2-A | M064 Seesaw Latches (L641) | 11×11–13×13 | 27–32 | 49–57 | L649 (≈62.7) | L650: Craft Basket 300 + 1 Needle Glow Hint | after L650 |
| 651–660 | P2-A | M065 Hidden Charm (L651) | 11×11–13×13 | 27–32 | 49–57 | L659 (≈62.7) | L660: Craft Basket 300 + 1 Golden Scissors | — |
| 661–670 | P2-A | M066 Ribbon-Tied Trio (L661) | 11×11–13×13 | 27–32 | 50–58 | L669 (≈63.8) | L670: Craft Basket 300 + 1 Thimble Shield | — |
| 671–680 | P2-A | M067 Worn Fabric Patch (L671) | 11×11–13×13 | 28–33 | 50–58 | L679 (≈63.8) | L680: Craft Basket 300 + 1 Seam Ripper Undo | after L675 |
| 681–690 | P2-A | M068 Lint Trail (L681) | 11×11–13×13 | 28–33 | 50–58 | L689 (≈63.8) | L690: Craft Basket 300 + 1 Needle Glow Hint | — |
| 691–700 | P2-A | M069 Triple Fabric Layers (L691) | 11×11–13×13 | 28–33 | 51–59 | L699 (≈64.9) | L700: Craft Basket 300 + 1 Golden Scissors | after L700 |
| 701–710 | P2-A | M070 Great Spool Lever (L701) | 11×11–13×13 | 28–33 | 51–59 | L709 (≈64.9) | L710: Craft Basket 300 + 1 Thimble Shield | — |
| 711–720 | P2-A | M071 Drawstring Hem (L711) | 11×11–13×13 | 28–33 | 51–59 | L719 (≈64.9) | L720: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 721–730 | P2-A | M072 Pattern Card Sequence (L721) | 11×11–13×13 | 29–34 | 51–59 | L729 (≈64.9) | L730: Craft Basket 300 + 1 Needle Glow Hint | after L725 |
| 731–740 | P2-A | M073 Cushioned Thread (L731) | 11×11–13×13 | 29–34 | 52–60 | L739 (≈66.0) | L740: Craft Basket 300 + 1 Golden Scissors | — |
| 741–750 | P2-A | M074 Brass Bar Wall (L741) | 11×11–13×13 | 29–34 | 52–60 | L749 (≈66.0) | L750: Craft Basket 300 + 1 Thimble Shield | after L750 |
| 751–760 | P2-B | M075 Creeping Fluff (L751) | 12×12–13×13 | 29–35 | 53–62 | L759 (≈68.2) | L760: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 761–770 | P2-B | M076 Pompom Tunnel Network (L761) | 12×12–13×13 | 29–35 | 53–62 | L769 (≈68.2) | L770: Craft Basket 300 + 1 Needle Glow Hint | — |
| 771–780 | P2-B | M077 Confetti Popper (L771) | 12×12–13×13 | 29–35 | 54–63 | L779 (≈69.3) | L780: Craft Basket 300 + 1 Golden Scissors | after L775 |
| 781–790 | P2-B | M078 Closed Hoop Frame (L781) | 12×12–13×13 | 30–36 | 54–63 | L789 (≈69.3) | L790: Craft Basket 300 + 1 Thimble Shield | — |
| 791–800 | P2-B | M079 Turning Quilt Frame (L791) | 12×12–13×13 | 30–36 | 54–63 | L799 (≈69.3) | L800: Craft Basket 300 + 1 Seam Ripper Undo | after L800 |
| 801–810 | P2-B | M080 Twin Clasps (L801) | 12×12–13×13 | 30–36 | 55–64 | L809 (≈70.4) | L810: Craft Basket 300 + 1 Needle Glow Hint | — |
| 811–820 | P2-B | M081 Copycat Thread (L811) | 12×12–13×13 | 30–36 | 55–64 | L819 (≈70.4) | L820: Craft Basket 300 + 1 Golden Scissors | — |
| 821–830 | P2-B | M082 Feed Dog Belt (L821) | 12×12–13×13 | 30–36 | 55–64 | L829 (≈70.4) | L830: Craft Basket 300 + 1 Thimble Shield | after L825 |
| 831–840 | P2-B | M083 Heavy Treadle Plate (L831) | 12×12–13×13 | 31–37 | 56–65 | L839 (≈71.5) | L840: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 841–850 | P2-B | M084 Sewing Lamp Emitter (L841) | 12×12–13×13 | 31–37 | 56–65 | L849 (≈71.5) | L850: Craft Basket 300 + 1 Needle Glow Hint | after L850 |
| 851–860 | P2-B | M085 Sun-Catcher Receiver (L851) | 12×12–13×13 | 31–37 | 56–65 | L859 (≈71.5) | L860: Craft Basket 300 + 1 Golden Scissors | — |
| 861–870 | P2-B | M086 Vanity Mirror (L861) | 12×12–13×13 | 31–37 | 57–66 | L869 (≈72.6) | L870: Craft Basket 300 + 1 Thimble Shield | — |
| 871–880 | P2-B | M087 Hook-and-Loop Pad (L871) | 12×12–14×14 | 31–37 | 57–66 | L879 (≈72.6) | L880: Craft Basket 300 + 1 Seam Ripper Undo | after L875 |
| 881–890 | P2-B | M088 Thistle Burr (L881) | 12×12–14×14 | 32–38 | 57–66 | L889 (≈72.6) | L890: Craft Basket 300 + 1 Needle Glow Hint | — |
| 891–900 | P2-B | M089 Crystal Bead Prism (L891) | 12×12–14×14 | 32–38 | 58–67 | L899 (≈73.7) | L900: Craft Basket 300 + 1 Golden Scissors | after L900 |
| 901–910 | P2-B | M090 Odd-Stitch Gate (L901) | 12×12–14×14 | 32–38 | 58–67 | L909 (≈73.7) | L910: Craft Basket 300 + 1 Thimble Shield | — |
| 911–920 | P2-B | M091 Grand Quilt Block Rotor (L911) | 12×12–14×14 | 32–38 | 58–67 | L919 (≈73.7) | L920: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 921–930 | P2-B | M092 Chain-Stitch Thread (L921) | 12×12–14×14 | 33–39 | 59–68 | L929 (≈74.8) | L930: Craft Basket 300 + 1 Needle Glow Hint | after L925 |
| 931–940 | P2-B | M093 Split-Ply Thread (L931) | 12×12–14×14 | 33–39 | 59–68 | L939 (≈74.8) | L940: Craft Basket 300 + 1 Golden Scissors | — |
| 941–950 | P2-B | M094 Dye Mixing Pot (L941) | 12×12–14×14 | 33–39 | 59–68 | L949 (≈74.8) | L950: Craft Basket 300 + 1 Thimble Shield | after L950 |
| 951–960 | P2-B | M095 Color Drawstring Hem (L951) | 12×12–14×14 | 33–39 | 60–69 | L959 (≈75.9) | L960: Craft Basket 300 + 1 Seam Ripper Undo | — |
| 961–970 | P2-B | M096 Shadow-Work Thread (L961) | 12×12–14×14 | 33–39 | 60–69 | L969 (≈75.9) | L970: Craft Basket 300 + 1 Needle Glow Hint | — |
| 971–980 | P2-B | M097 Button Domino Row (L971) | 12×12–14×14 | 34–40 | 60–69 | L979 (≈75.9) | L980: Craft Basket 300 + 1 Golden Scissors | after L975 |
| 981–990 | P2-B | M098 Wandering Pincushion Guardian (L981) | 12×12–14×14 | 34–40 | 61–70 | L989 (≈77.0) | L990: Craft Basket 300 + 1 Thimble Shield | — |
| 991–1000 | P2-B | M099 Master Jewel Clasp (L991) | 12×12–14×14 | 34–40 | 61–70 | L999 (≈77.0) | L1000: **Grand Sewing Chest** 1,000 + 2× each booster + Phase 2 badge | after L1000 |

Notes:
- દરેક row નો x0 level Scrapbook sticker પણ આપે ([04 §2](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)).
- Mechanic names = Yarn themed names; rules standard §10 મુજબ ([03](./03_OBSTACLE_CATALOG_PHASE_2.md)).
- x9 Hard D targets tier band high થી ઉપર જઈ શકે (standard §16.13).

## 8. Mechanic Mix Guidelines

| Range | Mix rule |
|---|---|
| 511–600 | Diagonals + push family (M051–M055) + ramps / shuttle gate / spinning arrow / dye. Level દીઠ max 4 mechanic types. Crates ≤ 3 per level |
| 601–750 | Goal/quota mechanics (M061, M062, M071, M072), magnets, seesaws, trio chains, 3 layers. Max 5 types. M062 + M072 એક જ level માં નહીં (goal overload) |
| 751–850 | Creeping fog, portal network, popper, closed hoop, board rotator, twin clasps, belts. Max 5 types. M079 Turning Quilt Frame ફક્ત square boards, 5 levels માંથી max 1 |
| 851–1000 | Beam family (M084–M086, M089, M099) + path-variants (M092–M096) + M098. Max 6 types. Beam levels માં M040 Lamplight Evening નહીં |

- Non-monotone instances (N) P2-A માં level દીઠ ≤ 6, P2-B ≤ 8 (solver budget: node limit 2M, CI).
- Daily Stitch Phase 2 mechanics વાપરી શકે (માત્ર unlocked); Daily માં M096 Shadow-Work Thread અને M079 Turning Quilt Frame નહીં (readability).
- Diagonal threads level ના ≤ 40% threads (P2-A), ≤ 60% (P2-B).

## 9. L1000 — Phase 2 Finale "The Heirloom Tapestry"

| Field | Value |
|---|---|
| Slot / tag | `finale` / `finale` (first clear **50** Coins) |
| Grid | **14×14** (Phase 2 max), 3 layers |
| Threads | **40** (P2-B max) |
| D | band high ×1.2 ⇒ target **84** (70 × 1.2), ±3 |
| Boss | **Wandering Pincushion Guardian** (M098), 2×2, patrol loop around the centre ring; HP = **8** linked threads |
| Mechanic mix (≥ 10) | M051 Bias-Cut Thread, M053 Bobbin Crate, M055 Crate Dock Plate, M064 Seesaw Latches, M069 Triple Fabric Layers, M076 Pompom Tunnel Network, M082 Feed Dog Belt, M084 Sewing Lamp Emitter, M085 Sun-Catcher Receiver, M086 Vanity Mirror, M089 Crystal Bead Prism, M092 Chain-Stitch Thread, M099 Master Jewel Clasp (13 mechanics + Guardian) |
| Hearts | 3; revive / Heart Refill rules standard મુજબ |
| Solvable | 0 hearts lost, 0 boosters (CI); solver node limit 2M, depth ≤ 3 × 40 = 120 |
| Presentation | Board frame = heirloom tapestry loom; Guardian HP bar (8 pins); Master Jewel Clasp centre માં |
| Reward flow | Level Complete (50 + star bonus) ⇒ **Grand Sewing Chest** (1,000 Coins + 2 Needle Glow Hint + 2 Seam Ripper Undo + 2 Thimble Shield + 2 Golden Scissors + "Heirloom Weaver" badge) ⇒ Scrapbook Vol 5 last sticker (+ volume reward if complete) ⇒ Golden Bobbin Rush (30 threads) ⇒ **Phase Complete** |
| After | `maxPhase = 2` ⇒ "New patterns coming soon" + Daily Stitch / Star Race CTA. Phase 3: [../SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md) |

Finale design intent:
1. **Opening (zoomed out):** 5 threads free (2 diagonal). Feed Dog Belt bottom row પર 3 threads ને Sun-Catcher તરફ લઈ જાય છે.
2. **Crate act:** 2 Bobbin Crates ને Dock Plates પર push ⇒ Seesaw Latches ની જોડ ખોલે. Design rule: crate dead-end positions layout થી ટાળવા (ખોટો push થાય તો Seam Ripper Undo અથવા Restart; CI only proves a 0-heart solution exists).
3. **Light act:** Sewing Lamp beam → Vanity Mirror → Crystal Bead Prism split ⇒ બે Sun-Catchers; એક Master Jewel Clasp નો receiver છે.
4. **Guardian act:** 8 linked threads (3 Chain-Stitch Threads — છેલ્લો segment exit થાય ત્યારે જ HP −1); Guardian દરેક Move એ ring પર ફરે અને lanes ને વારાફરતી block કરે.
5. **Finale cascade:** Master Jewel Clasp ખુલે ⇒ Pompom Tunnel Network center થી 3 layers ના બાકી threads quick cascade.
