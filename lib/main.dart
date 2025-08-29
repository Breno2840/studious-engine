import 'package.flutter/material.dart';
import 'package.supabase_flutter/supabase_flutter.dart';
import 'package.firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final _messagesStream = supabase.from('messages').stream(primaryKey: ['id']).order('created_at', ascending: false);

  // ========= AQUI ESTÁ A ÚNICA MUDANÇA =========
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      return; // Se não tiver texto, não faz nada.
    }

    _textController.clear();

    try {
      // Tenta inserir a mensagem no Supabase
      await supabase.from('messages').insert({
        'content': text,
        'username': 'Breno',
      });

      // Se o código chegou até aqui, o envio foi um SUCESSO.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mensagem enviada com sucesso!"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (error) {
      // Se deu algum erro, o código entra aqui.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Mostramos o erro EXATO na tela.
          content: Text("ERRO: ${error.toString()}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
  // ========= FIM DA MUDANÇA =========

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
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar mensagens: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(child: Text('Nenhuma mensagem ainda.'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['username'] ?? 'Anônimo', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(message['content']),
                    );
                  },
                );
              },
            ),
          ),
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
