import 'package:flutter/material.dart';
import 'package:stopnow/data/models/reading_model.dart';

class ReadingsDetailsPage extends StatelessWidget {
  final ReadingModel articulo;

  const ReadingsDetailsPage({super.key, required this.articulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(articulo.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              articulo.titulo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Por ${articulo.autor} - ${articulo.fechaCreacion.toLocal().toIso8601String().split("T").first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            Text(
              articulo.contenido,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
