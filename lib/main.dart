import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase usando o firebase_options.dart (para futuras notificações)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o Supabase (para o chat em tempo real)
  await Supabase.initialize(
    url: 'https://vkmzoznmzgxfzvgdlwvm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrbXpvem5temd4Znp2Z2Rsd3ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDcwNzIsImV4cCI6MjA3MTI4MzA3Mn0.Rm1f2YJPjdyom2xa5QaB4Iewr0cOhCq08ObdRJk27vg',
  );

  runApp(const ByteChatMiniApp());
}

// O cliente Supabase é uma forma fácil de acessar a instância do Supabase em qualquer lugar.
final supabase = Supabase.instance.client;

class ByteChatMiniApp extends StatelessWidget {
  const ByteChatMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ByteChat Mini',
      theme: ThemeData.dark(),
      home: const ChatPage(),
    );
  }
}

// A tela de chat agora é um StatefulWidget para gerenciar o campo de texto.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controller para ler o que o usuário digita.
  final TextEditingController _textController = TextEditingController();

  // O coração do tempo real: um Stream que "ouve" a tabela 'mensagens'.
  final _messagesStream = supabase.from('messages').stream(primaryKey: ['id']).order('created_at');

  // Função para enviar uma mensagem.
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _textController.clear();
      try {
        // Insere a nova mensagem na tabela do Supabase.
        await supabase.from('messages').insert({
          'content': text,
          // Para este teste simples, vamos fixar o nome do usuário.
          'username': 'Breno'
        });
      } catch (error) {
        // Se der erro, mostra no console (útil para depuração).
        print('Erro ao enviar mensagem: $error');
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteChat Mini (Supabase)'),
      ),
      body: Column(
        children: [
          // Expanded faz a lista de mensagens ocupar todo o espaço disponível.
          Expanded(
            // StreamBuilder reconstrói a lista sempre que uma nova mensagem chega.
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar mensagens.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(child: Text('Nenhuma mensagem ainda.'));
                }

                // ListView.builder é eficiente para listas longas.
                return ListView.builder(
                  reverse: true, // Começa a mostrar do final da lista (mensagens mais novas)
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      // Mostra o nome do usuário e a mensagem.
                      title: Text(message['username'] ?? 'Anônimo'),
                      subtitle: Text(message['content']),
                    );
                  },
                );
              },
            ),
          ),
          // Campo para digitar a mensagem.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
