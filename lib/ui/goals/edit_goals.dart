import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGoalsPage extends StatefulWidget {
  final GoalModel goal;
  const EditGoalsPage({super.key, required this.goal});

  @override
  State<EditGoalsPage> createState() => _EditGoalsPageState();
}

class _EditGoalsPageState extends State<EditGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.goal.nombre);
    _descripcionController =
        TextEditingController(text: widget.goal.descripcion);
    _precioController =
        TextEditingController(text: widget.goal.precio.toString());

    _nombreController.addListener(_onFieldsChanged);
    _descripcionController.addListener(_onFieldsChanged);
    _precioController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() {
    final nombreChanged = _nombreController.text != widget.goal.nombre;
    final descripcionChanged =
        _descripcionController.text != widget.goal.descripcion;
    final precioChanged =
        _precioController.text != widget.goal.precio.toString();
    final changed = nombreChanged || descripcionChanged || precioChanged;
    if (_hasChanged != changed) {
      setState(() {
        _hasChanged = changed;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.removeListener(_onFieldsChanged);
    _descripcionController.removeListener(_onFieldsChanged);
    _precioController.removeListener(_onFieldsChanged);
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(localizations.editarObjetivo, volver: true, onTap: () {
        Navigator.pop(context);
      }),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
              child: TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.workspaces_outlined,
                      color: colorScheme.primary),
                  labelText: localizations.nombre,
                  labelStyle: TextStyle(color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.introduceNombreObjetivo;
                  }
                  if (value.length < 3) {
                    return localizations.nombreMinimoCaracteres;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
              child: TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.description, color: colorScheme.primary),
                  labelText: localizations.descripcion,
                  labelStyle: TextStyle(color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
              child: TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.attach_money, color: colorScheme.primary),
                  labelText: localizations.cuantoCuesta,
                  labelStyle: TextStyle(color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return localizations.introduceNumeroValido;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: !_hasChanged
            ? null
            : () async {
                if (!_formKey.currentState!.validate()) {
                  buildErrorMessage(localizations.revisaCampos, context);
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final exito =
                    await Provider.of<GoalsProvider>(context, listen: false)
                        .editGoal(
                  originalGoal: widget.goal,
                  nombreNuevo: _nombreController.text.trim(),
                  descripcionNueva: _descripcionController.text.trim(),
                  precioNuevo:
                      double.tryParse(_precioController.text.trim()) ?? 0.0,
                  context: context,
                );

                Navigator.of(context, rootNavigator: true)
                    .pop(); // Quita el loader

                if (!exito) {
                  buildErrorMessage(localizations.errorObjetivo, context);
                } else {
                  Navigator.pop(context, true);
                }
              },
        child: const Icon(Icons.check),
      ),
    );
  }
}
