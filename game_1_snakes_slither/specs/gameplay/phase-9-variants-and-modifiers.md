Source docs: phases/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-9-base-mechanics.md, specs/gameplay/phase-9-signature-system.md.

# Spec: Gameplay — Phase 9 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 403 to 450 for Phase 9 (Levels 4001–4500), detailing how base mechanics M401–M404 combine with the 10 core modifiers.

## Current State
Design documented in `phases/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M401–M404 define foundational fusion, splitting, segment metrics, and twin synchronization.
- Modifiers synthesize complex topological challenges across the fixed plateau difficulty band $D \in [60, 76]$.

## Proposed Change
Implement the 45 variant permutations within `packages/puzzle_core/lib/src/variants/phase_9/`:

### 1. The 10 Core Modifiers Applied to Phase 9
1. **MOD-01 (Multi-Stage / Chained):** Multi-tier splits ($1 \to 2 \to 4$) or sequential merger chains.
2. **MOD-02 (Directional / Polarized):** One-way entry vectors or orientation-dependent activation.
3. **MOD-03 (Color-Coded):** Chromatic gating; only matched colors can merge or fulfill bead counters.
4. **MOD-04 (Move Countdown / Expiry):** Fixtures active only for $K$ turns before locking.
5. **MOD-05 (Speed / Surge):** Accelerated propulsion post-split or upon merger.
6. **MOD-06 (Segment Sizing):** Length constraints (e.g., minimum length $\ge 6$ or exact parity).
7. **MOD-07 (Paired Locks / Relays):** Synchronized dual locks or dual splitters required in unison.
8. **MOD-08 (Rotating / Shifting):** Dynamic directional rotation or cell shifting after each activation.
9. **MOD-09 (Ice / Frictionless Slide):** Post-split/post-merger paths transition onto zero-friction ice lanes.
10. **MOD-10 (Obstacle Guarded):** Fixtures surrounded by rock barriers, mud patches, or bramble vines.

---

### 2. Complete 45-Variant Catalog (Blocks 403–450)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 403 | 4021 | M401 | MOD-03 | **Color Merger:** Only snakes of identical hue can merge on the Hug Pad. |
| **V02** | 404 | 4031 | M401 | MOD-02 | **One-Way Merger:** Pad only accepts entries along North-South axis. |
| **V03** | 405 | 4041 | M401 | MOD-04 | **Timed Hug Pad:** Pad remains active for only 5 player moves before petrifying. |
| **V04** | 406 | 4051 | M401 | MOD-06 | **Heavy Snake Merger:** Only snakes with length $\ge 4$ are eligible for fusion. |
| **V05** | 407 | 4061 | M401 | MOD-09 | **Icy Pad:** Merged snake glides 3 continuous cells across ice upon fusion. |
| **V06** | 408 | 4071 | M401 | MOD-01 | **Triple Pad:** 3 separate snakes merge sequentially into an apex giant snake. |
| **V07** | 409 | 4081 | M401 | MOD-10 | **Muddy Merger:** Snakes must be extricated from mud patches prior to merger. |
| **V08** | 410 | 4091 | M401 | MOD-05 | **Surge Hug:** Instant acceleration and sonic wave emitted upon fusion. |
| **V09** | 411 | 4101 | M401 | MOD-07 | **Dual Pad Relay:** Two interconnected pads must both host snakes before firing. |
| **V10** | 412 | 4111 | M401 | MOD-08 | **Rotating Hug:** Pad exit vector rotates $90^\circ$ clockwise after each fusion. |
| **V11** | 413 | 4121 | M401 | MOD-01 | **Chain Merger:** One snake must successively pass through 2 distinct pads. |
| **V12** | 415 | 4141 | M402 | MOD-02 | **Asymmetric Split:** Left branch turns $90^\circ$ left; Right branch executes $180^\circ$ U-turn. |
| **V13** | 416 | 4151 | M402 | MOD-06 | **Mini-Split:** Only length-4 snakes can split, yielding two identical length-2 snakes. |
| **V14** | 417 | 4161 | M402 | MOD-03 | **Color Splice:** Post-split children are dyed distinct primary colors. |
| **V15** | 418 | 4171 | M402 | MOD-08 | **Revolving Fork:** Fork output channels rotate $90^\circ$ after each split event. |
| **V16** | 419 | 4181 | M402 | MOD-05 | **Rocket Split:** Both child snakes sprint instantly to board boundaries. |
| **V17** | 420 | 4191 | M402 | MOD-10 | **Rock Guarded Fork:** One fork branch is blocked until a rock barrier is removed. |
| **V18** | 421 | 4201 | M402 | MOD-04 | **Countdown Splitter:** Splitter collapses into a wall if unused within 6 moves. |
| **V19** | 422 | 4211 | M402 | MOD-09 | **Glacier Fork:** Both branches eject child snakes directly onto frictionless ice. |
| **V20** | 423 | 4221 | M402 | MOD-01 | **Double Fork (1 to 4):** Child snakes traverse secondary splitters ($1 \to 2 \to 4$). |
| **V21** | 424 | 4231 | M402 | MOD-07 | **Synchronized Fork:** Two splitters must be triggered on the same or adjacent turn. |
| **V22** | 425 | 4241 | M402 | MOD-02 | **Polarized Fork:** Splitter only permits southward entries. |
| **V23** | 427 | 4261 | M403 | MOD-03 | **Colored Bead Lock:** Only segments of Sapphire snakes increment the bead meter. |
| **V24** | 428 | 4271 | M403 | MOD-01 | **Multi-Tier Lock:** Gate retracts in two phases: Tier 1 at 6 beads, Tier 2 at 12 beads. |
| **V25** | 429 | 4281 | M403 | MOD-04 | **Decaying Beads:** Unfulfilled bead meters decay by 1 segment every 4 moves. |
| **V26** | 430 | 4291 | M403 | MOD-06 | **Long Segment Lock:** Only snakes with initial length $\ge 5$ contribute beads. |
| **V27** | 431 | 4301 | M403 | MOD-07 | **Dual Balance Lock:** Two locks must receive equal bead allocations ($\pm 1$). |
| **V28** | 432 | 4311 | M403 | MOD-10 | **Bramble Bead Lock:** Gate is overgrown with M351 Wild Vines requiring pruning. |
| **V29** | 433 | 4321 | M403 | MOD-05 | **Sprint Lock:** Requires 8 segments to exit within a rapid 3-move window. |
| **V30** | 434 | 4331 | M403 | MOD-08 | **Shifting Lock:** Lock translates 1 cell along perimeter per move. |
| **V31** | 435 | 4341 | M403 | MOD-09 | **Frozen Lock:** Lock is frozen solid; requires breaking ice barrier first. |
| **V32** | 436 | 4351 | M403 | MOD-02 | **Directional Beads:** Only segments exiting through the East portal are counted. |
| **V33** | 437 | 4361 | M403 | MOD-01 | **Grand Bead Gate:** Heavy-duty barrier demanding 20 cumulative exited segments. |
| **V34** | 439 | 4381 | M404 | MOD-03 | **Color Reunion:** Gate corresponds exclusively to chromatic twin pairs. |
| **V35** | 440 | 4391 | M404 | MOD-04 | **Urgent Reunion:** Twins must exit within 3 moves of each other or gate relocks. |
| **V36** | 441 | 4401 | M404 | MOD-07 | **Twin Reunion Gates:** Dual gates protecting dual exits open synchronously. |
| **V37** | 442 | 4411 | M404 | MOD-05 | **Turbo Reunion:** Reunion trigger creates an explosive corridor shockwave. |
| **V38** | 443 | 4421 | M404 | MOD-10 | **Rock Guarded Reunion:** Exit threshold guarded by crackable stone barriers. |
| **V39** | 444 | 4431 | M404 | MOD-08 | **Rotating Reunion:** Gate rotates open to form a bridge across a river chasm. |
| **V40** | 445 | 4441 | M404 | MOD-06 | **Exact Length Reunion:** Only twins that maintained equal length qualify. |
| **V41** | 446 | 4451 | M404 | MOD-09 | **Ice Slide Reunion:** Both child snakes must cross frozen ponds to reach exit. |
| **V42** | 447 | 4461 | M404 | MOD-02 | **One-Way Exit Reunion:** Twins must exit via Northern river mouth only. |
| **V43** | 448 | 4471 | M404 | MOD-01 | **Multi-Split Reunion:** Gate tracks quad children from a double fork ($1 \to 4$). |
| **V44** | 449 | 4481 | M404 | MOD-07 | **Cascade Gate:** Opening Reunion Gate instantly fulfills downstream Bead Lock. |
| **V45** | 450 | 4495 | M401 | MOD-01 | **Ultimate Convergence:** Master showcase of fusion, bifurcation, and reunion. |

---

### 3. Solver Verification
All 45 variant configurations are verified during offline CI generation to ensure complete $0$-booster solvability under strict A* heuristic tree limits ($\le 50{,}000$ states evaluated per seed).

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_9/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_9_modifier_rules.dart` (to be created)
- `test/variants/phase_9_variants_test.dart` (to be created)

## Risks and Open Questions
- **V20 & V43 Double Split Complexity:** Bifurcating into 4 child snakes increases state-space branching exponentially. Generator must enforce tight grid boundaries ($10 \times 10$) and short snakes ($\le 6$ segments) on V20/V43 to keep solver latency $< 150\text{ ms}$.
