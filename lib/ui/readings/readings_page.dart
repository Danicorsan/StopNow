import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadingsProvider>().cargarArticulos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReadingsProvider>();

    return Scaffold(
      drawer: baseDrawer(context),
      appBar: baseAppBar('Lecturas'),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.articulos.isEmpty
              ? const Center(
                  child: Text("No hay articulos disponibles"),
                )
              : ListView.builder(
                  itemCount: provider.articulos.length,
                  itemBuilder: (context, index) {
                    final articulo = provider.articulos[index];
                    return ListTile(
                      title: Text(articulo.titulo),
                      subtitle: Text(
                        '${articulo.autor} - ${DateFormat.yMMMd().format(articulo.fechaCreacion)}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ReadingsDetailsPage(articulo: articulo),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
