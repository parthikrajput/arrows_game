# Scaling to 10,000 Levels — 500 થી 10,000 levels content & scalability planning
> Purpose: Yarn Unravel ને 500 levels થી 10,000 levels સુધી કેવી રીતે લઈ જવું — દરેક phase નું content pipeline, generator algorithm (reverse construction + solver, D formula, validator), seeds & overrides, PRNG, JSON schema, Phases 3–20 (yarn-themed signature systems + 4 new base mechanics each), variant/modifier system, release cadence, analytics થી live tuning, QA at scale અને storage/size estimates.

**Related docs:** [../SHARED_CORE_STANDARD.md](../SHARED_CORE_STANDARD.md) (§9 Phases, §11 Phases 3–20, §12 Pipeline & Generator) · [./README.md](./README.md) · [./phase_1/02_LEVEL_PROGRESSION_0001_0500.md](./phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [./phase_2/02_LEVEL_PROGRESSION_0501_1000.md](./phase_2/02_LEVEL_PROGRESSION_0501_1000.md) · [./phase_2/03_OBSTACLE_CATALOG_PHASE_2.md](./phase_2/03_OBSTACLE_CATALOG_PHASE_2.md) · [./phase_2/06_FRONTEND_AND_QA_PHASE_2.md](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md)

> Standard §11–§12 ના rules binding છે. Standard માં ન હોય એવી planning choices (Phase 3+ D bands, mechanic ID numbering, modifier themed names, CI budgets) "Proposal" તરીકે લખી છે. Size numbers schema માંથી **compute** કર્યા છે (§12), market data નહીં.

---

## 1. Goals & Constraints

| Goal | How |
|---|---|
| 10,000 levels without 10,000 hand-made files | Phase 1–2 bundled (hand-tuned + generated), Phase 3–20 **on-device generation** from seeds |
| 100% deterministic, offline | `seed = hash64(gameId, level, GENERATOR_VERSION)`, custom PRNG, CI-validated seeds + shipped `seed_overrides.json` ⇒ no device retry loop |
| Every level fair | Solvable with **0 hearts lost & 0 boosters** (CI proves every level) |
| "Something new every 10 levels" | Every x1 slot introduces a new base mechanic or a new **variant** with its own tutorial card |
| Difficulty never drops | Phase n+1 lowest band ≥ Phase n last-tier mid (standard §9.3) |
| Small app size | Phase 3+ ships code + overrides, not level files |

## 2. Content Pipeline per Phase (standard §12)

| Phase | Levels | Source | Hand-tuned | Shipped as |
|---|---|---|---|---|
| 1 | 1–500 | `tools/levelgen` (Dart CLI) + designer | L1–30, every x1, every x9, L500 | `assets/levels/phase_1.json.gz` |
| 2 | 501–1000 | `tools/levelgen` + designer | L501–510, every x1, every x9, L1000 | `assets/levels/phase_2.json.gz` |
| 3–20 | 1001–10,000 | **on-device** `puzzle_core` generator | none (slot templates tuned by designers; CI-validated) | generator code + `seed_overrides.json` + tutorial cards |

Per-phase release pipeline:

| Step | Owner | Output |
|---|---|---|
| 1. Design 4 base mechanics + signature system | Design | catalog cards (standard §10 fields) |
| 2. Implement in `puzzle_core` + unit tests | Eng | `mXXX_test.dart` per ID |
| 3. Choose 45 variants (§8.4) | Design + data | `phase_N_plan.json` (slot → base/variant) |
| 4. Slot templates (grid, threads, obstacle budget, D window per slot) | Design | `phase_N_slots.json` |
| 5. CI: generate all 500 levels × attempts k = 0…63, validate, record first passing k | CI | `seed_overrides.json` delta, report |
| 6. Determinism check across platforms (§11.3) | CI | golden hash file |
| 7. Device play-test sample (§11.4) | QA | QA sheet (status Not run → result) |
| 8. Ship app update; set Remote Config `maxPhase = N` | Release | live phase |

## 3. Generator Algorithm

### 3.1 Inputs per level
`level` ⇒ `phase = (level − 1) ~/ 500 + 1`, `block = ((level − 1) % 500) ~/ 10 + 1`, `slot = level % 10` (0 ⇒ x0). Slot template gives: grid range, threads range, max obstacle instances, allowed mechanics (unlocked ≤ this level), intro mechanic (x1), D target window, tag (x5 Easy, x9 Hard, x0 milestone, finale).

### 3.2 Reverse construction (static solvability)
```
generate(level, k):
  rng   = Xoshiro128ss.fromSeed(seedFor(level) + k)
  T     = slotTemplate(level)
  board = emptyBoard(rng.pick(T.gridRange))
  place obstacles: intro mechanic first (≤ 3 instances on x1), then mix (≤ T.maxObstacles)
  order = []                                   // solution order, built backwards
  for i in 1..rng.range(T.threads):
      // new thread must be able to exit in the state where all threads placed so far
      // have ALREADY exited  (= it is earlier in the solution)
      cand = sampleThread(board, rng, T)       // shape, dir (8-dir from M051), layer, colour
      if laneClear(board_without(order), cand) and not createsCrossing(cand):
          board.add(cand); order.prepend(cand)
      else retry up to 40 samples, else stop adding
  attach thread-variants / keys / links consistent with `order`
  return board, solutionHint = order
```
- Static blockers: this guarantees solvability (standard §12).
- Directional devices (mirrors, bumpers, portals) are included in `laneClear` evaluation.

### 3.3 Solver for stateful mechanics (C, T, K, X)
Required after construction whenever the level has any stateful mechanic (standard §12):

| Item | Value |
|---|---|
| State | remaining threads (bitset), thread positions/dirs/colours/layers (if mutable), mechanic states (gates, counters, crates, HP, lint TTL, fog set, rotation index), Move parity/counters |
| Search | BFS for small states; IDA\* with heuristic `h = remaining threads` (admissible: each exit needs ≥ 1 Move) |
| Transitions | only **non-snag** Moves (snag costs a Heart ⇒ not allowed in a 0-heart proof); booster use excluded |
| Limits | node limit **2M** (CI), depth ≤ **3 × P** |
| Dedupe | Zobrist hashing (64-bit as two 32-bit words, §4) over state components |
| Output | optimal Move sequence ⇒ JSON `solution`, `par_moves = solution.length` |
| Reject | unsolved / over limit ⇒ attempt fails |

### 3.4 Difficulty D (standard §9.4)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = thread count, C = longest dependency chain (solver), O = obstacle instances,
N = non-monotone mechanic instances, S = solution Moves − P
```
Attempt rejected if D ∉ slot target ±3 (x9 target = band high × 1.1, finale = band high × 1.2 — standard §16.13).

### 3.5 Validator checks (every attempt)
1. Schema v3 valid; ids unique; cells in board; no two bodies in one cell per layer.
2. Solvable with 0 hearts & 0 boosters (§3.3).
3. D in band.
4. No thread initially locked **forever** (every thread appears in the solution).
5. Phase 1 grids: min cell ≥ 29 dp at 360 dp; ≥ 12×12 ⇒ zoom flag.
6. Intro levels: intro mechanic + ≤ 1 earlier mechanic.
7. Mechanic-specific checks (e.g. diagonal no-crossing, square board for rotator, even split length — [phase_2/06 §7](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md)).
8. Loop guards terminate (lanes, beams, portals).
9. **Device solve budget (Proposal):** the solver must find `solution` within **500k nodes** (so the device can rebuild it for Hint/par in an isolate); else try next k.

### 3.6 Attempts & overrides
- Attempt k uses `seed + k`, k = 0…63 (standard §12).
- CI validates **all** levels L1001–10,000 for the current `GENERATOR_VERSION`; the first passing k ≠ 0 is written to `seed_overrides.json`.
- No k passes ⇒ **CI fails** (release blocked); fix = adjust that slot's template or generator, never ship an unvalidated level.

## 4. Seeds & PRNG

- `seedFor(level) = hash64("yarn_unravel", level, GENERATOR_VERSION)`; JSON shows it as `"0x" + 16 hex`.
- PRNG: **xoshiro128\*\*** with **32-bit operations only** (standard §12 — Dart `Random` not used). All arithmetic masked to 32 bits and multiplications split into 16-bit halves so results are identical on the Dart VM (Android/iOS/CLI) and in JavaScript (Cloud Functions verifier).

```dart
const int _m32 = 0xFFFFFFFF;

/// 32-bit wrapping multiply, exact on the Dart VM and in JS (no >2^53 products).
int mul32(int a, int b) {
  final aHi = (a >>> 16) & 0xFFFF;
  final aLo = a & 0xFFFF;
  return ((aLo * b) + (((aHi * b) & 0xFFFF) << 16)) & _m32;
}

int rotl32(int x, int k) => ((x << k) | (x >>> (32 - k))) & _m32;

int fmix32(int h) {
  h = mul32(h ^ (h >>> 16), 0x85EBCA6B);
  h = mul32(h ^ (h >>> 13), 0xC2B2AE35);
  return (h ^ (h >>> 16)) & _m32;
}

/// 64-bit seed as two 32-bit words.
typedef Seed64 = ({int hi, int lo});

/// Two independent FNV-1a lanes + avalanche. Input: "gameId|level|version".
Seed64 hash64(String gameId, int level, int generatorVersion) {
  final bytes = '$gameId|$level|$generatorVersion'.codeUnits; // ASCII ids only
  var a = 0x811C9DC5;
  var b = 0x01000193 ^ 0x5BD1E995;
  for (final c in bytes) {
    a = mul32(a ^ (c & 0xFF), 0x01000193);
    b = mul32(b ^ (c & 0xFF), 0x01000193);
  }
  final hi = fmix32(a);
  final lo = fmix32(b ^ hi);
  return (hi: hi, lo: lo);
}

/// seed + k with carry (k = 0…63).
Seed64 addAttempt(Seed64 s, int k) {
  final lo = s.lo + k; // ≤ 2^32 + 63, exact on VM and JS
  final carry = lo > _m32 ? 1 : 0;
  return (hi: (s.hi + carry) & _m32, lo: lo & _m32);
}

class Xoshiro128ss {
  Xoshiro128ss._(this._s0, this._s1, this._s2, this._s3);

  factory Xoshiro128ss.fromSeed(Seed64 seed) {
    var state = (seed.hi ^ mul32(seed.lo, 0x9E3779B9)) & _m32;
    int next() {
      state = (state + 0x9E3779B9) & _m32;
      return fmix32(state);
    }

    final s0 = next(), s1 = next(), s2 = next(), s3 = next();
    // xoshiro must not start from the all-zero state.
    return Xoshiro128ss._(
        (s0 | s1 | s2 | s3) == 0 ? 1 : s0, s1, s2, s3);
  }

  int _s0, _s1, _s2, _s3;

  /// Next uniformly distributed 32-bit unsigned value.
  int nextUint32() {
    final result = mul32(rotl32(mul32(_s1, 5), 7), 9);
    final t = (_s1 << 9) & _m32;
    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = rotl32(_s3, 11);
    return result;
  }

  /// Unbiased integer in [0, n), n ≥ 1 (rejection sampling).
  int nextInt(int n) {
    final limit = 0x100000000 - (0x100000000 % n);
    while (true) {
      final r = nextUint32();
      if (r < limit) return r % n;
    }
  }

  int range(int minInclusive, int maxInclusive) =>
      minInclusive + nextInt(maxInclusive - minInclusive + 1);
}
```
Golden test vectors (first 8 outputs for 5 fixed seeds) live in `packages/puzzle_core/test/prng/xoshiro_golden.json`; CI runs them on VM and on the JS build.

### 4.1 `GENERATOR_VERSION` policy
- Bumped only when generator output changes for any not-yet-released level.
- Every Phase 3+ level is **cached on first reach** (compact binary, §12.3). A version bump therefore never changes a level a player has already seen — the cache *is* the freeze (standard §12). Unreached levels use the new version + its `seed_overrides.json`.
- Cache entries store `{level, generatorVersion, k}` for support/debug.

### 4.2 `seed_overrides.json`
```json
{"generatorVersion": 7, "overrides": {"1012": 3, "1349": 1, "2207": 12}}
```
Missing level ⇒ k = 0. Shipped in the app bundle (standard). A Remote Config patch of overrides is **not** used (it could change an unreached level after the player has seen its preview; app updates only).

## 5. Level JSON (schema v3) — Phase 3+ usage

Same schema as standard §12 plus optional keys (Proposal):
```json
{
  "schema": 3, "level": 1131, "phase": 3, "seed": "0x3A91C2D07E55B014",
  "tag": "intro", "grid": [12, 12], "layers": 2, "hearts": 3,
  "system": {"cycle": {"period": 5, "start": "A"}},
  "generator": {"version": 7, "k": 0},
  "paths": [
    {"id": "p1", "color": "rose", "dir": "UR", "body": [[3,9],[2,10],[1,11]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M013", "cells": [[6,6]], "params": {"path": "p4"}, "hammerable": false,
     "variant": {"mod": "frozen", "k": 2, "neighbors": ["p2", "p7"]}},
    {"id": "o2", "type": "M101", "cells": [[4,0]], "params": {"openIn": "A"}, "hammerable": false}
  ],
  "goals": {"gems": 0},
  "par_moves": 41, "difficulty": 63.8,
  "solution": ["p1", "o1", "p4"]
}
```
- `variant` lives on the base mechanic's entry (`type` stays the base ID) ⇒ engines that know the base also know which modifier wrapper to apply.
- On device the JSON is produced in memory and cached in compact binary form (§12.3).

## 6. Phase 3+ Difficulty Bands (Proposal)

Standard §9.3 defines tiers only to L1000 and the rule "next phase lowest band ≥ previous last-tier mid". To keep D bounded while never dropping:

| Item | Rule |
|---|---|
| Band, Phase p (3…20) | `low = 61 + 3·(p − 3)`, `high = low + 6` ⇒ P3 61–67 … P20 112–118 |
| Check | mid(p) = low + 3 = low(p + 1) ⇒ rule satisfied with equality |
| Grid / threads / obstacles | P2-B caps: 12×12–14×14, 28–40 threads, 8–14 instances (difficulty grows via C, N, S — new systems — not board size) |
| Block windows | 3-wide windows ramping low → high across the phase; x9 ×1.1; finale ×1.2 |
| Re-banding | analytics (§10) may shift a phase's band before release; never for released levels |

## 7. Phases 3–20 (yarn-themed)

ID numbering (Proposal): Phase p's 4 base mechanics get `M{(p−1)·50 + 1 … +4}` (Phase 3: M101–M104, Phase 4: M151–M154 … Phase 20: M951–M954). Each phase: L(start)…L(start+9) = signature-system onboarding block; slots 1–49 = x1 of blocks 2–50; **base intros at slots 1, 13, 25, 37** (Phase 3: L1011, L1131, L1251, L1371); the other 45 slots = variants (§8).

| Phase | Levels | Signature system (yarn name) | 4 new base mechanics — 1–2 line rule each |
|---|---|---|---|
| 3 | 1001–1500 | **Cycles — Day & Night Loom:** board state A/B flips every 5 Moves (`floor(m/5) % 2`) | **Cycle Gate (Loom Latch)** — gate open in its state (A or B), closed in the other. **Cycle Bridge (Day Bridge)** — Stitch Bridge in its state, Single Blocker in the other. **Cycle Portal (Night Pompom)** — Pompom Tunnel pair active in its state; in the other the pompom cells are blockers. **Cycle Color (Twilight Eyelet)** — Color Eyelet whose colour is colour-A in state A and colour-B in state B |
| 4 | 1501–2000 | **Multi-floor — Sewing Room Floors:** up to 3 stacked floors, view switch button | **Stairs (Spiral Spool Stair)** — lane entering stair continues on the linked floor at the same cell & dir. **Glass Floor (Organza Floor)** — threads below organza cells are visible and tappable from the floor above. **Drop Hole (Drop Hole)** — lane reaching it drops the thread to the floor below at that cell (relocate, 1 Move); next tap continues. **Elevator (Bobbin Lift)** — tap lift (1 Move) moves the thread whose needle is on it to the next floor (cyclic) |
| 5 | 2001–2500 | **Push Physics+ — Crate Workshop** | **Crate Holes (Crate Pit)** — crate pushed into pit fills it; both become floor. **Sliding Ice Crates (Satin Crate)** — crate that always slides until hitting something (no glide patch needed). **Crate Keys (Charm Crate)** — crate pushed onto its matching clasp opens it permanently (crate consumed). **Heavy Crate (Iron Crate)** — moves only when pushed by a Chunky Chenille or a Ribbon-Tied Pair lane; otherwise snag |
| 6 | 2501–3000 | **Light & Beams+ — Lamplight Atelier** | **Color Filter (Tinted Glass)** — beam passing takes the glass colour; coloured Sun-Catchers light only for matching beams. **Beam Splitter Lock (Prism Clasp)** — clasp opens permanently when ≥ 2 beams hit it after the same Move. **Beam Timer (Hourglass Lamp)** — emitter on for N Moves, off for N Moves (Move-based). **Dark Cells (Shadow Pocket)** — threads with any body cell in a dark pocket are locked until a beam passes over that pocket |
| 7 | 3001–3500 | **Rotation — Turning Table** | **Sub-board Rotor (Hoop Rotor)** — tap rotates a 4×4 region 90° CW (fully-inside contents only). **Rotating Edges (Turning Hem)** — open edge segments move 1 segment CW around the border every Move. **Spin Path (Twirl Thread)** — thread whose `dir` rotates 90° CW after every Move. **Rotation Lock (Ratchet Pin)** — pinned threads/regions ignore all rotations until the pin's key thread exits |
| 8 | 3501–4000 | **Growth — Garden Knitting** | **Vine Spread+ (Ivy Yarn)** — Spreader that grows every N Moves into 2 cells (oldest first, U,R,D,L). **Pruner Tile (Snip Tile)** — a lane passing it removes growth cells in its 8 neighbours. **Seed Path (Seed Bead Thread)** — on exit leaves a seed at its tail cell that becomes a Wooden Button after 3 Moves unless a thread body covers it. **Bloom Gate (Blossom Gate)** — opens permanently after K adjacent growth cells are removed |
| 9 | 4001–4500 | **Split & Merge — Ply & Twist** | **Merger Pad (Twisting Pad)** — tap pad (1 Move) merges two threads whose needles sit on its two cells into one thread (front + back). **Twin Splitter (Double Split)** — like Split-Ply but both halves keep the original `dir`. **Segment Lock (Stitch Lock)** — Chain-Stitch segment k locked until its key thread exits. **Rejoin Gate (Rejoin Gate)** — opens when both halves of one split thread have passed it |
| 10 | 4501–5000 | **Sequencing — Pattern Book** | **Rhythm Gate (Metronome Gate)** — open on Moves matching a repeating open/closed pattern (e.g. O,C,C). **Pattern Lock (Pattern Clasp)** — opens once threads exit in its shown colour order. **Order Edge (Ordered Hem)** — edge accepts exits only in ascending tag number; others snag. **Echo Sequence (Echo Card)** — the colour order of the first k exits must be repeated by the next k; mismatching colour = locked tap |
| 11 | 5001–5500 | **Linked Boards — Twin Hoops** (2 mini boards) | **Board Link Edge (Seam Edge)** — lane leaving board A through the seam enters board B at the matching row/col, same dir. **Cross-board Key (Cross Charm)** — key on one hoop opens a clasp on the other. **Mirror Board (Mirror Hoop)** — tapping a thread on A also taps its mirrored twin on B (both must succeed, −1 total on fail). **Relay Portal (Relay Pompom)** — pompom pair spanning the two hoops |
| 12 | 5501–6000 | **Gravity — Hanging Loom** | **Gravity Lever (Plumb Lever)** — tap (1 Move) sets gravity U/R/D/L for loose objects. **Falling Blockers (Dropping Buttons)** — loose buttons fall in gravity dir until stopped, after every Move. **Anti-grav Tile (Float Patch)** — objects on it never fall. **Weight Path (Weighted Thread)** — thread translates 1 cell in gravity dir each Move if all destination cells free |
| 13 | 6001–6500 | **Hidden Info — Mystery Basket** | **Scout Path (Scout Thread)** — on exit clears all fog within 1 cell of its lane. **Mimic Fog (Decoy Fluff)** — fluff that hides nothing; disappears when any lane passes it. **False Wall (Painted Wall)** — looks like a Ruler Strip but lanes pass; revealed on first pass. **Reveal Plate (Lantern Plate)** — while covered by a thread body, all fog is see-through (still locked) |
| 14 | 6501–7000 | **Mirror Worlds — Looking-Glass Quilt** | **Mirror Axis (Mirror Seam)** — threads across the axis are twins; a successful exit of one also exits its twin if the twin's lane is clear (else both snag, −1 total). **Reflect Lock (Reflect Clasp)** — opens when its mirrored clasp opens. **Twin Board (Twin Quilt)** — interactive toggles on one half apply to the mirrored half. **Inverse Path (Inverse Thread)** — when its twin moves, it moves the opposite way |
| 15 | 7001–7500 | **Conveyors & Tracks — Feed Dog Factory** | **Belt Junction (Belt Switch)** — tap toggles which branch a belt feeds. **Reversible Belt (Reversing Belt)** — belt direction flips every N Moves. **Belt Lever (Belt Lever)** — tap toggles linked belts on/off. **Track Loop (Track Loop)** — thread on a closed loop track rides 1 cell per Move; exits only from the marked exit cell |
| 16 | 7501–8000 | **Keys Deluxe — Jewel Box** | **Key Chain (Charm Chain)** — keys must be collected in chain order; out-of-order key thread = locked tap. **Key Crafting (Charm Crafting)** — two half-charm threads must both exit to forge the key. **Skeleton Key (Skeleton Charm)** — opens the first clasp of any colour that its lane passes. **Key Swap (Charm Swap Hoop)** — tap swaps key colours of two linked threads |
| 17 | 8001–8500 | **Guardians — Pincushion Court** | **Twin Guardian (Twin Pincushions)** — two guardians share one HP pool. **Shield Guardian (Armoured Pincushion)** — immune to HP loss while its linked lever is in the "shield" position. **Spawner Guardian (Seeding Pincushion)** — every N Moves spawns a Wooden Button in the first free neighbour (U,R,D,L). **Guardian Core (Heart Pincushion)** — HP drops only when a linked exit happens while a beam hits its core cell |
| 18 | 8501–9000 | **Remix A** (systems of P1–P6) | 4 combo-mechanics **chosen by data** (§10.3). Candidate pool: Cycle Crate, Floor Beam, Fogged Stair, Satin Charm Crate, Tinted Cycle Gate, Lift Lamp |
| 19 | 9001–9500 | **Remix B** (systems of P7–P12) | 4 combo-mechanics chosen by data. Candidate pool: Twirl Weighted Thread, Ivy Hoop Rotor, Rhythm Belt, Seam Edge Split, Plumb Pattern Lock, Echo Twin Hoop |
| 20 | 9501–10,000 | **Grand Master — all systems** | 4 slots: data-chosen mixes of all systems; **L10000 Grand Finale "The Endless Tapestry"** (Moving Guardian + every signature system once) |

Every new base mechanic gets a full catalog card (standard §10 fields) in `phase_N/03_OBSTACLE_CATALOG_PHASE_N.md` before step 2 of §2.

## 8. Variant / Modifier System

### 8.1 Definition
**Variant = existing base mechanic × modifier** (standard §11). Modifiers: `Frozen(K)`, `Colored`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`.

### 8.2 Exact modifier rules (Proposal — engine-binding once adopted)
| Modifier | Yarn name | Exact rule |
|---|---|---|
| `Frozen(K)` | **Knotted** | Instance inert until K threads in its precomputed neighbour set (threads orthogonally adjacent to its cells at level start) exit. While inert: blockers still block; interactive taps = locked tap; helpers (portal, ramp, mirror, plate) have no effect (cell acts as Single Blocker). Badge K (M003 semantics) |
| `Colored(c)` | **Dyed** | Effect applies only to threads of colour c; for other colours the cell acts as Single Blocker. Not for pure blockers (no difference) |
| `Fogged` | **Fluffed** | Instance starts under a Wool Fluff area covering its cells (M010): hidden, interactive taps locked, rules still active; clears by M010 rule. Thread Peek shows "?" where a lane enters fog |
| `Chained` | **Ribbon-Tied** | Two instances of the same base linked: any tap/trigger/state change on one is applied to the other in the same Move; for threads = M011 (both lanes clear or both snag, −1 total) |
| `Countdown(N)` | **Basting (N)** | Instance removed permanently after N Moves (badge N). Gates/blockers ⇒ open; helpers ⇒ lost |
| `Phasing` | **Sheer** | Active on even Move count; inactive on odd (non-blocking, no effect, not tappable) — M021 semantics |
| `Armored` | **Brass-Plated** | Not hammerable; removed/disabled only by a linked lever (M074 semantics). Only for hammerable bases |
| `Layered(l)` | **Tulle** | Instance on layer l ∈ {1, 2}; interacts only with same-layer lanes/threads; requires level `layers > l` |
| `Mirrored` | **Mirror-Stitched** | Instance has a twin at `(W − 1 − x, y)` with mirrored orientation params; both share state; triggering one triggers both |
| `Growing(N)` | **Growing** | Every N Moves gains 1 cell into the first free orthogonal neighbour (oldest cell first, U,R,D,L); for threads = M047 tail growth |

### 8.3 Compatibility matrix
| Modifier \ Category | B | K | C | T | P | D | L | G | X |
|---|---|---|---|---|---|---|---|---|---|
| Frozen(K) | – | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | – |
| Colored | – | ✓ | ✓ | ✓ | – | ✓ | ✓ | ✓ | – |
| Fogged | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | – | ✓ | – |
| Chained | – | ✓ | ✓ | ✓ | ✓ | ✓ | – | ✓ | ✓ |
| Countdown(N) | ✓ | – | – | ✓ | ✓ | ✓ | ✓ | ✓ | – |
| Phasing | ✓ | ✓ | – | ✓ | ✓ | ✓ | ✓ | ✓ | – |
| Armored | ✓ (hammerable only) | – | ✓ (hammerable only) | – | – | – | – | – | ✓ (M077) |
| Layered | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | – | ✓ | ✓ |
| Mirrored | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | – |
| Growing(N) | ✓ | – | ✓ | – | ✓ | – | – | – | ✓ |

Validator also rejects semantic no-ops (e.g. `Colored` Single Blocker, `Phasing` Torn Hole) and stacking > 1 modifier on one instance.

### 8.4 Choosing 45 variants per phase
1. Pool = all (base ≤ previous phase) × allowed modifiers, minus variants used in earlier phases.
2. Each modifier used 4–5 times per phase; each base at most once per phase.
3. Ranking signal (from §10): prefer bases with healthy fail rates and low quit rates; avoid bases already flagged as confusing.
4. Order inside the phase: variants of the phase's new base mechanics appear only after their base intro slot.

### 8.5 Tutorial card per variant
- Each variant's first appearance (its x1 slot) is an **intro level**: only that variant (+ ≤ 1 earlier mechanic), ≤ 3 instances (validator).
- Card = base card art + modifier badge (knot, dye drop, fluff, ribbon, basting stitch, sheer shimmer, brass plate, tulle, mirror stitch, sprout) + generated text from ARB templates: `"{modifierName} {baseName}: {modifierRule}"` (en / gu / hi), designer-reviewed before release.
- Shipped in `assets/tutorial_cards/phase_N.json`; Purl tooltip + tutorial hand on the first variant instance.

## 9. Content Cadence

| Item | Rule |
|---|---|
| Release unit | **One phase (500 levels) per app release** (new mechanic code + overrides + cards) |
| Activation | Remote Config `maxPhase` (standard §11); default = highest phase in the binary that QA signed off |
| Trigger to start next phase's production | Analytics: share of active players within 100 levels of `maxPhase × 500` (threshold in Remote Config, decided by the team — not a fixed calendar) |
| Players at the end | "New patterns coming soon" + Daily Stitch, Weekly Star Race, Scrapbook (Phase Complete screen) |
| Rollback | Lower `maxPhase` only blocks *entering* new levels; already-reached levels stay playable from cache |

## 10. Live Tuning via Analytics

### 10.1 Signals (standard §15 events)
Per level: `level_start`, `level_win` (moves, hearts_lost, stars, duration_s), `level_fail`, `booster_use`, `revive`. Derived: fail rate = fails / starts, attempts per win, ★★★ rate, booster-per-win, quit-after-fail (session end within 60 s of `level_fail`).

### 10.2 Re-banding
1. For each slot type (x1 … x0) compute the median of each signal across the phase; flag levels outside the inter-quartile range × 1.5 (outliers) — thresholds in config.
2. **Phase 1–2 (bundled):** designer edits flagged levels; fixed JSON ships in the next app update (only affects players who haven't reached that level yet; reached levels are unchanged for fairness of stars).
3. **Phase 3+ (generated):** for an unreleased phase, adjust slot templates / D windows and regenerate in CI; for a released phase, only levels not yet reached by any cache can change — achieved by a new `GENERATOR_VERSION` + new overrides in an app update.
4. **D formula calibration:** offline regression of fail rate vs (P, C, O, N, S) per phase; weight changes go through the standard (change standard first, then all four games — standard header rule).

### 10.3 Remix phases (18–20)
Combo-mechanic candidates (§7) are ranked by: engagement on their component systems (win rate band, low quit), designer feasibility, and solver cost (node counts from CI).

## 11. QA at Scale

### 11.1 CI runtime budget (Proposal)
| Job | Scope | Budget |
|---|---|---|
| PR (generator / `puzzle_core` change) | all x1 + x9 + finale levels of all released and next phase (100 per phase) + 2% random others | ≤ 30 min wall |
| Nightly | all 9,000 Phase 3–20 levels × needed attempts, sharded by phase (18 shards) | ≤ 60 min wall per shard |
| Release gate | full nightly result for the phase being released must be green + overrides regenerated | blocking |

Workload is bounded: ≤ 9,000 × 64 attempts, each solve ≤ 2M nodes; CI records actual node counts and wall time per level in the report to keep the budget honest (no assumed throughput).

### 11.2 Validation sampling
- Phase 1–2: **100%** of 1,000 levels every PR touching levels or `puzzle_core` (bundled, cheap).
- Phase 3+: full nightly + PR sample (§11.1); any failure ⇒ full run of that phase.

### 11.3 Determinism
Golden hashes (FNV over canonical JSON) for every 100th level + all intros, generated on Dart VM x64 (CI), Android ARM64 and iOS ARM64 (device farm), and the JS verifier build. Any mismatch ⇒ release blocked.

### 11.4 Device play-test sample per phase
All 4 base intros, all 45 variant intros, 10 random x9 Hard levels, the finale, and 20 random levels — on DM-1 (low-tier) and DM-6 (ProMotion). Results recorded with status Not run / Pass / Fail / Blocked.

## 12. Storage & Size Estimates (computed from the schema)

### 12.1 Bundled JSON (Phase 1–2)
Measured on **synthetic** schema-v3 levels (random layouts, average body length 4 cells, minified JSON, gzip level 9 over 500 levels). Real levels compress differently; CI reports actual sizes.

| Profile | Threads / obstacles / extra moves | Raw per level | gzip per level (in 500-level file) | 500 levels gzip |
|---|---|---|---|---|
| T1-like | 10 / 3 / 2 | ≈ 1.4 KB | ≈ 0.12 KB | ≈ 60 KB |
| P2-A mid | 29 / 9 / 5 | ≈ 3.8 KB | ≈ 0.40 KB | ≈ 195 KB |
| P2-B max | 40 / 14 / 10 | ≈ 5.4 KB | ≈ 0.59 KB | ≈ 288 KB |

⇒ `phase_1.json.gz` + `phase_2.json.gz` are expected in the low hundreds of KB — small relative to the 60 MB download budget ([phase_1/07 §11](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)).

### 12.2 `seed_overrides.json`
Entry `"1349":1,` ≈ 9–10 bytes. Worst case (every one of 9,000 levels needs k ≠ 0) ≈ 90 KB raw; actual count comes from CI.

### 12.3 On-device level cache (Phase 3+)
Compact binary per level (Proposal): header 32 B · per thread `id, colour, dir, layer, length` 5 B + 1 B per cell (x·16 + y, grids ≤ 16×16) · per obstacle ≈ 10 B · solution 1 B per step.
For the P2-B-max profile: 32 + 40 × (5 + 4) + 14 × 10 + 50 = **582 B/level**.
Worst case (a player has reached all 9,000 generated levels): 9,000 × 582 B ≈ **5.2 MB**; typical players store far less (only reached levels). Stored in a Hive box `levelCache`, gzip optional.

### 12.4 Save & cloud
- `progress.stars`: 1 byte per level locally; cloud map entry ≈ 8–10 bytes (`"1234":3,`) ⇒ 10,000 levels ≈ 100 KB — under the 1 MiB Firestore document limit but moved to per-phase docs `users/{uid}/stars/{phase}` from Phase 3 ([phase_2/05 §7](./phase_2/05_OFFLINE_AND_CLOUD_SYNC.md)).
- Op-log: v4 ops TTL 30 days; v5 once-only ops ≈ 4 per level (win, clear, star3, piggy) ⇒ grows with progress; each op doc ≈ 150–200 B of fields.

### 12.5 Code size
Each phase adds 4 mechanic files + modifier wrappers are shared ⇒ engine code grows linearly and modestly; tutorial cards and sticker/skin art are the main asset growth and are budgeted per release.
