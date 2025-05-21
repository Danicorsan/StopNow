import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/calm/calm_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalmPage extends StatelessWidget {
  const CalmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calmProvider = Provider.of<CalmProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(
        localizations.calma,
        volver: true,
        context: context,
        onTap: () => {
          if (calmProvider.init)
            {
              Provider.of<CalmProvider>(context, listen: false).reset(),
              calmProvider.reset()
            }
          else
            {
              Navigator.pop(context),
            }
        },
      ),
      body: !calmProvider.init
          ? Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  child: Text(localizations.tecnica478,
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
                    child: Text(
                      localizations.descripcionTecnica478,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.sp),
                    )),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.w, vertical: 20.h),
                        textStyle: TextStyle(fontSize: 20.sp),
                      ),
                      onPressed: calmProvider.iniciar,
                      child: Text(localizations.iniciar)),
                )
              ],
            )
          : _buildCalmContainer(calmProvider),
    );
  }

  Widget _buildCalmContainer(CalmProvider calmProvider) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              spreadRadius: 5.r,
              blurRadius: 7.r,
              offset: Offset(0.r, 3.r), // changes position of shadow
            ),
          ],
        ),
        width: 300.w,
        height: 500.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                calmProvider.image,
                width: 200.w,
              ),
              Text(
                calmProvider.currentPhase,
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                calmProvider.timeRemaining.toString(),
                style: const TextStyle(fontSize: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
