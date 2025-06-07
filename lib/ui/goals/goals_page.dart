// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    GoalsProvider provider = Provider.of<GoalsProvider>(context, listen: false);
    provider.traerObjetivos().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: baseAppBar(localizations.objetivos),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: Consumer<GoalsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: colorScheme.primary,
                rightDotColor: colorScheme.secondary,
                size: 50,
              ),
            );
          }
          if (provider.goals.isEmpty) {
            return Center(
              child: Text(
                localizations.noTienesObjetivos,
                style: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 18.sp,
                ),
              ),
            );
          }

          final goals = provider.goals;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: GridView.builder(
              itemCount: goals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1, // Mantiene cuadrado
              ),
              itemBuilder: (context, index) {
                final goal = goals[index];
                // Si es el último y hay impar, lo centramos
                final isLast =
                    index == goals.length - 1 && goals.length % 2 != 0;
                return Align(
                  alignment: isLast ? Alignment.center : Alignment.topCenter,
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: colorScheme.surface.withOpacity(0.93),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailGoal,
                            arguments: goal,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: colorScheme.secondary,
                                radius: 28,
                                child: Icon(Icons.emoji_events,
                                    color: colorScheme.onSecondary, size: 32),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                goal.nombre,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (goal.descripcion.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    goal.descripcion,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                      fontSize: 13.sp,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () async {
            final conexion = await UserRepository.tienesConexion();
            if (!conexion) {
              buildErrorMessage(localizations.sinConexion, context);
              return;
            }
            bool? exito =
                await Navigator.pushNamed(context, AppRoutes.addGoal) as bool?;
            if (exito == true) {
              Provider.of<GoalsProvider>(context, listen: false)
                  .traerObjetivos();
              buildSuccesMessage(localizations.objetivoExito, context);
            }
          },
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.add, color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
