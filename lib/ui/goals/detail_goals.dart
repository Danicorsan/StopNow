import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailGoalsPage extends StatelessWidget {
  const DetailGoalsPage({super.key, required this.goal});
  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    final localizations = AppLocalizations.of(context)!;

    final double precioPaquete = user?.precioPaquete ?? 0;
    final int cigarrosPorPaquete = user?.cigarrosPorPaquete ?? 1;
    final int cigarrosAlDia = user?.cigarrosAlDia ?? 1;
    final DateTime fechaDejarFumar = user?.fechaDejarFumar ?? DateTime.now();

    final int diasSinFumar = DateTime.now().difference(fechaDejarFumar).inDays;
    final int cigarrosEvitados = diasSinFumar * cigarrosAlDia;
    final double precioPorCigarro =
        precioPaquete / (cigarrosPorPaquete == 0 ? 1 : cigarrosPorPaquete);
    final double dineroAhorrado = cigarrosEvitados * precioPorCigarro;
    final int minutosGanados = cigarrosEvitados * 11;
    final double horasGanadas = minutosGanados / 60;

    final double dineroFaltante =
        (goal.precio - dineroAhorrado).clamp(0, goal.precio);
    final int cigarrosFaltantes =
        ((goal.precio - dineroAhorrado) / precioPorCigarro)
            .ceil()
            .clamp(0, double.infinity)
            .toInt();
    final double horasFaltantes =
        ((goal.precio - dineroAhorrado) / precioPorCigarro * 11 / 60)
            .clamp(0, double.infinity);

    final double porcentaje = (dineroAhorrado / goal.precio).clamp(0, 1);

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Resumen motivacional
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      localizations.estasAhorrandoPara,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      goal.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF153866),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations
                          .precioObjetivo(goal.precio.toStringAsFixed(2)),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    if (goal.usuarioId != null && goal.usuarioId!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          goal.usuarioId!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Progreso actual
              _buildContainerBarra(porcentaje),
              const SizedBox(height: 16),
              Text(
                localizations.ahorroCigarros(
                    cigarrosEvitados, dineroAhorrado.toStringAsFixed(2)),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Detalles de lo que falta
              _buildContainerSecundario(
                label: localizations.dineroFaltante,
                value: "${dineroFaltante.toStringAsFixed(2)} €",
              ),
              const SizedBox(height: 10),
              _buildContainerSecundario(
                label: localizations.cigarrosFaltantes,
                value: "$cigarrosFaltantes",
              ),
              const SizedBox(height: 10),
              _buildContainerSecundario(
                label: localizations.horasFaltantes,
                value: "${horasFaltantes.toStringAsFixed(1)} h",
              ),
              const SizedBox(height: 24),
              // Info extra
              Card(
                color: Colors.yellow[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Text(
                        localizations.comoSeCalcula,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${localizations.explicacionCalculo1}\n${localizations.explicacionCalculo2}",
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.sigueAsi,
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainerSecundario(
      {required String label, required String value}) {
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
