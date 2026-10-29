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
| gameplay | specs/gameplay/core-concept-and-rules.md | Core puzzle rules, board/thread models, turn resolution pipeline, and win/fail/stars logic | Draft |
| gameplay | specs/gameplay/level-progression-0001-0500.md | 500-level progression architecture, tiers, 10-level block patterns, FTUE onboarding, and L500 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-1.md | Catalog of 49 craft mechanics (M001–M049) and Phase 1 Finale with collision, hammer, and solver rules | Draft |
| economy | specs/economy/boosters-coins-shop.md | Boosters, coins inflow/outflow, Craft Baskets, Golden Bobbin Rush, Spinning Wheel, Shop, ads, and VIP | Draft |
| meta | specs/meta/daily-challenge-and-streak.md | Daily Stitch, 7 weekday modifiers, silhouettes, 7-day streak ladder, Darning Patch, and leaderboards | Draft |
| ui | specs/ui/ui-ux-screens.md | Design tokens, color-blind palette, responsive layout rules, and wireframes for all 18 screens and dialogs | Draft |
| tech | specs/tech/frontend-implementation-and-qa.md | Flutter architecture, pure-Dart puzzle_core engine, BLoCs, CustomPainter renderer, persistence, and QA matrix | Draft |
| audio | specs/audio/sound-effects.md | Audio engine, audioplayers setup, cozy craft ASMR sound effects, music loops, ducking, and audio QA checklist | Draft |
| tech | specs/tech/logging-and-error-tracking.md | AppLogger ring buffer and file sink, Crashlytics, tap tracing, deterministic replay, and problem reporting | Draft |
| tech | specs/tech/performance-optimization.md | 60 fps low-tier performance budgets, on-demand Ticker, static layer caching, device tiers, and perf monitor | Draft |
| tech | specs/tech/splash-and-instant-launch.md | Instant launch pipeline with zero loading screens, native Android/iOS splash, and Hearth & Thread intro | Draft |
| ui | specs/ui/vfx-and-juice.md | Particle, shake, flash and trail effects with tier limits, per-event effect catalog, and VFX QA checklist | Draft |
| gameplay | specs/gameplay/phase-2-scope-and-rules.md | Scope additions for Phase 2: zoom/pan, 8-directional paths, 3 layers, push physics, beams, and resolution order | Draft |
| gameplay | specs/gameplay/level-progression-0501-1000.md | Phase 2 500-level progression architecture, tiers P2-A/B, L501–510 zoom onboarding, and L1000 Finale | Draft |
| gameplay | specs/gameplay/obstacle-catalog-phase-2.md | Catalog of 49 Phase 2 craft mechanics (M051–M099) and Level 1000 Finale with rules and JSON schema | Draft |
| meta | specs/meta/liveops-sticker-album.md | Scrapbook 100-sticker album across 5 volumes, milestone grants, retroactive grant, and Daily Patches showcase | Draft |
| meta | specs/meta/liveops-weekly-star-race.md | Weekly Star Race 5-player async tournament, 50-star goal, ghost fill, and server anti-cheat validation | Draft |
| economy | specs/economy/piggy-bank-and-cosmetics.md | Knitted Piggy Bank (₹49 IAP, 1,000 capacity) and Wardrobe cosmetic shop (800–4,000 Coins) | Draft |
| tech | specs/tech/offline-and-cloud-sync.md | Offline-first sync architecture, Firebase Auth lifecycle, Hive save schema v2, and idempotent op-log | Draft |
| tech | specs/tech/auth-and-account-linking.md | Silent Google Sign-In, Firebase anonymous guest mode, persistent session tokens, and zero-loss account linking | Draft |
| tech | specs/tech/backend-cloud-functions-and-release-prerequisites.md | Backend Cloud Functions, Firestore security rules, App Check enforcement, and R1–R10 release gates | Draft |
| tech | specs/tech/frontend-and-qa-phase-2.md | Presentation layer Matrix4 transforms, CustomPainter 3-layer rendering, CI validator, and Phase 2 QA checklist | Draft |
| audio | specs/audio/sound-effects-phase-2.md | Phase 2 music tracks (P2-A, P2-B, Finale), mechanic sound effects, and LiveOps audio stings | Draft |
| ui | specs/ui/vfx-phase-2.md | Phase 2 particle effects, diagonal thread wakes, beam glow rendering, and LiveOps celebration animations | Draft |
| gameplay | specs/gameplay/phase-3-signature-system.md | Day & Night Loom (Cycles) 5-move periodic state machine, tick order hook, and solver integration | Draft |
| gameplay | specs/gameplay/phase-3-base-mechanics.md | Phase 3 base mechanics M101–M104 (Loom Latch, Day Bridge, Night Pompom, Twilight Eyelet) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-3-variants-and-modifiers.md | 10 craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-3-level-plan-01001-01500.md | Phase 3 500-level progression plan, tiers P3-A/B, D band 60–76, L1491 review, and L1500 Finale | Draft |
| economy | specs/economy/phase-3-rewards.md | Phase 3 rewards: 300-coin Craft Baskets, L1500 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-3-ui-additions.md | Sun/Moon Loom Dial HUD widget, ambient canvas color cross-fade, tutorial cards, and accessibility | Draft |
| ui | specs/ui/phase-3-vfx.md | Phase 3 cycle shift visual ripples, latch/bridge transforms, and device tier particle budgets | Draft |
| tech | specs/tech/phase-3-qa-and-rollout.md | CI seed pre-validation pipeline, phase_3_meta.bin shipping, generator performance, and QA checklist | Draft |
| tech | specs/tech/on-device-level-generation.md | Shared on-device deterministic level generator, reverse construction, IDA* solver, and PRNG infrastructure | Draft |
| gameplay | specs/gameplay/phase-4-signature-system.md | Multi-Floor Sewing Room 3D stack architecture, F1/F2/F3 floors, camera glide, and multi-floor solver | Draft |
| gameplay | specs/gameplay/phase-4-base-mechanics.md | Phase 4 base mechanics M151–M154 (Spiral Spool Stair, Organza Floor, Drop Hole, Bobbin Lift) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-4-variants-and-modifiers.md | 10 craft modifiers and 45 variant slot combinations across multi-floor topological layouts | Draft |
| gameplay | specs/gameplay/phase-4-level-plan-01501-02000.md | Phase 4 500-level progression plan, tiers P4-A/B, 2 to 3 floors, D band 64–80, and L2000 Finale | Draft |
| economy | specs/economy/phase-4-rewards.md | Phase 4 rewards: 300-coin Craft Baskets, L2000 Grand Sewing Chest, Golden Bobbin Rush, and multi-floor sinks | Draft |
| ui | specs/ui/phase-4-ui-additions.md | Multi-Floor HUD tabs (F1/F2/F3), Organza semi-transparency rendering, floor thread counters, and cards | Draft |
| ui | specs/ui/phase-4-vfx.md | Phase 4 camera vertical glide, spool stair rotation, drop hole puffs, and device tier particle budgets | Draft |
| tech | specs/tech/phase-4-qa-and-rollout.md | CI multi-floor seed validation pipeline, phase_4_meta.bin shipping, memory caps, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-5-signature-system.md | Push Physics+ (Crate Workshop) kinetics, displacement rules, collision handling, and Step 1 tick integration | Draft |
| gameplay | specs/gameplay/phase-5-base-mechanics.md | Phase 5 base mechanics M201–M204 (Crate Pit, Satin Crate, Charm Crate, Iron Crate) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-5-variants-and-modifiers.md | 10 push-physics craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-5-level-plan-02001-02500.md | Phase 5 500-level progression plan, tiers P5-A/B, D band 67–83, L2491 review, and L2500 Finale | Draft |
| economy | specs/economy/phase-5-rewards.md | Phase 5 rewards: 300-coin Craft Baskets, L2500 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-5-ui-additions.md | Crate entity styles (pine, satin, charm, iron), onboarding tutorial cards, and color-blind glyphs | Draft |
| ui | specs/ui/phase-5-vfx.md | Phase 5 crate slide dust puffs, pit fill ripples, satin trails, and device tier particle budgets | Draft |
| tech | specs/tech/phase-5-qa-and-rollout.md | CI seed pre-validation pipeline, phase_5_meta.bin shipping, push physics benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-6-signature-system.md | Light & Beams+ (Lamplight Atelier) ray-casting propagation, dynamic occlusion, and Step 4 derived states | Draft |
| gameplay | specs/gameplay/phase-6-base-mechanics.md | Phase 6 base mechanics M251–M254 (Tinted Glass, Prism Clasp, Hourglass Lamp, Shadow Pocket) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-6-variants-and-modifiers.md | 10 optical craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-6-level-plan-02501-03000.md | Phase 6 500-level progression plan, tiers P6-A/B, D band 70–86, L2991 review, and L3000 Finale | Draft |
| economy | specs/economy/phase-6-rewards.md | Phase 6 rewards: 300-coin Craft Baskets, L3000 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-6-ui-additions.md | Light beam BlendMode.plus rendering, shadow vignette shaders, prism status pips, and tutorial cards | Draft |
| ui | specs/ui/phase-6-vfx.md | Phase 6 beam glow rays, prism starburst flashes, shadow dissolve effects, and device tier particle budgets | Draft |
| tech | specs/tech/phase-6-qa-and-rollout.md | CI seed pre-validation pipeline, phase_6_meta.bin shipping, ray-casting benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-7-signature-system.md | Rotation (Turning Table) sub-board coordinate math, boundary invariants, and Tangled state rules | Draft |
| gameplay | specs/gameplay/phase-7-base-mechanics.md | Phase 7 base mechanics M301–M304 (Hoop Rotor, Turning Hem, Twirl Thread, Ratchet Pin) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-7-variants-and-modifiers.md | 10 rotational craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-7-level-plan-03001-03500.md | Phase 7 500-level progression plan, tiers P7-A/B, D band 73–89, L3491 review, and L3500 Finale | Draft |
| economy | specs/economy/phase-7-rewards.md | Phase 7 rewards: 300-coin Craft Baskets, L3500 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-7-ui-additions.md | Canvas matrix rotation transforms, embroidery hoop styling, turning hem borders, and tutorial cards | Draft |
| ui | specs/ui/phase-7-vfx.md | Phase 7 rotational swoosh arcs, pin pop bursts, needle spark glints, and device tier particle budgets | Draft |
| tech | specs/tech/phase-7-qa-and-rollout.md | CI seed pre-validation pipeline, phase_7_meta.bin shipping, canvas raster benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-8-signature-system.md | Growth (Garden Knitting) ivy vine spreading algorithms, clockwise priorities, and Step 3 tick integration | Draft |
| gameplay | specs/gameplay/phase-8-base-mechanics.md | Phase 8 base mechanics M351–M354 (Ivy Yarn, Snip Tile, Seed Bead Thread, Blossom Gate) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-8-variants-and-modifiers.md | 10 organic growth craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-8-level-plan-03501-04000.md | Phase 8 500-level progression plan, tiers P8-A/B, D band 76–92, L3991 review, and L4000 Finale | Draft |
| economy | specs/economy/phase-8-rewards.md | Phase 8 rewards: 300-coin Craft Baskets, L4000 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-8-ui-additions.md | Ivy vine canvas rendering, snip shears icons, blooming floral gates, and onboarding tutorial cards | Draft |
| ui | specs/ui/phase-8-vfx.md | Phase 8 vine sprout bursts, shears snip effects, floral pollen showers, and device tier particle budgets | Draft |
| tech | specs/tech/phase-8-qa-and-rollout.md | CI seed pre-validation pipeline, phase_8_meta.bin shipping, growth calculation benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-9-signature-system.md | Split & Merge (Ply & Twist) multi-ply thread topology, parallel splitting, and Step 4 derived states | Draft |
| gameplay | specs/gameplay/phase-9-base-mechanics.md | Phase 9 base mechanics M401–M404 (Twisting Pad, Double Split, Stitch Lock, Rejoin Gate) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-9-variants-and-modifiers.md | 10 split & merge craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-9-level-plan-04001-04500.md | Phase 9 500-level progression plan, tiers P9-A/B, D band 79–95, L4491 review, and L4500 Finale | Draft |
| economy | specs/economy/phase-9-rewards.md | Phase 9 rewards: 300-coin Craft Baskets, L4500 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-9-ui-additions.md | Twisting pad spirals, half-ply thread rendering, rejoin buckles, stitch locks, and tutorial cards | Draft |
| ui | specs/ui/phase-9-vfx.md | Phase 9 thread twisting spirals, fiber split sparks, buckle snap bursts, and device tier particle budgets | Draft |
| tech | specs/tech/phase-9-qa-and-rollout.md | CI seed pre-validation pipeline, phase_9_meta.bin shipping, ply mutation benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-10-signature-system.md | Sequencing (Pattern Book) rhythmic gate timing, chronological exit ordering, and Step 4 derived states | Draft |
| gameplay | specs/gameplay/phase-10-base-mechanics.md | Phase 10 base mechanics M451–M454 (Metronome Gate, Pattern Clasp, Ordered Hem, Echo Card) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-10-variants-and-modifiers.md | 10 sequencing craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-10-level-plan-04501-05000.md | Phase 10 500-level progression plan, tiers P10-A/B, D band 82–98, L4991 review, and L5000 Finale | Draft |
| economy | specs/economy/phase-10-rewards.md | Phase 10 rewards: 300-coin Craft Baskets, L5000 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-10-ui-additions.md | Metronome pendulums, chromatic sequence brooches, numbered hem stitches, and tutorial cards | Draft |
| ui | specs/ui/phase-10-vfx.md | Phase 10 pendulum sweep animations, chromatic sparkle streams, rhythmic pulses, and device tier particle budgets | Draft |
| tech | specs/tech/phase-10-qa-and-rollout.md | CI seed pre-validation pipeline, phase_10_meta.bin shipping, sequence engine benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-11-signature-system.md | Linked Boards (Twin Hoops) dual-board coordinate architecture, seam traversal, and cross-hoop kinetics | Draft |
| gameplay | specs/gameplay/phase-11-base-mechanics.md | Phase 11 base mechanics M501–M504 (Seam Edge, Cross Charm, Mirror Hoop, Relay Pompom) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-11-variants-and-modifiers.md | 10 linked-board craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-11-level-plan-05001-05500.md | Phase 11 500-level progression plan, tiers P11-A/B, D band 85–101, L5491 review, and L5500 Finale | Draft |
| economy | specs/economy/phase-11-rewards.md | Phase 11 rewards: 300-coin Craft Baskets, L5500 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-11-ui-additions.md | Dual-canvas layout, smart camera auto-framing, zig-zag seam stitch rendering, and tutorial cards | Draft |
| ui | specs/ui/phase-11-vfx.md | Phase 11 seam stitch shimmer waves, cross-hoop portal bursts, twin-mirror sync, and device tier particle budgets | Draft |
| tech | specs/tech/phase-11-qa-and-rollout.md | CI seed pre-validation pipeline, phase_11_meta.bin shipping, dual-canvas benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-12-signature-system.md | Gravity (Hanging Loom) 4-way field, falling button kinetics, weighted thread translation, and Step 4 tick | Draft |
| gameplay | specs/gameplay/phase-12-base-mechanics.md | Phase 12 base mechanics M551–M554 (Plumb Lever, Dropping Buttons, Float Patch, Weighted Thread) rules and schemas | Draft |
| gameplay | specs/gameplay/phase-12-variants-and-modifiers.md | 10 gravity craft modifiers and 45 variant slot combinations across the fixed difficulty plateau | Draft |
| gameplay | specs/gameplay/phase-12-level-plan-05501-06000.md | Phase 12 500-level progression plan, tiers P12-A/B, D band 88–104, L5991 review, and L6000 Finale | Draft |
| economy | specs/economy/phase-12-rewards.md | Phase 12 rewards: 300-coin Craft Baskets, L6000 Grand Sewing Chest, Golden Bobbin Rush, and economy sinks | Draft |
| ui | specs/ui/phase-12-ui-additions.md | Plumb bob gravity widget, sliding button physics, floating silk patches, and onboarding tutorial cards | Draft |
| ui | specs/ui/phase-12-vfx.md | Phase 12 gravity wave ripples, wood-slide dust trails, button impact thumps, and device tier particle budgets | Draft |
| tech | specs/tech/phase-12-qa-and-rollout.md | CI seed pre-validation pipeline, phase_12_meta.bin shipping, gravity physics benchmarks, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-13-signature-system.md | Phase 13 Hidden Info (Mystery Basket) wool fluff fog of war, reveal rules, and tick integration | Draft |
| gameplay | specs/gameplay/phase-13-base-mechanics.md | Phase 13 base mechanics: Scout Thread (M601), Decoy Fluff (M602), Painted Wall (M603), Lantern Plate (M604) | Draft |
| gameplay | specs/gameplay/phase-13-variants-and-modifiers.md | Phase 13 45-variant slot combinations and 10 craft modifiers for Hidden Info mechanics | Draft |
| gameplay | specs/gameplay/phase-13-level-plan-06001-06500.md | Phase 13 50-block slot map, tiers P13-A/P13-B, D band 91–107, and Finale Level 6500 | Draft |
| economy | specs/economy/phase-13-rewards.md | Phase 13 rewards: 49 Craft Baskets, Level 6500 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-13-ui-additions.md | Phase 13 wool fluff fog shaders, lantern warm glow lighting, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-13-vfx.md | Phase 13 wool dissolve particles, chalk outline flash, amber lantern rays, and tier budgets | Draft |
| tech | specs/tech/phase-13-qa-and-rollout.md | Phase 13 CI seed pre-validation, phase_13_meta.bin shipping, performance budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-14-signature-system.md | Phase 14 Mirror Worlds (Looking-Glass Quilt) symmetry, twin thread pulls, and tick integration | Draft |
| gameplay | specs/gameplay/phase-14-base-mechanics.md | Phase 14 base mechanics: Mirror Seam (M651), Reflect Clasp (M652), Twin Quilt (M653), Inverse Thread (M654) | Draft |
| gameplay | specs/gameplay/phase-14-variants-and-modifiers.md | Phase 14 45-variant slot combinations and 10 craft modifiers for Mirror Worlds mechanics | Draft |
| gameplay | specs/gameplay/phase-14-level-plan-06501-07000.md | Phase 14 50-block slot map, tiers P14-A/P14-B, D band 94–110, and Finale Level 7000 | Draft |
| economy | specs/economy/phase-14-rewards.md | Phase 14 rewards: 49 Craft Baskets, Level 7000 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-14-ui-additions.md | Phase 14 mirror seam shimmer, twin highlights, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-14-vfx.md | Phase 14 twin sparkle trails, resonant clasp blooms, and device tier particle budgets | Draft |
| tech | specs/tech/phase-14-qa-and-rollout.md | Phase 14 CI seed pre-validation, phase_14_meta.bin shipping, performance budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-15-signature-system.md | Phase 15 Conveyors & Tracks (Feed Dog Factory) kinetics, branch switches, and tick integration | Draft |
| gameplay | specs/gameplay/phase-15-base-mechanics.md | Phase 15 base mechanics: Belt Switch (M701), Reversing Belt (M702), Belt Lever (M703), Track Loop (M704) | Draft |
| gameplay | specs/gameplay/phase-15-variants-and-modifiers.md | Phase 15 45-variant slot combinations and 10 craft modifiers for Conveyors & Tracks mechanics | Draft |
| gameplay | specs/gameplay/phase-15-level-plan-07001-07500.md | Phase 15 50-block slot map, tiers P15-A/P15-B, D band 97–113, and Finale Level 7500 | Draft |
| economy | specs/economy/phase-15-rewards.md | Phase 15 rewards: 49 Craft Baskets, Level 7500 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-15-ui-additions.md | Phase 15 feed dog tread animations, track loop indicators, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-15-vfx.md | Phase 15 gear ratchet sparks, clutch brake puffs, thread slide trails, and tier budgets | Draft |
| tech | specs/tech/phase-15-qa-and-rollout.md | Phase 15 CI seed pre-validation, phase_15_meta.bin shipping, performance budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-16-signature-system.md | Phase 16 Keys Deluxe (Jewel Box) logistics, chain ordering, key crafting, and tick integration | Draft |
| gameplay | specs/gameplay/phase-16-base-mechanics.md | Phase 16 base mechanics: Charm Chain (M751), Charm Crafting (M752), Skeleton Charm (M753), Charm Swap Hoop (M754) | Draft |
| gameplay | specs/gameplay/phase-16-variants-and-modifiers.md | Phase 16 45-variant slot combinations and 10 craft modifiers for Keys Deluxe mechanics | Draft |
| gameplay | specs/gameplay/phase-16-level-plan-07501-08000.md | Phase 16 50-block slot map, tiers P16-A/P16-B, D band 100–116, and Finale Level 8000 | Draft |
| economy | specs/economy/phase-16-rewards.md | Phase 16 rewards: 49 Craft Baskets, Level 8000 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-16-ui-additions.md | Phase 16 jeweled charms, key forging montage, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-16-vfx.md | Phase 16 key forging starbursts, skeleton shimmer, chromatic waves, and tier budgets | Draft |
| tech | specs/tech/phase-16-qa-and-rollout.md | Phase 16 CI seed pre-validation, phase_16_meta.bin shipping, performance budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-17-signature-system.md | Phase 17 Guardians (Pincushion Court) boss entities, pin extraction damage, and tick integration | Draft |
| gameplay | specs/gameplay/phase-17-base-mechanics.md | Phase 17 base mechanics: Twin Pincushions (M801), Armoured Pincushion (M802), Seeding Pincushion (M803), Heart Pincushion (M804) | Draft |
| gameplay | specs/gameplay/phase-17-variants-and-modifiers.md | Phase 17 45-variant slot combinations and 10 craft modifiers for Guardians mechanics | Draft |
| gameplay | specs/gameplay/phase-17-level-plan-08001-08500.md | Phase 17 50-block slot map, tiers P17-A/P17-B, D band 103–119, and Finale Level 8500 | Draft |
| economy | specs/economy/phase-17-rewards.md | Phase 17 rewards: 49 Craft Baskets, Level 8500 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-17-ui-additions.md | Phase 17 velvet pincushion rendering, floating HP badges, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-17-vfx.md | Phase 17 pin extract sparks, ribbon collapse, shield deflections, and tier budgets | Draft |
| tech | specs/tech/phase-17-qa-and-rollout.md | Phase 17 CI seed pre-validation, phase_17_meta.bin shipping, performance budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-18-signature-system.md | Phase 18 Remix A (Phases 1–6 Synergy) multi-system integration, candidate pool, and tick integration | Draft |
| gameplay | specs/gameplay/phase-18-base-mechanics.md | Phase 18 combo mechanics: Cycle Crate (M851), Floor Beam (M852), Fogged Stair (M853), Satin Charm Crate (M854) | Draft |
| gameplay | specs/gameplay/phase-18-variants-and-modifiers.md | Phase 18 45-variant slot combinations and 10 craft modifiers for Remix A mechanics | Draft |
| gameplay | specs/gameplay/phase-18-level-plan-08501-09000.md | Phase 18 50-block slot map, tiers P18-A/P18-B, D band 106–122, and Finale Level 9000 | Draft |
| economy | specs/economy/phase-18-rewards.md | Phase 18 rewards: 49 Craft Baskets, Level 9000 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-18-ui-additions.md | Phase 18 composite HUD, multi-floor parallax depth, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-18-vfx.md | Phase 18 multi-layer beam sparkles, satin unlock bursts, and device tier particle budgets | Draft |
| tech | specs/tech/phase-18-qa-and-rollout.md | Phase 18 CI seed pre-validation, phase_18_meta.bin shipping, node budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-19-signature-system.md | Phase 19 Remix B (Phases 7–12 Synergy) kinematic systems, candidate pool, and tick integration | Draft |
| gameplay | specs/gameplay/phase-19-base-mechanics.md | Phase 19 combo mechanics: Twirl Weighted Thread (M901), Ivy Hoop Rotor (M902), Rhythm Belt (M903), Seam Edge Split (M904) | Draft |
| gameplay | specs/gameplay/phase-19-variants-and-modifiers.md | Phase 19 45-variant slot combinations and 10 craft modifiers for Remix B mechanics | Draft |
| gameplay | specs/gameplay/phase-19-level-plan-09001-09500.md | Phase 19 50-block slot map, tiers P19-A/P19-B, D band 109–125, and Finale Level 9500 | Draft |
| economy | specs/economy/phase-19-rewards.md | Phase 19 rewards: 49 Craft Baskets, Level 9500 Grand Sewing Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-19-ui-additions.md | Phase 19 rotor-growth dynamics, rhythm pulse meters, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-19-vfx.md | Phase 19 organic leaf bursts, metallic twirl trails, rhythm snaps, and tier budgets | Draft |
| tech | specs/tech/phase-19-qa-and-rollout.md | Phase 19 CI seed pre-validation, phase_19_meta.bin shipping, node budget, and QA checklist | Draft |
| gameplay | specs/gameplay/phase-20-signature-system.md | Phase 20 Grand Master (The Endless Tapestry) all-systems synthesis, L10,000 finale, and tick integration | Draft |
| gameplay | specs/gameplay/phase-20-base-mechanics.md | Phase 20 master mechanics: Moving Guardian (M951), Omni Gate (M952), Grand Loom Spool (M953), Master Weaver Key (M954) | Draft |
| gameplay | specs/gameplay/phase-20-variants-and-modifiers.md | Phase 20 45-variant slot combinations and 10 craft modifiers for Grand Master mechanics | Draft |
| gameplay | specs/gameplay/phase-20-level-plan-09501-10000.md | Phase 20 50-block slot map, tiers P20-A/P20-B, D band 112–128, and Grand Finale Level 10,000 | Draft |
| economy | specs/economy/phase-20-rewards.md | Phase 20 rewards: 49 Craft Baskets, Level 10,000 Grand Master Chest, and 20 Golden Bobbin Rush bonus rounds | Draft |
| ui | specs/ui/phase-20-ui-additions.md | Phase 20 moving guardian visuals, Level 10,000 ceremony cinematics, accessibility, and tutorial dialogues | Draft |
| ui | specs/ui/phase-20-vfx.md | Phase 20 moving step thumps, prismatic omni bursts, golden confetti shower, and tier budgets | Draft |
| tech | specs/tech/phase-20-qa-and-rollout.md | Phase 20 CI seed pre-validation, Level 10,000 verification, endgame loop transition, and QA checklist | Draft |
