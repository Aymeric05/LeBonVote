import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/party.dart';

// Remplace l'ancienne liste statique MockData.parties : les partis viennent
// désormais de Supabase (table `parties`), tenue à jour par
// supabase/functions/sync-parties.
class PartyRepository {
  static Stream<List<Party>> watchAll() {
    return Supabase.instance.client
        .from('parties')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map(Party.fromMap).toList());
  }

  static Stream<List<Party>> watchByOrientation(String orientationId) {
    return Supabase.instance.client
        .from('parties')
        .stream(primaryKey: ['id'])
        .eq('orientation_id', orientationId)
        .map((rows) => rows.map(Party.fromMap).toList());
  }

  static List<Party> byOrientation(List<Party> all, String orientationId) {
    return all.where((p) => p.orientationId == orientationId).toList();
  }
}
