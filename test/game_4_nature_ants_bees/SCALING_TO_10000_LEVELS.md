# Scaling to 10,000 Levels — 500 થી 10,000 levels content & scalability planning
"Ants & Bees: Garden Trails" ને 20 phases × 500 levels સુધી લઈ જવાનો plan: phase pipeline, generator (reverse construction + solver), seeds/overrides, PRNG, JSON schema, Phases 3–20 garden mechanics, variant/modifier system, content cadence, live tuning, QA at scale અને storage estimates.

**Related docs:** [Shared Core Standard §9–§12, §16](../SHARED_CORE_STANDARD.md) · [Game README](./README.md) · [Phase 1 README](./phase_1/README.md) · [Phase 2 README](./phase_2/README.md) · [Phase 2 Rules](./phase_2/01_PHASE_2_SCOPE_AND_RULES.md) · [Phase 2 Catalog](./phase_2/03_OBSTACLE_CATALOG_PHASE_2.md)

---

## 1. Content Map (20 phases)

| Phases | Levels | Content source | Mechanics |
|---|---|---|---|
| 1 | 1–500 | Bundled `phase_1.json.gz` (offline generator + hand-tuning) | M001–M049 (+ M004/M032 Game 4 swap) |
| 2 | 501–1000 | Bundled `phase_2.json.gz` | M051–M099 |
| 3–20 | 1001–10,000 | **On-device generation** from seeds (CI pre-validated) | Per phase: 1 signature system + 4 base mechanics + 45 variants |

દરેક phase = 50 blocks × 10 levels; block pattern (x1 intro … x9 Hard, x0 Gift Box) અને Phase Finale (x500) Standard §9.2 મુજબ. Phase Chest (1,000 + 2 each booster + badge) દરેક 500 મા level પર.

## 2. Pipeline per Phase (Standard §12)

### 2.1 Phase 1–2 (bundled)
```
tools/levelgen (Dart CLI, puzzle_core)
  → candidate levels (seeded)  → solver + D  → designer hand-tune (L1–30, x1, x9, finale)
  → CI validator (all levels)  → assets/levels/phase_N.json.gz  → app bundle
```
- Hand-tuned: L1–30, દરેક x1 intro, દરેક x9 Hard, Finale. બાકી generator output + designer review pass.
- Hotfix: signed `levels_patch_v{n}.json` (Remote Config URL) — specific level ids replace; player already **in** that level (attempt open) ⇒ patch next attempt.

### 2.2 Phase 3+ (on-device)
```
seed = hash64(gameId="ants_bees", level, GENERATOR_VERSION)
k    = seed_overrides[level] ?? 0           // CI found first valid k (0…63)
level JSON = generate(seed + k, params(level))  // isolate, deterministic
cache[level] = JSON (frozen for this install)   // §6, GENERATOR_VERSION freeze
```
- CI pre-validates **all** L1001–10,000 seeds for each `GENERATOR_VERSION`; first failing k ⇒ next k; first success recorded in `seed_overrides.json` (shipped). ⇒ device પર retry loop **નહીં**, 100% deterministic.
- 64 attempts પણ fail (CI) ⇒ release blocker (designer adjusts params for that slot) — device ક્યારેય fallback board ન બનાવે.
- Prefetch: current level રમાતો હોય ત્યારે next 2 levels background isolate માં generate + cache.
- Per-phase **`phase_N_meta.bin`** (shipped, Standard §17.34): દરેક level માટે attempt `k`, `par_moves`, D, JSON CRC, packed `solution` ⇒ Nectar Glow Hint ને device પર CI-size solver ક્યારેય જોઈતો નથી (off-path Hint = on-device solver 50 ms budget, fallback "Try Dewdrop Rewind").

### 2.3 Release per phase
| Step | Artifact |
|---|---|
| 1 | Mechanics code (`puzzle_core/mechanics/m1xx…`) + art/audio + tutorial cards |
| 2 | Generator params table for the phase (tiers, slot bands, variant schedule) |
| 3 | CI: generate + validate 500 seeds × GENERATOR_VERSION ⇒ `seed_overrides.json`, `phase_N_meta.bin` |
| 4 | Designer pass: all 4 base intros, 45 variant intros, 50 x9, finale (play + tune params, regenerate) |
| 5 | App update ships phase code **dark**; Remote Config `maxPhase = n` staged rollout unlocks |

## 3. Generator (reverse construction + solver)

### 3.1 Inputs
`(level, phase, slot, tierParams{grid, lines, maxObstacles, dBand}, layerMix{ground, air, canopy}, diagonalShare, mechanicPool, variantForSlot, seed)`.

### 3.2 Reverse construction (per layer)
1. Empty board W×H (+ floors/boards for Phase 4/11).
2. Place **static blockers** (non-stateful mechanics) per pool and `maxObstacles`.
3. Pick exit order backwards: repeatedly place a new line (random layer per `layerMix`, orthogonal/diagonal per `diagonalShare`, length per tier) such that its lane is **clear in its own layer** given only previously placed lines (= lines that exit **after** it) and blockers (`layerAffects` rule: ground sees all, air/canopy see `tall`). Diagonal lanes use no-cutting rule.
4. Cover-lock aware: a lower-layer line placed under a higher-layer line ⇒ dependency edge (higher exits first) recorded.
5. Insert **stateful** mechanics (C, T, K, X, push, beams, variants) at positions the plan needs (e.g., a gate on the lane of a line that exits after the lever line).
6. Reverse sequence = candidate solution.

Static-only boards ⇒ step 3 guarantees solvability. Stateful mechanics ⇒ **solver mandatory**.

### 3.3 Solver
- BFS (small) / IDA* (large) over state `(remaining lines + positions + layers, mechanic states (gates, blocks, beams-derived, fog, counters), moveCount parity / mod-cycle, goals)`; node limit **2M (CI)**, depth ≤ 3×P; must reach win with **0 bumps (heart loss) and 0 boosters** (Standard rule 6). Bubble-pop bumps (M073) count as 0-heart moves.
- Heuristic (IDA*): remaining lines + unmet goals; transposition table keyed by 64-bit state hash (Zobrist from PRNG fixed seed).
- Output: optimal `solution` (Move ids), `par_moves`, `C` (longest dependency chain edges), node count.

### 3.4 Difficulty D (Standard §9.4)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = lines (all layers), C = longest dependency chain edges (independent ⇒ 0, §16.16),
O = obstacle instances, N = non-monotone instances (catalog "N" column / variant flag),
S = solution Moves − P
```
- Device-safe: D computed in **fixed point ×10 integers** (no floating decisions) ⇒ identical across platforms.
- Accept if `|D − slotTarget| ≤ 3`; x9 target = high × 1.1, Finale = high × 1.2 (Standard §16.13).
- **Phase 3–20 band = fixed plateau 60–76** (Standard §17.24): difficulty નવા systems/mechanics થી આવે, numbers થી નહીં. Grid 12×12–14×14 per board/floor (zoom/pan).

### 3.5 Validator (CI + device sanity)
| Check | CI | Device |
|---|---|---|
| Solvable 0 hearts / 0 boosters (solver) | ✅ | trust CI (solution replay check only) |
| D in band | ✅ | ✅ (recompute, cheap) |
| No line initially locked forever (cover/fog/frozen/key) | ✅ | — |
| Intro = intro mechanic/variant + ≤ 1 earlier | ✅ | — |
| Layer rules (canopy only after unlock, bee body not on tall blocker) | ✅ | ✅ |
| Mechanic-specific rules (Phase 1 §4, Phase 2 §4 tables) | ✅ | — |
| Zoom: fit cell ≥ 22 dp at 360 dp (≤ 14×14); Phase 3+ max grid 14×14 per board | ✅ | ✅ |
| JSON hash = CI golden hash (sampled 1%) | ✅ | debug builds |

## 4. Seeds, Overrides & Hash

```dart
// packages/puzzle_core/lib/src/prng/seed.dart  (Dart VM/AOT and JS tooling — identical results)
import 'dart:convert';

const int _m32 = 0xFFFFFFFF;
const int _fnvPrime32 = 0x01000193;
const int _offsetLo = 0x811C9DC5; // FNV-1a 32 standard offset basis
const int _offsetHi = 0x050C5D1F; // second, independent offset basis

/// 32×32 → low 32 bits, split into 16-bit halves so no intermediate exceeds 2^53 (JS-safe).
int _mul32(int a, int b) {
  final lo = a * (b & 0xFFFF);
  final hi = ((a * (b >>> 16)) & 0xFFFF) << 16;
  return (lo + hi) & _m32;
}

int _fnv1a32(List<int> bytes, int offset) {
  var h = offset;
  for (final b in bytes) {
    h = _mul32((h ^ b) & _m32, _fnvPrime32);
  }
  return h;
}

/// Standard §17.35: hash64 = two independent 32-bit FNV-1a lanes (different offset bases), concatenated.
({int hi, int lo}) hash64(String gameId, int level, int generatorVersion) {
  final bytes = utf8.encode('$gameId|$level|$generatorVersion');
  return (hi: _fnv1a32(bytes, _offsetHi), lo: _fnv1a32(bytes, _offsetLo));
}

/// Attempt k is added to the low lane (k = 0…63, mod 2^32).
({int hi, int lo}) seedFor(int level, int generatorVersion, Map<int, int> overrides) {
  final h = hash64('ants_bees', level, generatorVersion);
  return (hi: h.hi, lo: (h.lo + (overrides[level] ?? 0)) & _m32);
}

String seedHex(({int hi, int lo}) seed) =>
    '0x${seed.hi.toRadixString(16).padLeft(8, '0')}${seed.lo.toRadixString(16).padLeft(8, '0')}';
```

`seed_overrides.json` (shipped). ⇒ device પર retry loop **નહીં**, 100% deterministic.
- 64 attempts પણ fail (CI) ⇒ release blocker (designer adjusts params for that slot) — device ક્યારેય fallback board ન બનાવે.
- Prefetch: current level રમાતો હોય ત્યારે next 2 levels background isolate માં generate + cache.
- Per-phase **`phase_N_meta.bin`** (shipped, Standard §17.34): દરેક level માટે attempt `k`, `par_moves`, D, JSON CRC, packed `solution` ⇒ Nectar Glow Hint ને device પર CI-size solver ક્યારેય જોઈતો નથી (off-path Hint = on-device solver 50 ms budget, fallback "Try Dewdrop Rewind").

### 2.3 Release per phase
| Step | Artifact |
|---|---|
| 1 | Mechanics code (`puzzle_core/mechanics/m1xx…`) + art/audio + tutorial cards |
| 2 | Generator params table for the phase (tiers, slot bands, variant schedule) |
| 3 | CI: generate + validate 500 seeds × GENERATOR_VERSION ⇒ `seed_overrides.json`, `phase_N_meta.bin` |
| 4 | Designer pass: all 4 base intros, 45 variant intros, 50 x9, finale (play + tune params, regenerate) |
| 5 | App update ships phase code **dark**; Remote Config `maxPhase = n` staged rollout unlocks |

## 3. Generator (reverse construction + solver)

### 3.1 Inputs
`(level, phase, slot, tierParams{grid, lines, maxObstacles, dBand}, layerMix{ground, air, canopy}, diagonalShare, mechanicPool, variantForSlot, seed)`.

### 3.2 Reverse construction (per layer)
1. Empty board W×H (+ floors/boards for Phase 4/11).
2. Place **static blockers** (non-stateful mechanics) per pool and `maxObstacles`.
3. Pick exit order backwards: repeatedly place a new line (random layer per `layerMix`, orthogonal/diagonal per `diagonalShare`, length per tier) such that its lane is **clear in its own layer** given only previously placed lines (= lines that exit **after** it) and blockers (`layerAffects` rule: ground sees all, air/canopy see `tall`). Diagonal lanes use no-cutting rule.
4. Cover-lock aware: a lower-layer line placed under a higher-layer line ⇒ dependency edge (higher exits first) recorded.
5. Insert **stateful** mechanics (C, T, K, X, push, beams, variants) at positions the plan needs (e.g., a gate on the lane of a line that exits after the lever line).
6. Reverse sequence = candidate solution.

Static-only boards ⇒ step 3 guarantees solvability. Stateful mechanics ⇒ **solver mandatory**.

### 3.3 Solver
- BFS (small) / IDA* (large) over state `(remaining lines + positions + layers, mechanic states (gates, blocks, beams-derived, fog, counters), moveCount parity / mod-cycle, goals)`; node limit **2M (CI)**, depth ≤ 3×P; must reach win with **0 bumps (heart loss) and 0 boosters** (Standard rule 6). Bubble-pop bumps (M073) count as 0-heart moves.
- Heuristic (IDA*): remaining lines + unmet goals; transposition table keyed by 64-bit state hash (Zobrist from PRNG fixed seed).
- Output: optimal `solution` (Move ids), `par_moves`, `C` (longest dependency chain edges), node count.

### 3.4 Difficulty D (Standard §9.4)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = lines (all layers), C = longest dependency chain edges (independent ⇒ 0, §16.16),
O = obstacle instances, N = non-monotone instances (catalog "N" column / variant flag),
S = solution Moves − P
```
- Device-safe: D computed in **fixed point ×10 integers** (no floating decisions) ⇒ identical across platforms.
- Accept if `|D − slotTarget| ≤ 3`; x9 target = high × 1.1, Finale = high × 1.2 (Standard §16.13).
- **Phase 3–20 band = fixed plateau 60–76** (Standard §17.24): difficulty નવા systems/mechanics થી આવે, numbers થી નહીં. Grid 12×12–14×14 per board/floor (zoom/pan).

### 3.5 Validator (CI + device sanity)
| Check | CI | Device |
|---|---|---|
| Solvable 0 hearts / 0 boosters (solver) | ✅ | trust CI (solution replay check only) |
| D in band | ✅ | ✅ (recompute, cheap) |
| No line initially locked forever (cover/fog/frozen/key) | ✅ | — |
| Intro = intro mechanic/variant + ≤ 1 earlier | ✅ | — |
| Layer rules (canopy only after unlock, bee body not on tall blocker) | ✅ | ✅ |
| Mechanic-specific rules (Phase 1 §4, Phase 2 §4 tables) | ✅ | — |
| Zoom: fit cell ≥ 22 dp at 360 dp (≤ 14×14); Phase 3+ max grid 14×14 per board | ✅ | ✅ |
| JSON hash = CI golden hash (sampled 1%) | ✅ | debug builds |

## 4. Seeds, Overrides & Hash

```dart
// packages/puzzle_core/lib/src/prng/seed.dart  (Dart VM/AOT — mobile; not for web)
import 'dart:convert';

const int _fnvOffset = 0xcbf29ce484222325;
const int _fnvPrime = 0x100000001b3;

/// FNV-1a 64-bit over "gameId|level|generatorVersion" (UTF-8). Wraps mod 2^64.
int hash64(String gameId, int level, int generatorVersion) {
  var h = _fnvOffset;
  for (final b in utf8.encode('$gameId|$level|$generatorVersion')) {
    h ^= b;
    h *= _fnvPrime; // 64-bit wrap-around multiply on native ints
  }
  return h;
}

String seedHex(int seed) => '0x${seed.toUnsigned(64).toRadixString(16).padLeft(16, '0')}';

int seedFor(int level, int generatorVersion, Map<int, int> overrides) =>
    hash64('ants_bees', level, generatorVersion) + (overrides[level] ?? 0);
```

`seed_overrides.json` (shipped, per `GENERATOR_VERSION`):
```json
{"generator": 7, "phase": 3, "overrides": {"1004": 2, "1139": 1, "1377": 5}}
```
Absent level ⇒ k = 0. Daily Garden Almanac separate seed `hash(gameId, dayKey)` (Phase 1 doc 05).

## 5. PRNG — xoshiro128\*\* (32-bit ops)

Dart `Random` ક્યારેય નહીં (cross-version guarantee નથી). Spec: Blackman & Vigna xoshiro128\*\*; seeding via murmur3 `fmix32`.

```dart
// packages/puzzle_core/lib/src/prng/xoshiro128ss.dart
const int _m32 = 0xFFFFFFFF;

int _rotl(int x, int k) => ((x << k) | (x >>> (32 - k))) & _m32;

int _fmix32(int z) {
  z = ((z ^ (z >>> 16)) * 0x85EBCA6B) & _m32;
  z = ((z ^ (z >>> 13)) * 0xC2B2AE35) & _m32;
  return (z ^ (z >>> 16)) & _m32;
}

final class Xoshiro128ss {
  Xoshiro128ss._(this._s0, this._s1, this._s2, this._s3);

  /// Expands a 64-bit seed (two 32-bit lanes, §4) into 4×32-bit state (never all zero).
  factory Xoshiro128ss.fromSeed64(({int hi, int lo}) seed) {
    final lo = seed.lo & _m32;
    final hi = seed.hi & _m32;
    var s0 = _fmix32((lo + 0x9E3779B9) & _m32);
    final s1 = _fmix32((hi + 0x3C6EF372) & _m32);
    final s2 = _fmix32((lo ^ 0xDAA66D2B) & _m32);
    final s3 = _fmix32((hi ^ 0x78DDE6E4) & _m32);
    if ((s0 | s1 | s2 | s3) == 0) s0 = 1;
    return Xoshiro128ss._(s0, s1, s2, s3);
  }

  int _s0;
  int _s1;
  int _s2;
  int _s3;

  int nextU32() {
    final result = (_rotl((_s1 * 5) & _m32, 7) * 9) & _m32;
    final t = (_s1 << 9) & _m32;
    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = _rotl(_s3, 11);
    return result;
  }

  /// Unbiased integer in [0, n), 1 ≤ n ≤ 2^32 (rejection sampling).
  int nextInt(int n) {
    final limit = (0x100000000 ~/ n) * n;
    var r = nextU32();
    while (r >= limit) {
      r = nextU32();
    }
    return r % n;
  }

  bool chance(int numerator, int denominator) => nextInt(denominator) < numerator;
}
```
- CI test vectors: first 8 outputs for seeds 0, 1, `0xDEADBEEF` pinned in `prng_test.dart`; Android/iOS/CLI સમાન.
- Generator decisions **only** integer math (no `double` in branching).

## 6. Level JSON Schema (v3 + Game 4 fields)

| Field | Type | Notes |
|---|---|---|
| `schema` | int | 3 |
| `level`, `phase` | int | |
| `seed` | hex string | `seedHex(seedFor(level, version, overrides))` (k added, §4) |
| `generator` | `{version, k}` | Phase 3+ only |
| `slot` | `intro\|practice\|breather\|ramp\|hard\|milestone\|finale` | Standard §16.15 |
| `tag` | `easy\|normal\|hard\|finale` | coins |
| `grid` | `[W, H]` | ≤ 14×14 per board |
| `layers` | 1 \| 2 \| 3 | 3 from L691 |
| `hearts` | int | 3 (Daily Wed modifier 1) |
| `paths[]` | `{id, color, dir, body[[x,y]], layer 0\|1\|2, mods{}}` | `dir` 8-way from L511; `body[0]` = head insect |
| `mechanics[]` | `{id, type "M0xx", cells, params, hammerable, tall, variant?}` | `tall` default false (Game 4, §16.28); `variant` Phase 3+ |
| `variant` | `{mod, n?, color?, layers?}` | e.g. `{"mod":"Countdown","n":4}` |
| `floors` | `[{id, grid}]` | Phase 4 Garden Terraces |
| `boards` | `[{id, grid, origin}]` | Phase 11 Twin Gardens |
| `goals` | `{gems, quota[]}` | |
| `par_moves`, `difficulty` | int, number (1 decimal) | |
| `solution` | `[id]` | lines / controls in order |

```json
{"schema":3,"level":1137,"phase":3,"seed":"0x5A1C9E0B7D3F2A61","generator":{"version":7,"k":0},
 "slot":"practice","tag":"normal","grid":[12,12],"layers":3,"hearts":3,
 "paths":[{"id":"p1","color":"red","dir":"DR","body":[[2,2],[1,1]],"layer":0,"mods":{}},
          {"id":"p2","color":"sky","dir":"L","body":[[6,4],[7,4],[8,4]],"layer":2,"mods":{}}],
 "mechanics":[{"id":"o1","type":"M101","cells":[[5,4]],"params":{"openIn":"A"},"hammerable":false,"tall":true},
              {"id":"o2","type":"M005","cells":[[3,9]],"params":{"color":"pink"},"hammerable":false,"tall":false,
               "variant":{"mod":"Phasing"}}],
 "goals":{"gems":0},"par_moves":41,"difficulty":58.3,"solution":["p2","o1","p1"]}
```

## 7. Phases 3–20 — Garden Systems & Base Mechanics

Standard §11 generic names; Game 4 themed names. **IDs** (Standard §17.24): phase `p` ⇒ `M{(p−1)·50+1 … +4}` (P3 = M101–M104 … P20 = M951–M954). **Slot map** (Standard §17.38): block 1 x1 = signature system intro (P3: L1001); 4 base mechanics at x1 of **blocks 2, 14, 26, 38** ⇒ phase start +10, +130, +250, +370 (P3: L1011, L1131, L1251, L1371); 45 variants = x1 of remaining blocks 3–49; block 50 x1 = review level (§8). Effects follow `layerAffects` (ground always, air/canopy if `tall`) unless stated.

### Phase 3 (L1001–1500) — Cycles: **Day & Night Garden** (board state A = day / B = night, flips every 5 Moves: `state = (moveCount ÷ 5) mod 2`)
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M101 | Sunrise Gate (Cycle Gate) | Open in A, closed in B (`params.openIn` can invert). | Ants blocked when closed; bees if tall |
| M102 | Moonlit Twig Bridge (Cycle Bridge) | Acts as M015 bridge only in B; in A plain cell. | Ant-only (like M015) |
| M103 | Dawn Burrow (Cycle Portal) | Portal pair active only in A; in B both cells plain. | Ant-only |
| M104 | Day-Bloom Line (Cycle Color) | Line color = `colorA` in A, `colorB` in B (gates/quotas use current). | Ants & bees (path variant) |

### Phase 4 (L1501–2000) — Multi-floor: **Garden Terraces** (up to 3 floors, each own grid; floor tabs + mini-map)
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M151 | Root Stairs (Stairs) | Lane entering stairs continues on linked floor at same (x, y), same dir. | Ants; bees only if tall stairs ("Updraft Stairs") |
| M152 | Dew-Glass Terrace (Glass Floor) | Body on a glass cell also blocks same-layer lanes on the floor below at that cell. | Both (own layer) |
| M153 | Rabbit Hole (Drop Hole) | Lane reaching it drops line to floor below at same cell; lane continues there. | Ant-only (bees fly over) |
| M154 | Acorn Lift (Elevator) | Control tap (1 Move) moves the line whose head is on it one floor up/down (`params.dir`). | Ants & bees |

### Phase 5 (L2001–2500) — Push Physics+: **Acorn Physics**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M201 | Mole Hole (Crate Holes) | Hole blocks lanes; push block into it ⇒ both vanish, cell becomes floor. | Ant lanes blocked; bees unaffected |
| M202 | Dewdrop Marble (Sliding Ice Crates) | Push block that slides on every floor cell (M054 behaviour everywhere). | Tall marble pushable by bees |
| M203 | Seed Key Pod (Crate Keys) | Push block that opens a matching-color socket lock when it rests on the socket. | Layer of block per tall |
| M204 | Stone Pumpkin (Heavy Crate) | Pushable only by Double-File (M024) lines or a chained group whose lanes all hit it. | Tall ⇒ wide bees too |

### Phase 6 (L2501–3000) — Light & Beams+: **Sunlit Garden**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M251 | Petal Filter (Color Filter) | Beam passing takes filter color; colored sunflowers lit only by matching color. | Beam layer rules (Phase 2 §8) |
| M252 | Twin-Sun Lock (Beam Splitter Lock) | Lock open while **both** linked receivers lit in the same step. | Lock per tall |
| M253 | Sundial Lens (Beam Timer) | Emitter on for N Moves, off for N (Move-based, no clock). | Beam layer param |
| M254 | Shade Patch (Dark Cells) | Lines with any body cell in shade are locked unless a same-layer beam lights one of those cells. | Ants & bees (layer-matched beams) |

### Phase 7 (L3001–3500) — Rotation: **Whirling Garden**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M301 | Flower-Bed Turntable (Sub-board Rotor) | Control rotates a 4×4/5×5 region (lines fully inside + mechanics) 90° CW. | All layers |
| M302 | Turning Hedge (Rotating Edges) | Edge-wall segments shift 1 segment clockwise around the border every N Moves. | Per tall (like M029) |
| M303 | Spinning Top Line (Spin Path) | Line's dir rotates 90° CW after every Move in which it did not move. | Ants & bees |
| M304 | Pinned Daisy (Rotation Lock) | Line immune to all rotations; a rotor/turntable containing it ⇒ locked tap. | Ants & bees |

### Phase 8 (L3501–4000) — Growth: **Bloom Season**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M351 | Morning Glory Vine (Vine Spread+) | Every N Moves grows 1 cell in **each** free orthogonal direction (cross). | Ground blocker; tall vines block bees |
| M352 | Garden Shears (Pruner Tile) | Any lane passing shears removes vine cells orthogonally adjacent to the shears. | Ant & bee lanes (shears tall) |
| M353 | Seed-Dropping Line (Seed Path) | On exit leaves a seed at its start head cell; after N Moves seed ⇒ Single Blocker unless a same-layer lane crosses it first. | Seed blocks own layer |
| M354 | Pollination Gate (Bloom Gate) | Opens permanently after K lines exit from cells orthogonally adjacent to it. | Both layers count |

### Phase 9 (L4001–4500) — Split & Merge: **Swarm Splits**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M401 | Honey Merge Pad (Merger Pad) | First linked line reaching pad stops there; second linked line reaching it merges (attaches behind, takes second's dir). | Same layer only |
| M402 | Fork Twig (Twin Splitter) | Lane reaching fork splits line into two halves exiting 90° left/right; both lanes must be clear else bump. | Ant; bees if tall |
| M403 | Segment Clasp (Segment Lock) | Caravan segments behind the clasp locked until linked key-line exits. | Ants & bees |
| M404 | Reunion Arch (Rejoin Gate) | Gate opens only after both halves of a split line have exited. | Gate per tall |

### Phase 10 (L4501–5000) — Sequencing: **Garden Rhythm**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M451 | Cricket Gate (Rhythm Gate) | Open when `moveCount mod P ∈ S` (pattern badge, e.g. P=3, S={0}). | Per tall |
| M452 | Bead-String Lock (Pattern Lock) | Opens when k consecutive exits match the shown color string. | Lock per tall; both layers' exits count |
| M453 | Queue Hedge (Order Edge) | Edge segment accepts exits only in its own numbered order; others bump. | Per tall |
| M454 | Echo Bloom (Echo Sequence) | First k exit colors are recorded; next k exits must repeat them (wrong ⇒ locked tap). | Both layers |

### Phase 11 (L5001–5500) — Linked Boards: **Twin Gardens** (2 boards side by side, each 12×12–14×14 per §17.24; zoom/pan + board switch)
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M501 | Garden Gate Link (Board Link Edge) | Lane leaving board A through linked edge enters board B at the matching edge cell, same dir. | Per tall (bees need tall link) |
| M502 | Pen-Pal Key (Cross-board Key) | Key-line on A opens lock on B. | Any layer key |
| M503 | Reflecting Pond Board (Mirror Board) | Tap on A also moves the mirror twin on B (M039 rules across boards). | Same layer twins |
| M504 | Relay Burrow (Relay Portal) | Portal pair across boards. | Ant-only |

### Phase 12 (L5501–6000) — Gravity: **Falling Leaves** (gravity dir; after each Move loose items fall 1 cell if free)
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M551 | Wind-Vane Lever (Gravity Lever) | Control sets gravity U/D/L/R (1 Move). | Global |
| M552 | Falling Acorns (Falling Blockers) | Blocker falls 1 cell per Move in gravity dir until resting. | Ground blocker; tall acorns block bees |
| M553 | Dandelion Puff Tile (Anti-grav Tile) | Items/lines on it never fall. | All |
| M554 | Heavy Beetle Line (Weight Path) | Whole line translates 1 cell per Move in gravity dir if free. | **Ant-only** (bees fly) |

### Phase 13 (L6001–6500) — Hidden Info: **Mystery Meadow**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M601 | Scout Ant (Scout Path) | On exit clears all fog within 2 cells (Chebyshev) of its lane. | Ant or bee scout |
| M602 | Mirage Mist (Mimic Fog) | Looks like lawn until a lane passes orthogonally adjacent; then becomes fog (hides lines). | All layers |
| M603 | Painted Pebble (False Wall) | Looks like a blocker; lanes pass through without bump and reveal it. Preview shows "?" | Ant & bee lanes |
| M604 | Sunlit Plate (Reveal Plate) | While an ant body is on it, all hidden lines in its row/column are visible & tappable. | Ant presses; reveals all layers |

### Phase 14 (L6501–7000) — Mirror Worlds: **Reflecting Pond**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M651 | Pond Axis (Mirror Axis) | Board split by axis; tapping a line also triggers its counterpart across the axis (group rules, −1 total). | Same layer pairs |
| M652 | Reflection Lock (Reflect Lock) | Lock opens when the key of its mirror-image lock exits. | Lock per tall |
| M653 | Twin Pond (Twin Board) | Two boards receive every tap simultaneously; bump on either ⇒ −1 total. | All |
| M654 | Upside-Down Line (Inverse Path) | Effective dir = mirror of shown dir across the axis. | Ants & bees |

### Phase 15 (L7001–7500) — Conveyors & Tracks: **Brook & Rails**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M701 | Brook Fork (Belt Junction) | Brook branches; drifting line follows branch set by fork state. | Ant-only |
| M702 | Tide Brook (Reversible Belt) | Flow direction reverses every N Moves. | Ant-only |
| M703 | Sluice Lever (Belt Lever) | Control toggles a brook on/off or flips a fork (1 Move). | Control |
| M704 | Lazy River (Track Loop) | Closed brook loop; lines fully on it circulate 1 cell/Move. | Ant-only; bees cross freely |

### Phase 16 (L7501–8000) — Keys Deluxe: **Royal Keyring**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M751 | Dew Key Chain (Key Chain) | Opening lock 1 grants the key icon to its linked line, whose exit opens lock 2, etc. | Any layer |
| M752 | Key-Crafting Flower (Key Crafting) | Two half-key lines must both exit; then the combined-color lock opens. | Any layer |
| M753 | Skeleton Dew Key (Skeleton Key) | Its exit opens every lock in its head's start row and column. | Any layer |
| M754 | Key Swap Pad (Key Swap) | Control swaps key icons between two linked lines (1 Move). | Same or different layer |

### Phase 17 (L8001–8500) — Guardians: **Garden Guardians**
| ID | Themed (generic) | Rule | Ants / Bees |
|---|---|---|---|
| M801 | Twin Hornets (Twin Guardian) | Two 2×2 guardians share one HP pool; both vanish at 0. | Tall fixed (all layers) |
| M802 | Armored Rhino Beetle (Shield Guardian) | HP drops only after its linked lever removed the shell. | All layers |
| M803 | Wasp Nest Guardian (Spawner Guardian) | Every N Moves spawns a 1-cell blocker in its first free neighbour (U,R,D,L) until HP 0. | Spawn per tall param |
| M804 | Heart-Seed Guardian (Guardian Core) | HP drops only from linked lines whose lane passes the core cell. | All layers |

### Phase 18 (L8501–9000) — Remix A: **Garden Festival I** (systems P1–P6)
4 combo-mechanics **chosen by data**: candidates ranked by per-system engagement (completion rate, booster use, replay) from analytics. Candidate pool: Day-Night Terrace (Cycles × Floors), Sunlit Acorn (Push × Beams), Shaded Stairs (Beams × Floors), Dawn Marble (Cycles × Push), Lens Terrace, Night Prism. Rule = composition of both parents' rules (no new primitives); ant/bee effect inherited.

### Phase 19 (L9001–9500) — Remix B: **Garden Festival II** (systems P7–P12)
Same method over Rotation, Growth, Split/Merge, Sequencing, Linked Boards, Gravity (e.g. Falling Vines, Rhythm Rotor, Twin-Garden Fork, Gravity Turntable).

### Phase 20 (L9501–10,000) — **Grand Master Garden**
All systems; 4 "Grand" combos chosen by data (one from each of P3–8, P9–12, P13–17, P18–19 pools). **L10,000 Grand Finale "Queen's Eternal Garden"**: Twin Hornets + ≥ 12 systems, 14×14, 3 layers, Phase Chest.

## 8. Variant / Modifier System

Variant = existing base mechanic × modifier (Standard §11). Slot map (Standard §17.38): block 1 x1 = signature system; base mechanics x1 of blocks 2, 14, 26, 38; **45 variant slots = x1 of blocks 3–49 excluding 14, 26, 38**; block 50 x1 = **review / "Mastery Mix"** level (no new item; Standard §17.34).

| Modifier | Exact rule | Applies to | Ants / Bees |
|---|---|---|---|
| `Frozen(K)` | Instance inactive until K lines orthogonally adjacent to any of its cells exit (M003 rule): blockers stay, gates stay closed, controls locked, devices off. Badge K. | All | Adjacency layer-independent (§16.29) |
| `Colored(c)` | Instance affects only lines of color `c` (others treat cell as empty). | Lane-affecting mechanics | Both layers by tall rule |
| `Fogged` | Instance placed under an M010 fog area; hidden but functioning; revealed when fog clears. | All | Fog hides all layers |
| `Chained` | Two instances share state: any state change of one applies to the other in the same step. | Stateful (gates, levers, rotors, portals) | — |
| `Countdown(N)` | Instance active for the first N Moves only, then permanently disabled (blocker removed, control inert). Badge N. | All except Guardians | — |
| `Phasing` | Instance active on even pre-increment `moveCount`, inactive on odd (§16.17). | All except Guardians | — |
| `Armored` | Not hammerable; removed only by linked Ivy Lever (M074 rule). | Blockers, walls, blocks | — |
| `Layered(mask)` | Instance affects exactly the layers in `mask` (e.g. air-only gate ants ignore), overriding `layerAffects`. | Lane-affecting | Explicit per mask |
| `Mirrored` | Instance duplicated across the vertical axis; copies share state. | Placeable mechanics | — |
| `Growing(N)` | Every N Moves extends 1 cell along its axis into the first free cell (U,R,D,L for 1-cell). | Blockers, walls, gates | Per tall |

- Selection: generator picks 45 (base × modifier) pairs from unlocked bases, each modifier ≥ 3 times per phase, no pair repeated across phases, compatibility matrix (e.g. no `Phasing` on Guardians, `Colored` only on lane-affecting).
- **Tutorial card per variant:** illustration + 1 sentence rule + "Try it" on its x1 level (variant only + ≤ 1 earlier mechanic), e.g. "**Frozen Petal Gate** — frozen until 2 neighbouring lines leave." Themed name = modifier adjective + base themed name.
- JSON: base `type` + `"variant": {"mod": "Frozen", "n": 2}`.

## 9. Content Cadence (Remote Config `maxPhase`)

| Item | Plan |
|---|---|
| Unit of release | 1 phase (500 levels) = app update (mechanics code) + `maxPhase` flag |
| Dark launch | App ships phase n code with `maxPhase = n−1`; flip after store rollout reaches target share |
| Trigger to start next phase build | Analytics: share of active players within 100 levels of current cap crosses a designer-set threshold (tunable; no fixed % claim) |
| Staging | Remote Config conditions: 5% → 25% → 100% over days; rollback = set `maxPhase` back (players keep reached levels via cache) |
| Players at cap | Phase Complete screen + Daily, Star Race (if ≥ 15 levels remain — else paused), Album |

## 10. Live Tuning via Analytics

- Per level metrics (from Standard §15 events): first-attempt win rate, attempts per clear, hearts lost, booster use per clear, quit-in-level rate, median `duration_s`.
- Alerts per slot type (thresholds = Remote Config params, set by designers from Phase 1 baselines).
- **Levers:**
  - Phase 1–2: `levels_patch_v{n}.json` replaces flagged levels (new hand-tuned/generated JSON).
  - Phase 3+: live tuning switches only between **≤ 3 pre-validated generator profiles** per phase (Standard §17.34), selected via Remote Config; every profile's seeds/meta CI-validated and shipped beforehand.
- **Never mutate a reached level:** device cache (frozen JSON) wins for levels `≤ highestCleared + 2` (prefetched); tuning affects only levels not yet generated on that device.
- A/B: Remote Config conditions on generator params (e.g. diagonal share) for unreached phases only.

## 11. QA at Scale

| Layer | Method |
|---|---|
| Generator determinism | Golden JSON hashes for 1% sampled levels per phase, checked on Android, iOS, CLI each build |
| Full validation | CI regenerates + validates all 9,000 Phase 3+ levels on every `GENERATOR_VERSION` bump (solver, D, rules) |
| Compute estimate | Assumption 1.5 s per level (incl. retries) ⇒ 9,000 × 1.5 s = 13,500 s ≈ 3.75 h single core ⇒ 32 shards ≈ 7 min (measure and update) |
| Mechanic unit tests | Per M-ID fixtures + Move scripts (Phase 1/2 pattern) |
| Fuzz | Random legal Move sequences on 10k generated boards: no crash, invariants (one body per layer per cell, hearts ≥ 0) |
| Human pass | Designers play all 4 base intros, 45 variant intros, 50 x9, finale per phase + 5% random sample |
| Device budget | On-device generation ≤ 300 ms mid-tier per level (isolate, prefetch); solution/par/CRC from `phase_N_meta.bin` |
| Regression | Bumping `GENERATOR_VERSION` must not change cached (reached) levels — migration test with old caches |

## 12. Storage Estimates (computed from schema)

Byte sizes from §6 JSON (minified, ASCII):

| Item | Calculation | Size |
|---|---|---|
| Path entry (5-cell line) | `{"id":"p12",`(12) + `"color":"yellow",`(17) + `"dir":"UR",`(11) + `"body":[…]`(8 + 5×7) + `"layer":1,`(10) + `"mods":{}}`(10) | ≈ **103 B** |
| Mechanic entry | `{"id","type","cells":[[x,y]],"params":{…},"hammerable","tall"}` | ≈ **110 B** |
| Header + goals + par/D | schema … difficulty | ≈ **200 B** |
| Solution | ≈ 6 B × moves | P2 avg 45 moves ⇒ 270 B |
| **Phase 1 level** (avg 18 lines, 5 mechanics, 25 moves) | 18×95 + 5×100 + 200 + 150 | ≈ **2.6 KB** |
| **Phase 2 level** (avg 34 lines, 11 mechanics) | 34×103 + 11×110 + 200 + 270 | ≈ **5.2 KB** |
| `phase_1.json.gz` | 500 × 2.6 KB = 1.3 MB raw; gzip ≈ 5× (assumption, measure) | ≈ **260 KB** |
| `phase_2.json.gz` | 500 × 5.2 KB = 2.6 MB raw ÷ 5 | ≈ **520 KB** |
| `seed_overrides.json` (worst case every level) | 9,000 × `"1234":3,` (9 B) | ≤ **81 KB** raw (≈ 25 KB gz) |
| `solutions_p{n}.bin` (heavy levels only) | ≤ 500 × 60 moves × 1 B | ≤ **30 KB / phase** |
| Device level cache (Phase 3+, gz in Hive) | 5.2 KB ÷ 5 ≈ 1.05 KB × reached levels | L4,000 ⇒ 3,000 × 1.05 ≈ **3.2 MB**; L10,000 ⇒ 9,000 × 1.05 ≈ **9.5 MB** |
| Save data (excl. cache) | stars 2 bits × 10,000 = 2.5 KB + flags/wallet/album ≈ 10 KB | ≈ **15 KB** |
| Firestore `state/main` | starsPacked base64 for 10,000 levels = 3,336 chars + rest ≈ 2 KB | ≈ **5.5 KB** (limit 1 MiB) |
| Firestore `ops` | ~3 ops/level × 300 B; TTL 180 days | bounded by recent play |

Total app content for 10,000 levels ≈ 260 KB + 520 KB + ≤ 0.6 MB (overrides + solutions for 18 phases) ⇒ **< 1.5 MB** of level data in the bundle; device cache grows ~1 KB per played Phase 3+ level.
