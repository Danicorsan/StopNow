import 'package:flutter/material.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Metas"),
      drawer: baseDrawer(context),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (_, index) => ListTile(
          title: Text("Meta ${index + 1}"),
          subtitle: Text("Descripción de la meta ${index + 1}"),
          onTap: () {
            // Acción al tocar la meta
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Añadir objetivo
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
