import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/calm/calm_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalmPage extends StatefulWidget {
  const CalmPage({super.key});

  @override
  State<CalmPage> createState() => _CalmPageState();
}

class _CalmPageState extends State<CalmPage> {
  CalmProvider? _calmProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calmProvider ??= Provider.of<CalmProvider>(context, listen: false);
  }

  Future<bool> _onWillPop() async {
    if (_calmProvider?.init == true) {
      _calmProvider?.reset();
      setState(() {}); // Para actualizar la UI
      return false; // No salir todavía
    }
    return true; // Salir
  }

  String getPhaseText(CalmPhase phase) {
    final localizations = AppLocalizations.of(context)!;
    switch (phase) {
      case CalmPhase.inhalar:
        return localizations.inhala;
      case CalmPhase.retener:
        return localizations.retener;
      case CalmPhase.exhalar:
        return localizations.exhala;
    }
  }

  @override
  Widget build(BuildContext context) {
    final calmProvider = Provider.of<CalmProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: baseAppBar(
          localizations.calma,
          volver: true,
          context: context,
          onTap: () {
            if (calmProvider.init) {
              calmProvider.reset();
              setState(() {});
            } else {
              Navigator.pop(context);
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
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode? Colors.white : colorScheme.primary)),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                      ),
                      child: Text(
                        localizations.descripcionTecnica478,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? Colors.white70 : colorScheme.onBackground,
                        ),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.w, vertical: 20.h),
                          textStyle: TextStyle(fontSize: 20.sp),
                        ),
                        onPressed: calmProvider.iniciar,
                        child: Text(localizations.iniciar)),
                  )
                ],
              )
            : _buildCalmContainer(calmProvider, colorScheme),
      ),
    );
  }

  Widget _buildCalmContainer(
      CalmProvider calmProvider, ColorScheme colorScheme) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.5),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                calmProvider.image,
                width: 200.w,
              ),
              Text(
                getPhaseText(calmProvider.currentPhase),
                style: TextStyle(
                  fontSize: 30,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                calmProvider.timeRemaining.toString(),
                style: TextStyle(
                  fontSize: 50,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
