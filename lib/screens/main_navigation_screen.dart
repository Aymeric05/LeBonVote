import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'news_feed_screen.dart';
import 'orientations_tab.dart';
import 'laws_votes_screen.dart';
import 'settings_screen.dart';
import '../widgets/ad_banner_widget.dart';

// Écran principal de l'app : 3 volets accessibles par swipe horizontal
// Page 0 : Actus (toutes les news mélangées)
// Page 1 : Familles politiques (grille des 6 orientations)
// Page 2 : Lois & votes
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  static const List<String> _tabTitles = ['Actus', 'Partis', 'Lois & votes'];

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final baseStyle = GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            );
            final isLight = Theme.of(context).brightness == Brightness.light;
            return Stack(
              alignment: Alignment.center,
              children: [
                // En thème clair, la partie blanche du dégradé se fond dans le
                // fond clair de l'AppBar : un fin contour noir sur chaque
                // lettre (texte en strokeWidth superposé) le garde lisible.
                if (isLight)
                  Text(
                    'LeBonVote',
                    style: baseStyle.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.4
                        ..color = Colors.black,
                    ),
                  ),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      LinearGradient(colors: AppTheme.lebonvoteGradient).createShader(bounds),
                  child: Text('LeBonVote', style: baseStyle.copyWith(color: Colors.white)),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Text('⚙️', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: const [
                NewsFeedScreen(),
                OrientationsTab(),
                LawsVotesScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 64,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: List.generate(_tabTitles.length, (index) {
                final bool active = _currentPage == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _goToPage(index),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: active ? 16 : 13.5,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                        child: Text(_tabTitles[index]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}