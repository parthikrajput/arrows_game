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
| gameplay | specs/gameplay/core-concept-and-rules.md | Core railway rules, board/train models, move resolution lifecycle, and buffer clack bump logic | Draft |
| gameplay | specs/gameplay/level-progression-0001-0500.md | 500-level progression architecture, difficulty D scaling, 10-level blocks, FTUE sequence, and L500 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-1.md | Catalog of 49 railway mechanics (M001–M049) and L500 Grand Central Finale with collision, hammer, and solver rules | Draft |
| economy | specs/economy/boosters-coins-shop.md | Boosters, coins economy, Conductor's Gift Crates, Golden Express Coin Rush, Lucky Turntable, Shop, ads, and VIP | Draft |
| meta | specs/meta/daily-challenge-and-streak.md | Daily Timetable Run, 7 weekday modifiers, silhouettes, 7-day Express Streak ladder, Saver, and leaderboards | Draft |
| ui | specs/ui/ui-ux-screens.md | Design tokens, color-blind palette, responsive layout rules, and wireframes for all 18 screens and dialogs | Draft |
| tech | specs/tech/frontend-implementation-and-qa.md | Flutter architecture, pure-Dart puzzle_core engine, BLoCs, CustomPainter renderer, persistence, and QA matrix | Draft |
| audio | specs/audio/sound-effects.md | Railway audio engine, audioplayers SoundPool setup, wooden toy ASMR sounds, music loops, ducking, and audio QA | Draft |
| tech | specs/tech/logging-and-error-tracking.md | AppLogger ring buffer and file sink, Crashlytics, tap tracing, deterministic replay, and diagnostic reporting | Draft |
| tech | specs/tech/performance-optimization.md | 60 fps low-tier performance budgets, on-demand Ticker, static layer caching, device tiers, and perf monitor | Draft |
| tech | specs/tech/splash-and-instant-launch.md | Instant launch pipeline with zero loading screens, native Android/iOS splash, and Toy Box Lid intro | Draft |
| ui | specs/ui/vfx-and-juice.md | Particle, shake, flash and trail effects with tier limits, per-event effect catalog, and VFX QA checklist | Draft |
| gameplay | specs/gameplay/phase-2-scope-and-rules.md | Phase 2 scope, pinch-zoom/pan on 12x12+ boards, diagonal trains, 3 layers, push physics, and turn tick pipeline | Draft |
| gameplay | specs/gameplay/level-progression-0501-1000.md | 500-level progression architecture for P2-A/P2-B tiers, L501–510 onboarding, 50-block rhythm, and L1000 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-2.md | Comprehensive catalog of 49 railway mechanics (M051–M099) and L1000 Grand Terminus Finale boss board | Draft |
| meta | specs/meta/liveops-sticker-album.md | Depot Sticker Album meta-system with 100 milestone stickers across 5 volumes, retroactive grants, and cosmetics | Draft |
| meta | specs/meta/liveops-weekly-star-race.md | Star Express Race weekly 5-player async tournament, ghost backfill algorithm, and server validation | Draft |
| economy | specs/economy/piggy-bank-and-cosmetics.md | Ticket Piggy Bank IAP (₹49, max 1000 coins) and Train Shed Cosmetics shop (800–4000 coin liveries & tables) | Draft |
| tech | specs/tech/offline-and-cloud-sync.md | Local-first op-log cloud synchronization with Firebase Auth, Firestore models, conflict resolution, and deletion | Draft |
| tech | specs/tech/auth-and-account-linking.md | Silent Google Sign-In, Firebase anonymous guest mode, persistent session tokens, and zero-loss account linking | Draft |
| tech | specs/tech/backend-cloud-functions-and-release-prerequisites.md | Cloud Functions suite (applyOps, verifyPurchase, race), security rules, and R1–R10 release prerequisites | Draft |
| tech | specs/tech/frontend-and-qa-phase-2.md | Frontend BLoC architecture, Impeller shader warmup, Remote Config telemetry keys, and QA-P2 acceptance matrix | Draft |
| audio | specs/audio/sound-effects-phase-2.md | Phase 2 audio expansions, P2-A/P2-B music loops, L1000 Finale track, M051–M099 SFX, and LiveOps audio stings | Draft |
| ui | specs/ui/vfx-phase-2.md | Phase 2 visual effects, diagonal trails, optical beam shaders, 3-layer shadows, and LiveOps celebration juice | Draft |
| gameplay | specs/gameplay/phase-3-signature-system.md | Phase 3 signature system Day & Night Timetable (Cycles S03), 5-move flip, Sun/Moon dial, and tick pipeline | Draft |
| gameplay | specs/gameplay/phase-3-base-mechanics.md | Phase 3 base mechanics M101–M104 (Day/Night Gate, Overpass, Tunnel, Livery) with collision and schemas | Draft |
| gameplay | specs/gameplay/phase-3-variants-and-modifiers.md | Ten standard railway modifiers and 45 variant slot mappings across Phase 3 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-3-level-plan-01001-01500.md | 500-level procedural plan for P3-A/P3-B, D 60–76 difficulty plateau, L1491 review, and L1500 Finale | Draft |
| economy | specs/economy/phase-3-rewards.md | Phase 3 rewards, 49 Gift Crates (300 coins), L1500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-3-ui-additions.md | Top HUD Sun/Moon Timetable dial, ambient tabletop day/night lighting tweens, and tutorial cards | Draft |
| ui | specs/ui/phase-3-vfx.md | Day & Night lighting transitions, cyclic mechanic particle effects, and device tier performance limits | Draft |
| tech | specs/tech/phase-3-qa-and-rollout.md | CI seed validation pipeline, binary metadata (phase_3_meta.bin), generation budgets, and QA checklist | Draft |
| tech | specs/tech/on-device-level-generation.md | Shared procedural generation engine, xoshiro128** PRNG, reverse construction, IDA* solver, and cache freeze | Draft |
| gameplay | specs/gameplay/phase-4-signature-system.md | Phase 4 signature system Station Floors (Multi-Floor S04), F1/F2/F3 tabs, and 3D navigation pipeline | Draft |
| gameplay | specs/gameplay/phase-4-base-mechanics.md | Phase 4 base mechanics M151–M154 (Station Stairs, Glass Platform, Goods Chute, Goods Lift) with schemas | Draft |
| gameplay | specs/gameplay/phase-4-variants-and-modifiers.md | Ten standard railway modifiers and 45 multi-floor variant slot mappings across Phase 4 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-4-level-plan-01501-02000.md | 500-level multi-floor procedural plan for P4-A/P4-B, D 60–76 difficulty plateau, and L2000 Finale | Draft |
| economy | specs/economy/phase-4-rewards.md | Phase 4 rewards, 49 Gift Crates (300 coins), L2000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-4-ui-additions.md | Vertical floor selector tabs (F1/F2/F3), camera vertical slide transitions, and tutorial cards | Draft |
| ui | specs/ui/phase-4-vfx.md | Multi-floor camera transition juice, vertical elevation steam, hydraulic lifts, and tier particle caps | Draft |
| tech | specs/tech/phase-4-qa-and-rollout.md | CI multi-floor seed validation pipeline, binary metadata (phase_4_meta.bin), and QA-P4 matrix | Draft |
| gameplay | specs/gameplay/phase-5-signature-system.md | Phase 5 signature system Yard Shunting+ (Push Physics S05), cart displacement, and shunting pipeline | Draft |
| gameplay | specs/gameplay/phase-5-base-mechanics.md | Phase 5 base mechanics M201–M204 (Cart Pit, Ice Cart, Ticket Cart, Ballast Cart) with schemas | Draft |
| gameplay | specs/gameplay/phase-5-variants-and-modifiers.md | Ten standard railway modifiers and 45 shunting variant slot mappings across Phase 5 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-5-level-plan-02001-02500.md | 500-level shunting procedural plan for P5-A/P5-B, D 60–76 difficulty plateau, and L2500 Finale | Draft |
| economy | specs/economy/phase-5-rewards.md | Phase 5 rewards, 49 Gift Crates (300 coins), L2500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-5-ui-additions.md | Shunting push vector guides, cart weight resistance badges, pit fill visuals, and tutorial cards | Draft |
| ui | specs/ui/phase-5-vfx.md | Shunting impact buffers, continuous ice sliding mist, ballast resistance soot, and tier particle caps | Draft |
| tech | specs/tech/phase-5-qa-and-rollout.md | CI shunting seed validation pipeline, binary metadata (phase_5_meta.bin), and QA-P5 matrix | Draft |
| gameplay | specs/gameplay/phase-6-signature-system.md | Phase 6 signature system Signal Lights+ (Optical Beams S06), chromatic filters, and ray-tracing | Draft |
| gameplay | specs/gameplay/phase-6-base-mechanics.md | Phase 6 base mechanics M251–M254 (Coloured Lens, Twin Sensor, Lamp Timer, Blackout Patch) with schemas | Draft |
| gameplay | specs/gameplay/phase-6-variants-and-modifiers.md | Ten standard railway modifiers and 45 optical variant slot mappings across Phase 6 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-6-level-plan-02501-03000.md | 500-level optical procedural plan for P6-A/P6-B, D 60–76 difficulty plateau, and L3000 Finale | Draft |
| economy | specs/economy/phase-6-rewards.md | Phase 6 rewards, 49 Gift Crates (300 coins), L3000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-6-ui-additions.md | Chromatic beam rendering, twin-sensor status LEDs, timer countdown rings, and tutorial cards | Draft |
| ui | specs/ui/phase-6-vfx.md | Optical beam glare flares, lens refraction sparkles, blackout reveals, and tier particle caps | Draft |
| tech | specs/tech/phase-6-qa-and-rollout.md | CI optical seed validation pipeline, binary metadata (phase_6_meta.bin), and QA-P6 matrix | Draft |
| gameplay | specs/gameplay/phase-7-signature-system.md | Phase 7 signature system Turntable Yards+ (Rotations S07), 4x4 sub-board rotor matrix, and moving exits | Draft |
| gameplay | specs/gameplay/phase-7-base-mechanics.md | Phase 7 base mechanics M301–M304 (4x4 Rotor, Spinning Exits, Spinner Engine, Turntable Lock) with schemas | Draft |
| gameplay | specs/gameplay/phase-7-variants-and-modifiers.md | Ten standard railway modifiers and 45 rotational variant slot mappings across Phase 7 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-7-level-plan-03001-03500.md | 500-level rotational procedural plan for P7-A/P7-B, D 60–76 difficulty plateau, and L3500 Finale | Draft |
| economy | specs/economy/phase-7-rewards.md | Phase 7 rewards, 49 Gift Crates (300 coins), L3500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-7-ui-additions.md | 4x4 sub-board rotor disc rendering, perimeter moving exit indicators, and tutorial cards | Draft |
| ui | specs/ui/phase-7-vfx.md | Rotor friction sparks, gear locking clacks, clockwork twirl sparkles, and tier particle caps | Draft |
| tech | specs/tech/phase-7-qa-and-rollout.md | CI rotational solver validation pipeline, binary metadata (phase_7_meta.bin), and QA-P7 matrix | Draft |
| gameplay | specs/gameplay/phase-8-signature-system.md | Phase 8 signature system Overgrown Branch Line (Growth S08), cellular automata ivy spread, and pruners | Draft |
| gameplay | specs/gameplay/phase-8-base-mechanics.md | Phase 8 base mechanics M351–M354 (Wild Ivy+, Hedge Trimmer, Seed Wagon, Flower Arch) with schemas | Draft |
| gameplay | specs/gameplay/phase-8-variants-and-modifiers.md | Ten standard railway modifiers and 45 botanical variant slot mappings across Phase 8 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-8-level-plan-03501-04000.md | 500-level botanical procedural plan for P8-A/P8-B, D 60–76 difficulty plateau, and L4000 Finale | Draft |
| economy | specs/economy/phase-8-rewards.md | Phase 8 rewards, 49 Gift Crates (300 coins), L4000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-8-ui-additions.md | Procedural ivy vine rendering, hedge trimmer scythe animations, and tutorial cards | Draft |
| ui | specs/ui/phase-8-vfx.md | Foliage sprout pops, leaf shredding showers, floral petal bursts, and tier particle caps | Draft |
| tech | specs/tech/phase-8-qa-and-rollout.md | CI botanical growth solver validation pipeline, binary metadata (phase_8_meta.bin), and QA-P8 matrix | Draft |
| gameplay | specs/gameplay/phase-9-signature-system.md | Phase 9 signature system Couple & Uncouple (Train Composition S09), dynamic train splitting and merging | Draft |
| gameplay | specs/gameplay/phase-9-base-mechanics.md | Phase 9 base mechanics M401–M404 (Coupling Pad, Twin Split Train, Coupling Lock, Rejoin Arch) with schemas | Draft |
| gameplay | specs/gameplay/phase-9-variants-and-modifiers.md | Ten standard railway modifiers and 45 coupling variant slot mappings across Phase 9 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-9-level-plan-04001-04500.md | 500-level composition procedural plan for P9-A/P9-B, D 60–76 difficulty plateau, and L4500 Finale | Draft |
| economy | specs/economy/phase-9-rewards.md | Phase 9 rewards, 49 Gift Crates (300 coins), L4500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-9-ui-additions.md | Coupling pad graphics, split train seam lines, rejoin archway indicators, and tutorial cards | Draft |
| ui | specs/ui/phase-9-vfx.md | Magnetic coupling snap sparks, central split steam bursts, clamp unlock fragments, and tier particle caps | Draft |
| tech | specs/tech/phase-9-qa-and-rollout.md | CI composition solver validation pipeline, binary metadata (phase_9_meta.bin), and QA-P9 matrix | Draft |
| gameplay | specs/gameplay/phase-10-signature-system.md | Phase 10 signature system Timetable Master (Sequencing S10), metronomes, chronological orders, and echo signals | Draft |
| gameplay | specs/gameplay/phase-10-base-mechanics.md | Phase 10 base mechanics M451–M454 (Metronome Gate, Departure Code Lock, Platform Order Exit, Echo Signal) with schemas | Draft |
| gameplay | specs/gameplay/phase-10-variants-and-modifiers.md | Ten standard railway modifiers and 45 timetable variant slot mappings across Phase 10 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-10-level-plan-04501-05000.md | 500-level sequencing procedural plan for P10-A/P10-B, D 60–76 difficulty plateau, and L5000 Finale | Draft |
| economy | specs/economy/phase-10-rewards.md | Phase 10 rewards, 49 Gift Crates (300 coins), L5000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-10-ui-additions.md | Metronome beat visualizers, departure code ribbons, numbered platform order badges, and tutorial cards | Draft |
| ui | specs/ui/phase-10-vfx.md | Rhythmic sonic pulse waves, departure code unlock flares, order buzz shocks, and tier particle caps | Draft |
| tech | specs/tech/phase-10-qa-and-rollout.md | CI timetable sequencing solver pipeline, binary metadata (phase_10_meta.bin), and QA-P10 matrix | Draft |
| gameplay | specs/gameplay/phase-11-signature-system.md | Phase 11 signature system Twin Tables (Linked Boards S11), dual sub-boards, bridges, and mirror trains | Draft |
| gameplay | specs/gameplay/phase-11-base-mechanics.md | Phase 11 base mechanics M501–M504 (Table Bridge, Inter-table Ticket, Mirror Table, Relay Tunnel) with schemas | Draft |
| gameplay | specs/gameplay/phase-11-variants-and-modifiers.md | Ten standard railway modifiers and 45 twin table variant slot mappings across Phase 11 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-11-level-plan-05001-05500.md | 500-level twin board procedural plan for P11-A/P11-B, D 60–76 difficulty plateau, and L5500 Finale | Draft |
| economy | specs/economy/phase-11-rewards.md | Phase 11 rewards, 49 Gift Crates (300 coins), L5500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-11-ui-additions.md | Dual-table viewport camera controls, bridge chevron flow overlays, cross-board ticket link indicators, and tutorial cards | Draft |
| ui | specs/ui/phase-11-vfx.md | Bridge transit sparks, cross-board unlock lasers, mirror synchronization flashes, and relay portal warps | Draft |
| tech | specs/tech/phase-11-qa-and-rollout.md | CI dual-board graph solver validation pipeline, binary metadata (phase_11_meta.bin), and QA-P11 matrix | Draft |
| gameplay | specs/gameplay/phase-12-signature-system.md | Phase 12 signature system Hill Line (Gravity Physics S12), tilt levers, sliding crates, and ballast trains | Draft |
| gameplay | specs/gameplay/phase-12-base-mechanics.md | Phase 12 base mechanics M551–M554 (Tilt Lever, Loose Crates, Balloon Pad, Ballast Train) with schemas | Draft |
| gameplay | specs/gameplay/phase-12-variants-and-modifiers.md | Ten standard railway modifiers and 45 incline variant slot mappings across Phase 12 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-12-level-plan-05501-06000.md | 500-level incline procedural plan for P12-A/P12-B, D 60–76 difficulty plateau, and L6000 Finale | Draft |
| economy | specs/economy/phase-12-rewards.md | Phase 12 rewards, 49 Gift Crates (300 coins), L6000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-12-ui-additions.md | Gravity direction compass HUD, sliding crate motion trails, balloon floating indicators, and tutorial cards | Draft |
| ui | specs/ui/phase-12-vfx.md | Tilt fulcrum thuds, crate friction dust, anti-gravity sparkles, and ballast rolling smoke puffs | Draft |
| tech | specs/tech/phase-12-qa-and-rollout.md | CI gravity physics solver validation pipeline, binary metadata (phase_12_meta.bin), and QA-P12 matrix | Draft |
| gameplay | specs/gameplay/phase-13-signature-system.md | Phase 13 signature system Weather Station (Fog on the Line S13), scout draisines, mirage steam, and lanterns | Draft |
| gameplay | specs/gameplay/phase-13-base-mechanics.md | Phase 13 base mechanics M601–M604 (Scout Draisine, Mirage Steam, Painted Backdrop, Lantern Plate) with schemas | Draft |
| gameplay | specs/gameplay/phase-13-variants-and-modifiers.md | Ten standard railway modifiers and 45 fog variant slot mappings across Phase 13 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-13-level-plan-06001-06500.md | 500-level fog procedural plan for P13-A/P13-B, D 60–76 difficulty plateau, and L6500 Finale | Draft |
| economy | specs/economy/phase-13-rewards.md | Phase 13 rewards, 49 Gift Crates (300 coins), L6500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-13-ui-additions.md | Procedural atmospheric fog overlays, route peek visualizers, lantern illumination circles, and tutorial cards | Draft |
| ui | specs/ui/phase-13-vfx.md | Fog parting swirls, mirage shimmer ripples, painted backdrop flutter, and lantern warmth flares | Draft |
| tech | specs/tech/phase-13-qa-and-rollout.md | CI fog reconnaissance solver validation pipeline, binary metadata (phase_13_meta.bin), and QA-P13 matrix | Draft |
| gameplay | specs/gameplay/phase-14-signature-system.md | Phase 14 signature system Alpine Pass (Reflection & Symmetry S14), mirror rail axes, and reverse engines | Draft |
| gameplay | specs/gameplay/phase-14-base-mechanics.md | Phase 14 base mechanics M651–M654 (Mirror Rail Axis, Reflection Lock, Alpine Twin Yard, Reverse Engine) with schemas | Draft |
| gameplay | specs/gameplay/phase-14-variants-and-modifiers.md | Ten standard railway modifiers and 45 symmetry variant slot mappings across Phase 14 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-14-level-plan-06501-07000.md | 500-level symmetry procedural plan for P14-A/P14-B, D 60–76 difficulty plateau, and L7000 Finale | Draft |
| economy | specs/economy/phase-14-rewards.md | Phase 14 rewards, 49 Gift Crates (300 coins), L7000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-14-ui-additions.md | Central glacier mirror seam line, reflection highlight badges, reverse engine badges, and tutorial cards | Draft |
| ui | specs/ui/phase-14-vfx.md | Glacier refraction glints, paired barrier shatter bursts, reverse steam jets, and alpine snow flurries | Draft |
| tech | specs/tech/phase-14-qa-and-rollout.md | CI bilateral symmetry solver validation pipeline, binary metadata (phase_14_meta.bin), and QA-P14 matrix | Draft |
| gameplay | specs/gameplay/phase-15-signature-system.md | Phase 15 signature system Moving Platforms (Conveyors S15), motorized belts, reversing levers, and loops | Draft |
| gameplay | specs/gameplay/phase-15-base-mechanics.md | Phase 15 base mechanics M701–M704 (Belt Switch, Reversing Belt, Belt Stop Lever, Loop Belt) with schemas | Draft |
| gameplay | specs/gameplay/phase-15-variants-and-modifiers.md | Ten standard railway modifiers and 45 conveyor variant slot mappings across Phase 15 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-15-level-plan-07001-07500.md | 500-level conveyor procedural plan for P15-A/P15-B, D 60–76 difficulty plateau, and L7500 Finale | Draft |
| economy | specs/economy/phase-15-rewards.md | Phase 15 rewards, 49 Gift Crates (300 coins), L7500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-15-ui-additions.md | Animated tread conveyor belt tiles, directional flow chevrons, reversing lever visualizers, and tutorial cards | Draft |
| ui | specs/ui/phase-15-vfx.md | Motor steam exhausts, roller gear sparks, conveyor slip dust, and pneumatic air blast vents | Draft |
| tech | specs/tech/phase-15-qa-and-rollout.md | CI conveyor simulation solver validation pipeline, binary metadata (phase_15_meta.bin), and QA-P15 matrix | Draft |
| gameplay | specs/gameplay/phase-16-signature-system.md | Phase 16 signature system Ticket Office (Keys Deluxe S16), chained barriers, punch crafting, and master passes | Draft |
| gameplay | specs/gameplay/phase-16-base-mechanics.md | Phase 16 base mechanics M751–M754 (Ticket Chain, Ticket Punch, Master Pass, Ticket Swap Pad) with schemas | Draft |
| gameplay | specs/gameplay/phase-16-variants-and-modifiers.md | Ten standard railway modifiers and 45 ticket variant slot mappings across Phase 16 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-16-level-plan-07501-08000.md | 500-level key-network procedural plan for P16-A/P16-B, D 60–76 difficulty plateau, and L8000 Finale | Draft |
| economy | specs/economy/phase-16-rewards.md | Phase 16 rewards, 49 Gift Crates (300 coins), L8000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-16-ui-additions.md | Ticket chain connection tracers, ticket stub crafting animations, master pass golden auras, and tutorial cards | Draft |
| ui | specs/ui/phase-16-vfx.md | Stamped ticket punch confetti chads, chain link shatter sparks, master pass starbursts, and swap energy arcs | Draft |
| tech | specs/tech/phase-16-qa-and-rollout.md | CI key dependency DAG solver validation pipeline, binary metadata (phase_16_meta.bin), and QA-P16 matrix | Draft |
| gameplay | specs/gameplay/phase-17-signature-system.md | Phase 17 signature system Clock Towers (Guardians S17), multi-cell HP towers, shield sequences, and spawner depots | Draft |
| gameplay | specs/gameplay/phase-17-base-mechanics.md | Phase 17 base mechanics M801–M804 (Twin Clock Towers, Armoured Clock Tower, Depot Tower, Clock Core) with schemas | Draft |
| gameplay | specs/gameplay/phase-17-variants-and-modifiers.md | Ten standard railway modifiers and 45 guardian variant slot mappings across Phase 17 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-17-level-plan-08001-08500.md | 500-level guardian boss procedural plan for P17-A/P17-B, D 60–76 difficulty plateau, and L8500 Finale | Draft |
| economy | specs/economy/phase-17-rewards.md | Phase 17 rewards, 49 Gift Crates (300 coins), L8500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-17-ui-additions.md | Multi-cell wooden clock tower graphics, overhead boss HP health bars, shield sequence banners, and tutorial cards | Draft |
| ui | specs/ui/phase-17-vfx.md | Tower structural crumble dust, shield armor shatter shards, spawner smoke, and core vaporization light pillars | Draft |
| tech | specs/tech/phase-17-qa-and-rollout.md | CI guardian boss health and spawner solver pipeline, binary metadata (phase_17_meta.bin), and QA-P17 matrix | Draft |
| gameplay | specs/gameplay/phase-18-signature-system.md | Phase 18 signature system Remix A (Early Era Synergy S18), day/night shunting, and optical sensors | Draft |
| gameplay | specs/gameplay/phase-18-base-mechanics.md | Phase 18 base mechanics M851–M854 (Day/Night Ticket Cart, Shunting Lift, Prism Sensor, Ice Chute) with schemas | Draft |
| gameplay | specs/gameplay/phase-18-variants-and-modifiers.md | Ten standard railway modifiers and 45 early synergy variant slot mappings across Phase 18 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-18-level-plan-08501-09000.md | 500-level synergy procedural plan for P18-A/P18-B, D 60–76 difficulty plateau, and L9000 Finale | Draft |
| economy | specs/economy/phase-18-rewards.md | Phase 18 rewards, 49 Gift Crates (300 coins), L9000 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-18-ui-additions.md | Compound synergy status badges, multi-system HUD docks, elevator wireframes, and tutorial cards | Draft |
| ui | specs/ui/phase-18-vfx.md | Hydraulic lift steam vents, rainbow prism flare streams, chute slam impacts, and tier particle caps | Draft |
| tech | specs/tech/phase-18-qa-and-rollout.md | CI multi-system synergy solver validation pipeline, binary metadata (phase_18_meta.bin), and QA-P18 matrix | Draft |
| gameplay | specs/gameplay/phase-19-signature-system.md | Phase 19 signature system Remix B (Mid-Era Synergy S19), turntable coupling, spore wagons, and pruners | Draft |
| gameplay | specs/gameplay/phase-19-base-mechanics.md | Phase 19 base mechanics M901–M904 (Turntable Coupler, Incline Spore Wagon, Bridge Metronome, Split Pruner) with schemas | Draft |
| gameplay | specs/gameplay/phase-19-variants-and-modifiers.md | Ten standard railway modifiers and 45 kinetic synergy variant slot mappings across Phase 19 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-19-level-plan-09001-09500.md | 500-level kinetic procedural plan for P19-A/P19-B, D 60–76 difficulty plateau, and L9500 Finale | Draft |
| economy | specs/economy/phase-19-rewards.md | Phase 19 rewards, 49 Gift Crates (300 coins), L9500 Grand Central Chest, and Coin Rush schedule | Draft |
| ui | specs/ui/phase-19-ui-additions.md | Turntable coupler discs, incline spore trails, cross-table bridge metronomes, and tutorial cards | Draft |
| ui | specs/ui/phase-19-vfx.md | Turntable gear lock clacks, spore pollen puffs, bridge acoustic ripples, and scythe leaf shreds | Draft |
| tech | specs/tech/phase-19-qa-and-rollout.md | CI kinetic synergy solver validation pipeline, binary metadata (phase_19_meta.bin), and QA-P19 matrix | Draft |
| gameplay | specs/gameplay/phase-20-signature-system.md | Phase 20 signature system Grand Master (Omni-Convergence S20) and Level 10000 Marching Boss | Draft |
| gameplay | specs/gameplay/phase-20-base-mechanics.md | Phase 20 base mechanics M951–M954 (Conveyor Guardian, Gravity Relay, Celestial Pass, Prism Bloom) with schemas | Draft |
| gameplay | specs/gameplay/phase-20-variants-and-modifiers.md | Ten standard railway modifiers and 45 supreme convergence variant slot mappings across Phase 20 blocks 3–49 | Draft |
| gameplay | specs/gameplay/phase-20-level-plan-09501-10000.md | 500-level ultimate procedural plan for P20-A/P20-B, D 60–76 plateau, and L10000 Climax Boss (D ≈ 91) | Draft |
| economy | specs/economy/phase-20-rewards.md | Phase 20 rewards, 49 Gift Crates (300 coins), L10000 Grand Sovereign Chest (5,000 coins), and lifetime audit | Draft |
| ui | specs/ui/phase-20-ui-additions.md | 3x3 Marching Clock Tower boss, footprint crush hazard overlays, crushed track splinters, and victory ceremony | Draft |
| ui | specs/ui/phase-20-vfx.md | Seismic marching footstep slams, celestial stardust trails, bloom starbursts, and grand boss death pyrotechnics | Draft |
| tech | specs/tech/phase-20-qa-and-rollout.md | CI omni-system and Level 10000 Marching Boss solver pipeline, binary metadata (phase_20_meta.bin), and QA-P20 | Draft |
