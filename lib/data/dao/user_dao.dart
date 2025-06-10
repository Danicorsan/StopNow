import 'package:stopnow/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDao {
  static final supabase = Supabase.instance.client;

  // Método para insertar un nuevo usuario en la base de datos cuando se registra
  static Future<void> insertarUsuario({
    required String id,
    required String nombreUsuario,
    required String fotoEmail,
    required DateTime fechaDejarFumar,
    required int cigarrosAlDia,
    required int cigarrosPorPaquete,
    required double precioPaquete,
  }) async {
    await supabase.from('public.users').insert({
      'id': id,
      'nombre_usuario': nombreUsuario,
      'foto_perfil': fotoEmail,
      'fecha_dejar_fumar': fechaDejarFumar.toUtc().toIso8601String(),
      'cigarros_al_dia': cigarrosAlDia,
      'cigarros_por_paquete': cigarrosPorPaquete,
      'precio_paquete': precioPaquete,
    });
  }

  // Método para insertar un nuevo objetivo en la base de datos cuando se registra
  static Future<void> insertarObjetivo({
    required String idUsuario,
    required String nombreObjetivo,
    required String descripcion,
    required double precio,
  }) async {
    await supabase.from('public.objetivos').insert({
      'usuario_id': idUsuario,
      'nombre': nombreObjetivo,
      'precio': precio,
      'descripcion': descripcion,
    });
  }

  // Método para borrar objetivo en la base de datos
  static Future<void> borrarObjetivo({
    required String id,
  }) async {
    await supabase.from('public.objetivos').delete().eq('id', id);
  }

  // Método para actualizar un usuario en la base de datos
  static Future<UserModel?> traerUsuario(String id) async {
    final response =
        await supabase.from('public.users').select('*').eq('id', id).single();

    final json = response;

    return UserModel.fromSupabase(
      json,
    );
  }

  // Metodo para traer todos los objetivos de un usuario ordenados por la fecha
  //de creacion
  static Future<List<Map<String, dynamic>>> obtenerObjetivos(
      String userId) async {
    final response = await supabase
        .from('public.objetivos')
        .select('*')
        .eq('usuario_id', userId)
        .order('fecha_creado', ascending: false);

    if (response.isEmpty) {
      throw Exception('Error al obtener objetivos: $response');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Método para actualizar solo la fecha_dejar_fumar de un usuario para recaída
  static Future<void> actualizarFechaDejarFumar() async {
    DateTime nuevaFecha = DateTime.now();
    final userId = supabase.auth.currentUser?.id;
    await supabase.from('public.users').update({
      'fecha_dejar_fumar': nuevaFecha.toUtc().toIso8601String(),
    }).eq('id', userId!);
  }

  // Metodo para traer los articulos de lectura del usuario
  static Future<List<Map<String, dynamic>>> obtenerArticulos(
      String locale) async {
    //LENGUAJE del movil
    final response = await supabase
        .from('public.articulos')
        .select()
        .eq('idioma', locale)
        .order('fecha_creacion', ascending: false);

    if (response.isEmpty) {
      throw Exception('Error al obtener articulos: $response');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  /*
await _supabase.from('public.chat_mensajes').insert({
      'usuario_id': user.id,
      'nombre_usuario': Provider.of<UserProvider>(context, listen: false)
          .currentUser!
          .nombreUsuario,
      'mensaje': texto.trim(),
      'fecha_envio': DateTime.now().toIso8601String(),
    });
  */

  static Future<void> insertarMensaje(
      String texto, String nombreUsuario, String fotoPerfil) async {
    await supabase.from('public.chat_mensajes').insert({
      'usuario_id': supabase.auth.currentUser?.id,
      'nombre_usuario': nombreUsuario,
      'mensaje': texto.trim(),
      'foto_perfil': fotoPerfil,
    });
  }

  static Future<void> actualizarObjetivo({
    required String id,
    required String nombreNuevo,
    required String descripcionNueva,
    required double precioNuevo,
  }) async {
    await supabase.from('public.objetivos').update({
      'nombre': nombreNuevo,
      'descripcion': descripcionNueva,
      'precio': precioNuevo,
    }).eq('id', id);
  }

  static Future<void> actualizarPerfilUsuario({
    required String id,
    required String nombreUsuario,
    required String? fotoPerfil,
    required DateTime fechaDejarFumar,
    required int cigarrosAlDia,
    required int cigarrosPorPaquete,
    required double precioPaquete,
  }) async {
    await supabase.from('public.users').update({
      'nombre_usuario': nombreUsuario,
      'foto_perfil': fotoPerfil,
      'fecha_dejar_fumar': fechaDejarFumar.toUtc().toIso8601String(),
      'cigarros_al_dia': cigarrosAlDia,
      'cigarros_por_paquete': cigarrosPorPaquete,
      'precio_paquete': precioPaquete,
    }).eq('id', id);
  }

  static obtenerMensajes() async {
    final response = await supabase
        .from('public.chat_mensajes')
        .select()
        .order('fecha_envio', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> actualizarMensajesNombreYFoto({
    required String userId,
    required String? nuevaFotoPerfil,
    required String nuevoNombreUsuario,
  }) async {
    await supabase.from('public.chat_mensajes').update({
      'foto_perfil': nuevaFotoPerfil,
      'nombre_usuario': nuevoNombreUsuario,
    }).eq('usuario_id', userId);
  }

  static Future<void> borrarFotoPerfilAntigua(String urlFoto) async {
    final storage = Supabase.instance.client.storage;
    const bucket = 'avatars';
    final path =
        urlFoto.split('/').last;
    await storage.from(bucket).remove([path]);
  }

  static nombresDeUsuarios({required String nombreUsuario}) {
    return supabase
        .from('public.users')
        .select('nombre_usuario')
        .ilike('nombre_usuario', nombreUsuario);
  }
}
