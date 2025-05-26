class ReadingModel {
  final String id;
  final String titulo;
  final String contenido;
  final String idioma;
  final DateTime fechaCreacion;
  final String? autor;

  ReadingModel({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.idioma,
    required this.fechaCreacion,
    this.autor,
  });

  factory ReadingModel.fromMap(Map<String, dynamic> map) {
    return ReadingModel(
      id: map['id'],
      titulo: map['titulo'],
      contenido: map['contenido'],
      idioma: map['idioma'],
      fechaCreacion: DateTime.parse(map['fecha_creacion']),
      autor: map['autor'],
    );
  }
}
