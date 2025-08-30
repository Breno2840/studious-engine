import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/chat_page.dart'; // Importa nossa nova página de chat

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://vkmzoznmzgxfzvgdlwvm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrbXpvem5temd4Znp2Z2Rsd3ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDcwNzIsImV4cCI6MjA3MTI4MzA3Mn0.Rm1f2YJPjdyom2xa5QaB4Iewr0cOhCq08ObdRJk27vg',
  );
  runApp(const ByteChatMiniApp());
}

class ByteChatMiniApp extends StatelessWidget {
  const ByteChatMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ByteChat',
      theme: ThemeData.dark(),
      home: const ChatPage(), // A tela inicial agora é a ChatPage
    );
  }
}
