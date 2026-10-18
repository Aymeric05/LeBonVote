import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/party.dart';

// Carte représentant un parti dans la liste (une fois une orientation sélectionnée)
class PartyCard extends StatelessWidget {
  final Party party;
  final Color accentColor;
  final VoidCallback onTap;

  const PartyCard({
    super.key,
    required this.party,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: accentColor, width: 5)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: accentColor.withValues(alpha: 0.1),
          backgroundImage: (party.leaderImageUrl != null && party.leaderImageUrl!.isNotEmpty)
              ? CachedNetworkImageProvider(party.leaderImageUrl!)
              : null,
          child: (party.leaderImageUrl == null || party.leaderImageUrl!.isEmpty)
              ? Icon(Icons.person, color: accentColor)
              : null,
        ),
        title: Text(
          party.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(party.shortDescription),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}