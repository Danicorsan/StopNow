import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:stopnow/data/models/goal_model.dart';
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
      'fecha_dejar_fumar': fechaDejarFumar.toIso8601String(),
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

  // Método para insertar un nuevo objetivo en la base de datos cuando se registra
  static Future<void> borrarObjetivo({
    required GoalModel goal,
  }) async {
    await supabase
        .from('public.objetivos')
        .delete()
        .eq('usuario_id', goal.usuarioId)
        .eq('nombre', goal.nombre)
        .eq('precio', goal.precio)
        .single();
  }

  // Método para actualizar un usuario existente en la base de datos
  static Future<UserModel?> traerUsuario(String id) async {
    final response =
        await supabase.from('public.users').select('*').eq('id', id).single();

    final json = response;

    print(json);

    return UserModel.fromSupabase(
      json,
    );
  }

  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileExt = extension(file.path);
    final userId = supabase.auth.currentUser!.id;
    final fileName = '$userId$fileExt';
    final filePath = 'avatars/$fileName';

    final storageResponse = await supabase.storage
        .from('avatars')
        .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

    if (storageResponse != null) {
      print('Error al subir imagen: ${storageResponse}');
      return;
    }

    // Obtener la URL pública
    final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

    // Guardar en la base de datos
    final updateResponse = await supabase.from('public.users').update({
      'avatar_url': publicUrl,
    }).eq('id', userId);

    if (updateResponse.error != null) {
      print('Error al actualizar perfil: ${updateResponse.error!.message}');
    } else {
      print('Avatar actualizado correctamente.');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerObjetivos(
      String userId) async {
    final response = await supabase
        .from('public.objetivos')
        .select('*')
        .eq('usuario_id', userId)
        .order('fecha_creado', ascending: false);

    if (response.isEmpty) {
      throw Exception('Error al obtener objetivos: ${response}');
    }

    print('Objetivos obtenidos: ${response}');

    return List<Map<String, dynamic>>.from(response);
  }
}
