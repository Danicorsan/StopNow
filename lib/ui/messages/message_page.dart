// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final mensajes = chatProvider.mensajes;
    final myUserId = Supabase.instance.client.auth.currentUser?.id;
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final myNombreUsuario = Provider.of<UserProvider>(context, listen: false)
            .currentUser
            ?.nombreUsuario ??
        '';

    return Scaffold(
      appBar: baseAppBar(localizations.chat),
      drawer: baseDrawer(context),
      backgroundColor: const Color.fromARGB(216, 255, 255, 255),
      body: chatProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: mensajes.isEmpty
                      ? Center(
                          child: Text(
                            localizations.noHayMensajes,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: mensajes.length,
                          itemBuilder: (context, index) {
                            final mensaje = mensajes[index];
                            final esMio = mensaje.usuarioId == myUserId;
                            final contieneMencion = myNombreUsuario
                                    .isNotEmpty &&
                                mensaje.mensaje.contains('@$myNombreUsuario') && !esMio;

                            bool mostrarFecha = false;
                            if (index == mensajes.length - 1) {
                              mostrarFecha = true;
                            } else {
                              final mensajeSiguiente = mensajes[index + 1];
                              if (!_esMismaFecha(mensaje.fechaEnvio,
                                  mensajeSiguiente.fechaEnvio)) {
                                mostrarFecha = true;
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (mostrarFecha)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _formatearFechaLabel(
                                              mensaje.fechaEnvio, context),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: esMio
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!esMio)
                                      Padding(
                                        padding: EdgeInsets.only(right: 4.h),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: UserAvatar(
                                            avatarUrl: mensaje.fotoPerfil,
                                          ),
                                        ),
                                      ),

                                    /*Padding(
                                        padding:
                                            const EdgeInsets.only(top: 38, right: 8.0),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: UserAvatar(
                                            avatarUrl: mensaje.fotoPerfil,
                                          ),
                                        ),
                                      ),
                                      */
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 14),
                                        decoration: BoxDecoration(
                                          color: contieneMencion
                                              ? const Color.fromARGB(
                                                  255, 217, 235, 255)
                                              : esMio
                                                  ? colorScheme.secondary
                                                  : colorScheme.surfaceVariant,
                                          border: contieneMencion
                                              ? Border.all(
                                                  color: colorScheme.tertiary,
                                                  width: 2,
                                                )
                                              : null,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(16),
                                            topRight: const Radius.circular(16),
                                            bottomLeft:
                                                Radius.circular(esMio ? 16 : 0),
                                            bottomRight:
                                                Radius.circular(esMio ? 0 : 16),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.shadow
                                                  .withOpacity(0.04),
                                              blurRadius: 2,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (mensaje.nombreUsuario != null &&
                                                mensaje
                                                    .nombreUsuario.isNotEmpty &&
                                                !esMio)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2),
                                                child: Text(
                                                  mensaje.nombreUsuario,
                                                  style: TextStyle(
                                                    color: colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 48.0),
                                                  child: contieneMencion
                                                      ? _buildMensajeConMencion(
                                                          mensaje.mensaje,
                                                          myNombreUsuario,
                                                          colorScheme,)
                                                      : Text(
                                                          mensaje.mensaje,
                                                          style: TextStyle(
                                                            color: esMio
                                                                ? colorScheme
                                                                    .onSecondary
                                                                : colorScheme
                                                                    .onSurface,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Text(
                                                    _formatHora(
                                                        mensaje.fechaEnvio),
                                                    style: TextStyle(
                                                      color: esMio
                                                          ? colorScheme
                                                              .onSecondary
                                                              .withOpacity(0.7)
                                                          : colorScheme
                                                              .onSurface
                                                              .withOpacity(0.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatHora(DateTime? fecha) {
    if (fecha == null) return '';
    final hora = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$min';
  }

  String _formatearFechaLabel(DateTime fecha, BuildContext context) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);

    if (fechaNormalizada == hoy) {
      return AppLocalizations.of(context)!.hoy;
    } else if (fechaNormalizada == hoy.subtract(const Duration(days: 1))) {
      return AppLocalizations.of(context)!.ayer;
    } else {
      return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    }
  }

  bool _esMismaFecha(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildMensajeConMencion(String mensaje, String nombreUsuario,
      ColorScheme colorScheme) {
    final mention = '@$nombreUsuario';
    final partes = mensaje.split(mention);

    List<InlineSpan> spans = [];
    for (int i = 0; i < partes.length; i++) {
      if (partes[i].isNotEmpty) {
        spans.add(TextSpan(
          text: partes[i],
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
          ),
        ));
      }
      if (i < partes.length - 1) {
        spans.add(TextSpan(
          text: mention,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  /*
  void buildVibracion() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 120);
    }
  }
  */

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
