// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stopnow/routes/app_routes.dart';
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
      appBar: baseAppBar("Objetivos"),
      drawer: baseDrawer(context),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
              color: const Color(0xFF608AAE),
            ),
            width: double.infinity,
            height: 90.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.h),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: FlutterLogo(
                        size: 50,
                      ),),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Bicicleta nueva",
                        style: TextStyle(color: Colors.white, fontSize: 19.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 21, 56, 102),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addGoal);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
