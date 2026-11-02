import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../theme/app_theme.dart';

// Carte cliquable représentant une orientation politique (écran d'accueil).
// Dégradé de couleur, léger rebond au toucher, titre centré pour un rendu
// plus soigné qu'un simple bloc de texte aligné à gauche.
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                orientation.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                orientation.description,
                style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.9), height: 1.25),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
