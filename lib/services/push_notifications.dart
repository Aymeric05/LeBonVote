// Le push cible Android/iOS uniquement (comme les pubs, déjà gérées via kIsWeb
// ailleurs dans l'app). `onesignal_flutter` ne déclare même pas le support web
// dans son pubspec, mais son code Dart serait quand même compilé dans le bundle
// web par un simple `import` — un import conditionnel sur `dart.library.io`
// l'exclut complètement de ce bundle au lieu de juste ignorer l'appel à l'exécution.
export 'push_notifications_stub.dart'
    if (dart.library.io) 'push_notifications_io.dart';
