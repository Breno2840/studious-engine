import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Mantivemos a configuração web, caso precise no futuro.
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // AQUI ESTÁ A CORREÇÃO PRINCIPAL:
        // Agora, quando a plataforma for Android, ele retorna as chaves corretas.
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
          'try to add using FlutLab Firebase Configuration',
        );
      // ... outras plataformas não suportadas
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configuração Web que já existia (pode deixar aqui)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAhE5iTdU1MflQxb4_M_uHiXJR9EC_mE_I",
    authDomain: "nanochat.firebaseapp.com",
    projectId: "firebase-nanochat",
    messagingSenderId: "137230848633",
    appId: "1:137230848633:web:89e9b54f881fa0b843baa8",
  );

  // ==== COLE SUAS CONFIGURAÇÕES REAIS DO ANDROID AQUI ====
  // Pegue estes valores do seu arquivo google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbJ-eYG43n3i5n_e938D-NRVFdr_Eq6Tg',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
  );
}
