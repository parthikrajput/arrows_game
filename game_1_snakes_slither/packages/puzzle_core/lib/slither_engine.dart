/// Snakes Slither engine: pure Dart, synchronous, deterministic.
///
/// Kept as its own entry point because its types share names with the
/// level-codec engine exported from puzzle_core.dart.
library;

export 'src/model/cell.dart';
export 'src/model/snake.dart';
export 'src/model/board_state.dart';
export 'src/model/level_def.dart';
export 'src/rules/engine.dart';
export 'src/solver/solver.dart';
export 'src/prng/xoshiro128ss.dart';
export 'src/prng/hash.dart';
export 'src/generator/board_generator.dart';
export 'src/generator/silhouettes.dart';
export 'src/scoring.dart';
