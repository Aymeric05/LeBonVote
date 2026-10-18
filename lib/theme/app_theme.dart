import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Classe statique regroupant les couleurs et le thème de l'app
class AppTheme {
  // Couleurs flashy associées à chaque orientation politique
  static const Color extremeGauche = Color(0xFFE0304B);
  static const Color gauche = Color(0xFFFF5C7A);
  static const Color centre = Color(0xFFFFB020);
  static const Color droite = Color(0xFF3D8BFF);
  static const Color extremeDroite = Color(0xFF1C3FAA);
  static const Color sansEtiquette = Color(0xFF6E7681);

  // Couleurs spécifiques partis (Infographie Toute l'Europe 2024-2025)
  static const Color colorGDR = Color(0xFFB31B1B); // Bordeaux
  static const Color colorLFI = Color(0xFFE0304B); // Rouge
  static const Color colorECOS = Color(0xFF27AE60); // Vert
  static const Color colorSOC = Color(0xFFFF5C7A); // Rose
  static const Color colorLIOT = Color(0xFF9B59B6); // Mauve
  static const Color colorEPR = Color(0xFFF1C40F); // Jaune (Renaissance)
  static const Color colorDEM = Color(0xFFE67E22); // Orange (MoDem)
  static const Color colorHOR = Color(0xFF3498DB); // Bleu clair (Horizons)
  static const Color colorDR = Color(0xFF2980B9); // Bleu (Droite Républicaine)
  static const Color colorUDR = Color(0xFF2C3E50); // Bleu très foncé
  static const Color colorRN = Color(0xFF1C2833); // Marine / Noir (RN)
  static const Color colorNI = Color(0xFF95A5A6); // Gris (Non inscrits)

  // Couleurs pour les scrutins / hémicycle
  static const Color votePour = Color(0xFF27AE60);
  static const Color voteContre = Color(0xFFE74C3C);
  static const Color voteAbstention = Color(0xFFF1C40F);
  static const Color voteAbsent = Color(0xFFD5D8DC);

  // Dégradé bleu utilisé pour le logo "LEBONVOTE"
  static const List<Color> lebonvoteGradient = [
    Color(0xFF3D8BFF),
    Color(0xFF6C5CE7),
  ];

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? colorScheme.surface : const Color(0xFFF3F4F8),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  // Renvoie un dégradé de couleur "flashy" à partir d'une couleur de base
  // (utilisé pour donner du relief aux cartes des orientations)
  static LinearGradient cardGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [base, Color.lerp(base, Colors.black, 0.25)!],
    );
  }

  static Color getPartyColor(String? partyId, {String? abbreviation}) {
    String key = (partyId ?? abbreviation ?? '').toLowerCase();
    
    switch (key) {
      case 'lfi':
      case 'lfi-nfp':
        return colorLFI;
      case 'gdr':
        return colorGDR;
      case 'soc':
        return colorSOC;
      case 'ecos':
      case 'ecologistes':
        return colorECOS;
      case 'liot':
        return colorLIOT;
      case 'epr':
      case 'renaissance':
      case 'ensemble':
        return colorEPR;
      case 'dem':
      case 'modem':
        return colorDEM;
      case 'hor':
        return colorHOR;
      case 'dr':
      case 'lr':
      case 'les-republicains':
        return colorDR;
      case 'rn':
        return colorRN;
      case 'udr':
      case 'uddplr':
        return colorUDR;
      case 'ni':
      case 'non inscrit':
        return colorNI;
      case 'extreme-gauche':
        return extremeGauche;
      case 'gauche':
        return gauche;
      case 'centre':
        return centre;
      case 'droite':
        return droite;
      case 'extreme-droite':
        return extremeDroite;
      default:
        return sansEtiquette;
    }
  }
}
