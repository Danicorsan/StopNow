import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/messages/message_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final mensajes = chatProvider.mensajes;
    final myUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: baseAppBar(
        'Chat',
      ),
      drawer: baseDrawer(context),
      body: chatProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: mensajes.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay mensajes aún. ¡Sé el primero en escribir!",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: mensajes.length,
                          itemBuilder: (context, index) {
                            final mensaje = mensajes[index];
                            final esMio = mensaje.usuarioId == myUserId;

                            return Align(
                              alignment: esMio
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: esMio
                                      ? const Color(0xFF608AAE)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(esMio ? 16 : 0),
                                    bottomRight:
                                        Radius.circular(esMio ? 0 : 16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: esMio
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (mensaje.nombreUsuario != null &&
                                        mensaje.nombreUsuario!.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.amber,
                                          child: Text(
                                            mensaje.nombreUsuario!,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: esMio
                                                  ? Colors.white70
                                                  : Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Text(
                                      mensaje.mensaje,
                                      style: TextStyle(
                                        color: esMio
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatHora(mensaje.fechaEnvio),
                                      style: TextStyle(
                                        color: esMio
                                            ? Colors.white70
                                            : Colors.grey[600],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Escribe un mensaje',
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _enviarMensaje(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF153866),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _enviarMensaje,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      backgroundColor: const Color(0xFFF5F6FA),
    );
  }

  void _enviarMensaje() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      context.read<ChatProvider>().enviarMensaje(texto, context);
      _controller.clear();
    }
  }

  String _formatHora(DateTime? fecha) {
    if (fecha == null) return '';
    final hora = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$min';
  }
}
