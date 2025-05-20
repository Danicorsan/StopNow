import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';

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
    return Scaffold(
      appBar: baseAppBar("Objetivos"),
      drawer: baseDrawer(context),
      body: Consumer<GoalsProvider>(
        builder: (context, provider, _) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.goals.isEmpty
                  ? Center(
                      child: Text(
                        "No tienes objetivos aún",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18.sp),
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
                              color: Colors.white.withOpacity(0.93),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFF608AAE),
                                  child: Icon(Icons.emoji_events,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  goal.nombre,
                                  style: TextStyle(
                                    color: const Color(0xFF153866),
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

      //TODO: poner como funciona

      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: const Color(0xFF153866),
          onPressed: () async {
            bool exito = await Navigator.pushNamed(context, AppRoutes.addGoal) as bool;
            if(exito){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Objetivo añadido con éxito"),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF608AAE),
                ),
              );
              Provider.of<GoalsProvider>(context, listen: false).traerObjetivos();
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error al añadir el objetivo"),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF8A0000),
                ),
              );
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
