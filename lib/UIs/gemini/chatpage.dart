import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Untuk autentikasi gemini dan mengambil data user
  final Gemini gemini = Gemini.instance;
  final FirebaseAuthHandler _authHandler = FirebaseAuthHandler();

  List<Map<String, String>> messages = [];
  TextEditingController _messageController = TextEditingController();
  String? username;
  bool _isProcessing = false; // Status untuk memproses

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    username = await _authHandler.getUsername();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gemini Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(messages[index]['sender']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(messages[index]['text']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Tulislah sebuah pesan!",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isProcessing ? null : _sendMessage, // Nonaktifkan tombol saat memproses
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String question = _messageController.text;
    if (question.isEmpty || username == null) return;

    // Tambahin pesan dari pengguna
    setState(() {
      messages.add({'sender': username!, 'text': question});
      _messageController.clear();
      _isProcessing = true; // Set status memproses
    });

    // Kalo gemini lagi ngeproses, bakal loading dulu
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sedang diproses, harap tunggu sebentar.'),
              ],
            ),
          ),
        );
      },
    );

    // Kirim pesan ke gemini
    StringBuffer responseBuffer = StringBuffer();

    // Stream gemini dialirkan
    gemini.streamGenerateContent(question).listen(
      (event) {
        // Tambahin bagian respons ke buffer
        String part = event.content?.parts?.map((part) => part.text).join(" ") ?? "";
        responseBuffer.write(part);
      },
      onDone: () {
        // Tambahin all respon setelah stream selesai
        setState(() {
          messages.add({'sender': 'Gemini', 'text': responseBuffer.toString()});
          _isProcessing = false; // Reset status memproses
        });
        // Tutup dialog loading setelah proses selesai
        Navigator.of(context).pop();
      },
      onError: (error) {
        print('Error: $error');
        _isProcessing = false; // Reset status memproses
        Navigator.of(context).pop(); // Tutup dialog jika ada error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat memproses pesan.')),
        );
      },
    );
  }
}
