// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/message_model.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
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

  //TODO CAMBIAR LLAMADAS A REPOSITORIO Y A USAR BASE_RESULT

  Future<void> _cargarMensajes() async {
    final res = await _supabase
        .from('public.chat_mensajes')
        .select()
        .order('fecha_envio', ascending: false);

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

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nombreUsuario = userProvider.currentUser!.nombreUsuario;
    final fotoPerfil = userProvider.currentUser!.fotoPerfil; // O el campo correcto

    var exito = await UserRepository.enviarMensaje(
        texto, nombreUsuario, fotoPerfil);

    if (exito is BaseResultError) {
      buildErrorMessage("No se ha podido enviar el mensaje", context);
      return;
    }
  }
}
