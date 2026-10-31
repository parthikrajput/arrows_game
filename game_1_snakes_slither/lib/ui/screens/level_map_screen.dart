// OWNER: UI agent. Redesigned LevelMapScreen with winding vine path,
// biome header, star ratings, and jump-to-current FAB.
// Preserves constructor and AppKeys.mapNode(n).
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({
    super.key,
    required this.nodes,
    required this.onLevelTap,
    required this.onBack,
  });

  /// Level 1 first.
  final List<LevelNodeData> nodes;

  /// Only called for unlocked nodes.
  final void Function(int level) onLevelTap;
  final VoidCallback onBack;

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll near the current level after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrent(animate: false);
    });
  }

  void _scrollToCurrent({bool animate = true}) {
    if (!mounted || widget.nodes.isEmpty) return;
    final currentIndex = widget.nodes.indexWhere((n) => n.state == NodeState.current);
    if (currentIndex == -1) return;

    // Approximate offset: header ~80 dp + item height ~100 dp
    final targetOffset = (currentIndex * 100.0).clamp(0.0, _scrollController.position.maxScrollExtent);

    if (animate) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else if (_scrollController.hasClients) {
      _scrollController.jumpTo(targetOffset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.mapScreen,
      backgroundColor: AppColors.bgSage,
      appBar: AppBar(
        backgroundColor: AppColors.bgSage,
        elevation: 0,
        leading: BackButton(
          onPressed: widget.onBack,
          color: AppColors.textPrimary,
        ),
        title: Text(
          "Pip's Backyard",
          style: AppText.h1.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _scrollToCurrent(animate: true),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.my_location_rounded, color: Colors.white),
      ),
      body: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.md),
        itemCount: widget.nodes.length,
        itemBuilder: (context, index) {
          final node = widget.nodes[index];
          // Calculate winding horizontal offset (left, center, right, center, left...)
          final mod = index % 4;
          final Alignment align = switch (mod) {
            0 => const Alignment(-0.55, 0),
            1 => Alignment.center,
            2 => const Alignment(0.55, 0),
            _ => Alignment.center,
          };

          return Container(
            height: 96,
            alignment: align,
            child: _MapNodeWidget(
              key: AppKeys.mapNode(node.number),
              data: node,
              onTap: node.state == NodeState.locked ? null : () => widget.onLevelTap(node.number),
            ),
          );
        },
      ),
    );
  }
}

class _MapNodeWidget extends StatelessWidget {
  const _MapNodeWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  final LevelNodeData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = data.state == NodeState.locked;
    final isCurrent = data.state == NodeState.current;

    final baseColor = isCurrent
        ? AppColors.primary
        : isLocked
            ? const Color(0xFFCFD8DC)
            : AppColors.coinGold;

    final borderColor = isCurrent
        ? AppColors.primaryLight
        : isLocked
            ? const Color(0xFFB0BEC5)
            : AppColors.coinGoldDark;

    return Semantics(
      button: !isLocked,
      enabled: !isLocked,
      label: 'Level ${data.number}${isLocked ? ', locked' : ''}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 72,
          height: 84,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Pulsing halo for current level
              if (isCurrent)
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        blurRadius: 14,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),

              // Main Circular 3D Node Button
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor,
                      blurRadius: 0,
                      offset: const Offset(0, 3.5),
                    ),
                    const BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock_rounded, size: 22, color: Color(0xFF78909C))
                      : isCurrent
                          ? const Text(
                              '◉',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              '${data.number}',
                              style: AppText.h2.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF5D4037),
                              ),
                            ),
                ),
              ),

              // Stars (if cleared) or Hard badge
              if (data.state == NodeState.cleared && data.stars > 0)
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppColors.bgCream,
                      borderRadius: BorderRadius.circular(Radii.pill),
                      border: Border.all(color: AppColors.creamEdge, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      '★' * data.stars,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFFFB300),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

              // Hard level chip
              if (data.isHard)
                Positioned(
                  top: -4,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(Radii.xs),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Text('🐾', style: TextStyle(fontSize: 9)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
