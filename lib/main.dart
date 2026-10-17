import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

// TODO: remplacer par l'URL et la clé publishable de ton projet Supabase
// (Project Settings > API dans le dashboard Supabase).
const supabaseUrl = 'https://wbkdhxzpmqocucfyqqjq.supabase.co';
const supabasePublishableKey = 'sb_publishable_MxN3RtPEsagawym4WHiOaA_euIG8bAr';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);

  // Initialisation non-bloquante pour éviter l'écran blanc au démarrage
  MobileAds.instance.initialize();

  runApp(const PolitiqueFranceApp());
}

class PolitiqueFranceApp extends StatelessWidget {
  const PolitiqueFranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeBonVote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}