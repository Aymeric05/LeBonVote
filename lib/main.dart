import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/push_notifications.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/splash_screen.dart';

const supabaseUrl = 'https://wbkdhxzpmqocucfyqqjq.supabase.co';
const supabasePublishableKey = 'sb_publishable_MxN3RtPEsagawym4WHiOaA_euIG8bAr';

const oneSignalAppId = '9ec91cfb-a1f5-4009-b9e8-969d6f589d18';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  await ThemeController.load();

  await initPush(oneSignalAppId);

  // Initialisation non-bloquante pour éviter l'écran blanc au démarrage
  MobileAds.instance.initialize();

  runApp(const PolitiqueFranceApp());
}

class PolitiqueFranceApp extends StatelessWidget {
  const PolitiqueFranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'LeBonVote',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}