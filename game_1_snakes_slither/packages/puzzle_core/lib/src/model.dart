/// Board model. Origin is top-left, x grows right, y grows down.
library;

enum Dir {
  up(0, -1),
  down(0, 1),
  left(-1, 0),
  right(1, 0);

  const Dir(this.dx, this.dy);
  final int dx;
  final int dy;

  static Dir parse(String s) => switch (s.toUpperCase()) {
    'U' => Dir.up,
    'D' => Dir.down,
    'L' => Dir.left,
    'R' => Dir.right,
    _ => throw FormatException('Unknown dir "$s"'),
  };

  String get code => switch (this) {
    Dir.up => 'U',
    Dir.down => 'D',
    Dir.left => 'L',
    Dir.right => 'R',
  };
}

class Cell {
  const Cell(this.x, this.y);
  final int x;
  final int y;

  Cell step(Dir d, [int n = 1]) => Cell(x + d.dx * n, y + d.dy * n);

  bool isNeighbour(Cell o) => (x - o.x).abs() + (y - o.y).abs() == 1;

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}

/// The 8 palette colours. Visual hex values live in the app's design tokens.
enum SnakeColor { red, green, blue, yellow, purple, orange, pink, teal }

enum SnakeSkin { snake, caterpillar }

/// Mechanic state of one snake, for badges and lock icons. Rules live in the
/// full rules engine; this is only what the board needs to draw.
class SnakeMarks {
  const SnakeMarks({
    this.layer = 0,
    this.reverse = false,
    this.hydra = false,
    this.wideSide,
    this.lock,
    this.frozen = 0,
    this.sleeping = false,
    this.hidden = false,
    this.ghost = false,
    this.cageColor,
    this.hatch = 0,
    this.restless = 0,
    this.keyColor,
    this.hungry = false,
    this.growing = false,
    this.group = 0,
    this.child = false,
    this.chameleon = false,
    this.loop = false,
  });

  /// 1 = Canopy (drawn above the ground layer).
  final int layer;
  final bool reverse;
  final bool hydra;

  /// Wide (Giant Anaconda) snakes cover a second column on this side.
  final Dir? wideSide;

  /// Mechanic type that blocks taps right now ("M003", "M021", …) or null.
  final String? lock;

  /// Frost Coil: exits still needed.
  final int frozen;
  final bool sleeping;

  /// Under Jungle Mist: drawn as a silhouette.
  final bool hidden;

  /// Phantom Snake on a ghost move: drawn see-through.
  final bool ghost;
  final String? cageColor;

  /// Hatch Order number (1-based), 0 = none.
  final int hatch;

  /// Restless Caterpillar: moves left before it costs a heart.
  final int restless;

  /// Carries the key for a Bamboo Cage / Knot Cage / Tail-Biter of this colour.
  final String? keyColor;
  final bool hungry;
  final bool growing;

  /// Twins, Pond Twins and Parade members share a non-zero group number.
  final int group;
  final bool child;
  final bool chameleon;

  /// Closed Tail-Biter Loop.
  final bool loop;
}

class Snake {
  const Snake({
    required this.id,
    required this.body,
    required this.dir,
    required this.color,
    this.skin = SnakeSkin.snake,
    this.ref = '',
    this.marks = const SnakeMarks(),
  });

  final SnakeMarks marks;

  final int id;

  /// Id from the level file ("p1"); used in solutions and messages.
  final String ref;

  /// `body[0]` is the head.
  final List<Cell> body;
  final Dir dir;
  final SnakeColor color;
  final SnakeSkin skin;

  Cell get head => body.first;
  int get length => body.length;
}

/// Static blocker (Garden Rock). Removable with the Hammer.
class Rock {
  const Rock({required this.id, required this.cell, this.ref = ''});
  final int id;
  final Cell cell;

  /// Id from the level file ("o1").
  final String ref;
}

/// Any board mechanic other than a Garden Rock, as the board draws it.
class Obstacle {
  const Obstacle({
    required this.id,
    required this.type,
    required this.cells,
    this.ref = '',
    this.value = 0,
    this.open = false,
    this.color = '',
    this.arrow,
    this.orient = '',
    this.side,
    this.horizontal = false,
    this.links = const [],
    this.done = const [],
    this.hammerable = false,
    this.interactive = false,
  });

  /// Index in the level's mechanics list; used for taps and the Hammer.
  final int id;

  /// Mechanic id, e.g. "M009".
  final String type;
  final List<Cell> cells;
  final String ref;

  /// Countdown, HP, keys left or the beetle's waypoint, depending on [type].
  final int value;

  /// Gate open, mist cleared, cage open, bridge snapped, switch turned right.
  final bool open;
  final String color;
  final Dir? arrow;

  /// Mushroom Bumper "/" or "\".
  final String orient;

  /// Board edge for hedges and arches.
  final Dir? side;
  final bool horizontal;

  /// Linked cells: twig gates of a lever, gate of a pressure stone.
  final List<Cell> links;

  /// Per cell of [cells]: gem collected / berry eaten.
  final List<bool> done;
  final bool hammerable;

  /// Tapping it is a Move (lever, lilypad, switch, stump, gear).
  final bool interactive;
}

class BoardState {
  BoardState({
    required this.width,
    required this.height,
    required Map<int, Snake> snakes,
    required Map<int, Rock> rocks,
    this.obstacles = const [],
    this.night = false,
  }) : snakes = Map.unmodifiable(snakes),
       rocks = Map.unmodifiable(rocks);

  final int width;
  final int height;
  final Map<int, Snake> snakes;
  final Map<int, Rock> rocks;
  final List<Obstacle> obstacles;

  /// Jungle Night: only the last moved snake and previews are lit.
  final bool night;

  /// Gems still on the board (win needs 0).
  int get gemsLeft => [
    for (final o in obstacles)
      if (o.type == 'M026') ...o.done.where((d) => !d),
  ].length;

  /// Mongoose HP, or null when there is no Grumpy Mongoose.
  int? get mongooseHp {
    for (final o in obstacles) {
      if (o.type == 'M049') return o.value;
    }
    return null;
  }

  Obstacle? obstacleAt(Cell c) {
    for (final o in obstacles) {
      if (o.cells.contains(c)) return o;
    }
    return null;
  }

  bool inBounds(Cell c) => c.x >= 0 && c.y >= 0 && c.x < width && c.y < height;

  bool get isEmpty => snakes.isEmpty;

  /// Snake occupying [c], if any.
  Snake? snakeAt(Cell c) {
    for (final s in snakes.values) {
      if (s.body.contains(c)) return s;
    }
    return null;
  }

  Rock? rockAt(Cell c) {
    for (final r in rocks.values) {
      if (r.cell == c) return r;
    }
    return null;
  }

  BoardState withoutSnake(int id) =>
      BoardState(width: width, height: height, snakes: {...snakes}..remove(id), rocks: rocks, obstacles: obstacles, night: night);

  BoardState withoutRock(int id) =>
      BoardState(width: width, height: height, snakes: snakes, rocks: {...rocks}..remove(id), obstacles: obstacles, night: night);
}

/// Difficulty tag of a level; decides first-clear coins.
enum LevelTag { easy, normal, hard, finale }

/// Role of a level inside its 10-level block.
enum LevelSlot { intro, practice, breather, ramp, hard, milestone, finale }

class Level {
  const Level({
    required this.number,
    required this.tag,
    required this.board,
    this.slot = LevelSlot.practice,
    this.parMoves = 0,
    this.difficulty = 0,
    this.solution = const [],
    this.mechanicTypes = const [],
    this.raw,
  });

  /// The level JSON, for the full rules engine. Null for generated boards
  /// (snakes and rocks only), which are rebuilt from [board].
  final Map<String, dynamic>? raw;
  final int number;
  final LevelTag tag;
  final BoardState board;
  final LevelSlot slot;

  /// Values written by the designer; the validator recomputes and compares.
  final int parMoves;
  final double difficulty;

  /// Path/obstacle ids in tap order, as written in the file.
  final List<String> solution;

  /// Mechanic type of every obstacle instance in the file, e.g. ["M001", "M001"].
  final List<String> mechanicTypes;
}
