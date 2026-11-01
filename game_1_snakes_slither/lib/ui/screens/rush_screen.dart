// OWNER: UI agent. Canvas: RushIntro.dc.html, Rush.dc.html, RushResults.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

const _gold = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFFFFF3B0), Color(0xFFFFCA28), Color(0xFFE0A100)],
);

TextStyle _title(double size) => AppText.fredoka(size, color: const Color(0xFFFFE082)).copyWith(
  letterSpacing: 1,
  shadows: const [
    Shadow(color: Color(0xFFB8860B), offset: Offset(0, 2)),
    Shadow(color: Color(0x73000000), offset: Offset(0, 4), blurRadius: 10),
  ],
);

String _clock(int ms) {
  final s = (ms / 1000).ceil();
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

class _RushBackground extends StatelessWidget {
  const _RushBackground({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(0, -.1),
        radius: 1.1,
        colors: [Color(0xFF2F7A32), Color(0xFF17501C), Color(0xFF0B2E10)],
        stops: [0, .55, 1],
      ),
    ),
    child: child,
  );
}

class _CoinPillGold extends StatelessWidget {
  const _CoinPillGold({required this.coins});
  final int coins;
  @override
  Widget build(BuildContext context) => Container(
    key: AppKeys.rushCoins,
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      gradient: _gold,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Color(0xFF9C6F00), offset: Offset(0, 3)),
        BoxShadow(color: Color(0x59000000), offset: Offset(0, 8), blurRadius: 16),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ArtIcon(Art.coin, size: 20),
        const SizedBox(width: 6),
        Text('+$coins', style: AppText.fredoka(20, color: const Color(0xFF1B2B1F))),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({super.key, required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x29FFFFFF), Color(0x0DFFFFFF)],
      ),
      border: Border.all(color: const Color(0x47FFE082)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppText.fredoka(22, color: Colors.white)),
        Text(label, style: AppText.nunito(12, color: const Color(0xFFC8E6C9))),
      ],
    ),
  );
}

/// Bonus round intro: rules and START.
class RushIntroPopup extends StatelessWidget {
  const RushIntroPopup({super.key, required this.data, required this.onStart, required this.onSkip});
  final RushData data;
  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final rules = [
      ('${data.seconds}', const Color(0xFFE08A00), '${data.seconds} seconds — tap fast!'),
      ('+${data.perSnake}', const Color(0xFF2E7D32), '+${data.perSnake} coins for every golden snake'),
      ('${data.total}', const Color(0xFF7A5200), 'Clear all ${data.total} for +${data.fullClearBonus} bonus'),
      ('♥', const Color(0xFF9AA59D), 'No hearts, no boosters, no bonks'),
    ];
    return PopupCard(
      key: AppKeys.rushIntroDialog,
      badge: 'BONUS ROUND · AFTER LEVEL ${data.afterLevel}',
      children: [
        Text('Golden Slither Rush!', textAlign: TextAlign.center, style: AppText.fredoka(26)),
        const SizedBox(height: 14),
        for (final (icon, bg, text) in rules)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                  child: Text(icon, style: AppText.fredoka(15, color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: AppText.nunito(15))),
              ],
            ),
          ),
        const SizedBox(height: 8),
        GameButton(key: AppKeys.rushIntroStart, label: 'START', onTap: onStart),
        const SizedBox(height: 6),
        TextButton(
          key: AppKeys.rushIntroSkip,
          onPressed: onSkip,
          child: Text('Skip', style: AppText.nunito(14, color: AppColors.muted)),
        ),
      ],
    );
  }
}

/// The 30-second round. [board] is the ready-made board widget.
class RushScreen extends StatelessWidget {
  const RushScreen({super.key, required this.data, required this.board, required this.onSkip});
  final RushData data;
  final Widget board;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final frac = (data.msLeft / (data.seconds * 1000)).clamp(0.0, 1.0);
    return Scaffold(
      key: AppKeys.rushScreen,
      backgroundColor: const Color(0xFF0B2E10),
      body: _RushBackground(
        child: SafeArea(
          child: CenteredColumn(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: FittedBox(child: Text('GOLDEN SLITHER RUSH', style: _title(22)))),
                      const SizedBox(width: 8),
                      _CoinPillGold(coins: data.coins),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Semantics(
                    label: '${(data.msLeft / 1000).ceil()} seconds left',
                    child: Container(
                      key: AppKeys.rushProgressBar,
                      height: 12,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: const Color(0xFF0A2E0E), borderRadius: BorderRadius.circular(6)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: frac,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: _gold,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [BoxShadow(color: Color(0xB3FFCA28), blurRadius: 10)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _Stat(key: AppKeys.rushTimer, value: _clock(data.msLeft), label: 'time left')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Stat(
                          key: AppKeys.rushCounter,
                          value: '${data.cleared} / ${data.total}',
                          label: 'snakes out',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Center(child: board)),
                        if (!data.playing && data.countdown > 0)
                          IgnorePointer(
                            child: Text(
                              '${data.countdown}',
                              key: ValueKey(data.countdown),
                              style: _title(96),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    'Tap fast! No hearts, no boosters. Clear all ${data.total} before time runs out for +${data.fullClearBonus}',
                    textAlign: TextAlign.center,
                    style: AppText.nunito(14, color: const Color(0xFFC8E6C9)),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    key: AppKeys.rushSkipButton,
                    onPressed: onSkip,
                    child: Text(
                      'Skip (keep ${data.coins} coins)',
                      style: AppText.nunito(14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RushResultsPopup extends StatelessWidget {
  const RushResultsPopup({super.key, required this.data, required this.onContinue, required this.onMap});
  final RushResultData data;
  final VoidCallback onContinue;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) => PopupCard(
    key: AppKeys.rushResultsDialog,
    badge: 'GOLDEN SLITHER RUSH',
    children: [
      Text(data.bonus > 0 ? 'Rush complete!' : 'Time\'s up!', style: AppText.fredoka(26)),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ArtIcon(Art.coin, size: 30),
          const SizedBox(width: 6),
          Text('+${data.totalCoins}', style: AppText.fredoka(34, color: const Color(0xFFB8860B))),
        ],
      ),
      const SizedBox(height: 12),
      CreamCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          children: [
            _row('Golden snakes out', '${data.cleared} / ${data.total} · +${data.snakeCoins}'),
            _row('Full clear bonus', data.bonus > 0 ? '+${data.bonus}' : '—'),
            _row('Time left', _clock(data.msLeft)),
          ],
        ),
      ),
      const SizedBox(height: 14),
      GameButton(
        key: AppKeys.rushResultsContinue,
        label: data.nextLevel == null ? 'Continue' : 'Continue to Level ${data.nextLevel}',
        onTap: onContinue,
      ),
      const SizedBox(height: 6),
      TextButton(
        key: AppKeys.rushResultsMap,
        onPressed: onMap,
        child: Text('Map', style: AppText.nunito(14, color: AppColors.muted)),
      ),
    ],
  );

  Widget _row(String a, String b) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(a, style: AppText.nunito(14, color: AppColors.muted))),
        Text(b, style: AppText.fredoka(16)),
      ],
    ),
  );
}
