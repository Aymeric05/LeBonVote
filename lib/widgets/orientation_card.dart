import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../theme/app_theme.dart';

// Insère un retour à la ligne après le premier mot pour les noms composés
// de deux mots ("Extrême gauche" -> "Extrême\ngauche"), pour un rendu plus
// net que de laisser le texte se replier tout seul.
String _wrapName(String name) {
  final firstSpace = name.indexOf(' ');
  if (firstSpace == -1) return name;
  return '${name.substring(0, firstSpace)}\n${name.substring(firstSpace + 1)}';
}

// Carte cliquable représentant une orientation politique (écran d'accueil).
// Dégradé de couleur + reflet glossy (lumière en haut à gauche, ombre
// portée en bas) pour donner du volume, bulle du nom façon verre, léger
// rebond au toucher.
class OrientationCard extends StatefulWidget {
  final PoliticalOrientation orientation;
  final VoidCallback onTap;

  const OrientationCard({
    super.key,
    required this.orientation,
    required this.onTap,
  });

  @override
  State<OrientationCard> createState() => _OrientationCardState();
}

class _OrientationCardState extends State<OrientationCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final orientation = widget.orientation;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              // Halo coloré diffus (ambiance).
              BoxShadow(
                color: orientation.color.withValues(alpha: 0.45),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
              // Ombre resserrée plus sombre, pour ancrer la carte (volume).
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // ClipRRect isole le dégradé/reflet aux coins arrondis, sans
          // rogner les ombres portées définies juste au-dessus.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(gradient: AppTheme.cardGradient(orientation.color)),
              child: Stack(
                children: [
                  // Reflet glossy : lumière en haut à gauche qui s'estompe.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0, 0.55],
                          colors: [Colors.white.withValues(alpha: 0.3), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  // Vignette sombre en bas pour creuser la profondeur.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.5, 1],
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.22)],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hauteur fixe : même taille de bulle pour les 6 cases, que
                        // le nom tienne sur une ligne (Gauche) ou deux (Extrême
                        // gauche). Dégradé + liseré clair en haut pour un effet verre
                        // qui sert aussi de reflet.
                        Container(
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.34),
                                Colors.white.withValues(alpha: 0.14),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(
                              top: BorderSide(color: Colors.white.withValues(alpha: 0.55), width: 1),
                            ),
                          ),
                          child: Text(
                            _wrapName(orientation.name),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.15,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          orientation.description,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.25,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
