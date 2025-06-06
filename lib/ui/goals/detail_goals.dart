// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';

class DetailGoalsPage extends StatefulWidget {
  const DetailGoalsPage({super.key, required this.goal});
  final GoalModel goal;

  @override
  State<DetailGoalsPage> createState() => _DetailGoalsPageState();
}

class _DetailGoalsPageState extends State<DetailGoalsPage> {
  late GoalModel goal;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
  }

  Future<void> _refreshGoal(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<GoalsProvider>(context, listen: false).traerObjetivos();
    final provider = Provider.of<GoalsProvider>(context, listen: false);
    final updated = provider.goals.firstWhere(
      (g) => g.id == goal.id,
      orElse: () => goal,
    );
    setState(() {
      goal = updated;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double precioPaquete = user?.precioPaquete ?? 0;
    final int cigarrosPorPaquete = user?.cigarrosPorPaquete ?? 1;
    final int cigarrosAlDia = user?.cigarrosAlDia ?? 1;
    final DateTime fechaDejarFumar = user?.fechaDejarFumar ?? DateTime.now();

    final int diasSinFumar = DateTime.now().difference(fechaDejarFumar).inDays;
    final int cigarrosEvitados = diasSinFumar * cigarrosAlDia;
    final double precioPorCigarro =
        precioPaquete / (cigarrosPorPaquete == 0 ? 1 : cigarrosPorPaquete);
    final double dineroAhorrado = cigarrosEvitados * precioPorCigarro;
    //final int minutosGanados = cigarrosEvitados * 11;
    //final double horasGanadas = minutosGanados / 60;

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
      appBar: baseAppBar(goal.nombre, volver: true, onTap: () {
        Navigator.pop(context);
      }, actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () async {
            final exito = await Navigator.pushNamed(
              context,
              AppRoutes.editGoal,
              arguments: goal,
            );
            if (exito == true) {
              await _refreshGoal(context);
              buildSuccesMessage(localizations.objetivoEditadoExito, context);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: colorScheme.surface,
                title: Text(
                  localizations.confirmarBorrado,
                  style: TextStyle(color: colorScheme.primary),
                ),
                content: Text(
                  localizations.mensajeConfirmarBorradoObjetivo,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      localizations.cancelar,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      bool exito = await Provider.of<GoalsProvider>(context,
                              listen: false)
                          .removeGoal(goal.id);

                      if (!mounted) return; // <--- IMPORTANTE
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // Cierra el diálogo
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // Quita el loader

                      if (exito) {
                        buildSuccesMessage(
                            localizations.objetivoBorradoExito, context);
                      } else {
                        buildErrorMessage(
                            localizations.errorBorrarObjetivo, context);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(localizations.aceptar),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Resumen motivacional
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Text(
                            localizations.estasAhorrandoPara,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: colorScheme.secondary,
                            ),
                          ),
                          Text(
                            goal.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: colorScheme.primary,
                            ),
                          ),
                          if (goal.descripcion.isNotEmpty)
                            const SizedBox(height: 8),
                          if (goal.descripcion.isNotEmpty)
                            Text(
                              goal.descripcion,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            localizations
                                .precioObjetivo(goal.precio.toStringAsFixed(2)),
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Progreso actual
                    _buildContainerBarra(porcentaje, colorScheme),
                    const SizedBox(height: 16),
                    Text(
                      localizations.ahorroCigarros(
                          dineroAhorrado.toStringAsFixed(2), cigarrosEvitados),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[
                            theme.brightness == Brightness.dark ? 200 : 700],
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Detalles de lo que falta
                    _buildContainerSecundario(
                      label: localizations.dineroFaltante,
                      value: "${dineroFaltante.toStringAsFixed(2)} €",
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 10),
                    _buildContainerSecundario(
                      label: localizations.cigarrosFaltantes,
                      value: "$cigarrosFaltantes",
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 10),
                    _buildContainerSecundario(
                      label: localizations.horasFaltantes,
                      value: "${horasFaltantes.toStringAsFixed(1)} h",
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 24),
                    // Info extra
                    Card(
                      color: Colors.yellow[
                          theme.brightness == Brightness.dark ? 950 : 50],
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
                                color: Colors.orange[
                                    theme.brightness == Brightness.dark
                                        ? 200
                                        : 900],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${localizations.explicacionCalculo1}\n${localizations.explicacionCalculo2}",
                              style: TextStyle(
                                color: Colors.orange[
                                    theme.brightness == Brightness.dark
                                        ? 100
                                        : 800],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.sigueAsi,
                              style: TextStyle(
                                color: Colors.green[
                                    theme.brightness == Brightness.dark
                                        ? 200
                                        : 800],
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

  Widget _buildContainerSecundario({
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
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
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildContainerBarra(double porcentaje, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
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
              color: colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          FractionallySizedBox(
            widthFactor: porcentaje.clamp(0, 1),
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.secondary, colorScheme.primary],
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
              style: TextStyle(
                color: colorScheme.onSurface,
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
