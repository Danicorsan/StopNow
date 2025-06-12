// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Datos del usuario
    final double precioPaquete = user?.precioPaquete ?? 0;
    final int cigarrosPorPaquete = user?.cigarrosPorPaquete ?? 1;
    final int cigarrosAlDia = user?.cigarrosAlDia ?? 1;

    // Cálculo actualizado en tiempo real

    // Duración desde que se creó el objetivo
    final Duration duracion = DateTime.now().difference(goal.fechaCreacion);
    
    // Dias desde el objetivo
    final double diasDesdeGoal = duracion.inSeconds / Duration.secondsPerDay;
    
    // Cálculo de cigarros evitados
    final double cigarrosEvitados = diasDesdeGoal * cigarrosAlDia;
    
    // Precio por cigarro
    final double precioPorCigarro =
        precioPaquete / (cigarrosPorPaquete == 0 ? 1 : cigarrosPorPaquete);

    // Dinero ahorrado 
    final double dineroAhorrado = cigarrosEvitados * precioPorCigarro;

    // Dinero faltante para alcanzar el objetivo
    final double dineroFaltante =
        (goal.precio - dineroAhorrado).clamp(0, goal.precio);

    // Cigarros faltantes
    final double cigarrosFaltantes =
        ((goal.precio - dineroAhorrado) / precioPorCigarro)
            .clamp(0, double.infinity);
    
    // Días restantes para alcanzar el objetivo haciendo el cálculo
    final double diasRestantes =
        cigarrosAlDia > 0 ? cigarrosFaltantes / cigarrosAlDia : 0;

    // Porcentaje de progreso
    final double porcentaje = (dineroAhorrado / goal.precio).clamp(0, 1);

    return Scaffold(
      appBar:
          baseAppBar(localizations.detallesObjetivo, volver: true, onTap: () {
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
                        builder: (_) => Center(
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: colorScheme.primary,
                            rightDotColor: colorScheme.secondary,
                            size: 50,
                          ),
                        ),
                      );

                      bool exito = await Provider.of<GoalsProvider>(context,
                              listen: false)
                          .removeGoal(goal.id);

                      if (!mounted) return;
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
          ? Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: colorScheme.primary,
                rightDotColor: colorScheme.secondary,
                size: 50,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Resumen
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
                              color: isDarkMode
                                  ? Colors.white
                                  : colorScheme.primary,
                            ),
                          ),
                          if (goal.descripcion.isNotEmpty)
                            const SizedBox(height: 8),
                          if (goal.descripcion.isNotEmpty)
                            Text(
                              goal.descripcion,
                              textAlign: TextAlign.center,
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
                      localizations.ahorroCigarros(dineroAhorrado
                          .toStringAsFixed(2)
                          .replaceAll("-", "")),
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
                      value: "${cigarrosFaltantes.ceil()}",
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 10),
                    _buildContainerSecundario(
                      label: localizations.tiempoRestante,
                      value: formatearTiempoRestante(diasRestantes, context),
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
    final localizations = AppLocalizations.of(context)!;

    // Cualquier valor que sea 0, 0.0 o 0.00 se considera "completado"
    final normalized =
        value.replaceAll('€', '').replaceAll(' ', '').replaceAll(',', '.');
    final isZero =
        normalized == "0" || normalized == "0.0" || normalized == "0.00";

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            Flexible(
              child: Text(
                isZero ? localizations.completado : value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
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

  String formatearTiempoRestante(double diasRestantes, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (diasRestantes <= 0) {
      return localizations.completado;
    }

    final int dias = diasRestantes.floor();
    final double horasDec = (diasRestantes - dias) * 24;
    final int horas = horasDec.floor();
    final double minutosDec = (horasDec - horas) * 60;
    final int minutos = minutosDec.floor();

    if (dias > 0) {
      // "2 días 5 horas"
      return "$dias ${dias == 1 ? localizations.diaMinusculaSingular : localizations.diasMinusculaPlural} "
          "$horas ${horas == 1 ? localizations.horaMinusculaSingular : localizations.horasMinusculaPlural}";
    } else if (horas > 0) {
      // "5 horas 12 minutos"
      return "$horas ${horas == 1 ? localizations.horaMinusculaSingular : localizations.horasMinusculaPlural} "
          "$minutos ${minutos == 1 ? localizations.minutoMinusculaSingular : localizations.minutosMinusculaPlural}";
    } else if (minutos > 0) {
      // "12 minutos"
      return "$minutos ${minutos == 1 ? localizations.minutoMinusculaSingular : localizations.minutosMinusculaPlural}";
    } else {
      return localizations.menosDeUnMinutoMinuscula;
    }
  }
}
