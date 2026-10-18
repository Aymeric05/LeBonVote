import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';
import '../widgets/edge_swipe_back.dart';
import 'notifications_screen.dart';

// Écran des paramètres : accès aux réglages de notifications + choix du thème
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: const Text('Paramètres')),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              subtitle: const Text('Choisir les partis à suivre'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Thème'),
              subtitle: const Text('Clair, sombre ou automatique'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeController.mode,
                builder: (context, mode, _) {
                  return SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Système'),
                        icon: Icon(Icons.brightness_auto_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Clair'),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Sombre'),
                        icon: Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (selection) =>
                        ThemeController.set(selection.first),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}