import 'package:stopnow/data/models/user.dart';
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

  static Future<UserModel?> traerUsuario(String id) async {
    final response =
        await supabase.from('public.users').select('*').eq('id', id).single();

    print(response);

    final json = response;
    return UserModel.fromSupabase(
      json,
    );
  }
}
