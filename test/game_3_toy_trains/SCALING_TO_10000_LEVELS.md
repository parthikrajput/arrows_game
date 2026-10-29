# Scaling to 10,000 Levels — Toy Trains: Wooden Railway Puzzle
> હેતુ: **500 થી 10,000 levels content & scalability planning** — દરેક phase ની pipeline, generator (reverse construction + stateful solver, D formula, validator), seeds & overrides, PRNG, level JSON schema, Phases 3–20 નો toy-railway themed plan, variant/modifier system, content cadence, analytics થી live tuning, scale પર QA, અને schema પરથી ગણેલા storage estimates.

**Related docs:** [Shared Core Standard §9–§12, §16](../SHARED_CORE_STANDARD.md) · [Game README](./README.md) · [Phase 1 README](./phase_1/README.md) · [Phase 2 README](./phase_2/README.md) · [Phase 2 Catalog](./phase_2/03_OBSTACLE_CATALOG_PHASE_2.md) · [Phase 2 Frontend & QA](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md)

> ⚖️ Pipeline, seed formula, PRNG, solver limits, phase plan અને modifier list standard §11–§12 મુજબ. Standard જ્યાં ચૂપ છે (mechanic IDs for Phase 3+, modifier exact rules, meta file, tuning profiles) ત્યાં આ doc game definition આપે છે — §12 list.

---

## 1. Goals & Constraints

| Goal | Constraint |
|---|---|
| 10,000 levels, દર 10 levels એ કંઈક નવું | Phase = 500 levels; 20 phases |
| 100% solvable with 0 hearts / 0 boosters | CI solver validates **every** level before ship |
| Deterministic on every device | Same level number ⇒ same board on Android/iOS (and JS replay validator) |
| Small app size | Phase 3+ levels **not bundled** — generated on-device from seeds |
| Offline | Generation needs no network |
| Fair difficulty ramp | D formula + slot bands; never decreasing across phases (standard §9.3) |

## 2. Pipeline per Phase (standard §12)

| Phase | Levels | Source | Hand-tuned | Shipped artefact |
|---|---|---|---|---|
| 1 | 1–500 | Offline generator (`tools/levelgen`, Dart CLI) + designer tuning | L1–30, every x1, every x9, L500 | `assets/levels/phase_1.json.gz` |
| 2 | 501–1000 | Same | L501–510, every x1, every x9, L1000 | `assets/levels/phase_2.json.gz` |
| 3–20 | 1001–10,000 | **On-device generation** from `seed = hash64(gameId, level, GENERATOR_VERSION)`, attempt `k` uses `seed + k` (k = 0…63) | Tutorial cards + finale templates (finale boards still generator output with a fixed template) | Generator code (in `puzzle_core`), `seed_overrides.json`, `phase_N_meta.bin` (§4.3) |

```
Phase 1–2:  levelgen generate ─► designer tune ─► levelgen validate (CI) ─► pack .json.gz ─► app bundle
Phase 3+:   CI: for L in 1001..10000: for k in 0..63: gen(seed+k) ─► validate ─► first pass ⇒ k
            ─► seed_overrides.json (only k ≠ 0) + phase_N_meta.bin ─► app update
            Device: gen(seed + k_L) ─► CRC check vs meta ─► play  (no retry loop on device)
```

## 3. Generator

### 3.1 Reverse construction (static solvability)
1. Empty W×H board (tier grid), signature-system board flags, exit edges.
2. Pick the **solution order** length P. Place trains **in reverse**: the train placed now must be able to exit in the state where all previously placed trains have *already exited* (i.e. it is placed so that its lane is clear except for trains placed *later*). Repeat until P trains.
3. Place static blockers (B/D tiles) only on cells that no lane in the planned order needs at its exit time.
4. Place stateful mechanics (C, T, K, X) from the slot's allowed set (intro ⇒ intro mechanic + ≤ 1 earlier).
5. Static-only boards ⇒ solvable by construction (standard §12). Any C/T/K/X ⇒ **solver mandatory** (§3.2).

### 3.2 Solver (stateful mechanics)
- BFS / IDA* over state `(remaining trains + positions, mechanic states, cart cells, smoke TTLs, moveCount parity / counters mod period, board rotation, layers' lock bits)`.
- **CI limits:** node limit **2M**, depth ≤ **3 × P**. Unsolved / over-limit ⇒ reject attempt.
- Heart-free search: bump transitions are pruned (solution must lose 0 hearts); boosters never used.
- Output: optimal Move sequence ⇒ `solution`, `par_moves = len(solution)`.
- Dead-end pruning: states flagged "Track jammed" (Phase 2 01 §8) are terminal non-goal.

### 3.3 Difficulty D (standard §9.4, §16.16)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = trains, C = longest dependency chain (edges), O = obstacle instances,
N = non-monotone instances (Phase 2 catalog "N?" column; variants inherit the base's flag,
    modifiers Countdown/Phasing/Growing set N = Yes), S = solution Moves − P
```
Attempt rejected if D ∉ slot target ±3 (x9 = high × 1.1, finale = high × 1.2 — standard §16.13).

### 3.4 Validator (CI, every attempt)
Solvable 0 hearts / 0 boosters · D in band · tier limits (grid, trains, obstacles) · no train initially locked forever · intro rule (intro mechanic + ≤ 1 earlier) · Phase 1 grids min cell ≥ 29 dp · Phase 2 catalog structural checks ([06 §8](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md)) · variant compatibility (§7.2) · `solution` replays to Win on the reference engine · **CRC32 of canonical JSON** recorded for device check.

### 3.5 Phase 3+ tiers
Standard §9.3 tier table covers Phases 1–2 only. Phase 3+ tier tables are defined in each phase's docs under two binding constraints: lowest D band ≥ previous phase's last-tier **mid** (P2-B mid = 58–64 ⇒ Phase 3 low ≥ 58), and grid ≤ 14×14 (zoom limit, fit cell 23.4 dp at 360 dp). Storage estimates below therefore use the P2-B maxima (14×14, 40 trains, 14 obstacles) as the upper bound.

## 4. Seeds, Overrides & Meta

### 4.1 Seed
`seed = hash64(gameId, level, GENERATOR_VERSION)`; `gameId = "toy_trains"`. hash64 = two independent 32-bit FNV-1a lanes (`h1 = fnv1a32(key)`, `h2 = fnv1a32(key + "#")`, `seed = h1 << 32 | h2`) over `key = "$gameId|$level|$GENERATOR_VERSION"` — implemented with 32-bit-safe multiply (§5) so dart2js and the VM agree.

### 4.2 `seed_overrides.json`
```json
{"generatorVersion": 3, "overrides": {"1007": 2, "1342": 11, "8015": 5}}
```
- Only levels whose first passing attempt is `k ≠ 0`. Missing ⇒ k = 0.
- **No level may fail all 64 attempts** — CI fails the build; designer changes phase params (and bumps `GENERATOR_VERSION` if it alters already-shipped levels).

### 4.3 `phase_N_meta.bin` (game definition)
Per level, packed: `k (1 B) · par_moves (1 B) · D×10 (2 B) · CRC32 (4 B) · solutionLen (1 B) · solution object indices (1 B each)`. Lets the device run Green Signal Hint (Hint) from the solution prefix exactly like Phases 1–2 (standard §12 on-device Hint) and verify the generated board (CRC) without running the 2M-node solver on device. CRC mismatch ⇒ Crashlytics non-fatal + on-device solver validation (isolate, 200k nodes); if that fails ⇒ next `k` that validates (logged as a determinism bug).

### 4.4 `GENERATOR_VERSION` freeze
Every Phase 3+ level is stored in the Hive `levelCache` (gzip JSON) **when first generated**. On an app update with a new `GENERATOR_VERSION`, cached (already-reached) levels keep their frozen boards; only never-reached levels use the new version (standard §12).

## 5. PRNG — xoshiro128** (Dart, 32-bit ops)

Dart `Random` is not used (no cross-version guarantee). All arithmetic is masked to 32 bits and multiplication uses a 16-bit split so values stay < 2^53 — identical results on the Dart VM (AOT) and dart2js (server replay).

```dart
/// xoshiro128** — 32-bit state, 32-bit output. Deterministic on VM + JS.
class Xoshiro128ss {
  Xoshiro128ss._(this._s0, this._s1, this._s2, this._s3);

  /// Seeds the 4×32-bit state from a 64-bit seed (hi, lo) via splitmix32.
  factory Xoshiro128ss.fromSeed(int hi32, int lo32) {
    var x = (hi32 ^ _mul32(lo32, 0x9E3779B9)) & _mask;
    int next() {
      x = (x + 0x9E3779B9) & _mask;
      var z = x;
      z = _mul32(z ^ (z >> 16), 0x85EBCA6B);
      z = _mul32(z ^ (z >> 13), 0xC2B2AE35);
      return (z ^ (z >> 16)) & _mask;
    }

    final s0 = next(), s1 = next(), s2 = next(), s3 = next();
    // All-zero state is invalid for xoshiro.
    return Xoshiro128ss._(s0 | ((s0 | s1 | s2 | s3) == 0 ? 1 : 0), s1, s2, s3);
  }

  static const int _mask = 0xFFFFFFFF;
  int _s0, _s1, _s2, _s3;

  static int _mul32(int a, int b) {
    final aHi = (a >> 16) & 0xFFFF;
    final aLo = a & 0xFFFF;
    return (aLo * b + (((aHi * b) & 0xFFFF) << 16)) & _mask;
  }

  static int _rotl(int x, int k) => ((x << k) | (x >> (32 - k))) & _mask;

  /// Next unsigned 32-bit value.
  int nextUint32() {
    final result = _mul32(_rotl(_mul32(_s1, 5), 7), 9);
    final t = (_s1 << 9) & _mask;
    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = _rotl(_s3, 11);
    return result;
  }

  /// Uniform int in [0, n) without modulo bias (rejection sampling).
  int nextInt(int n) {
    assert(n > 0 && n <= 0x100000000);
    final limit = 0x100000000 - (0x100000000 % n);
    while (true) {
      final r = nextUint32();
      if (r < limit) return r % n;
    }
  }
}
```
CI golden test: first 1,000 outputs for 16 fixed seeds compared on Android ARM64, iOS, x64 VM and dart2js — any difference fails the build.

## 6. Level JSON (schema v3)

Same schema for every phase (standard §12). Phase 3+ boards are generated in this shape and cached; `mods` carries variant modifiers.

```json
{
  "schema": 3, "level": 1137, "phase": 3, "seed": "0x5C21E0B7A94D3F06", "k": 0,
  "slot": "practice", "tag": "normal", "grid": [13, 13], "layers": 1, "hearts": 3,
  "signature": {"type": "S03", "params": {"period": 5, "state": "A"}},
  "paths": [
    {"id": "p1", "color": "red", "dir": "UR", "body": [[3,9],[2,10]], "layer": 0, "mods": {}},
    {"id": "p2", "color": "blue", "dir": "L", "body": [[9,4],[10,4],[11,4]], "layer": 0, "mods": {"frozen": 2}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M101", "cells": [[6,4]], "params": {"openIn": "A"}, "hammerable": false},
    {"id": "o2", "type": "M013", "cells": [[9,4]], "params": {}, "hammerable": false, "mods": {"chained": "o5"}}
  ],
  "goals": {"gems": 0}, "par_moves": 38, "difficulty": 61.2,
  "solution": ["p1", "o2", "p2"]
}
```
Phase 3+ additions (game definition): `k`, `signature`, `mods` on mechanics. Mechanic IDs for Phase p ≥ 3 base mechanics: **M(50·(p−1)+1) … M(50·(p−1)+4)** (Phase 3 ⇒ M101–M104, Phase 20 ⇒ M951–M954); signature systems `S03`…`S20`.

## 7. Phases 3–20 (Toy-Railway Themed Plan, standard §11)

Every phase: **1 signature system + 4 new base mechanics + 45 variants**. 49 slots: base intros at x1 of blocks **1, 13, 25, 37**; the other 45 x1 slots of blocks 2–49 are variants; block 50's x1 (L…491) is a **review level** (mixed, no new content) leading to the phase Finale (L…500).

| Phase | Levels | Signature system (theme) | 4 new base mechanics (theme ← generic) — rule |
|---|---|---|---|
| 3 | 1001–1500 | **Day & Night Timetable** (Cycles: board state A/B flips every 5 Moves, step 3) | **M101 Day/Night Gate** ← Cycle Gate — open in one state, closed in the other · **M102 Day/Night Overpass** ← Cycle Bridge — acts as Wooden Overpass (M015) in A, Single Blocker in B · **M103 Day/Night Tunnel** ← Cycle Portal — tunnel pair works in A, both mouths block in B · **M104 Day/Night Livery** ← Cycle Color — train swaps between its two colours on every A/B flip |
| 4 | 1501–2000 | **Station Floors** (Multi-floor: up to 3 stacked boards, floor tabs) | **M151 Station Stairs** ← Stairs — lane entering stairs continues on the linked floor from the same cell · **M152 Glass Platform** ← Glass Floor — trains below are visible & tappable through it (no lock) · **M153 Goods Chute** ← Drop Hole — lane reaching it drops the train to the floor below at that cell (relocate, 1 Move) · **M154 Goods Lift** ← Elevator — tap (1 Move) moves a train fully on the lift to the other floor |
| 5 | 2001–2500 | **Yard Shunting+** (Push Physics+) | **M201 Cart Pit** ← Crate Holes — pit blocks lanes; a cart pushed in fills it and both become floor · **M202 Ice Block Cart** ← Sliding Ice Crates — cart always slides like on Frosty Rails · **M203 Ticket Cart** ← Crate Keys — cart pushed onto its barrier pad opens the matching barrier permanently · **M204 Ballast Cart** ← Heavy Crate — moves only when pushed by a Wide Load or by a coupled pair together |
| 6 | 2501–3000 | **Signal Lights+** (Light & Beams+) | **M251 Coloured Lens** ← Color Filter — beam passing takes the lens colour; coloured sensors need matching colour · **M252 Twin Sensor Gate** ← Beam Splitter Lock — opens only while two linked sensors are lit at once · **M253 Lamp Timer** ← Beam Timer — Signal Lamp switches on/off every N Moves · **M254 Blackout Patch** ← Dark Cells — trains under it hidden & locked until a beam lights the cell |
| 7 | 3001–3500 | **Turntable Yards+** (Rotation) | **M301 Rotating Yard Block** ← Sub-board Rotor — 4×4 sub-board rotates 90° CW on lever tap (1 Move) · **M302 Spinning Station Exits** ← Rotating Edges — open edge segments shift one segment CW around the border every N Moves · **M303 Spinner Engine** ← Spin Path — train's dir rotates 90° CW each Move · **M304 Turntable Lock** ← Rotation Lock — a turntable/yard can't rotate until its linked key train exits |
| 8 | 3501–4000 | **Overgrown Branch Line** (Growth) | **M351 Wild Ivy+** ← Vine Spread+ — ivy grows into up to 2 free neighbours every N Moves (U,R,D,L order) · **M352 Hedge Trimmer Car** ← Pruner Tile — a completed lane over it removes all ivy orthogonally adjacent to that lane · **M353 Seed Wagon** ← Seed Path — on exit drops a seed on its last body cell that sprouts ivy after N Moves · **M354 Flower Arch** ← Bloom Gate — gate opens permanently once K ivy cells touch it |
| 9 | 4001–4500 | **Couple & Uncouple** (Split & Merge) | **M401 Coupling Pad** ← Merger Pad — tap (1 Move) when two linked trains' heads are on the pads ⇒ they merge into one train (front + rear) · **M402 Twin Split Train** ← Twin Splitter — tap splits into two trains side-by-side facing the same dir · **M403 Coupling Lock** ← Segment Lock — Uncoupling Train segment can't leave until a key train exits · **M404 Rejoin Arch** ← Rejoin Gate — passable only by halves of a split train, opens fully after both halves pass |
| 10 | 4501–5000 | **Timetable Master** (Sequencing) | **M451 Metronome Gate** ← Rhythm Gate — open/closed follows a repeating Move pattern (e.g. O-O-C) · **M452 Departure Code Lock** ← Pattern Lock — opens once trains exit in the shown colour code · **M453 Platform Order Exit** ← Order Edge — edge segment accepts trains only in their numbered order · **M454 Echo Signal** ← Echo Sequence — next N exits must repeat the colours of the previous N exits |
| 11 | 5001–5500 | **Twin Tables** (Linked Boards: 2 mini boards) | **M501 Table Bridge** ← Board Link Edge — exiting via the linked edge of table A enters table B at the matching edge · **M502 Inter-table Ticket** ← Cross-board Key — ticket train on A opens a barrier on B · **M503 Mirror Table** ← Mirror Board — a Move on a twin train on A mirrors on B · **M504 Relay Tunnel** ← Relay Portal — tunnel pair spanning both tables |
| 12 | 5501–6000 | **Hill Line** (Gravity: a gravity direction, loose items fall) | **M551 Tilt Lever** ← Gravity Lever — tap (1 Move) sets gravity dir; loose items fall until blocked · **M552 Loose Crates** ← Falling Blockers — each Move fall 1 cell in gravity dir if free · **M553 Balloon Pad** ← Anti-grav Tile — loose item on it ignores gravity · **M554 Ballast Train** ← Weight Path — train falls 1 cell in gravity dir each Move if free |
| 13 | 6001–6500 | **Fog on the Line** (Hidden Info) | **M601 Scout Draisine** ← Scout Path — on exit reveals all hidden cells within 1 of its lane · **M602 Mirage Steam** ← Mimic Fog — steam shows decoy trains; Route Peek reveals them as empty · **M603 Painted Backdrop** ← False Wall — looks like a fence but lanes pass; Route Peek shows green through it · **M604 Lantern Plate** ← Reveal Plate — while a train covers it, fog within radius 2 is lifted |
| 14 | 6501–7000 | **Looking-Glass Line** (Mirror Worlds) | **M651 Mirror Rail Axis** ← Mirror Axis — tapping a train also moves its mirrored twin across the axis (both must be clear) · **M652 Reflection Lock** ← Reflect Lock — barrier opens only when its mirrored counterpart is open · **M653 Mirror Table** ← Twin Board — duplicate mirrored table shares every Move · **M654 Reverse Engine** ← Inverse Path — on the mirrored half it exits opposite to its arrow |
| 15 | 7001–7500 | **Moving Platforms** (Conveyors & Tracks) | **M701 Belt Switch** ← Belt Junction — directs belt flow L/R, tap toggles (1 Move) · **M702 Reversing Belt** ← Reversible Belt — linked lever reverses its direction · **M703 Belt Stop Lever** ← Belt Lever — starts/stops linked belts · **M704 Loop Belt** ← Track Loop — closed conveyor ring carrying trains 1 cell per Move (a belt, not a free-running circuit; trains still exit straight) |
| 16 | 7501–8000 | **Ticket Office** (Keys Deluxe) | **M751 Ticket Chain** ← Key Chain — barrier opened by ticket A releases ticket B, and so on · **M752 Ticket Punch** ← Key Crafting — two half-tickets collected combine into one full ticket · **M753 Master Pass** ← Skeleton Key — opens the first barrier its lane reaches, then is spent · **M754 Ticket Swap Pad** ← Key Swap — tap (1 Move) swaps ticket icons between two linked trains |
| 17 | 8001–8500 | **Clock Towers** (Guardians) | **M801 Twin Clock Towers** ← Twin Guardian — two towers share one HP pool · **M802 Armoured Clock Tower** ← Shield Guardian — HP drops only when linked trains exit in a fixed order · **M803 Depot Tower** ← Spawner Guardian — every N Moves places a Buffer Stop in its first free neighbour until HP 0 · **M804 Clock Core** ← Guardian Core — vanishes only when HP 0 **and** its core cell is lit by a beam |
| 18 | 8501–9000 | **Remix A** (P1–P6 systems) | **M851–M854**: 4 combo-mechanics chosen by data — each combines two systems from Phases 1–6 (e.g. Ticket Cart through a Day/Night Tunnel); picked from the highest-engagement / lowest-quit variants of Phases 3–8 (§10) |
| 19 | 9001–9500 | **Remix B** (P7–P12 systems) | **M901–M904**: 4 combo-mechanics from Phases 7–12, chosen the same way |
| 20 | 9501–10000 | **Grand Master** (all systems) | **M951–M954**: 4 combo-mechanics chosen by data across all systems; **L10000 Grand Finale** = every signature system on one 14×14 board (Marching Clock Tower boss) |

Phase 20's 4 base mechanics are not named by the standard ("all systems") — defined here as data-chosen combos like Phases 18–19.

## 8. Variant / Modifier System

### 8.1 Modifiers (exact rules — game definition; names from standard §11)

| Modifier | Theme name | Exact rule | Applies to (categories) |
|---|---|---|---|
| `Frozen(K)` | Snowbound | Instance inactive until K trains orthogonally adjacent to any of its cells exit (interactive taps = locked tap, counters don't tick, passive tiles keep their initial state); trains with Frozen ⇒ M003 rule | T, C, D, G, P |
| `Colored` | Painted | Instance interacts only with trains of colour c; for other colours its cell is a blocker (bump) | D, G, L, T plates/pads |
| `Fogged` | Steamy | Instance starts under a Steam Cloud (M010) area; clears per M010; while fogged its interactive taps are locked, passive behaviour unchanged, Route Peek shows "?" at the fog edge | all non-X |
| `Chained` | Linked | Instance linked to a partner of the same base; any action/trigger on one applies to the partner in the same Move; if the partner's action is impossible ⇒ whole action is a locked tap (train ⇒ M011 rule) | T, P, D |
| `Countdown(N)` | Last Call | After N Moves the instance flips permanently: blockers/gates/locks **open**; helpers (portals, ramps, pads, sheds, mirrors) **become 1-cell blockers**. Badge N. Ticks in step 3 after the Phase 2 list | B, K, D, G, L |
| `Phasing` | Phantom | Instance exists only when pre-increment `moveCount` is even (M021 semantics); on odd it is absent (non-blocking, not tappable) | B, D, T, G |
| `Armored` | Iron-clad | Not hammerable; immune to Popper Crate and Domino clears; on a train: Track Crane can't target it | B, X, P |
| `Layered` | Deck | Instance placed on layer 1 or 2; affects only trains on that layer (requires `layers ≥ 2`) | B, D, T, G, K |
| `Mirrored` | Looking-glass | Directions reflected across the vertical axis (R↔L, UR↔UL, DR↔DL); rotations become CCW; `/`↔`\` | D, T, P |
| `Growing` | Sprouting | Every N Moves the instance adds 1 cell into the first free orthogonal neighbour (U,R,D,L; oldest cell first); trains with Growing ⇒ M047 rule | B, C |

Variant ID = `"<base>~<MOD>[param]"`, e.g. `M013~CHN`, `M007~FRZ2`, `M084~PHS`. JSON: base `type` + `mods` object.

### 8.2 Variant selection rules
- Each phase's 45 variants: base from any earlier phase **or** this phase's bases (after their intro block); every variant unique across all phases.
- Modifier must be in the base's "applies to" category; generator rejects incompatible pairs (e.g. `Colored` on M049 Guardian).
- Spread: each of the 10 modifiers used 4–5 times per phase; ≥ 15 of 45 variants use this phase's signature bases.
- Variant intro levels follow the x1 intro rule: only the variant (+ ≤ 1 earlier mechanic).
- Modifiers stack only in Remix phases (18–20), max 2 per instance.

### 8.3 Tutorial card per variant
Every variant intro (x1) shows a card: **title** "<Base themed name> · <Modifier theme name>" (e.g. "Turntable · Linked"), **one-line rule** from §8.1 filled with params ("These two turntables always turn together"), **3-frame animated demo** auto-generated from a template board for that modifier, and "Got it". Shown once per variant (`seenTutorials` set), re-openable from the level's ⓘ button. Cards localized (EN / ગુજરાતી / हिन्दी) via ARB templates with params.

## 9. Content Cadence & Release Gating

| Rule | Detail |
|---|---|
| One phase per release | Each app update adds 1 phase: signature + 4 base mechanics (engine code, art, audio, tutorials), meta + overrides files |
| Remote Config `maxPhase` | Levels above `maxPhase × 500` show "New tracks under construction". RC condition `app_version ≥ release N` so `maxPhase` can't exceed shipped content |
| Release trigger (decision rule, no assumed numbers) | Start rollout of phase n+1 when analytics shows a configurable share of D30-active players within 50 levels of the current cap (`cadence_trigger_share`, set by product) |
| Staged rollout | Store staged rollout first; `maxPhase` raised only after crash-free and validator dashboards are green |
| Star Race | Needs ≥ 15 unplayed levels under `maxPhase` ([Phase 2 04 §3.1](./phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |

## 10. Live Tuning via Analytics

- Per-level metrics (standard §15 events): first-attempt win rate, attempts per clear, hearts lost, booster use per type, revive rate, quit-in-level rate, median `duration_s`, Hint "Try Reverse Gear" rate.
- Dashboards per phase / block slot / mechanic / variant; outliers = levels outside the slot's expected range for its tier (ranges set from Phases 1–2 data, not assumed).
- **Tuning knobs without breaking determinism (game definition):** Remote Config `genProfile[phase]` selects one of **≤ 3 pre-validated generator parameter profiles** bundled with the app (each has its own CI-validated overrides + meta). RC never sends raw generator parameters. Profiles affect only levels not yet in `levelCache`.
- Economy knobs (coins, prices, rewards) stay standard Remote Config values.
- Remix phases (18–20) choose combo mechanics from variant metrics of Phases 3–12.

## 11. QA at Scale

| Layer | Practice |
|---|---|
| CI per PR | Unit tests per mechanic/modifier (`mNNN_test.dart`, `mod_frz_test.dart` …); golden tick-order tests; PRNG golden vectors (VM + dart2js) |
| CI nightly | Full regeneration + validation of L1001–10,000 for every bundled profile, sharded by phase; diff vs previous `seed_overrides.json` / meta (unexpected diffs fail) |
| Determinism | 1,000 random Phase 3+ levels generated on Android ARM64, iOS, VM, dart2js; CRC must match meta |
| Replay | Every stored `solution` replayed on the reference engine ⇒ Win; random-order fuzz (1,000 Move sequences/level sample) ⇒ no crash, no illegal state |
| Manual | Every base intro, every variant tutorial card, every Finale played on device; QA checklist rows per mechanic "Not run" until executed (format: [Phase 2 06 §10](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md)) |
| Production | Crashlytics CRC-mismatch alerts, `level_fail` spikes per level, Hint-fail rate alerts |

## 12. Storage Estimates (computed from schema v3)

Method: synthetic levels in the exact schema v3 shape (random train lengths 2–5, 8 colours, 8 dirs, mechanics with 1–3 cells and params, `solution` = P + 4 entries), minified JSON, Python `gzip` level 9; 200 samples per row. These are **computed upper-bound estimates** at tier maxima, not measured shipped files.

| Item | Basis | Estimate |
|---|---|---|
| Level JSON, T5 max (11×11, 30 trains, 10 mech) | raw / in gz pack | ≈ 4.1 KB / ≈ 0.44 KB per level |
| Level JSON, P2-A max (13×13, 34, 12) | raw / in gz pack | ≈ 4.7 KB / ≈ 0.52 KB |
| Level JSON, P2-B max (14×14, 40, 14) | raw / in gz pack / gz alone | ≈ 5.5 KB / ≈ 0.62 KB / ≈ 1.13 KB |
| `phase_1.json.gz` (500 levels, ≤ T5 max) | 500 × 0.44 KB | **≤ ≈ 220 KB** |
| `phase_2.json.gz` (500 levels, ≤ P2-B max) | 500 × 0.62 KB | **≤ ≈ 310 KB** |
| Decoded Phase 1 + 2 JSON in memory | 500 × 4.1 + 500 × 5.5 KB | ≤ ≈ 4.8 MB (decode once, keep index; or decode per level) |
| `seed_overrides.json` worst case (all 9,000 levels k ≠ 0, `"10000":63,` ≤ 11 B) | computed exactly | **≤ 90,001 B ≈ 88 KB** |
| `phase_N_meta.bin` | 9 B header + ~44 B solution (P2-B: 40 + 4) ≈ 53 B × 500 | ≈ 26 KB per phase · ≈ 477 KB for Phases 3–20 |
| `levelCache` (gzip JSON per reached Phase 3+ level) | 9,000 × 1.13 KB | ≤ ≈ 10 MB for a player at L10,000 (grows with progress) |
| Save `stars` (10,000 levels) | Hive `Uint8List` 1 B/level | 10 KB (vs `Map<int,int>` ≈ 18 B/entry ≈ 180 KB — prefer bytes) |
| Firestore `users/{uid}.progress.stars` | 1 char/level | 10,000 B at L10,000 (≪ 1 MiB doc limit) |

## 13. Game Definitions Made Here (standard silent)
1. Phase 3+ mechanic IDs `M(50·(p−1)+1…4)`, signature IDs `S03–S20`.
2. Block 50 x1 of Phases 3–20 = review level (49 slots ⇒ blocks 1–49).
3. Phase 20 base mechanics = 4 data-chosen combos.
4. Exact rules + category compatibility for all 10 modifiers; Countdown tick slot after the Phase 2 counters.
5. `phase_N_meta.bin` (k, par, D, CRC, solution) shipped alongside `seed_overrides.json`.
6. `levelCache` fill on first generation (implements the standard's freeze).
7. Remote Config tuning only via ≤ 3 pre-validated `genProfile`s.
8. hash64 = two 32-bit FNV-1a lanes (JS-safe).
9. Phase 3+ tier constraints (§3.5).
