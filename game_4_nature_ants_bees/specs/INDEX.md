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
| gameplay | specs/gameplay/core-concept-and-rules.md | Core puzzle rules, two-layer board (ants/bees), movement/bonk, hearts, stars, and deterministic resolution | Draft |
| gameplay | specs/gameplay/level-progression-0001-0500.md | 500-level progression architecture, tiers, 10-level block patterns, FTUE onboarding, and L500 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-1.md | Complete catalog of 49 garden mechanics (M001–M049) and Phase 1 Finale with layer and hammer rules | Draft |
| economy | specs/economy/boosters-coins-shop.md | Boosters, coin economy, Queen's Gift Box, Golden Nectar Rush, Sunflower Spin, Shop catalog, ads, and VIP | Draft |
| meta | specs/meta/daily-challenge-and-streak.md | Daily Garden Almanac, 7 weekday modifiers, 7-day streak ladder, Queen's Favor, and platform leaderboards | Draft |
| ui | specs/ui/ui-ux-screens.md | Design tokens, soft-3D art direction, accessibility, responsive layout, and wireframes for all 18 screens | Draft |
| tech | specs/tech/frontend-implementation-and-qa.md | Flutter architecture, pure-Dart puzzle_core engine, BLoCs, CustomPainter renderer, storage, and QA matrix | Draft |
| audio | specs/audio/sound-effects.md | Audio engine, audioplayers setup, garden soundscape, layer-specific SFX, music loops, ducking, and QA | Draft |
| tech | specs/tech/logging-and-error-tracking.md | AppLogger ring buffer, file sink, Crashlytics, tap tracing, deterministic replay, and problem reporting | Draft |
| tech | specs/tech/performance-optimization.md | 60 fps low-tier performance budgets, on-demand Ticker, static layer caching, device tiers, and perf monitor | Draft |
| tech | specs/tech/splash-and-instant-launch.md | Instant launch pipeline with zero loading screens, native Android/iOS splash, and Garden Flight intro | Draft |
| ui | specs/ui/vfx-and-juice.md | Particle, shake, flash, and trail effects with tier limits, garden effect catalog, and VFX QA checklist | Draft |
| gameplay | specs/gameplay/phase-2-scope-and-rules.md | Phase 2 rule extensions: pinch-zoom/pan (>= 12x12), 8 diagonal directions, 3rd Canopy layer, and push blocks | Draft |
| gameplay | specs/gameplay/level-progression-0501-1000.md | Levels 501–1000 progression, P2-A/P2-B tiers, L501–510 zoom onboarding, and L1000 Midsummer Jubilee Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-2.md | Complete catalog of 49 Phase 2 mechanics (M051–M099), sunbeam optics, push physics, and Great Stag Beetle | Draft |
| meta | specs/meta/liveops-sticker-album.md | Flora & Fauna Compendium, 100 stickers across 5 volumes, retroactive grants, and Daily silhouette gallery | Draft |
| meta | specs/meta/liveops-weekly-star-race.md | Weekly Star Race (Garden Dash), 5-player async cohorts, server ghost fill, plausibility checks, and rewards | Draft |
| economy | specs/economy/piggy-bank-and-cosmetics.md | Golden Honeycomb Bank (₹49 IAP consumable) and Garden Wardrobe cosmetics shop with coin sink items | Draft |
| tech | specs/tech/offline-and-cloud-sync.md | Offline-first sync, Firebase Auth anonymous linking, Firestore op-log, and account deletion compliance | Draft |
| tech | specs/tech/auth-and-account-linking.md | Silent Google Sign-In, Firebase anonymous guest mode, persistent session tokens, and zero-loss account linking | Draft |
| tech | specs/tech/backend-cloud-functions-and-release-prerequisites.md | Cloud Functions suite (applyOps, race, piggy), Firestore security rules, App Check, and R1–R10 prerequisites | Draft |
| tech | specs/tech/frontend-and-qa-phase-2.md | Extended BLoCs/Cubits, BoardViewport transform engine, 3-layer renderer, and Phase 2 QA matrix | Draft |
| audio | specs/audio/sound-effects-phase-2.md | Phase 2 audio additions: canopy flight flutter, push physics, sunbeam optics hum, and LiveOps SFX | Draft |
| ui | specs/ui/vfx-phase-2.md | Phase 2 VFX: canopy 3rd layer sheen, diagonal trails, push-block dust, sunbeam rays, and Jubilee confetti | Draft |
| gameplay | specs/gameplay/phase-3-signature-system.md | Day & Night Garden Cycles (5-move period), Sun/Moon dial HUD, and cyclic tick order | Draft |
| gameplay | specs/gameplay/phase-3-base-mechanics.md | Base mechanics M101–M104 (Sunrise Gate, Moonlit Twig Bridge, Dawn Burrow, Day-Bloom Line) | Draft |
| gameplay | specs/gameplay/phase-3-variants-and-modifiers.md | 45 variant slots combining base mechanics with 10 generic modifiers across Levels 1001–1500 | Draft |
| gameplay | specs/gameplay/phase-3-level-plan-01001-01500.md | Levels 1001–1500 progression, P3-A/P3-B tiers, fixed plateau D band 60–76, and L1500 Finale | Draft |
| economy | specs/economy/phase-3-rewards.md | Queen's Gift Boxes (300 coins), Level 1500 Royal Honey Chest (1,000 coins), and Coin Rush | Draft |
| ui | specs/ui/phase-3-ui-additions.md | Sun/Moon cycle dial HUD, variant tutorial cards, and color-blind shape encodings | Draft |
| ui | specs/ui/phase-3-vfx.md | Ambient cycle transitions, M101–M104 particle effects, and Level 1500 Finale visual burst | Draft |
| tech | specs/tech/phase-3-qa-and-rollout.md | CI pre-validation suite, phase_3_meta.bin bundling, maxPhase rollout, and Phase 3 QA matrix | Draft |
| tech | specs/tech/on-device-level-generation.md | Core on-device level generator, reverse construction, IDA* solver, xoshiro128**, and cache freeze | Draft |
| gameplay | specs/gameplay/phase-4-signature-system.md | Garden Terraces multi-floor system (up to 3 floors), vertical raycasting, and floor switcher | Draft |
| gameplay | specs/gameplay/phase-4-base-mechanics.md | Base mechanics M151–M154 (Root Stairs, Dew-Glass Terrace, Rabbit Hole, Acorn Lift) | Draft |
| gameplay | specs/gameplay/phase-4-variants-and-modifiers.md | 45 variant slots combining multi-floor mechanics with 10 generic modifiers across Levels 1501–2000 | Draft |
| gameplay | specs/gameplay/phase-4-level-plan-01501-02000.md | Levels 1501–2000 progression, P4-A/P4-B tiers, fixed plateau D band 60–76, and L2000 Finale | Draft |
| economy | specs/economy/phase-4-rewards.md | Queen's Gift Boxes (300 coins), Level 2000 Royal Honey Chest (1,000 coins), and Coin Rush | Draft |
| ui | specs/ui/phase-4-ui-additions.md | Multi-Floor vertical tabs HUD, inter-floor camera slide transitions, and tutorial cards | Draft |
| ui | specs/ui/phase-4-vfx.md | Vertical parallax camera glide, M151–M154 particle effects, and Level 2000 Finale canopy burst | Draft |
| tech | specs/tech/phase-4-qa-and-rollout.md | CI pre-validation suite, phase_4_meta.bin bundling, maxPhase rollout, and Phase 4 QA matrix | Draft |
| gameplay | specs/gameplay/phase-5-signature-system.md | Acorn Physics push system, momentum sliding, and pit filling terrain modification | Draft |
| gameplay | specs/gameplay/phase-5-base-mechanics.md | Base mechanics M201–M204 (Mole Hole, Dewdrop Marble, Seed Key Pod, Stone Pumpkin) | Draft |
| gameplay | specs/gameplay/phase-5-variants-and-modifiers.md | 45 variant slots combining push mechanics with 10 generic modifiers across Levels 2001–2500 | Draft |
| gameplay | specs/gameplay/phase-5-level-plan-02001-02500.md | Levels 2001–2500 progression, P5-A/P5-B tiers, fixed plateau D band 60–76, and L2500 Finale | Draft |
| economy | specs/economy/phase-5-rewards.md | Queen's Gift Boxes (300 coins), Level 2500 Royal Honey Chest (1,000 coins), and Coin Rush | Draft |
| ui | specs/ui/phase-5-ui-additions.md | Push trajectory cues, boulder warning feedback, and pit transformation UI indicators | Draft |
| ui | specs/ui/phase-5-vfx.md | Sliding mist trails, pit settling dust, key burst flare, and Level 2500 Finale shrine burst | Draft |
| tech | specs/tech/phase-5-qa-and-rollout.md | CI pre-validation suite, phase_5_meta.bin bundling, maxPhase rollout, and Phase 5 QA matrix | Draft |
| gameplay | specs/gameplay/phase-6-signature-system.md | Sunlit Garden light & beams system, raycasting engine, and shade patch awakening | Draft |
| gameplay | specs/gameplay/phase-6-base-mechanics.md | Base mechanics M251–M254 (Petal Filter, Twin-Sun Lock, Sundial Lens, Shade Patch) | Draft |
| gameplay | specs/gameplay/phase-6-variants-and-modifiers.md | 45 variant slots combining optical mechanics with 10 generic modifiers across Levels 2501–3000 | Draft |
| gameplay | specs/gameplay/phase-6-level-plan-02501-03000.md | Levels 2501–3000 progression, P6-A/P6-B tiers, fixed plateau D band 60–76, and L3000 Finale | Draft |
| economy | specs/economy/phase-6-rewards.md | Queen's Gift Boxes (300 coins), Level 3000 Royal Honey Chest (1,000 coins), and Coin Rush | Draft |
| ui | specs/ui/phase-6-ui-additions.md | Sundial move-count HUD badges, shade patch sleeping cues, and optical filter color guides | Draft |
| ui | specs/ui/phase-6-vfx.md | Sunbeam laser glows, petal filter color blooms, shade awakening sparks, and L3000 zenith flare | Draft |
| tech | specs/tech/phase-6-qa-and-rollout.md | CI pre-validation suite, phase_6_meta.bin bundling, maxPhase rollout, and Phase 6 QA matrix | Draft |
| gameplay | specs/gameplay/phase-7-signature-system.md | Whirling Garden rotation system (90° CW matrix), turntable containment, and perimeter hedge | Draft |
| gameplay | specs/gameplay/phase-7-base-mechanics.md | Base mechanics M301–M304 (Flower-Bed Turntable, Turning Hedge, Spinning Top Line, Pinned Daisy) | Draft |
| gameplay | specs/gameplay/phase-7-variants-and-modifiers.md | 45 variant slots combining rotation mechanics with 10 generic modifiers across Levels 3001–3500 | Draft |
| gameplay | specs/gameplay/phase-7-level-plan-03001-03500.md | Levels 3001–3500 progression, P7-A/P7-B tiers, fixed plateau D band 60–76, and L3500 Finale | Draft |
| economy | specs/economy/phase-7-rewards.md | Queen's Gift Boxes (300 coins), Level 3500 Royal Honey Chest (1,000 coins), and Coin Rush | Draft |
| ui | specs/ui/phase-7-ui-additions.md | Turntable button indicators, spinning line propeller icons, and rotating edge gap cues | Draft |
| ui | specs/ui/phase-7-vfx.md | Turntable sector spin, turning hedge sweep, spinning top propeller blur, and L3500 blossom cyclone | Draft |
| tech | specs/tech/phase-7-qa-and-rollout.md | CI pre-validation suite, phase_7_meta.bin bundling, maxPhase rollout, and Phase 7 QA matrix | Draft |
| gameplay | specs/gameplay/phase-8-signature-system.md | Bloom Season (Growth) signature system: vine cross-expansion BFS, pruning logic, tick order, and Remote Config keys | Draft |
| gameplay | specs/gameplay/phase-8-base-mechanics.md | Base mechanics M351–M354 (Morning Glory Vine, Garden Shears, Seed-Dropping Line, Pollination Gate) | Draft |
| gameplay | specs/gameplay/phase-8-variants-and-modifiers.md | 45 variant slots combining Growth mechanics with 10 generic modifiers across Levels 3501–4000 | Draft |
| gameplay | specs/gameplay/phase-8-level-plan-03501-04000.md | Levels 3501–4000 progression, P8-A/P8-B tiers, fixed plateau D band 60–76, and L4000 Eternal Bloom Gala | Draft |
| economy | specs/economy/phase-8-rewards.md | Queen's Gift Boxes (300 coins), Level 4000 Royal Honey Chest (1,000 coins + Master Florist badge), and Rush rounds | Draft |
| ui | specs/ui/phase-8-ui-additions.md | Vine pulse indicator, shears snip cue, seed countdown badge, pollination gate meter, and tutorial cards | Draft |
| ui | specs/ui/phase-8-vfx.md | Vine expansion, shears snip, seed drop/sprout, gate pollination sparkle, and L4000 Eternal Bloom Gala confetti | Draft |
| tech | specs/tech/phase-8-qa-and-rollout.md | CI seed validation, vine BFS performance budget, phase_8_meta.bin, maxPhase rollout, and Phase 8 QA matrix | Draft |
| gameplay | specs/gameplay/phase-9-signature-system.md | Swarm Splits (Split & Merge) signature system: line splitting, caravan coupling, atomic clearance, and tick order | Draft |
| gameplay | specs/gameplay/phase-9-base-mechanics.md | Base mechanics M401–M404 (Honey Merge Pad, Fork Twig, Segment Clasp, Reunion Arch) | Draft |
| gameplay | specs/gameplay/phase-9-variants-and-modifiers.md | 45 variant slots combining Split & Merge mechanics with 10 generic modifiers across Levels 4001–4500 | Draft |
| gameplay | specs/gameplay/phase-9-level-plan-04001-04500.md | Levels 4001–4500 progression, P9-A/P9-B tiers, fixed plateau D band 60–76, and L4500 Great Swarm Reunion | Draft |
| economy | specs/economy/phase-9-rewards.md | Queen's Gift Boxes (300 coins), Level 4500 Royal Honey Chest (1,000 coins + Swarm Conductor badge), and Rush rounds | Draft |
| ui | specs/ui/phase-9-ui-additions.md | Merge pad sticky pool UI, fork branch trajectory preview, segment clasp badge, and tutorial cards | Draft |
| ui | specs/ui/phase-9-vfx.md | Merge fusion, fork split, clasp unlock, arch opening, and L4500 Great Swarm Reunion celebration effects | Draft |
| tech | specs/tech/phase-9-qa-and-rollout.md | CI seed validation suite, branch routing budget, phase_9_meta.bin, maxPhase rollout, and Phase 9 QA matrix | Draft |
| gameplay | specs/gameplay/phase-10-signature-system.md | Garden Rhythm (Sequencing) signature system: modulo cycle evaluation, FIFO color tracking, and queue enforcement | Draft |
| gameplay | specs/gameplay/phase-10-base-mechanics.md | Base mechanics M451–M454 (Cricket Gate, Bead-String Lock, Queue Hedge, Echo Bloom) | Draft |
| gameplay | specs/gameplay/phase-10-variants-and-modifiers.md | 45 variant slots combining Sequencing mechanics with 10 generic modifiers across Levels 4501–5000 | Draft |
| gameplay | specs/gameplay/phase-10-level-plan-04501-05000.md | Levels 4501–5000 progression, P10-A/P10-B tiers, fixed plateau D band 60–76, and L5000 Mid-Season Symphony Gala | Draft |
| economy | specs/economy/phase-10-rewards.md | Queen's Gift Boxes (300 coins), Level 5000 Royal Honey Chest (1,000 coins + Rhythm Maestro badge), and Rush rounds | Draft |
| ui | specs/ui/phase-10-ui-additions.md | Rhythm cycle indicator, bead-string HUD bar, queue number plates, echo bloom overlay, and tutorial cards | Draft |
| ui | specs/ui/phase-10-vfx.md | Cricket pulse, bead match, queue exit, echo playback, and L5000 Mid-Season Symphony celebration effects | Draft |
| tech | specs/tech/phase-10-qa-and-rollout.md | CI seed validation suite, rhythm engine performance budget, phase_10_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-11-signature-system.md | Twin Gardens (Linked Boards) signature system: cross-board boundary links, remote keys, mirror lines, and relay burrows | Draft |
| gameplay | specs/gameplay/phase-11-base-mechanics.md | Base mechanics M501–M504 (Garden Gate Link, Pen-Pal Key, Reflecting Pond Board, Relay Burrow) | Draft |
| gameplay | specs/gameplay/phase-11-variants-and-modifiers.md | 45 variant slots combining Linked Boards mechanics with 10 generic modifiers across Levels 5001–5500 | Draft |
| gameplay | specs/gameplay/phase-11-level-plan-05001-05500.md | Levels 5001–5500 progression, P11-A/P11-B tiers, fixed plateau D band 60–76, and L5500 Twin Garden Jubilee | Draft |
| economy | specs/economy/phase-11-rewards.md | Queen's Gift Boxes (300 coins), Level 5500 Royal Honey Chest (1,000 coins + Twin Realm Navigator badge), and Rush rounds | Draft |
| ui | specs/ui/phase-11-ui-additions.md | Dual-board viewport toggle bar, link mini-map widget, connection beams, and tutorial cards | Draft |
| ui | specs/ui/phase-11-vfx.md | Gate link boundary crossing, cross-board unlock, mirror sync, burrow teleport, and L5500 Twin Jubilee effects | Draft |
| tech | specs/tech/phase-11-qa-and-rollout.md | CI seed validation suite, dual viewport memory budget, phase_11_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-12-signature-system.md | Falling Leaves (Gravity) signature system: directional gravity settlement, lever vector shifts, and anti-gravity zones | Draft |
| gameplay | specs/gameplay/phase-12-base-mechanics.md | Base mechanics M551–M554 (Wind-Vane Lever, Falling Acorns, Dandelion Puff Tile, Heavy Beetle Line) | Draft |
| gameplay | specs/gameplay/phase-12-variants-and-modifiers.md | 45 variant slots combining Gravity mechanics with 10 generic modifiers across Levels 5501–6000 | Draft |
| gameplay | specs/gameplay/phase-12-level-plan-05501-06000.md | Levels 5501–6000 progression, P12-A/P12-B tiers, fixed plateau D band 60–76, and L6000 Autumn Gale Gala | Draft |
| economy | specs/economy/phase-12-rewards.md | Queen's Gift Boxes (300 coins), Level 6000 Royal Honey Chest (1,000 coins + Wind Whisperer badge), and Rush rounds | Draft |
| ui | specs/ui/phase-12-ui-additions.md | Global gravity compass HUD, dandelion floating aura, heavy beetle weight badge, and tutorial cards | Draft |
| ui | specs/ui/phase-12-vfx.md | Gravity shift wind sweep, acorn tumble, dandelion zero-g float, and L6000 Autumn Gale celebration effects | Draft |
| tech | specs/tech/phase-12-qa-and-rollout.md | CI seed validation suite, gravity settlement performance budget, phase_12_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-13-signature-system.md | Mystery Meadow (Hidden Info) signature system: Chebyshev fog clearing, tap protection, and sunlit crosshair reveals | Draft |
| gameplay | specs/gameplay/phase-13-base-mechanics.md | Base mechanics M601–M604 (Scout Ant, Mirage Mist, Painted Pebble, Sunlit Plate) | Draft |
| gameplay | specs/gameplay/phase-13-variants-and-modifiers.md | 45 variant slots combining Hidden Info mechanics with 10 generic modifiers across Levels 6001–6500 | Draft |
| gameplay | specs/gameplay/phase-13-level-plan-06001-06500.md | Levels 6001–6500 progression, P13-A/P13-B tiers, fixed plateau D band 60–76, and L6500 Solstice Dawn Gala | Draft |
| economy | specs/economy/phase-13-rewards.md | Queen's Gift Boxes (300 coins), Level 6500 Royal Honey Chest (1,000 coins + Meadow Clairvoyant badge), and Rush rounds | Draft |
| ui | specs/ui/phase-13-ui-additions.md | Volumetric fog shader, scout ant radar rings, painted pebble inspection badge, and tutorial cards | Draft |
| ui | specs/ui/phase-13-vfx.md | Fog dissolve sunbeams, mirage mist burst, false wall crumble, and L6500 Solstice Dawn celebration effects | Draft |
| tech | specs/tech/phase-13-qa-and-rollout.md | CI seed validation suite, fog mask rendering budget, phase_13_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-14-signature-system.md | Reflecting Pond (Mirror Worlds) signature system: bilateral symmetry transforms, synchronized movement, and reflection locks | Draft |
| gameplay | specs/gameplay/phase-14-base-mechanics.md | Base mechanics M651–M654 (Pond Axis, Reflection Lock, Twin Pond, Upside-Down Line) | Draft |
| gameplay | specs/gameplay/phase-14-variants-and-modifiers.md | 45 variant slots combining Mirror Worlds mechanics with 10 generic modifiers across Levels 6501–7000 | Draft |
| gameplay | specs/gameplay/phase-14-level-plan-06501-07000.md | Levels 6501–7000 progression, P14-A/P14-B tiers, fixed plateau D band 60–76, and L7000 Mirrored Solstice Gala | Draft |
| economy | specs/economy/phase-14-rewards.md | Queen's Gift Boxes (300 coins), Level 7000 Royal Honey Chest (1,000 coins + Mirror Mirage Master badge), and Rush rounds | Draft |
| ui | specs/ui/phase-14-ui-additions.md | Pond axis water shader, mirrored twin target highlight, upside-down line badge, and tutorial cards | Draft |
| ui | specs/ui/phase-14-vfx.md | Axis ripple waves, reflection unlock splash, twin pond ripple, and L7000 Mirrored Solstice celebration effects | Draft |
| tech | specs/tech/phase-14-qa-and-rollout.md | CI seed validation suite, bilateral symmetry performance budget, phase_14_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-15-signature-system.md | Brook & Rails (Conveyors & Tracks) signature system: water conveyor drift vectors, sluice routing, and ant-only transport | Draft |
| gameplay | specs/gameplay/phase-15-base-mechanics.md | Base mechanics M701–M704 (Brook Fork, Tide Brook, Sluice Lever, Lazy River) | Draft |
| gameplay | specs/gameplay/phase-15-variants-and-modifiers.md | 45 variant slots combining Conveyors & Tracks mechanics with 10 generic modifiers across Levels 7001–7500 | Draft |
| gameplay | specs/gameplay/phase-15-level-plan-07001-07500.md | Levels 7001–7500 progression, P15-A/P15-B tiers, fixed plateau D band 60–76, and L7500 Rushing Waters Gala | Draft |
| economy | specs/economy/phase-15-rewards.md | Queen's Gift Boxes (300 coins), Level 7500 Royal Honey Chest (1,000 coins + River Master badge), and Rush rounds | Draft |
| ui | specs/ui/phase-15-ui-additions.md | Flowing water texture shader, sluice valve state indicator, tidal countdown badge, and tutorial cards | Draft |
| ui | specs/ui/phase-15-vfx.md | Water drift foam wakes, sluice gate flip splash, tidal reversal wave, and L7500 Rushing Waters celebration effects | Draft |
| tech | specs/tech/phase-15-qa-and-rollout.md | CI seed validation suite, conveyor drift performance budget, phase_15_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-16-signature-system.md | Royal Keyring (Keys Deluxe) signature system: chained locks, multi-part synthesis, row/col clearing, and key swapping | Draft |
| gameplay | specs/gameplay/phase-16-base-mechanics.md | Base mechanics M751–M754 (Dew Key Chain, Key-Crafting Flower, Skeleton Dew Key, Key Swap Pad) | Draft |
| gameplay | specs/gameplay/phase-16-variants-and-modifiers.md | 45 variant slots combining Keys Deluxe mechanics with 10 generic modifiers across Levels 7501–8000 | Draft |
| gameplay | specs/gameplay/phase-16-level-plan-07501-08000.md | Levels 7501–8000 progression, P16-A/P16-B tiers, fixed plateau D band 60–76, and L8000 Queen's Royal Lock Gala | Draft |
| economy | specs/economy/phase-16-rewards.md | Queen's Gift Boxes (300 coins), Level 8000 Royal Honey Chest (1,000 coins + Master Keywright badge), and Rush rounds | Draft |
| ui | specs/ui/phase-16-ui-additions.md | Keyring HUD bar, key crafting petal fusion indicator, skeleton crown shimmer, and tutorial cards | Draft |
| ui | specs/ui/phase-16-vfx.md | Chain key hops, key crafting synthesis flash, skeleton light wave sweep, and L8000 Lock Gala celebration effects | Draft |
| tech | specs/tech/phase-16-qa-and-rollout.md | CI seed validation suite, key graph verification budget, phase_16_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-17-signature-system.md | Garden Guardians signature system: 2x2 boss obstacles, shared HP, armor stripping, periodic spawners, and core hits | Draft |
| gameplay | specs/gameplay/phase-17-base-mechanics.md | Base mechanics M801–M804 (Twin Hornets, Armored Rhino Beetle, Wasp Nest Guardian, Heart-Seed Guardian) | Draft |
| gameplay | specs/gameplay/phase-17-variants-and-modifiers.md | 45 variant slots combining Garden Guardians mechanics with 10 generic modifiers across Levels 8001–8500 | Draft |
| gameplay | specs/gameplay/phase-17-level-plan-08001-08500.md | Levels 8001–8500 progression, P17-A/P17-B tiers, fixed plateau D band 60–76, and L8500 Royal Hive Defense Gala | Draft |
| economy | specs/economy/phase-17-rewards.md | Queen's Gift Boxes (300 coins), Level 8500 Royal Honey Chest (1,000 coins + Hive Protector badge), and Rush rounds | Draft |
| ui | specs/ui/phase-17-ui-additions.md | Boss segmented HP bar, armor shell overlay, spawner pulse counter, core reticle, and tutorial cards | Draft |
| ui | specs/ui/phase-17-vfx.md | Guardian hit sparks, armor shell fracture chime, mud blocker spawn pop, and L8500 Hive Defense celebration effects | Draft |
| tech | specs/tech/phase-17-qa-and-rollout.md | CI seed validation suite, boss logic execution budget, phase_17_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-18-signature-system.md | Garden Festival I (Remix A) signature system: data-driven candidate selection and parent rule composition (P1–P6) | Draft |
| gameplay | specs/gameplay/phase-18-base-mechanics.md | Base combo mechanics M851–M854 (Day-Night Terrace, Sunlit Acorn, Shaded Stairs, Dawn Marble) | Draft |
| gameplay | specs/gameplay/phase-18-variants-and-modifiers.md | 45 variant slots combining Remix A combo mechanics with 10 generic modifiers across Levels 8501–9000 | Draft |
| gameplay | specs/gameplay/phase-18-level-plan-08501-09000.md | Levels 8501–9000 progression, P18-A/P18-B tiers, fixed plateau D band 60–76, and L9000 Sun & Shadows Gala | Draft |
| economy | specs/economy/phase-18-rewards.md | Queen's Gift Boxes (300 coins), Level 9000 Royal Honey Chest (1,000 coins + Festival Grandee badge), and Rush rounds | Draft |
| ui | specs/ui/phase-18-ui-additions.md | Cycle-floor dual badge, prism reflection cue, shaded stairs illumination ring, and tutorial cards | Draft |
| ui | specs/ui/phase-18-vfx.md | Terrace cycle bloom/sink, acorn beam deflection flash, shaded stair light, and L9000 Festival Gala celebration effects | Draft |
| tech | specs/tech/phase-18-qa-and-rollout.md | CI seed validation suite, hybrid multi-floor raycast solver budget, phase_18_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-19-signature-system.md | Garden Festival II (Remix B) signature system: kinetic multi-system composition and deterministic settlement (P7–P12) | Draft |
| gameplay | specs/gameplay/phase-19-base-mechanics.md | Base combo mechanics M901–M904 (Falling Vines, Rhythm Rotor, Twin-Garden Fork, Gravity Turntable) | Draft |
| gameplay | specs/gameplay/phase-19-variants-and-modifiers.md | 45 variant slots combining Remix B combo mechanics with 10 generic modifiers across Levels 9001–9500 | Draft |
| gameplay | specs/gameplay/phase-19-level-plan-09001-09500.md | Levels 9001–9500 progression, P19-A/P19-B tiers, fixed plateau D band 60–76, and L9500 Winds & Blooms Gala | Draft |
| economy | specs/economy/phase-19-rewards.md | Queen's Gift Boxes (300 coins), Level 9500 Royal Honey Chest (1,000 coins + Master Composer badge), and Rush rounds | Draft |
| ui | specs/ui/phase-19-ui-additions.md | Gravity-growth composite indicator, rhythm rotor beat halo, cross-board split portals, and tutorial cards | Draft |
| ui | specs/ui/phase-19-vfx.md | Vine slide dust puffs, auto-rotor turn chimes, cross-board split warp, and L9500 Winds & Blooms celebration effects | Draft |
| tech | specs/tech/phase-19-qa-and-rollout.md | CI seed validation suite, kinetic multi-system settlement budget, phase_19_meta.bin, maxPhase rollout, and QA matrix | Draft |
| gameplay | specs/gameplay/phase-20-signature-system.md | Grand Master Garden signature system: 9-step deterministic tick order, all-systems integration, and L10,000 Grand Finale | Draft |
| gameplay | specs/gameplay/phase-20-base-mechanics.md | Base grand combo mechanics M951–M954 (Eternal Bloom Canopy, Twin Cascade Nexus, Shrouded Guardian Aegis, Prismatic Rhythm Turntable) | Draft |
| gameplay | specs/gameplay/phase-20-variants-and-modifiers.md | 44 variant slots combining Grand Master mechanics with 10 generic modifiers across Levels 9501–10,000 | Draft |
| gameplay | specs/gameplay/phase-20-level-plan-09501-10000.md | Levels 9501–10,000 progression, P20-A/P20-B tiers, fixed plateau D band 60–76, and L10,000 Queen's Eternal Garden | Draft |
| economy | specs/economy/phase-20-rewards.md | Queen's Gift Boxes (300 coins), Level 10,000 Grand Royal Honey Chest (1,000 coins + Eternal Hive Champion badge), and Endless mode | Draft |
| ui | specs/ui/phase-20-ui-additions.md | Grand Master systems HUD, bloom canopy stage ring, cascade gravity arrows, shrouded guardian key progress, and tutorial cards | Draft |
| ui | specs/ui/phase-20-vfx.md | Canopy bloom pollen, cascade stream warp, shrouded guardian unlock shatter, and L10,000 Queen's Coronation celebration effects | Draft |
| tech | specs/tech/phase-20-qa-and-rollout.md | CI seed validation suite, all-systems full tick resolution budget, phase_20_meta.bin, maxPhase rollout, and QA matrix | Draft |
