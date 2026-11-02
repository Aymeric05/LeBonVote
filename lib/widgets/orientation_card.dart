import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../theme/app_theme.dart';

// Icône évoquant chaque orientation sans symbole politique précis (reste neutre).
IconData _iconFor(String orientationId) {
  switch (orientationId) {
    case 'extreme-gauche':
      return Icons.bolt_rounded;
    case 'gauche':
      return Icons.eco_rounded;
    case 'centre':
      return Icons.balance_rounded;
    case 'droite':
      return Icons.shield_rounded;
    case 'extreme-droite':
      return Icons.flag_rounded;
    default:
      return Icons.diversity_3_rounded;
  }
}

// Carte cliquable représentant une orientation politique (écran d'accueil).
// Dégradé de couleur, icône, léger rebond au toucher pour un rendu plus
// ludique et invitant qu'un simple bloc de texte.
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
            gradient: AppTheme.cardGradient(orientation.color),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: orientation.color.withValues(alpha: 0.45),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Positioned(
                top: -6,
                right: -6,
                child: Icon(
                  _iconFor(orientation.id),
                  size: 52,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconFor(orientation.id), size: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    orientation.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    orientation.description,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9), height: 1.25),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
