import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdPUSE7A9ZYQpI91zSXDYbDLfzT8UPQJ4',
    appId: '1:861077148599:web:0ff2326da90d8601194e32',
    messagingSenderId: '861077148599',
    projectId: 'momentum-c2ab4',
    authDomain: 'momentum-c2ab4.firebaseapp.com',
    storageBucket: 'momentum-c2ab4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAh8zVpTUerc3TRGaLVtuSEdxhF2gCeHw',
    appId: '1:861077148599:android:ad3953f744e94bc2194e32',
    messagingSenderId: '861077148599',
    projectId: 'momentum-c2ab4',
    storageBucket: 'momentum-c2ab4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9Tt00w1zOJvdr1vvkNhDnyuI0P18AzAg',
    appId: '1:861077148599:ios:7dd3ea7f22d10955194e32',
    messagingSenderId: '861077148599',
    projectId: 'momentum-c2ab4',
    storageBucket: 'momentum-c2ab4.firebasestorage.app',
    iosBundleId: 'com.momentum.app',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
