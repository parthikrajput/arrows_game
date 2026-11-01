import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/services/perf/perf.dart';

FrameTiming _frame(int buildUs, int rasterUs) => FrameTiming(
  vsyncStart: 0,
  buildStart: 0,
  buildFinish: buildUs,
  rasterStart: buildUs,
  rasterFinish: buildUs + rasterUs,
  rasterFinishWallTime: buildUs + rasterUs,
);

void main() {
  late SaveStore store;
  setUp(() async => store = await SaveStore.at(Directory.systemTemp.createTempSync('perf').path));

  test('launch args carry the tier and process start', () {
    final l = LaunchInfo.parse(['tier=low', 'processStartEpochMs=123', 'junk']);
    expect(l.tier, DeviceTier.low);
    expect(l.processStartEpochMs, 123);
  });

  test('profiles: particles 30/80/150, shake off on Low; Battery Saver forces Low', () {
    expect([for (final t in DeviceTier.values) QualityProfile.of(t).maxParticles], [30, 80, 150]);
    expect(QualityProfile.low.shakeDp, 0);
    final p = PerfSettings(store, detected: DeviceTier.high);
    expect(p.profile(batterySaver: false).tier, DeviceTier.high);
    expect(p.profile(batterySaver: true).tier, DeviceTier.low);
  });

  test('frame monitor counts janky frames and the raster p95', () {
    final m = FrameMonitor();
    m.addForTest([for (var i = 0; i < 95; i++) _frame(4000, 6000), for (var i = 0; i < 5; i++) _frame(4000, 30000)]);
    final r = m.stop();
    expect(r.frames, 100);
    expect(r.janky, 5);
    expect(r.p95RasterUs, 30000);
  });

  test('tier drops one step after 3 levels over 5% jank, and is saved', () {
    final p = PerfSettings(store, detected: DeviceTier.high);
    const bad = FrameReport(frames: 100, janky: 10, p95RasterUs: 20000);
    const good = FrameReport(frames: 100, janky: 0, p95RasterUs: 5000);
    p.levelFinished(bad);
    p.levelFinished(good);
    p.levelFinished(bad);
    expect(p.tier, DeviceTier.high);
    p.levelFinished(bad);
    expect(p.tier, DeviceTier.mid);
    expect(PerfSettings(store).tier, DeviceTier.mid);
  });
}
