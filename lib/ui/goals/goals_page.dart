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

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Objetivos"),
      drawer: baseDrawer(context),
      body: Consumer<GoalsProvider>(
        builder: (context, provider, _) {
          return provider.goals.isEmpty
              ? Center(
                  child: Text(
                    "No tienes objetivos aún",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
                        onDismissed: (_) => provider.removeGoal(index),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white.withOpacity(0.93),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF608AAE),
                              child: const Icon(Icons.emoji_events,
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
            Navigator.pushNamed(context, AppRoutes.addGoal);
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
