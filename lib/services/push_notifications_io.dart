// Implémentation Android/iOS/desktop : vraie intégration OneSignal.
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initPush(String appId) async {
  OneSignal.initialize(appId);
  OneSignal.Notifications.requestPermission(true);
}

void setPartyTag(String partyId, bool enabled) {
  if (enabled) {
    OneSignal.User.addTagWithKey(partyId, 'true');
  } else {
    OneSignal.User.removeTag(partyId);
  }
}
