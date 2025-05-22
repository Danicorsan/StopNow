// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/messages/message_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(
        localizations.chat,
      ),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: chatProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: mensajes.isEmpty
                      ? Center(
                          child: Text(
                            localizations.noHayMensajes,
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6)),
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
                                      ? colorScheme.secondary
                                      : colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(esMio ? 16 : 0),
                                    bottomRight:
                                        Radius.circular(esMio ? 0 : 16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          colorScheme.shadow.withOpacity(0.04),
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
                                        mensaje.nombreUsuario.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Container(
                                          width: double.infinity,
                                          color: colorScheme.tertiary
                                              .withOpacity(0.2),
                                          child: Text(
                                            mensaje.nombreUsuario,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: esMio
                                                  ? colorScheme.onSecondary
                                                      .withOpacity(0.7)
                                                  : colorScheme.primary,
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
                                            ? colorScheme.onSecondary
                                            : colorScheme.onSurface,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatHora(mensaje.fechaEnvio),
                                      style: TextStyle(
                                        color: esMio
                                            ? colorScheme.onSecondary
                                                .withOpacity(0.7)
                                            : colorScheme.onSurface
                                                .withOpacity(0.6),
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
                  color: colorScheme.surface,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: localizations.escribeUnMensaje,
                            hintStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.5)),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant,
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
                        backgroundColor: colorScheme.primary,
                        child: IconButton(
                          icon: Icon(Icons.send, color: colorScheme.onPrimary),
                          onPressed: _enviarMensaje,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
