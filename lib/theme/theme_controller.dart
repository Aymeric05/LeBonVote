import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Petit contrôleur global pour le choix de thème (système/clair/sombre),
// persisté via shared_preferences. Pas besoin de provider/riverpod pour
// une seule valeur partagée dans toute l'app.
class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);
  static const _prefsKey = 'theme_mode';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    mode.value = switch (prefs.getString(_prefsKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static Future<void> set(ThemeMode newMode) async {
    mode.value = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, newMode.name);
  }
}
