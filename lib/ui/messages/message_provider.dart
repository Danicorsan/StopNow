// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/message_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider extends ChangeNotifier {
  final List<MessageModel> _mensajes = [];
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _canal;
  var isLoading = true;

  List<MessageModel> get mensajes => List.unmodifiable(_mensajes);

  ChatProvider() {
    _init();
  }

  void _init() async {
    await _cargarMensajes();
    _escucharMensajesNuevos();
    isLoading = false;
  }

  Future<void> _cargarMensajes() async {
    await Future.delayed(Duration(seconds: 1));
    final res = await _supabase
        .from('public.chat_mensajes')
        .select()
        .order('fecha_envio', ascending: false)
        .limit(50);

    _mensajes.clear();
    _mensajes.addAll(res.map((m) => MessageModel.fromMap(m)).toList());
    notifyListeners();
  }

  void _escucharMensajesNuevos() {
    _canal = _supabase.channel('public:public.chat_mensajes')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'public.chat_mensajes',
        callback: (payload) {
          final nuevo = MessageModel.fromMap(payload.newRecord);
          _mensajes.insert(0, nuevo);
          notifyListeners();
        },
      )
      ..subscribe();
  }

  Future<void> enviarMensaje(String texto, BuildContext context) async {
    final user = _supabase.auth.currentUser;
    if (user == null || texto.trim().isEmpty) return;

    await _supabase.from('public.chat_mensajes').insert({
      'usuario_id': user.id,
      'nombre_usuario': Provider.of<UserProvider>(context, listen: false)
          .currentUser!
          .nombreUsuario,
      'mensaje': texto.trim(),
      'fecha_envio': DateTime.now().toIso8601String(),
    });
    // No añadas el mensaje localmente aquí, deja que llegue por el canal
  }
}
