// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/message_model.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vibration/vibration.dart';

class ChatProvider extends ChangeNotifier {
  final List<MessageModel> _mensajes = [];
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _canal;
  var isLoading = true;
  var conexion = true;
  var isLoadingMessage = false;
  var suscrito = true;

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
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.first == ConnectivityResult.none) {
      // Mostrar mensaje o dejar la lista vacía
      _mensajes.clear();
      conexion = false;
      suscrito = false;
      notifyListeners();
      return;
    }

    if (!suscrito) {
      // Si no está suscrito, suscribirse al canal
      _escucharMensajesNuevos();
      suscrito = true;
    }

    conexion = true;
    notifyListeners();

    // Llamada al repositorio para obtener los mensajes
    final res = await UserRepository.getMensajes();

    if (res is BaseResultError) {
      _mensajes.clear();
      return;
    }

    if (res is BaseResultSuccess) {
      // Si es un BaseResultSuccess, contiene una lista de mapas
      final List<Map<String, dynamic>> mensajesMap =
          res.data as List<Map<String, dynamic>>;
      if (mensajesMap.isEmpty) {
        _mensajes.clear();
        notifyListeners();
        return;
      }
      _mensajes.clear();
      _mensajes.addAll(
          mensajesMap.map((mensaje) => MessageModel.fromMap(mensaje)).toList());
      notifyListeners();
    }
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
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'public.chat_mensajes',
        callback: (payload) {
          final actualizado = MessageModel.fromMap(payload.newRecord);
          final index = _mensajes.indexWhere((m) => m.id == actualizado.id);
          if (index != -1) {
            _mensajes[index] = actualizado;
            notifyListeners();
          }
        },
      )
      ..subscribe();
  }

  Future<void> enviarMensaje(String texto, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.first == ConnectivityResult.none) {
      buildErrorMessage(localizations.errorSinConexionMensaje, context);
      suscrito = false;
      return;
    }

    if (!suscrito) {
      // Si no está suscrito, suscribirse al canal
      _escucharMensajesNuevos();
      suscrito = true;
    }

    final user = _supabase.auth.currentUser;
    if (user == null || texto.trim().isEmpty) return;
    isLoadingMessage = true;
    notifyListeners();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nombreUsuario = userProvider.currentUser!.nombreUsuario;
    final fotoPerfil = userProvider.currentUser!.fotoPerfil;

    var exito =
        await UserRepository.enviarMensaje(texto, nombreUsuario, fotoPerfil);

    if (exito is BaseResultError) {
      buildErrorMessage(localizations.errorEnviarMensaje, context);
      isLoadingMessage = false;
      notifyListeners();
      return;
    }

    // Notificar al usuario de que el mensaje se ha enviado
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        duration: 50,
        amplitude: 128,
      );
    }
    isLoadingMessage = false;
    notifyListeners();
  }

  Future<void> cargarMensajes() async {
    await _cargarMensajes();
  }
}
