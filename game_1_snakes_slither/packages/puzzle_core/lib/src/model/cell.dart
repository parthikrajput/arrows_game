/// Head facing. Phase 1 has no diagonals.
enum Dir {
  up(0, -1),
  down(0, 1),
  left(-1, 0),
  right(1, 0);

  const Dir(this.dx, this.dy);
  final int dx;
  final int dy;

  Dir get opposite => switch (this) {
        Dir.up => Dir.down,
        Dir.down => Dir.up,
        Dir.left => Dir.right,
        Dir.right => Dir.left,
      };

  String get code => switch (this) {
        Dir.up => 'U',
        Dir.down => 'D',
        Dir.left => 'L',
        Dir.right => 'R',
      };

  static Dir parse(String code) => switch (code) {
        'U' => Dir.up,
        'D' => Dir.down,
        'L' => Dir.left,
        'R' => Dir.right,
        _ => throw FormatException('Unknown dir "$code"'),
      };
}

/// Board cell. x grows right, y grows down, origin top-left.
class Cell {
  const Cell(this.x, this.y);

  final int x;
  final int y;

  Cell step(Dir d, [int n = 1]) => Cell(x + d.dx * n, y + d.dy * n);

  bool isAdjacentTo(Cell o) => (x - o.x).abs() + (y - o.y).abs() == 1;

  /// Direction from this cell to an orthogonally adjacent [o].
  Dir dirTo(Cell o) {
    if (o.x > x) return Dir.right;
    if (o.x < x) return Dir.left;
    if (o.y > y) return Dir.down;
    return Dir.up;
  }

  List<int> toJson() => [x, y];

  static Cell fromJson(Object? json) {
    final l = json as List;
    return Cell(l[0] as int, l[1] as int);
  }

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}
