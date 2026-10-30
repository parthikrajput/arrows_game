import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/garden_background.dart';
import 'settings_panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GardenBackground(
        hillsAt: 0.9,
        child: SafeArea(
          child: Column(
            children: [
              HubHeader(title: 'Settings', showCoins: false),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.xl),
                  child: SettingsPanel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
