// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/readings/readings_details_page.dart';
import 'package:stopnow/ui/readings/readings_provider.dart';

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  @override
  void initState() {
    super.initState();
    // Para asegurarnos de que los artículos se carguen después de que el widget se haya construido,
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadingsProvider>().cargarArticulos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReadingsProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      drawer: baseDrawer(context),
      appBar: baseAppBar('Lecturas'),
      backgroundColor: colorScheme.background,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.articulos.isEmpty
              ? Center(
                  child: Text(
                    "No hay artículos disponibles",
                    style: TextStyle(
                      color: colorScheme.onBackground.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  itemCount: provider.articulos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final articulo = provider.articulos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.readingDetail,
                          arguments: articulo,
                        );
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                articulo.titulo,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 18, color: colorScheme.secondary),
                                  const SizedBox(width: 6),
                                  // Envuelve el autor en un Flexible para evitar overflow
                                  Flexible(
                                    child: Text(
                                      articulo.autor!,
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.calendar_today,
                                      size: 16, color: colorScheme.outline),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat.yMMMd()
                                        .format(articulo.fechaCreacion),
                                    style: TextStyle(
                                      color: colorScheme.outline,
                                      fontSize: 13,
                                      
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
