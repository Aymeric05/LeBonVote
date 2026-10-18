import 'package:flutter/material.dart';
import '../data/party_repository.dart';
import '../models/party.dart';
import '../models/political_orientation.dart';
import '../widgets/party_card.dart';
import '../widgets/edge_swipe_back.dart';
import '../widgets/orientation_intro_card.dart';
import 'party_screen.dart';

// Écran affichant la liste des partis appartenant à une orientation donnée
class OrientationScreen extends StatelessWidget {
  final PoliticalOrientation orientation;

  const OrientationScreen({super.key, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: Text(orientation.name)),
        body: StreamBuilder<List<Party>>(
          stream: PartyRepository.watchByOrientation(orientation.id),
          builder: (context, snapshot) {
            final parties = snapshot.data ?? [];

            return ListView(
              padding: const EdgeInsets.only(bottom: 10),
              children: [
                // Bandeau d'introduction sur l'orientation, dépliable
                OrientationIntroCard(orientation: orientation),

                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (parties.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Aucun parti renseigné pour le moment.')),
                  )
                else
                  ...parties.map(
                        (party) => PartyCard(
                      party: party,
                      accentColor: orientation.color,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PartyScreen(
                              party: party,
                              accentColor: orientation.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
