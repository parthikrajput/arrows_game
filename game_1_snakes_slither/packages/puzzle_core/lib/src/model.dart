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

class Snake {
  const Snake({
    required this.id,
    required this.body,
    required this.dir,
    required this.color,
    this.skin = SnakeSkin.snake,
  });

  final int id;

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
  const Rock({required this.id, required this.cell});
  final int id;
  final Cell cell;
}

class BoardState {
  BoardState({
    required this.width,
    required this.height,
    required Map<int, Snake> snakes,
    required Map<int, Rock> rocks,
  }) : snakes = Map.unmodifiable(snakes),
       rocks = Map.unmodifiable(rocks);

  final int width;
  final int height;
  final Map<int, Snake> snakes;
  final Map<int, Rock> rocks;

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
      BoardState(width: width, height: height, snakes: {...snakes}..remove(id), rocks: rocks);

  BoardState withoutRock(int id) =>
      BoardState(width: width, height: height, snakes: snakes, rocks: {...rocks}..remove(id));
}

/// Difficulty tag of a level; decides first-clear coins.
enum LevelTag { easy, normal, hard, finale }

class Level {
  const Level({required this.number, required this.tag, required this.board});
  final int number;
  final LevelTag tag;
  final BoardState board;
}
