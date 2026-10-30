import 'dart:io';

import 'package:snakes_slither/data/level_repository.dart';

/// The real shipped level file, read straight from disk.
LevelRepository testLevels() =>
    LevelRepository.fromJsonString(File(LevelRepository.assetPath).readAsStringSync());
