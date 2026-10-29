# 500 થી 10,000 levels content & scalability planning
> Snakes Slither ને 500 levels થી 10,000 levels સુધી લઈ જવાનો plan: phase-wise pipeline, generator (reverse construction + solver), D formula અને validator, seeds/overrides/PRNG, JSON schema, Phases 3–20 jungle mechanics, variant/modifier system, content cadence, analytics-driven tuning, QA at scale અને storage estimates.

**Related docs:** [Game overview](./README.md) · [Shared Core Standard §9–§12, §16](./SHARED_CORE_STANDARD.md) · [Phase 1 Progression](./phases/phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [Phase 2 index](./phases/phase_2/README.md) · [Phase 2 Progression](./phases/phase_2/02_LEVEL_PROGRESSION_0501_1000.md) · [Phase 2 Catalog](./phases/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md)

---

## 1. Goal & Numbers
| Item | Value |
|---|---|
| Total levels | 10,000 = 20 phases × 500 |
| Phase 1–2 (L1–1000) | Offline generated + hand-tuned, **bundled JSON** |
| Phase 3–20 (L1001–10,000) | **On-device deterministic generation** from seeds (CI pre-validated) |
| Mechanics | 49 (P1) + 49 (P2) + 18 × 4 new base mechanics (P3–P20) = 170 base mechanics + variants |
| New thing every 10 levels | દરેક block ના x1 slot પર નવું mechanic **અથવા** નવો variant (standard §9.2, §11) |
| Rules | Standard §2 core rules બધા phases માં યથાવત (turn-based, no forced damage, 0-heart solvable) |

## 2. Pipeline per Phase (standard §12)
| Stage | Phase 1–2 (L1–1000) | Phase 3+ (L1001–10,000) |
|---|---|---|
| Generate | `tools/levelgen` (Dart CLI, `puzzle_core` same code) | Same generator on device (isolate) |
| Hand-tune | L1–30, દરેક x1 intro, દરેક x9 Hard, Finales (designer editor) | Designer **seed review**: x1, x9, Finale seeds CI માં render કરી review; ખરાબ ⇒ `seed_overrides.json` માં બીજો valid `k` |
| Validate | CI validator (§3.6) on every PR | CI validator **all** L1001–10,000 seeds (k = 0…63) |
| Ship | `assets/levels/phase_1.json.gz`, `phase_2.json.gz` | Generator code + `seed_overrides.json` + mechanics code in app update; Remote Config `maxPhase` |
| On device | Decode JSON (isolate, lazy) | `generate(level)` ⇒ `LevelDef` (≤ 300 ms budget mid-tier) ⇒ cache JSON |
| Fix after release | Remote Config `levelOverrides` ⇒ bundled alternate file | Remote Config `levelOverrides` ⇒ CI-validated alternate `k` (§4.3) |

```
            ┌──────────────┐   ┌───────────────┐   ┌─────────────┐   ┌──────────────┐
 params ──► │ Reverse       │─► │ Place          │─► │ Solver       │─► │ Validator     │─► accept (JSON)
 (slot,     │ construction  │   │ mechanics      │   │ (stateful)   │   │ D band, rules │
 tier)      └──────────────┘   └───────────────┘   └─────────────┘   └──────┬───────┘
                                                                          reject ⇒ next k (seed + k)
```

## 3. Generator
### 3.1 Inputs (per level)
`level`, `phase`, `slot` (block role), tier params (grid range, path range, obstacle range, D band), mechanic pool (§9 standard + phase list), modifiers allowed, `seed`.

### 3.2 Reverse Construction (standard §12)
1. Empty board W×H (from tier range, PRNG). Optional silhouette mask (Daily only).
2. Choose path count P (tier range). Place snakes one by one in **reverse of the solution order** (standard §12): the first snake placed is the **last** to exit.
   - Candidate exit lane for the new snake: random edge cell (or inner exit) + direction (8-dir from Phase 2). The lane must be clear of static blockers **and of every already-placed snake** (they are still on the board when the new snake exits, because they exit later).
   - Grow the new snake from its head (cell just behind the lane start) through **free** cells, 2–8 cells, 8-connected from Phase 2, `body[1] = body[0] − dir`.
   - The new snake's body **may** lie on lanes of already-placed snakes — that is exactly a dependency ("this one first"), each such overlap adds an edge for C.
   - Independent exits (C = 0) vs deep chains are steered by how often new bodies are grown across earlier lanes (D target).
   - Equivalent forward view: when snake `i` exits, every snake that exits before it is gone, so its lane only needs to avoid snakes that exit after it.
3. Static blockers (B category) placed on cells that no solution lane crosses ⇒ solvability preserved (standard: reverse construction guarantees solvability for static blockers).
4. Stateful mechanics (C, T, K, X, plus D/L/P with state) placed from templates per mechanic (e.g. key snake = a snake earlier in exit order, its lock on a later snake's lane).
5. Compute C (dependency edges, standard §16.16), O, N, S.

### 3.3 Solver (stateful mechanics, standard §12)
- **Mandatory** when level has any C/T/K/X mechanic (and any Phase 2+ stateful D/P/L: push, rotation, paint, layers, beams).
- Search: BFS for small states, **IDA\*** for large (heuristic h = remaining snakes + unsatisfied goals).
- State key `(remaining snakes, mechanic states via encode(), moveCount mod LCM(periods), parity)`; periods = M057 `2n`, M058 4, M079 `4n`, M090/M021/M096 2, Phase 3 cycles 10.
- Limits: CI node limit **2M**, depth ≤ **3 × P**. Unsolved / over limit ⇒ reject.
- Output: optimal Move sequence ⇒ `solution` + `par_moves` (Hint + Tuesday par + Star Race plausibility).
- Solver rules = engine rules (same `puzzle_core.Engine.apply`) ⇒ no drift.

### 3.4 D Formula (standard §9.4)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = paths, C = longest dependency chain (edges), O = obstacle instances (marker entries excluded),
N = non-monotone instances, S = solution Moves − P
```
Target: slot band (±3); x9 = band high × 1.1, Finale = × 1.2 (standard §16.13). Generator tries to hit target by adjusting P, C (lane crossings), O, N before the solver step (cheap) and re-checks after the solver (exact C, S).

### 3.5 Phase 3+ Tiers (this game's plan)
Standard §9.3 tiers end at Phase 2. Phase 3+ grid stays phone-safe (Phase 2 cell rule `fitCell ≥ 22 dp`): grid **12×12–14×14**, paths **28–40**, obstacle instances **8–14**. D band = **fixed plateau 60–76** for every Phase 3–20 (standard §17.24); x9 Hard = high × 1.1, Finale = high × 1.2 (§16.13). Phase 2 P2-B (52–70) થી plateau નો lower edge 60 ≥ P2-B mid (61 ≈ 60) — non-decrease rule plateau થી replace થાય છે.

| Phase | D band | x9 Hard target | Finale target |
|---|---|---|---|
| 3–20 (each) | **60–76** | ≈ 84 | ≈ 91 |

- Difficulty numbers થી નહીં પણ **નવા mechanics / signature systems / variants** થી આવે છે (standard §17.24). Block ની અંદર x1 intro (low) → x9 Hard (high) નો ફરક દરેક phase માં એકસરખો રહે.
- Grid 12×12–14×14 per board/floor (zoom), paths 28–40, obstacle instances 8–14 (આ game નો plan, plateau band ની અંદર).

### 3.6 Validator (CI)
| Check | Rule |
|---|---|
| Solvable | 0 hearts lost, 0 boosters (solver replay) |
| D | In slot band ±3 (x9/Finale multipliers allowed) |
| No forever-locked snake | Every snake exits in `solution` |
| Cell size | Phase 1: min cell ≥ 29 dp; Phase 2+: `fitCell ≥ 22 dp` |
| Intro rule | x1 = intro mechanic/variant + ≤ 1 earlier mechanic type |
| FTUE | L1–3 optimal ≤ 4 Moves, L4–10 ≤ 8 |
| Structure | `body[1] = body[0] − dir`, 8-connected, ids unique, schema 3 |
| Combos | Phase 1 + Phase 2 ban tables + per-phase bans |
| Loops | No lane/beam loop (same cell + dir twice) |
| Fair info | No "blind lane" through hidden cells in `solution` before reveal |
| Determinism | Re-generate same seed ⇒ byte-identical JSON |
| Caps | Instances ≤ tier max; Finale composition rule |

## 4. Seeds, Overrides & PRNG
### 4.1 Seeds (standard §12)
- `seed = hash64(gameId, level, GENERATOR_VERSION)`; attempt `k` uses `seed + k`, `k = 0 … 63`; first valid wins.
- CI pre-validates all L1001–10,000; levels whose first valid `k ≠ 0` ⇒ `seed_overrides.json` (`{"1234": 5, …}`) shipped in app ⇒ **device પર retry loop નહીં**, 100% deterministic.
- 64 attempts fail ⇒ CI failure ⇒ generator/params fix before release (ship blocker).

### 4.2 GENERATOR_VERSION
- Generator code/params બદલાય ⇒ `GENERATOR_VERSION + 1`. Player એ પહેલેથી **reach** કરેલા levels (≤ `highestCleared + 1`) JSON cache માં **freeze** (standard §12) ⇒ નવા version થી બદલાતા નથી.
- Cache key: `gen/{level}.json.gz` (Hive box `level_cache`), version stamp સાથે.

### 4.3 Live Overrides
- CI દરેક Phase 3+ level માટે પહેલા **3 valid `k`** values + તેમના D, par record કરે (`validated_k.json`, shipped).
- Per-phase `phase_N_meta.bin` (shipped, standard §17.34): per level attempt `k`, par, D, CRC, `solution` ⇒ device Hint ને CI-size solver ક્યારેય જરૂરી નથી. Live tuning માત્ર ≤ 3 pre-validated generator profiles વચ્ચે switch કરી શકે.
- Remote Config `levelOverrides: {"1234": 1}` = "use 2nd valid k" ⇒ માત્ર `validated_k.json` માં હોય તેવું `k` accept (નહીં તો ignore). Player એ level reach કર્યું હોય (cache frozen) ⇒ override લાગુ નહીં.

### 4.4 PRNG & Hash (Dart, native 64-bit ints)
```dart
// packages/puzzle_core/lib/src/prng/xoshiro128ss.dart
const int _m32 = 0xFFFFFFFF;

/// 32-bit FNV-1a step using only operations that stay < 2^53
/// (identical on Dart VM/AOT and JS tooling).
int _fnv1a32(int basis, String key) {
  var h = basis;
  for (final unit in key.codeUnits) {
    h = (h ^ unit) & _m32;
    // h * 0x01000193 mod 2^32 == h * 0x193 + (h << 24)
    h = ((h * 0x193) + ((h << 24) & _m32)) & _m32;
  }
  return h;
}

/// hash64 (standard §17.35): two independent 32-bit FNV-1a lanes with
/// different offset bases, concatenated hi:lo, over "gameId|level|version".
int hash64(String gameId, int level, int generatorVersion) {
  final key = '$gameId|$level|$generatorVersion';
  final hi = _fnv1a32(0x811C9DC5, key); // standard FNV-1a 32 offset basis
  final lo = _fnv1a32(0x050C5D1F, key); // second lane, different basis
  return (hi << 32) | lo;
}

/// xoshiro128** with 32-bit state words; seeded via splitmix64.
class Xoshiro128ss {
  Xoshiro128ss(int seed64) {
    var sm = seed64;
    int next() {
      sm += 0x9E3779B97F4A7C15;
      var z = sm;
      z = (z ^ (z >>> 30)) * 0xBF58476D1CE4E5B9;
      z = (z ^ (z >>> 27)) * 0x94D049BB133111EB;
      return z ^ (z >>> 31);
    }

    for (var i = 0; i < 4; i++) {
      _s[i] = next() & _m32;
    }
    if (_s.every((v) => v == 0)) _s[0] = 1;
  }

  final List<int> _s = List<int>.filled(4, 0);

  static int _rotl(int x, int k) => ((x << k) | (x >>> (32 - k))) & _m32;

  int nextUint32() {
    final result = (_rotl((_s[1] * 5) & _m32, 7) * 9) & _m32;
    final t = (_s[1] << 9) & _m32;
    _s[2] ^= _s[0];
    _s[3] ^= _s[1];
    _s[1] ^= _s[2];
    _s[0] ^= _s[3];
    _s[2] ^= t;
    _s[3] = _rotl(_s[3], 11);
    return result;
  }

  /// Uniform int in [0, max), max ≤ 2^31.
  int nextInt(int max) => (nextUint32() * max) >> 32;

  double nextDouble() => nextUint32() / 4294967296.0;
}
```
- Dart `Random` વાપરવો નહીં (standard §12). Golden vectors: `test/prng/golden_test.dart` — first 1,000 outputs for seeds {0, 1, hash64("snakes_slither", 1001, 1)} Android ARM64 + iOS + x64 CI પર identical.
- `hash64` 32-bit lanes વાપરે છે ⇒ JS tooling સાથે identical (standard §17.35). `Xoshiro128ss` seeding (splitmix64) 64-bit wrap વાપરે ⇒ generator native targets (Dart VM/AOT) પર જ ચાલે; tooling golden vectors થી ચકાસે.

## 5. Level JSON (schema v3)
Standard §12 schema (+ `slot` field, Phase 2 8-dir, `layers` up to 3):
```json
{
  "schema": 3, "level": 1234, "phase": 3, "seed": "0x5A1F00C3D4E5F607",
  "tag": "normal", "slot": "practice", "grid": [13, 13], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "teal", "dir": "DL", "body": [[6,2],[7,1],[8,1]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M101", "cells": [[4,6]], "params": {"state": "A"}, "hammerable": false},
    {"id": "o2", "type": "M014", "cells": [[9,3]], "params": {"orient": "/", "mod": {"kind": "Countdown", "n": 6}}, "hammerable": false}
  ],
  "goals": {"gems": 0},
  "par_moves": 37, "difficulty": 66.2,
  "solution": ["p4", "o1", "p1"],
  "gen": {"version": 1, "k": 0}
}
```
- Variant = base mechanic + `params.mod` (`kind` + modifier params). `gen` block only for generated levels (cache freeze check).

## 6. Phases 3–20 (themed for the jungle, standard §11)
Mechanic IDs: Phase n base mechanics = `M(50·(n−1)+1)` … +3 (Phase 3: M101–M104, Phase 4: M151–M154, … Phase 20: M951–M954). Slot map (standard §17.38): block 1 x1 = **signature system intro**; x1 of blocks **2, 14, 26, 38** = the 4 new base mechanics; x1 of remaining blocks 3–49 (excluding 14, 26, 38) = **45 variants**; block 50 x1 = **review / "Mastery Mix" level** (no new item, standard §17.34), x0 = Phase Finale.

| Phase | Levels | Signature system (themed) | ID | Base mechanic (themed / generic) | Rule (1–2 lines) |
|---|---|---|---|---|---|
| 3 | 1001–1500 | **Day & Night Garden** (Cycles: board state A/B every 5 Moves; sun/moon dial HUD) | M101 | Sun-Moon Gate / Cycle Gate | Open in Day (A), closed in Night (B) (or inverted by param) |
| | | | M102 | Moonlight Root Bridge / Cycle Bridge | Bridge exists only in its state; outside it the cell is plain floor (body on it blocks normally) |
| | | | M103 | Day-Night Burrows / Cycle Portal | Portal pair active only in its state; inactive ⇒ burrow = blocker |
| | | | M104 | Twilight Flower Gate / Cycle Color | Flower Gate whose colour alternates between 2 colours with the cycle |
| 4 | 1501–2000 | **Great Tree Floors** (Multi-floor: up to 3 stacked grids, floor tabs; viewing a floor = no Move) | M151 | Root Stairs / Stairs | Lane entering stairs continues on the adjacent floor from the linked stair cell |
| | | | M152 | Dewglass Floor / Glass Floor | See-through cell: snakes above do not lock snakes below at this cell |
| | | | M153 | Knot Hole / Drop Hole | Lane on upper floor reaching it drops to the floor below, same cell, same dir |
| | | | M154 | Vine Lift / Elevator | Tap (1 Move): platform + snake fully on it moves 1 floor (direction alternates) |
| 5 | 2001–2500 | **Coconut Grove Physics** (Push Physics+) | M201 | Coconut Pit / Crate Holes | Coconut pushed into pit fills it ⇒ pit becomes floor; empty pit = lane blocker |
| | | | M202 | Dew-Slick Coconut / Sliding Ice Crates | This coconut slides on any floor until the next cell is not free |
| | | | M203 | Key Coconut / Crate Keys | Coconut carrying a key; pushed onto matching lock cell ⇒ lock opens permanently |
| | | | M204 | Jackfruit Boulder / Heavy Crate | Only a Giant Anaconda or a chained-group push moves it; a single normal snake ⇒ bump |
| 6 | 2501–3000 | **Sun Temple Light** (Light & Beams+) | M251 | Petal Filter / Color Filter | Beam passing takes the filter colour; coloured receivers light only with matching colour |
| | | | M252 | Prism Lock / Beam Splitter Lock | Lock opens permanently when ≥ 2 beams hit it in the same Move |
| | | | M253 | Sundial Receiver / Beam Timer | Must stay lit N consecutive Moves to latch its gate open |
| | | | M254 | Shade Leaves / Dark Cells | Snakes with head in a dark cell are locked until any beam passes through that cell |
| 7 | 3001–3500 | **Whirlwind Valley** (Rotation) | M301 | Island Spinner / Sub-board Rotor | Tap: 4×4 region rotates 90° CW (partial snakes ⇒ locked tap) |
| | | | M302 | Turning Hedges / Rotating Edges | Edge wall segments shift 1 edge cell clockwise around the border each Move |
| | | | M303 | Spinning Snake / Spin Path | Snake's dir rotates 90° CW after every Move (exit with the right timing) |
| | | | M304 | Gear Lock / Rotation Lock | Lock open only while the linked rotor is at its marked orientation |
| 8 | 3501–4000 | **Overgrown Garden** (Growth) | M351 | Wild Vine / Vine Spread+ | Every N Moves grows into its first **two** free neighbours (U,R,D,L order) |
| | | | M352 | Pruning Shears Tile / Pruner Tile | Lane passing it removes all vine cells orthogonally adjacent to the lane cell |
| | | | M353 | Seed-Carrier Snake / Seed Path | On exit drops a seed at its marked cell; seed becomes a blocker after N Moves unless a lane passes it |
| | | | M354 | Bloom Gate / Bloom Gate | Gate opens permanently when all linked vines are pruned |
| 9 | 4001–4500 | **Twin Rivers** (Split & Merge) | M401 | Hug Pad / Merger Pad | Two snakes with heads on the pad pair: tap pad ⇒ merge into one snake (A's head, A's body + B's body) |
| | | | M402 | Fork Stump / Twin Splitter | Lane entering it splits the snake into two halves exiting 90° left and right; both lanes must be clear |
| | | | M403 | Bead Lock / Segment Lock | Lock opens after N segment exits (M092) in total |
| | | | M404 | Reunion Gate / Rejoin Gate | Opens when both halves of a split snake have exited |
| 10 | 4501–5000 | **Jungle Drum Festival** (Sequencing) | M451 | Drum Gate / Rhythm Gate | Open/closed by a repeating Move pattern, e.g. [open, open, closed] |
| | | | M452 | Totem Pattern Lock / Pattern Lock | Opens when the last k exits' colours equal its pattern |
| | | | M453 | Parade Exit / Order Edge | Edge segment accepts exits only in numbered order; wrong number ⇒ bump |
| | | | M454 | Echo Frogs / Echo Sequence | Group B (same colours) must exit in the same colour order group A exited, else locked |
| 11 | 5001–5500 | **Two Ponds** (Linked Boards: 2 mini boards side by side) | M501 | Vine Bridge Edge / Board Link Edge | Exit via linked edge on board 1 ⇒ snake re-enters board 2 at the opposite linked edge and lane continues |
| | | | M502 | Messenger Key / Cross-board Key | Key snake on one board opens a lock on the other |
| | | | M503 | Pond Reflection / Mirror Board | Tapping a snake on board 1 also taps its mirror twin on board 2 (both must be clear) |
| | | | M504 | Relay Burrow / Relay Portal | Portal pair whose ends are on different boards |
| 12 | 5501–6000 | **Monsoon Winds** (Gravity) | M551 | Wind Lever / Gravity Lever | Tap: gravity direction rotates 90° CW (HUD arrow) |
| | | | M552 | Falling Fruit / Falling Blockers | After each Move, loose fruit blockers fall 1 cell along gravity if free |
| | | | M553 | Floaty Lily / Anti-grav Tile | Fruit on this tile does not fall |
| | | | M554 | Heavy Python / Weight Path | Snake that also falls 1 cell along gravity when all cells below are free |
| 13 | 6001–6500 | **Mystery Mists** (Hidden Info) | M601 | Scout Gecko / Scout Path | On exit reveals all hidden cells within 1 cell of its lane |
| | | | M602 | Trick Mist / Mimic Fog | After any exit, mist re-forms on 1 cell vacated by that snake unless a Scout has exited |
| | | | M603 | Painted Wall / False Wall | Looks like a wall but lanes pass; free preview shows the truth (fair) |
| | | | M604 | Glow Stone / Reveal Plate | While a snake body covers it, all hidden info in its 3×3 is revealed |
| 14 | 6501–7000 | **Pond Reflections** (Mirror Worlds) | M651 | Pond Axis / Mirror Axis | Board halves mirrored: a tap on one side also moves the mirror snake (both must be clear) |
| | | | M652 | Reflection Lock / Reflect Lock | Lock opens when the key snake on the **opposite** side exits |
| | | | M653 | Twin Pond / Twin Board | Two identical boards; win needs both cleared with the same tap sequence constraints |
| | | | M654 | Upside-down Snake / Inverse Path | Moves in the opposite direction of its mirror twin |
| 15 | 7001–7500 | **River Delta** (Conveyors & Tracks) | M701 | River Fork / Belt Junction | Conveyor junction routing left/right by switch state (tap = 1 Move) |
| | | | M702 | Tide River / Reversible Belt | Belt flow reverses every N Moves |
| | | | M703 | Sluice Lever / Belt Lever | Tap toggles linked belts on/off |
| | | | M704 | Whirlpool / Track Loop | Closed loop belt; snakes fully on it circulate each Move |
| 16 | 7501–8000 | **Treasure Keys** (Keys Deluxe) | M751 | Key Vine / Key Chain | Locks open in chain order: lock 1 opening releases key 2, etc. |
| | | | M752 | Key Bundle / Key Crafting | 2 half-keys (on 2 snakes) — both exited ⇒ full key opens the lock |
| | | | M753 | Golden Master Leaf / Skeleton Key | Key token that opens the first lock any later lane reaches |
| | | | M754 | Key Swap Stone / Key Swap | Tap (1 Move): two snakes exchange their keys |
| 17 | 8001–8500 | **Mongoose Clan** (Guardians) | M801 | Mongoose Twins / Twin Guardian | Two guardians share one HP pool |
| | | | M802 | Armadillo Guardian / Shield Guardian | Takes no HP damage while its linked shield lever is ON |
| | | | M803 | Mama Mongoose / Spawner Guardian | Every N Moves spawns a Garden Rock in the first free adjacent cell (cap 3) |
| | | | M804 | Mongoose Den Core / Guardian Core | HP drops only for linked snakes exiting via its marked side |
| 18 | 8501–9000 | **Remix A** (P1–P6 systems) | M851–M854 | 4 combo-mechanics chosen by data | Selected from Phases 1–6 systems by analytics (§9): highest engagement, low frustration |
| 19 | 9001–9500 | **Remix B** (P7–P12 systems) | M901–M904 | 4 combo-mechanics | Same selection rule over Phases 7–12 |
| 20 | 9501–10000 | **Grand Jungle Master** (all systems) | M951–M954 | 4 grand combos + **L10000 Grand Finale "Jungle Kingdom Crown"** | Finale = Prowling Mongoose Emperor + one instance from each signature system (≤ 14 instances) |

- દરેક phase finale (L1500, L2000 …): Jungle Treasure Chest (1,000 + 2 each booster + phase badge, standard §6.1) ⇒ Golden Slither Rush ⇒ Phase Complete (standard §16.20). Gift Basket x0 Phase 3+ = **300** (Phase 2 value; standard માં Phase 3+ value નથી ⇒ standard update વગર બદલવું નહીં).
- દરેક new base mechanic નું catalog card (Phase 1/2 format) phase release પહેલાં લખવું ફરજિયાત.

## 7. Variant / Modifier System (standard §11)
Variant = existing base mechanic × modifier. JSON: `params.mod = {"kind": …, …}`. Applicability validator માં.

| Modifier | Exact rule | Applies to | Tutorial card line |
|---|---|---|---|
| `Frozen(K)` | Instance is inert until **K orthogonally adjacent snakes exit** (M003 counting, layer-independent). While frozen: lane-type mechanics act as a Single Blocker; interactive taps = locked tap. Badge K | B, D, T, G | "Frozen! Free K neighbours to wake it." |
| `Colored(c)` | Instance's effect applies **only to lanes of colour c**; other colours treat the cell as a blocker (M005 rule) | Lane-type D, G, L (mirrors, portals, pads, ramps, exits) | "Only c snakes can use this." |
| `Fogged` | Instance sits under a 1-cell Jungle Mist (M010 rules): hidden & locked until a touching snake exits; physically active while hidden (no blind lanes in solution) | All except X | "Something hides in the mist…" |
| `Chained` | Two instances of the same base are linked: an action/trigger on one (tap, lane pass, exit trigger) applies to both in the same Move | T, D, C | "Linked by a vine — both act together." |
| `Countdown(N)` | Instance works for the first **N Moves**, then permanently becomes plain floor (blockers vanish, helpers stop). Badge N (Moves, not seconds) | B, D, T, G | "Lasts N moves!" |
| `Phasing` | Present on **even** moveCount, plain floor on odd (pre-increment parity, standard §16.17); max 1 parity type per level | B, D, G | "Blinks every other move." |
| `Armored` | Not hammerable; immune to Boom Puffball / Domino clears; HP-based bases (Termite Mound, Guardians) +1 HP | B, C, X | "Armored — the hammer won't work." |
| `Layered(l)` | Instance affects **only layer l**; other layers pass through (requires `layers ≥ 2`) | B, D, T, G | "Only affects the canopy/ground/treetop." |
| `Mirrored` | Handedness flip: CW ⇒ CCW rotations, arrows/flows reversed, `/` ⇔ `\`, deflections mirrored | D, T (rotors, arrows, belts, mirrors, bumpers, turntables) | "Everything turns the other way." |
| `Growing(N)` | Every N Moves the instance grows 1 cell into its first free orthogonal neighbour (U, R, D, L; M027 rules), max 4 cells | B (single-cell blockers, puffball, burr) | "Grows every N moves!" |

- **Tutorial card per variant:** auto-composed: base mechanic intro animation + modifier overlay icon + localized template line (ARB `variant_<modifier>_rule` with params) + Grandpa Tortoise one-liner; designer reviews all 45 cards per phase before release. Settings → Jungle Guide માં બધા.
- **Variant selection per phase (45):** CI script ranks candidates (base × modifier, applicable, not used in earlier phases) by analytics engagement/frustration (§9) and novelty; designer approves the list. No variant repeats across Phases 3–20 (18 × 45 = 810 ≤ available combos).
- Variant x1 levels: intro rule = variant + ≤ 1 earlier mechanic type.

## 8. Content Cadence
- **Release unit = phase (500 levels):** app update ships phase mechanics code + `seed_overrides.json` + `validated_k.json` + tutorial cards; content unlocked by Remote Config **`maxPhase`** (e.g. update ships Phase n+1 code while `maxPhase = n`).
- **Trigger** (analytics, not calendar): next phase release planned when ≥ 10% of 28-day active players have `highestCleared ≥ maxPhase × 500 − 150` (players near the cap). Review monthly.
- Pre-build buffer: CI keeps phases up to `maxPhase + 2` validated at all times.
- Players at cap: "More levels coming soon" card + Daily / Star Race / Album continue.

## 9. Live Tuning via Analytics
| Signal (standard §15 events) | Use |
|---|---|
| Per-level win rate, attempts, hearts lost, `booster_use`, `hint_fail` | Win rate < 35% (x9 < 25%) ⇒ review ⇒ swap to alternate valid `k` (Remote Config `levelOverrides`, §4.3) |
| Quit after level start (no win/fail) | Frustration flag for that mechanic/variant |
| Mechanic engagement (levels per session after intro) | Remix (Phases 18–19) and variant selection |
| Economy (`coins_earn`, `coins_spend`) | Remote Config economy keys; changes go through the standard first |
| Tutorial `ftue_step` / intro card skip | Card copy A/B |
- Overrides never apply to levels a player has already reached (frozen cache) ⇒ no "level changed under me".
- No unsourced targets: KPI thresholds above are review triggers; actual targets set from soft-launch data.

## 10. QA at Scale
| Layer | What |
|---|---|
| CI generation | All 9,000 Phase 3+ levels × up to 64 attempts, sharded (e.g. 32 runners); solver node limit 2M; full run on every generator change |
| Cross-platform determinism | Generate all 9,000 on Android ARM64 + iOS device farm + CI x64 ⇒ SHA-256 of each JSON must match |
| Golden levels | 200 frozen golden levels (every x1, x9, finale of Phases 3–4) checked byte-exact |
| Solver replay | Every `solution` replayed by engine ⇒ win with 0 hearts lost |
| Human review | Every x1 (intro / variant), x9, Finale rendered to PNG in CI artifacts; designer playtests a sample per phase (all intros + 1 per block) |
| On-device perf | `generate(level)` ≤ 300 ms mid-tier, ≤ 800 ms low-tier (isolate; next level pre-generated during current play) |
| Regression | Phase 1–2 bundled JSON unchanged by generator changes (checksum test) |
| Device QA | Phase-specific QA checklist (like [Phase 2 06 §10](./phases/phase_2/06_FRONTEND_AND_QA_PHASE_2.md#10-qa-checklist)); all rows "Not run" until executed |

## 11. Storage Estimates (computed from schema v3)
Method: synthetic levels generated with the schema v3 structure (random snakes 2–8 cells, 8 colours, mechanics with 1–3 cells + params), compact JSON + gzip -9 (script in build tools). Real levels are more regular ⇒ compress better; numbers are upper-side estimates.

| Item | Assumption | Raw | Gzip |
|---|---|---|---|
| Phase 1 level (avg) | P 20, O 6, 9×9 | ≈ 3.0 KB | — |
| Phase 2 level (avg) | P 32, O 10, 13×13 | ≈ 4.8 KB | — |
| Phase 3+ level (avg) | P 36, O 12, 14×14 | ≈ 5.5 KB | ≈ 1.2 KB single-file |
| `phase_1.json.gz` | 500 levels | 1.5 MB | **≈ 170 KB** |
| `phase_2.json.gz` | 500 levels | 2.4 MB | **≈ 290 KB** |
| If Phases 3–20 were bundled | 9,000 × 5.5 KB | 49.5 MB | ≈ 6 MB (not shipped — on-device generation) |
| `seed_overrides.json` | ~30% levels with k ≠ 0, ≈ 12 B/entry | ≈ 32 KB | ≈ 10 KB |
| `validated_k.json` | 9,000 × 3 k + D + par, ≈ 40 B | ≈ 360 KB | ≈ 90 KB |
| On-device level cache | Reached levels, gz per level ≈ 1.2 KB; worst case 9,000 | — | ≈ 11 MB worst case (typical player far less) |
| Firestore `users/{uid}` snapshot | Wallet, streak, album (100 stickers), cosmetics, settings | ≈ 4 KB | — |
| Firestore stars | 500 levels/doc × ≈ 7 B ⇒ 3.5 KB/doc; 20 docs at L10,000 | ≈ 70 KB | — |
| Firestore ops (90-day retention) | ≈ 220 B/op, ~40 ops/day active player | ≈ 0.8 MB/player/90 d | — |

- App download impact Phase 1–2 levels ≈ 0.5 MB; Phase 3+ adds only code + ≈ 100 KB metadata per release.
- Level cache eviction: keep frozen (version-mismatched) levels forever; evict regenerable levels older than the last 200 reached when cache > 5 MB.

## 12. Risks & Mitigations
| Risk | Mitigation |
|---|---|
| Generator change alters unplayed levels | Expected; reached levels frozen (§4.2) |
| Device generation too slow on low-tier | Pre-generate next 3 levels in isolate; cached |
| Difficulty creep / band narrowing | Fixed plateau 60–76 (standard §17.24, §3.5); variety from mechanics/systems/variants |
| Mechanic count explosion (170 bases) | Same `Mechanic` interface + per-mechanic tests + catalog card gate |
| Cross-platform int semantics | `hash64` = two 32-bit FNV-1a lanes (JS-safe, §4.4); golden vectors in CI on native targets |
