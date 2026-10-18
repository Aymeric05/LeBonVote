import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../data/party_repository.dart';
import '../models/party.dart';
import '../services/push_notifications.dart';
import '../widgets/edge_swipe_back.dart';

String _prefsKey(String partyId) => 'notif_party_$partyId';

// Écran de gestion des notifications : une rubrique par orientation,
// et à l'intérieur, un switch par parti pour activer/désactiver ses notifs.
// L'état est persisté (shared_preferences) et reflété côté OneSignal via un
// tag par parti, pour que le serveur sache à qui pousser une notif. La liste
// des partis vient de Supabase (PartyRepository), donc un parti ajouté par
// sync-parties apparaît ici automatiquement, sans redéploiement de l'app.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => setState(() => _prefs = prefs));
  }

  bool _isEnabled(String partyId) => _prefs?.getBool(_prefsKey(partyId)) ?? false;

  Future<void> _setPartyNotification(String partyId, bool value) async {
    await _prefs?.setBool(_prefsKey(partyId), value);
    setState(() {});
    setPartyTag(partyId, value);
  }

  Future<void> _toggleOrientation(List<Party> parties, bool value) async {
    for (final p in parties) {
      await _setPartyNotification(p.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_prefs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: StreamBuilder<List<Party>>(
          stream: PartyRepository.watchAll(),
          builder: (context, snapshot) {
            final allParties = snapshot.data ?? [];

            return ListView(
              children: MockData.orientations.map((orientation) {
                final parties = PartyRepository.byOrientation(allParties, orientation.id);
                final fullyEnabled = parties.isNotEmpty && parties.every((p) => _isEnabled(p.id));
                return ExpansionTile(
                  leading: CircleAvatar(backgroundColor: orientation.color, radius: 8),
                  title: Text(orientation.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Switch(
                    value: fullyEnabled,
                    onChanged: (value) => _toggleOrientation(parties, value),
                  ),
                  children: parties.map((party) {
                    return SwitchListTile(
                      title: Text(party.name),
                      contentPadding: const EdgeInsets.only(left: 32, right: 16),
                      value: _isEnabled(party.id),
                      onChanged: (value) => _setPartyNotification(party.id, value),
                    );
                  }).toList(),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
