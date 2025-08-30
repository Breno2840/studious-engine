import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  // Pega a instância do Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Função para inicializar as notificações
  Future<void> initialize() async {
    // Pede permissão ao usuário (o pop-up)
    await _firebaseMessaging.requestPermission();

    // Pega o "endereço" (token) do celular
    final token = await _firebaseMessaging.getToken();
    print('=================================');
    print('TOKEN DO FIREBASE (FCM): $token');
    print('=================================');

    // Futuramente, aqui salvaremos o token no Supabase
  }
}
