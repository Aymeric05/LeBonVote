import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../services/push_notifications.dart';
import '../widgets/edge_swipe_back.dart';

String _prefsKey(String partyId) => 'notif_party_$partyId';

// Écran de gestion des notifications : une rubrique par orientation,
// et à l'intérieur, un switch par parti pour activer/désactiver ses notifs.
// L'état est persisté (shared_preferences) et reflété côté OneSignal via un
// tag par parti, pour que le serveur sache à qui pousser une notif.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, bool> _partyNotifications = {
    for (final p in MockData.parties) p.id: false,
  };
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _partyNotifications = {
        for (final p in MockData.parties) p.id: prefs.getBool(_prefsKey(p.id)) ?? false,
      };
      _loaded = true;
    });
  }

  Future<void> _setPartyNotification(String partyId, bool value) async {
    setState(() => _partyNotifications[partyId] = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey(partyId), value);
    setPartyTag(partyId, value);
  }

  // Vérifie si tous les partis d'une orientation ont leurs notifs activées
  bool _isOrientationFullyEnabled(String orientationId) {
    final parties = MockData.getPartiesByOrientation(orientationId);
    return parties.isNotEmpty && parties.every((p) => _partyNotifications[p.id] == true);
  }

  // Active ou désactive toutes les notifs d'une orientation d'un coup
  Future<void> _toggleOrientation(String orientationId, bool value) async {
    for (final p in MockData.getPartiesByOrientation(orientationId)) {
      await _setPartyNotification(p.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: ListView(
          children: MockData.orientations.map((orientation) {
            final parties = MockData.getPartiesByOrientation(orientation.id);
            return ExpansionTile(
              leading: CircleAvatar(backgroundColor: orientation.color, radius: 8),
              title: Text(orientation.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Switch(
                value: _isOrientationFullyEnabled(orientation.id),
                onChanged: (value) => _toggleOrientation(orientation.id, value),
              ),
              children: parties.map((party) {
                return SwitchListTile(
                  title: Text(party.name),
                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                  value: _partyNotifications[party.id] ?? false,
                  onChanged: (value) => _setPartyNotification(party.id, value),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
