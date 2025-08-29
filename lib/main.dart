import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Importa o arquivo de configuração do Firebase que acabamos de corrigir
import 'firebase_options.dart';

Future<void> main() async {
  // Garante que o Flutter esteja pronto
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZAÇÃO CORRETA E MODERNA DO FIREBASE
  // Usamos o arquivo firebase_options.dart para garantir que as chaves certas sejam usadas.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização do Supabase (continua igual)
  await Supabase.initialize(
    url: 'https://vkmzoznmzgxfzvgdlwvm.supabase.co',
    anonKey: 'eyJhbGciOiJIANiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrbXpvem5temd4Znp2Z2Rsd3ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDcwNzIsImV4cCI6MjA3MTI4MzA3Mn0.Rm1f2YJPjdyom2xa5QaB4Iewr0cOhCq08ObdRJk27vg',
  );

  runApp(const ByteChatMiniApp());
}

class ByteChatMiniApp extends StatelessWidget {
  const ByteChatMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ByteChat Mini',
      theme: ThemeData.dark(),
      home: const ProofOfConceptPage(),
    );
  }
}

// TELA DE TESTE PARA PROVAR QUE TUDO FUNCIONOU
class ProofOfConceptPage extends StatelessWidget {
  const ProofOfConceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteChat - Teste de Configuração'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              'Sucesso!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Supabase e Firebase inicializados corretamente!'),
          ],
        ),
      ),
    );
  }
}
