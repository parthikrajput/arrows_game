import 'cell.dart';

/// The 8 palette colours. Each one also has a body pattern for colour-blind play.
enum SnakeColor { red, green, blue, yellow, purple, orange, pink, teal, gold }

/// A path piece. `body[0]` is the head; the cells are orthogonally connected.
class Snake {
  const Snake({
    required this.id,
    required this.body,
    required this.dir,
    required this.color,
    this.caterpillar = false,
  });

  final String id;
  final List<Cell> body;
  final Dir dir;
  final SnakeColor color;

  /// Skin only: same hit-box, lane and rules as a snake.
  final bool caterpillar;

  Cell get head => body.first;
  Cell get tail => body.last;
  int get length => body.length;

  Map<String, Object?> toJson() => {
        'id': id,
        'body': [for (final c in body) c.toJson()],
        'dir': dir.code,
        'color': color.name,
        if (caterpillar) 'skin': 'caterpillar',
      };

  static Snake fromJson(Map<String, Object?> json) {
    final body = [for (final c in json['body'] as List) Cell.fromJson(c)];
    if (body.length < 2) throw FormatException('Snake ${json['id']} shorter than 2');
    for (var i = 1; i < body.length; i++) {
      if (!body[i - 1].isAdjacentTo(body[i])) {
        throw FormatException('Snake ${json['id']} body is not connected');
      }
    }
    return Snake(
      id: json['id'] as String,
      body: List.unmodifiable(body),
      dir: Dir.parse(json['dir'] as String),
      color: SnakeColor.values.byName(json['color'] as String),
      caterpillar: json['skin'] == 'caterpillar',
    );
  }
}
