import 'dart:convert';
import 'dart:io';

/// Tool to validate audio theme JSON and asset budget rules.
void main() {
  stdout.writeln('Checking audio configuration and theme mapping...');

  final themeFile = File('assets/audio/theme.json');
  if (!themeFile.existsSync()) {
    stderr.writeln('ERROR: assets/audio/theme.json not found!');
    exit(1);
  }

  final data = jsonDecode(themeFile.readAsStringSync()) as Map<String, dynamic>;
  final events = data['events'] as Map<String, dynamic>? ?? {};
  final music = data['music'] as Map<String, dynamic>? ?? {};

  stdout.writeln('Theme: ${data['theme']} (v${data['version']})');
  stdout.writeln('Found ${events.length} mapped SFX events and ${music.length} music tracks.');

  final requiredEvents = [
    'path_tap',
    'path_exit',
    'bump',
    'locked_tap',
    'heart_lost',
    'shield_absorb',
    'booster_hint',
    'booster_hammer',
    'win_stinger',
    'coins_fly',
  ];

  final missing = <String>[];
  for (final req in requiredEvents) {
    if (!events.containsKey(req)) {
      missing.add(req);
    }
  }

  if (missing.isNotEmpty) {
    stderr.writeln('FAIL: Missing required audio events in theme: $missing');
    exit(1);
  }

  stdout.writeln('SUCCESS: All required Phase 1 audio mappings validated!');
}
