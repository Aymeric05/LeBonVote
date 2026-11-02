import 'package:flutter/material.dart';

// AppBar dont le titre est vraiment centré sur la largeur de l'écran, pas
// dans l'espace restant entre la flèche retour et les actions (ce que fait
// centerTitle par défaut, ce qui décale visuellement le titre côté actions).
// La flèche retour et les actions sont superposées au titre via un Stack
// qui occupe tout le bandeau, au lieu des slots leading/actions habituels.
class CenteredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final bool showBackButton;

  const CenteredAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(onPressed: () => Navigator.maybePop(context)),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: DefaultTextStyle.merge(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  child: title,
                ),
              ),
            ),
            if (actions.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Row(mainAxisSize: MainAxisSize.min, children: actions),
              ),
          ],
        ),
      ),
    );
  }
}
