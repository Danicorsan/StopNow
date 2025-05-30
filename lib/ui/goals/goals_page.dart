// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
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

//TODO verificar campos, nombre repetido, precio negativo, descripcion vacia, y poder editar el objetivo
class _GoalsPageState extends State<GoalsPage> {
  var isLoading = false;

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

    return Scaffold(
      appBar: baseAppBar(localizations.objetivos),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: Consumer<GoalsProvider>(
        builder: (context, provider, _) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.goals.isEmpty
                  ? Center(
                      child: Text(
                        localizations.noTienesObjetivos,
                        style: TextStyle(
                          color: colorScheme.onBackground,
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.goals.length,
                      itemBuilder: (_, index) {
                        final goal = provider.goals[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 30.w),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete,
                                  color: Colors.white, size: 32),
                            ),
                            onDismissed: (_) =>
                                provider.removeGoal(index, context),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: colorScheme.surface.withOpacity(0.93),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.secondary,
                                  child: Icon(Icons.emoji_events,
                                      color: colorScheme.onSecondary),
                                ),
                                title: Text(
                                  goal.nombre,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.detailGoal,
                                    arguments: goal,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () async {
            bool? exito =
                await Navigator.pushNamed(context, AppRoutes.addGoal) as bool?;
            if (exito == true) {
              Provider.of<GoalsProvider>(context, listen: false)
                  .traerObjetivos();
              buildSuccesMessage(localizations.objetivoExito, context);
            } else {
              buildErrorMessage(localizations.errorObjetivo, context);
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
