// OWNER: UI agent. Canvas: Leaderboards.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class LeaderboardsScreen extends StatefulWidget {
  const LeaderboardsScreen({
    super.key,
    required this.highestLevel,
    required this.totalStars,
    required this.streakDays,
    required this.online,
    required this.onOpenBoard,
    required this.onBack,
  });
  final int highestLevel;
  final int totalStars;
  final int streakDays;

  /// Play Games / Game Center is set up for this build.
  final bool online;

  /// 0 Highest Level, 1 Total Stars, 2 Streak Days: opens the platform board.
  final void Function(int tab) onOpenBoard;
  final VoidCallback onBack;

  @override
  State<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends State<LeaderboardsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('level', 'Highest Lv', widget.highestLevel, 'Highest level cleared'),
      ('stars', 'Stars', widget.totalStars, 'Total stars, levels 1–500'),
      ('streak', 'Streak', widget.streakDays, 'Total Daily streak days'),
    ];
    final t = tabs[_tab];
    return Scaffold(
      key: AppKeys.leaderboardsScreen,
      body: CreamBackground(
        leaves: false,
        child: SafeArea(
          child: CenteredColumn(
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        RoundButton(
                          size: 40,
                          label: 'Back',
                          onTap: widget.onBack,
                          child: const LineIconView(LineIcon.back, size: 18),
                        ),
                        Expanded(child: Text('Leaderboards', textAlign: TextAlign.center, style: AppText.fredoka(22))),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.track, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        for (var i = 0; i < tabs.length; i++)
                          Expanded(
                            child: Pressable(
                              key: AppKeys.leaderboardTab(tabs[i].$1),
                              onTap: () => setState(() => _tab = i),
                              semanticLabel: tabs[i].$2,
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: i == _tab ? AppColors.card : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tabs[i].$2,
                                  style: AppText.nunito(14, color: i == _tab ? AppColors.text : AppColors.muted),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      CreamCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Text('You', style: AppText.nunito(13, color: AppColors.muted)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_tab == 1) const ArtIcon(Art.star, size: 30),
                                if (_tab == 1) const SizedBox(width: 6),
                                Text(fmt(t.$3), style: AppText.fredoka(40)),
                              ],
                            ),
                            Text(t.$4, style: AppText.nunito(14, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GameButton(
                        key: AppKeys.leaderboardsSignIn,
                        label: widget.online ? 'Open Play Games ▸' : 'Leaderboards unavailable',
                        onTap: widget.online ? () => widget.onOpenBoard(_tab) : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.online
                            ? 'See how you rank against players everywhere.'
                            : 'Your stats are saved on this device. Online ranks need Play Games or Game Center.',
                        textAlign: TextAlign.center,
                        style: AppText.nunito(13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
