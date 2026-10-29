# Spec Index

This file is maintained automatically by Claude.
Every time a new spec is created or a spec status changes,
this file is updated. Do not edit manually.

Every spec under specs/** (excluding WORKFLOW.md, TEMPLATE.md,
and this file) must have exactly one row here. Descriptions must
stay to one line; do not append change history into this file.

## Format
Group | File Path | Description | Status

## Specs

| Group | File Path | Description | Status |
|---|---|---|---|
| gameplay | specs/gameplay/core-concept-and-rules.md | Core puzzle rules, board/snake models, turn resolution pipeline, and win/fail/stars logic | Draft |
| gameplay | specs/gameplay/level-progression-0001-0500.md | 500-level progression architecture, tiers, 10-level block patterns, FTUE onboarding, and L500 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-1.md | Catalog of 49 jungle mechanics (M001–M049) and Phase 1 Finale with collision, hammer, and solver rules | Draft |
| economy | specs/economy/boosters-coins-shop.md | Boosters, coins inflow/outflow, Gift Baskets, Golden Slither Rush, Lucky Lily Wheel, Shop, ads, and VIP | Draft |
| meta | specs/meta/daily-challenge-and-streak.md | Daily Jungle Puzzle, 7 weekday modifiers, silhouettes, 7-day streak ladder, Saver Leaf, and leaderboards | Draft |
| ui | specs/ui/ui-ux-screens.md | Design tokens, color-blind palette, responsive layout rules, and wireframes for all 18 screens and dialogs | Draft |
| tech | specs/tech/frontend-implementation-and-qa.md | Flutter architecture, pure-Dart puzzle_core engine, BLoCs, CustomPainter renderer, persistence, and QA matrix | Draft |
| audio | specs/audio/sound-effects.md | Audio engine, audioplayers setup, jungle ASMR sound effects, music loops, ducking, and audio QA checklist | Draft |
| tech | specs/tech/logging-and-error-tracking.md | AppLogger ring buffer and file sink, Crashlytics, tap tracing, deterministic replay, and problem reporting | Draft |
| tech | specs/tech/performance-optimization.md | 60 fps low-tier performance budgets, on-demand Ticker, static layer caching, device tiers, and perf monitor | Draft |
| tech | specs/tech/splash-and-instant-launch.md | Instant launch pipeline with zero loading screens, native Android/iOS splash, and Jungle Dawn intro | Draft |
| ui | specs/ui/vfx-and-juice.md | Particle, shake, flash and trail effects with tier limits, per-event effect catalog, and VFX QA checklist | Draft |
| gameplay | specs/gameplay/phase-2-scope-and-rules.md | Pinch-zoom and pan, diagonal snakes, 3 layers, push physics, sunbeams, and Remote Config rollout | Draft |
| gameplay | specs/gameplay/level-progression-0501-1000.md | Levels 501–1000 progression, P2-A/P2-B tiers, zoom onboarding (L501–510), and L1000 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-2.md | Catalog of 49 mechanics (M051–M099), push blocks, periodic gates, beams, and L1000 boss rules | Draft |
| meta | specs/meta/liveops-sticker-album.md | Jungle Sticker Album with 100 milestone stickers, Daily silhouettes page, and volume rewards | Draft |
| meta | specs/meta/liveops-weekly-star-race.md | Weekly Star Race async 5-player cohorts, ghost fill, server plausibility checks, and podium rewards | Draft |
| economy | specs/economy/piggy-bank-and-cosmetics.md | Piggy Bank savings (₹49 smash / 1,000 cap), Cosmetics Style tab (800–4,000 coins), and VIP skin | Draft |
| tech | specs/tech/offline-and-cloud-sync.md | Offline-first sync, Firebase Auth anonymous-to-linked identity, idempotent op-log, and account deletion | Draft |
| tech | specs/tech/auth-and-account-linking.md | Silent Google Sign-In, Firebase anonymous guest mode, persistent session tokens, and zero-loss account linking | Draft |
| tech | specs/tech/backend-cloud-functions-and-release-prerequisites.md | Cloud Functions endpoints (syncPush, race, IAP, auth) and production release prerequisites R1–R10 | Draft |
| tech | specs/tech/frontend-and-qa-phase-2.md | Frontend rendering for 8 directions, 3 layers, zoom viewport, 60 fps budgets, and QA matrix | Draft |
| audio | specs/audio/sound-effects-phase-2.md | Phase 2 music loops, Level 1000 Finale track, mechanics SFX, and LiveOps audio events | Draft |
| ui | specs/ui/vfx-phase-2.md | Visual effects for diagonals, 3 layers, sunbeams, push physics, LiveOps celebrations, and L1000 Finale | Draft |
| gameplay | specs/gameplay/phase-3-signature-system.md | Day & Night Garden Cycles (5-move period), Sun/Moon dial HUD, and cyclic tick order | Draft |
| gameplay | specs/gameplay/phase-3-base-mechanics.md | Base mechanics M101–M104 (Sun-Moon Gate, Moonlight Bridge, Burrows, Twilight Flower Gate) | Draft |
| gameplay | specs/gameplay/phase-3-variants-and-modifiers.md | 45 variant slots combining base mechanics with 10 generic modifiers across Levels 1001–1500 | Draft |
| gameplay | specs/gameplay/phase-3-level-plan-01001-01500.md | Levels 1001–1500 progression, P3-A/P3-B tiers, fixed plateau D band 60–76, and L1500 Finale | Draft |
| economy | specs/economy/phase-3-rewards.md | Gift Baskets (300 coins), Level 1500 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-3-ui-additions.md | Sun/Moon cycle dial HUD, variant tutorial cards, and color-blind shape encodings | Draft |
| ui | specs/ui/phase-3-vfx.md | Ambient cycle transitions, M101–M104 particle effects, and Level 1500 Finale visual burst | Draft |
| tech | specs/tech/phase-3-qa-and-rollout.md | CI pre-validation suite, phase_3_meta.bin bundling, maxPhase rollout, and Phase 3 QA matrix | Draft |
| tech | specs/tech/on-device-level-generation.md | Core on-device level generator, reverse construction, IDA* solver, xoshiro128**, and cache freeze | Draft |
| gameplay | specs/gameplay/phase-4-signature-system.md | Great Tree Floors multi-floor system (up to 3 floors), floor tabs HUD, and vertical lane continuity | Draft |
| gameplay | specs/gameplay/phase-4-base-mechanics.md | Base mechanics M151–M154 (Root Stairs, Dewglass Floor, Knot Hole, Vine Lift) rules and solver models | Draft |
| gameplay | specs/gameplay/phase-4-variants-and-modifiers.md | 45 variant slots combining multi-floor mechanics with 10 generic modifiers across Levels 1501–2000 | Draft |
| gameplay | specs/gameplay/phase-4-level-plan-01501-02000.md | Levels 1501–2000 progression, P4-A/P4-B tiers, fixed plateau D band 60–76, and L2000 Finale | Draft |
| economy | specs/economy/phase-4-rewards.md | Gift Baskets (300 coins), Level 2000 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-4-ui-additions.md | Multi-Floor vertical tabs HUD, inter-floor camera slide transitions, and tutorial cards | Draft |
| ui | specs/ui/phase-4-vfx.md | Vertical camera sweep, M151–M154 particle effects, and Level 2000 Finale canopy burst | Draft |
| tech | specs/tech/phase-4-qa-and-rollout.md | CI pre-validation suite, phase_4_meta.bin bundling, maxPhase rollout, and Phase 4 QA matrix | Draft |
| gameplay | specs/gameplay/phase-5-signature-system.md | Coconut Grove Physics push system, momentum sliding, and pit filling terrain modification | Draft |
| gameplay | specs/gameplay/phase-5-base-mechanics.md | Base mechanics M201–M204 (Coconut Pit, Dew-Slick Coconut, Key Coconut, Jackfruit Boulder) | Draft |
| gameplay | specs/gameplay/phase-5-variants-and-modifiers.md | 45 variant slots combining push mechanics with 10 generic modifiers across Levels 2001–2500 | Draft |
| gameplay | specs/gameplay/phase-5-level-plan-02001-02500.md | Levels 2001–2500 progression, P5-A/P5-B tiers, fixed plateau D band 60–76, and L2500 Finale | Draft |
| economy | specs/economy/phase-5-rewards.md | Gift Baskets (300 coins), Level 2500 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-5-ui-additions.md | Push trajectory cues, boulder warning feedback, and pit transformation UI indicators | Draft |
| ui | specs/ui/phase-5-vfx.md | Sliding mist trails, pit settling dust, key burst flare, and Level 2500 Finale shrine burst | Draft |
| tech | specs/tech/phase-5-qa-and-rollout.md | CI pre-validation suite, phase_5_meta.bin bundling, maxPhase rollout, and Phase 5 QA matrix | Draft |
| gameplay | specs/gameplay/phase-6-signature-system.md | Sun Temple Light optics system, chromatic beam filtering, ray tracing, and beam blocking | Draft |
| gameplay | specs/gameplay/phase-6-base-mechanics.md | Base mechanics M251–M254 (Petal Filter, Prism Lock, Sundial Receiver, Shade Leaves) | Draft |
| gameplay | specs/gameplay/phase-6-variants-and-modifiers.md | 45 variant slots combining optics mechanics with 10 generic modifiers across Levels 2501–3000 | Draft |
| gameplay | specs/gameplay/phase-6-level-plan-02501-03000.md | Levels 2501–3000 progression, P6-A/P6-B tiers, fixed plateau D band 60–76, and L3000 Finale | Draft |
| economy | specs/economy/phase-6-rewards.md | Gift Baskets (300 coins), Level 3000 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-6-ui-additions.md | Prism lock convergence HUD, sundial countdown dials, color-blind glyphs, and tutorial cards | Draft |
| ui | specs/ui/phase-6-vfx.md | Chromatic beam glow, prism flare, sundial shockwaves, shade dissolution, and L3000 Finale burst | Draft |
| tech | specs/tech/phase-6-qa-and-rollout.md | CI pre-validation suite, phase_6_meta.bin bundling, maxPhase rollout, and Phase 6 QA matrix | Draft |
| gameplay | specs/gameplay/phase-7-signature-system.md | Whirlwind Valley rotation system, 4×4 sub-board rotor transformation, and boundary invariants | Draft |
| gameplay | specs/gameplay/phase-7-base-mechanics.md | Base mechanics M301–M304 (Island Spinner, Turning Hedges, Spinning Snake, Gear Lock) | Draft |
| gameplay | specs/gameplay/phase-7-variants-and-modifiers.md | 45 variant slots combining rotation mechanics with 10 generic modifiers across Levels 3001–3500 | Draft |
| gameplay | specs/gameplay/phase-7-level-plan-03001-03500.md | Levels 3001–3500 progression, P7-A/P7-B tiers, fixed plateau D band 60–76, and L3500 Finale | Draft |
| economy | specs/economy/phase-7-rewards.md | Gift Baskets (300 coins), Level 3500 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-7-ui-additions.md | Sub-board rotor handle widgets, spinning snake trajectory crests, and tutorial cards | Draft |
| ui | specs/ui/phase-7-vfx.md | 4×4 rotational swoosh, perimeter hedge dust puffs, spin flares, and L3500 Finale burst | Draft |
| tech | specs/tech/phase-7-qa-and-rollout.md | CI pre-validation suite, phase_7_meta.bin bundling, maxPhase rollout, and Phase 7 QA matrix | Draft |
| gameplay | specs/gameplay/phase-8-signature-system.md | Overgrown Garden growth system, U->R->D->L vine spread, and pruning mechanics | Draft |
| gameplay | specs/gameplay/phase-8-base-mechanics.md | Base mechanics M351–M354 (Wild Vine, Pruning Shears Tile, Seed-Carrier Snake, Bloom Gate) | Draft |
| gameplay | specs/gameplay/phase-8-variants-and-modifiers.md | 45 variant slots combining growth mechanics with 10 generic modifiers across Levels 3501–4000 | Draft |
| gameplay | specs/gameplay/phase-8-level-plan-03501-04000.md | Levels 3501–4000 progression, P8-A/P8-B tiers, fixed plateau D band 60–76, and L4000 Finale | Draft |
| economy | specs/economy/phase-8-rewards.md | Gift Baskets (300 coins), Level 4000 Phase Chest (1,000 coins + 6 boosters), and Coin Rush | Draft |
| ui | specs/ui/phase-8-ui-additions.md | Vine growth countdown badges, seed pod germination timers, and bloom gate status meters | Draft |
| ui | specs/ui/phase-8-vfx.md | Sprouting tendril scaling, pruning shears slash cut, seed bursts, and L4000 Finale burst | Draft |
| tech | specs/tech/phase-8-qa-and-rollout.md | CI pre-validation suite, phase_8_meta.bin bundling, maxPhase rollout, and Phase 8 QA matrix | Draft |
| gameplay | specs/gameplay/phase-9-signature-system.md | Twin Rivers split & merge signature system, topological rules, and interaction matrix | Draft |
| gameplay | specs/gameplay/phase-9-base-mechanics.md | Base mechanics M401–M404 (Merger Pad, Twin Splitter, Segment Lock, Rejoin Gate) | Draft |
| gameplay | specs/gameplay/phase-9-variants-and-modifiers.md | 45 variant slots combining split & merge mechanics with 10 generic modifiers across Levels 4001–4500 | Draft |
| gameplay | specs/gameplay/phase-9-level-plan-04001-04500.md | Levels 4001–4500 progression, P9-A/P9-B tiers, fixed plateau D band 60–76, and L4500 Finale | Draft |
| economy | specs/economy/phase-9-rewards.md | 49 Gift Baskets (300 coins), Level 4500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-9-ui-additions.md | Bead lock progress counter, reunion gate status indicators, and twin fork trajectory ghost preview | Draft |
| ui | specs/ui/phase-9-vfx.md | Aquatic fusion flare, bifurcation particle burst, bead absorption streams, and L4500 Finale burst | Draft |
| tech | specs/tech/phase-9-qa-and-rollout.md | CI pre-validation suite, phase_9_meta.bin bundling, maxPhase rollout, and Phase 9 QA matrix | Draft |
| gameplay | specs/gameplay/phase-10-signature-system.md | Jungle Drum Festival sequencing signature system, move-modulo rules, and FIFO history buffer | Draft |
| gameplay | specs/gameplay/phase-10-base-mechanics.md | Base mechanics M451–M454 (Drum Gate, Totem Pattern Lock, Parade Exit, Echo Frogs) | Draft |
| gameplay | specs/gameplay/phase-10-variants-and-modifiers.md | 45 variant slots combining sequencing mechanics with 10 generic modifiers across Levels 4501–5000 | Draft |
| gameplay | specs/gameplay/phase-10-level-plan-04501-05000.md | Levels 4501–5000 progression, P10-A/P10-B tiers, fixed plateau D band 60–76, and L5000 Halfway Finale | Draft |
| economy | specs/economy/phase-10-rewards.md | 49 Gift Baskets (300 coins), Level 5000 Grand Halfway Chest (2,000 coins + 9 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-10-ui-additions.md | Rhythm beat ribbon, totem pattern ribbon, parade callout badge, and echo sequence HUD tracker | Draft |
| ui | specs/ui/phase-10-vfx.md | Drum acoustic pulse rings, totem gemstone glows, parade confetti, and Level 5000 Halfway celebration burst | Draft |
| tech | specs/tech/phase-10-qa-and-rollout.md | CI pre-validation suite, phase_10_meta.bin bundling, maxPhase rollout, and Phase 10 QA matrix | Draft |
| gameplay | specs/gameplay/phase-11-signature-system.md | Two Ponds dual-grid signature system, continuous bridge transit, and inter-board state model | Draft |
| gameplay | specs/gameplay/phase-11-base-mechanics.md | Base mechanics M501–M504 (Vine Bridge Edge, Messenger Key, Mirror Board, Relay Burrow) | Draft |
| gameplay | specs/gameplay/phase-11-variants-and-modifiers.md | 45 variant slots combining linked board mechanics with 10 generic modifiers across Levels 5001–5500 | Draft |
| gameplay | specs/gameplay/phase-11-level-plan-05001-05500.md | Levels 5001–5500 progression, P11-A/P11-B tiers, fixed plateau D band 60–76, and L5500 Finale | Draft |
| economy | specs/economy/phase-11-rewards.md | 49 Gift Baskets (300 coins), Level 5500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-11-ui-additions.md | Dual-grid viewport layout, vine bridge connector widget, cross-board lock beam, and mirror twin glow | Draft |
| ui | specs/ui/phase-11-vfx.md | Water lily splashes, vine bridge transit particles, cross-board golden sparks, and L5500 Finale burst | Draft |
| tech | specs/tech/phase-11-qa-and-rollout.md | CI pre-validation suite, phase_11_meta.bin bundling, maxPhase rollout, and Phase 11 QA matrix | Draft |
| gameplay | specs/gameplay/phase-12-signature-system.md | Monsoon Winds rotating gravity signature system, post-move cascade settling, and anti-grav tiles | Draft |
| gameplay | specs/gameplay/phase-12-base-mechanics.md | Base mechanics M551–M554 (Wind Lever, Falling Fruit, Floaty Lily, Heavy Python) | Draft |
| gameplay | specs/gameplay/phase-12-variants-and-modifiers.md | 45 variant slots combining gravity mechanics with 10 generic modifiers across Levels 5501–6000 | Draft |
| gameplay | specs/gameplay/phase-12-level-plan-05501-06000.md | Levels 5501–6000 progression, P12-A/P12-B tiers, fixed plateau D band 60–76, and L6000 Finale | Draft |
| economy | specs/economy/phase-12-rewards.md | 49 Gift Baskets (300 coins), Level 6000 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-12-ui-additions.md | Compass wind indicator, falling trajectory ghost preview, heavy python weight badge, and fruit counter | Draft |
| ui | specs/ui/phase-12-vfx.md | Monsoon wind gusts, falling fruit impact dust puffs, anti-grav shimmers, and L6000 Finale burst | Draft |
| tech | specs/tech/phase-12-qa-and-rollout.md | CI pre-validation suite, phase_12_meta.bin bundling, maxPhase rollout, and Phase 12 QA matrix | Draft |
| gameplay | specs/gameplay/phase-13-signature-system.md | Mystery Mists fog-of-war signature system, scout clearing, and zero-guessing fairness standard | Draft |
| gameplay | specs/gameplay/phase-13-base-mechanics.md | Base mechanics M601–M604 (Scout Gecko, Trick Mist, Painted Wall, Glow Stone) | Draft |
| gameplay | specs/gameplay/phase-13-variants-and-modifiers.md | 45 variant slots combining fog mechanics with 10 generic modifiers across Levels 6001–6500 | Draft |
| gameplay | specs/gameplay/phase-13-level-plan-06001-06500.md | Levels 6001–6500 progression, P13-A/P13-B tiers, fixed plateau D band 60–76, and L6500 Finale | Draft |
| economy | specs/economy/phase-13-rewards.md | 49 Gift Baskets (300 coins), Level 6500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-13-ui-additions.md | Fog alpha overlay, tongue-flick through-beam raycast, scout gecko aura badge, and fog meter | Draft |
| ui | specs/ui/phase-13-vfx.md | Mist dispersal bursts, trick fog condensation plumes, false wall ripple dissolves, and L6500 Finale burst | Draft |
| tech | specs/tech/phase-13-qa-and-rollout.md | CI pre-validation suite, phase_13_meta.bin bundling, maxPhase rollout, and Phase 13 QA matrix | Draft |
| gameplay | specs/gameplay/phase-14-signature-system.md | Pond Reflections mirror worlds signature system, bilateral axis symmetry, and synchronized safety rules | Draft |
| gameplay | specs/gameplay/phase-14-base-mechanics.md | Base mechanics M651–M654 (Pond Axis, Reflection Lock, Twin Board, Upside-down Snake) | Draft |
| gameplay | specs/gameplay/phase-14-variants-and-modifiers.md | 45 variant slots combining reflection mechanics with 10 generic modifiers across Levels 6501–7000 | Draft |
| gameplay | specs/gameplay/phase-14-level-plan-06501-07000.md | Levels 6501–7000 progression, P14-A/P14-B tiers, fixed plateau D band 60–76, and L7000 Finale | Draft |
| economy | specs/economy/phase-14-rewards.md | 49 Gift Baskets (300 coins), Level 7000 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-14-ui-additions.md | Caustic water axis line, mirror link partner halo, inverse direction glyph, and ripple wave indicator | Draft |
| ui | specs/ui/phase-14-vfx.md | Crystal reflection glints, cross-axis ripple waves, twin board splashes, and L7000 Finale burst | Draft |
| tech | specs/tech/phase-14-qa-and-rollout.md | CI pre-validation suite, phase_14_meta.bin bundling, maxPhase rollout, and Phase 14 QA matrix | Draft |
| gameplay | specs/gameplay/phase-15-signature-system.md | River Delta conveyors and tracks signature system, post-move flow propagation, and loop topologies | Draft |
| gameplay | specs/gameplay/phase-15-base-mechanics.md | Base mechanics M701–M704 (River Fork, Tide River, Sluice Lever, Whirlpool Loop) | Draft |
| gameplay | specs/gameplay/phase-15-variants-and-modifiers.md | 45 variant slots combining conveyor mechanics with 10 generic modifiers across Levels 7001–7500 | Draft |
| gameplay | specs/gameplay/phase-15-level-plan-07001-07500.md | Levels 7001–7500 progression, P15-A/P15-B tiers, fixed plateau D band 60–76, and L7500 Finale | Draft |
| economy | specs/economy/phase-15-rewards.md | 49 Gift Baskets (300 coins), Level 7500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-15-ui-additions.md | Conveyor flow chevron overlays, tide countdown pill, sluice gate status widget, and whirlpool tangent indicators | Draft |
| ui | specs/ui/phase-15-vfx.md | Water chevron flows, tidal wave crest bursts, sluice torrent rushes, and L7500 Finale fountain burst | Draft |
| tech | specs/tech/phase-15-qa-and-rollout.md | CI pre-validation suite, phase_15_meta.bin bundling, maxPhase rollout, and Phase 15 QA matrix | Draft |
| gameplay | specs/gameplay/phase-16-signature-system.md | Treasure Keys / Keys Deluxe DAG dependency signature system, multi-part key forging, and vine locks | Draft |
| gameplay | specs/gameplay/phase-16-base-mechanics.md | Base mechanics M751–M754 (Key Vine, Key Crafting, Skeleton Key, Key Swap Pedestal) | Draft |
| gameplay | specs/gameplay/phase-16-variants-and-modifiers.md | 45 variant slots combining key mechanics with 10 generic modifiers across Levels 7501–8000 | Draft |
| gameplay | specs/gameplay/phase-16-level-plan-07501-08000.md | Levels 7501–8000 progression, P16-A/P16-B tiers, fixed plateau D band 60–76, and L8000 Finale | Draft |
| economy | specs/economy/phase-16-rewards.md | 49 Gift Baskets (300 coins), Level 8000 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-16-ui-additions.md | Key crafting HUD ribbon, skeleton key inventory badge, dynamic golden vine connection lines, and swap pedestal auras | Draft |
| ui | specs/ui/phase-16-vfx.md | Golden vine dissolution bursts, key forge anvil sparks, skeleton key unlock flash, and L8000 Finale vault burst | Draft |
| tech | specs/tech/phase-16-qa-and-rollout.md | CI pre-validation suite, phase_16_meta.bin bundling, maxPhase rollout, and Phase 16 QA matrix | Draft |
| gameplay | specs/gameplay/phase-17-signature-system.md | Mongoose Clan Guardians signature system, boss health pools, and post-move damage resolution | Draft |
| gameplay | specs/gameplay/phase-17-base-mechanics.md | Base mechanics M801–M804 (Twin Guardian, Shield Guardian, Spawner Guardian, Guardian Core) | Draft |
| gameplay | specs/gameplay/phase-17-variants-and-modifiers.md | 45 variant slots combining guardian mechanics with 10 generic modifiers across Levels 8001–8500 | Draft |
| gameplay | specs/gameplay/phase-17-level-plan-08001-08500.md | Levels 8001–8500 progression, P17-A/P17-B tiers, fixed plateau D band 60–76, and L8500 Finale | Draft |
| economy | specs/economy/phase-17-rewards.md | 49 Gift Baskets (300 coins), Level 8500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-17-ui-additions.md | Boss health bar widget, shield status indicator, directional vulnerability arrows, and stagger rings | Draft |
| ui | specs/ui/phase-17-vfx.md | Guardian damage impact sparks, shield deflection crystals, burrow dirt retreat, and L8500 Finale burst | Draft |
| tech | specs/tech/phase-17-qa-and-rollout.md | CI pre-validation suite, phase_17_meta.bin bundling, maxPhase rollout, and Phase 17 QA matrix | Draft |
| gameplay | specs/gameplay/phase-18-signature-system.md | Remix A early eras synergy signature system, composite multi-system state, and post-move resolution | Draft |
| gameplay | specs/gameplay/phase-18-base-mechanics.md | Combo mechanics M851–M854 (Cycle Floor Elevator, Prism Coconut Roll, Sun Portal, Trapdoor Balance) | Draft |
| gameplay | specs/gameplay/phase-18-variants-and-modifiers.md | 45 variant slots combining synergy mechanics with 10 generic modifiers across Levels 8501–9000 | Draft |
| gameplay | specs/gameplay/phase-18-level-plan-08501-09000.md | Levels 8501–9000 progression, P18-A/P18-B tiers, fixed plateau D band 60–76, and L9000 Finale | Draft |
| economy | specs/economy/phase-18-rewards.md | 49 Gift Baskets (300 coins), Level 9000 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-18-ui-additions.md | Seasonal cycle dial widget, solar beam status, coconut weight badges, and portal runic rings | Draft |
| ui | specs/ui/phase-18-vfx.md | Sub-floor elevation dust, coconut prism reflection rays, portal solar warp swirl, and L9000 Finale burst | Draft |
| tech | specs/tech/phase-18-qa-and-rollout.md | CI pre-validation suite, phase_18_meta.bin bundling, maxPhase rollout, and Phase 18 QA matrix | Draft |
| gameplay | specs/gameplay/phase-19-signature-system.md | Remix B late eras synergy signature system, environmental coupling, and post-move resolution | Draft |
| gameplay | specs/gameplay/phase-19-base-mechanics.md | Combo mechanics M901–M904 (Wind-Driven Vine, Split River Bridge, Rhythm Gravity Cascade, Echo Weight Shift) | Draft |
| gameplay | specs/gameplay/phase-19-variants-and-modifiers.md | 45 variant slots combining late-era mechanics with 10 generic modifiers across Levels 9001–9500 | Draft |
| gameplay | specs/gameplay/phase-19-level-plan-09001-09500.md | Levels 9001–9500 progression, P19-A/P19-B tiers, fixed plateau D band 60–76, and L9500 Finale | Draft |
| economy | specs/economy/phase-19-rewards.md | 49 Gift Baskets (300 coins), Level 9500 Phase Chest (1,000 coins + 6 boosters), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-19-ui-additions.md | Rhythm metronome pill widget, wind vector arrows, siphon river chevrons, and seismic ripple mesh | Draft |
| ui | specs/ui/phase-19-vfx.md | Wind-swept leafy vine trails, river siphon surges, monsoon rain squalls, and L9500 Finale waterfall burst | Draft |
| tech | specs/tech/phase-19-qa-and-rollout.md | CI pre-validation suite, phase_19_meta.bin bundling, maxPhase rollout, and Phase 19 QA matrix | Draft |
| gameplay | specs/gameplay/phase-20-signature-system.md | Grand Jungle Master 14-system culmination signature system, Apex Boss state machine, and crown victory | Draft |
| gameplay | specs/gameplay/phase-20-base-mechanics.md | Grand Master mechanics M951–M954 (Apex Chieftain Mongoose, Prismatic Master Key, Convergence Vortex, Jungle Crown Pedestal) | Draft |
| gameplay | specs/gameplay/phase-20-variants-and-modifiers.md | 45 variant slots combining summit mechanics with 10 generic modifiers across Levels 9501–10000 | Draft |
| gameplay | specs/gameplay/phase-20-level-plan-09501-10000.md | Levels 9501–10,000 progression, ascent & high-plateau tiers, Master Gauntlet, and Level 10,000 Climax | Draft |
| economy | specs/economy/phase-20-rewards.md | 49 Gift Baskets (300 coins), Level 10,000 Grand Climax Chest (5,000 coins + 15 boosters + Crown skin), and 20 Slither Rush events | Draft |
| ui | specs/ui/phase-20-ui-additions.md | Apex boss threat corridor projections, omni-key status pill, crown pedestal radiant aura, and stun stars | Draft |
| ui | specs/ui/phase-20-vfx.md | Boss telegraph roar shockwaves, charge dust trails, omni-key prismatic flash, and Level 10,000 sovereign coronation burst | Draft |
| tech | specs/tech/phase-20-qa-and-rollout.md | CI pre-validation suite, phase_20_meta.bin bundling, maxPhase rollout, and Phase 20 QA matrix | Draft |
