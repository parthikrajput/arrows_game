import 'package:puzzle_core/puzzle_core.dart';

/// Test boards only. The real 500-level file is out of scope for now, so
/// this list stands in until assets/levels/phase_1.json.gz exists.
const _testBoards = <Map<String, dynamic>>[
  {
    'n': 1,
    'tag': 'easy',
    'w': 4,
    'h': 4,
    'snakes': [
      {
        'body': [
          [1, 1],
          [0, 1],
        ],
        'dir': 'R',
        'color': 'green',
      },
      {
        'body': [
          [2, 3],
          [2, 2],
        ],
        'dir': 'D',
        'color': 'blue',
      },
    ],
  },
  {
    'n': 2,
    'tag': 'easy',
    'w': 5,
    'h': 5,
    'snakes': [
      {
        'body': [
          [1, 2],
          [0, 2],
        ],
        'dir': 'R',
        'color': 'red',
      },
      {
        'body': [
          [3, 1],
          [3, 2],
          [3, 3],
        ],
        'dir': 'U',
        'color': 'yellow',
      },
      {
        'body': [
          [1, 4],
          [2, 4],
        ],
        'dir': 'L',
        'color': 'purple',
        'skin': 'caterpillar',
      },
    ],
  },
  {
    'n': 3,
    'tag': 'normal',
    'w': 5,
    'h': 5,
    'snakes': [
      {
        'body': [
          [2, 0],
          [1, 0],
          [0, 0],
        ],
        'dir': 'R',
        'color': 'orange',
      },
      {
        'body': [
          [0, 2],
          [1, 2],
          [2, 2],
        ],
        'dir': 'L',
        'color': 'teal',
      },
      {
        'body': [
          [3, 2],
          [3, 3],
          [3, 4],
        ],
        'dir': 'U',
        'color': 'pink',
      },
      {
        'body': [
          [1, 3],
          [1, 4],
        ],
        'dir': 'U',
        'color': 'green',
        'skin': 'caterpillar',
      },
    ],
  },
  {
    'n': 4,
    'tag': 'normal',
    'w': 6,
    'h': 6,
    'snakes': [
      {
        'body': [
          [2, 1],
          [1, 1],
          [0, 1],
        ],
        'dir': 'R',
        'color': 'blue',
      },
      {
        'body': [
          [4, 3],
          [4, 2],
          [4, 1],
          [4, 0],
        ],
        'dir': 'D',
        'color': 'red',
      },
      {
        'body': [
          [1, 3],
          [2, 3],
          [3, 3],
        ],
        'dir': 'L',
        'color': 'yellow',
      },
      {
        'body': [
          [2, 5],
          [3, 5],
        ],
        'dir': 'L',
        'color': 'purple',
      },
      {
        'body': [
          [5, 5],
          [5, 4],
        ],
        'dir': 'R',
        'color': 'teal',
        'skin': 'caterpillar',
      },
    ],
    'rocks': [
      [0, 4],
    ],
  },
  {
    'n': 5,
    'tag': 'hard',
    'w': 6,
    'h': 6,
    'snakes': [
      {
        'body': [
          [0, 0],
          [1, 0],
          [2, 0],
        ],
        'dir': 'D',
        'color': 'green',
      },
      {
        'body': [
          [0, 3],
          [1, 3],
          [1, 2],
        ],
        'dir': 'L',
        'color': 'orange',
      },
      {
        'body': [
          [3, 2],
          [2, 2],
          [2, 1],
        ],
        'dir': 'R',
        'color': 'pink',
      },
      {
        'body': [
          [5, 2],
          [5, 3],
          [5, 4],
        ],
        'dir': 'U',
        'color': 'blue',
      },
      {
        'body': [
          [3, 5],
          [3, 4],
          [2, 4],
        ],
        'dir': 'D',
        'color': 'purple',
        'skin': 'caterpillar',
      },
      {
        'body': [
          [4, 1],
          [4, 0],
        ],
        'dir': 'D',
        'color': 'red',
      },
    ],
    'rocks': [
      [5, 5],
    ],
  },
];

class LevelRepository {
  LevelRepository() : _levels = [for (final j in _testBoards) LevelCodec.decode(j)];
  final List<Level> _levels;

  int get count => _levels.length;

  /// Throws [LevelFormatException] / [RangeError] for an unknown level; the
  /// gameplay route turns that into the "Level unavailable" message.
  Level load(int number) {
    if (number < 1 || number > _levels.length) {
      throw RangeError.range(number, 1, _levels.length, 'level');
    }
    return _levels[number - 1];
  }

  bool exists(int number) => number >= 1 && number <= _levels.length;
}
