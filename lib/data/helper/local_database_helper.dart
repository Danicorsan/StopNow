import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stopnow/data/models/user_model.dart';

class LocalDbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'stopnow.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_progress(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreUsuario TEXT,
            fotoPerfil TEXT,
            fechaDejarFumar TEXT,
            cigarrosAlDia INTEGER,
            cigarrosPorPaquete INTEGER,
            precioPaquete REAL,
            fechaRegistro TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveUserProgress(UserModel user) async {
    final db = await database;
    await db.delete('user_progress'); // Solo guardamos uno
    await db.insert('user_progress', {
      'nombreUsuario': user.nombreUsuario,
      'fotoPerfil': user.fotoPerfil,
      'fechaDejarFumar': user.fechaDejarFumar.toIso8601String(),
      'cigarrosAlDia': user.cigarrosAlDia,
      'cigarrosPorPaquete': user.cigarrosPorPaquete,
      'precioPaquete': user.precioPaquete,
      'fechaRegistro': user.fechaRegistro.toIso8601String(),
    });
  }

  static Future<void> deleteUserProgress() async {
    final db = await database;
    await db.delete('user_progress'); // Elimina el registro del usuario
  }

  static Future<UserModel?> getUserProgress() async {
    final db = await database;
    final maps = await db.query('user_progress');
    if (maps.isNotEmpty) {
      final json = maps.first;
      return UserModel(
        nombreUsuario: json['nombreUsuario'] as String,
        fotoPerfil: json['fotoPerfil'] as String,
        fechaDejarFumar: DateTime.parse(json['fechaDejarFumar'] as String),
        cigarrosAlDia: json['cigarrosAlDia'] as int,
        cigarrosPorPaquete: json['cigarrosPorPaquete'] as int,
        precioPaquete: json['precioPaquete'] as double,
        fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      );
    }
    return null;
  }
}
