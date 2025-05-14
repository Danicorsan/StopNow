import 'package:flutter/material.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';

class DetailGoalsPage extends StatelessWidget {
  const DetailGoalsPage({super.key, required this.goal});
  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar(
        goal.nombre,
        volver: true,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContainerPrincipal(),
              _buildContainerSecundario(dinero: true),
              _buildContainerSecundario(cigarros: true),
              _buildContainerSecundario(fecha:true),
              _buildContainerBarra(0.7)
            ],
          ),
        ),
      ),
    );
  }

  _buildContainerPrincipal() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            goal.nombre,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            goal.usuarioId,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (goal.precio != null)
            Text(
              "${goal.precio.toStringAsFixed(2)} €",
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
            ),
        ],
      ),
    );
  }

  _buildContainerSecundario({bool dinero = false, bool cigarros = false, bool fecha = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (dinero) const Text("Dinero"),
          if (cigarros) const Text("Cigarros"),
          if (fecha) const Text("Fecha"),
        ],
      ),
    );
  }

  Widget _buildContainerBarra(double porcentaje) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          FractionallySizedBox(
            widthFactor: porcentaje.clamp(0, 1),
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF608AAE), Color(0xFF153866)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Center(
            child: Text(
              "${(porcentaje * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
