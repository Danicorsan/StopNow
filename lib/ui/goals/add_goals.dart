// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGoalsPage extends StatefulWidget {
  const AddGoalsPage({super.key});

  @override
  State<AddGoalsPage> createState() => _AddGoalsPageState();
}

class _AddGoalsPageState extends State<AddGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    required ColorScheme colorScheme,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        autocorrect: false,
        style: TextStyle(color: colorScheme.onBackground),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(localizations.anadirObjetivo, volver: true, onTap: () {
        Navigator.pop(context);
      }),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 20.h,),
            _buildTextField(
              controller: _nombreController,
              label: localizations.nombre,
              icon: Icons.workspaces_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.introduceNombreObjetivo;
                }
                if (value.length < 3) {
                  return localizations.nombreMinimoCaracteres;
                }
                return null;
              },
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _descripcionController,
              label: localizations.descripcion,
              icon: Icons.description,
              validator: (value) => null,
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _precioController,
              label: localizations.cuantoCuesta,
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  return localizations.introduceNumeroValido;
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              colorScheme: colorScheme,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            buildErrorMessage(localizations.revisaCampos, context);
            return;
          }

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

          String nombre = _nombreController.text.trim();
          if (nombre.isNotEmpty) {
            nombre = nombre[0].toUpperCase() + nombre.substring(1);
          }

          final exito =
              await Provider.of<GoalsProvider>(context, listen: false).addGoal(
            GoalModel(
                usuarioId: UserRepository.getId(),
                nombre: nombre,
                descripcion: _descripcionController.text.trim(),
                precio: double.tryParse(_precioController.text.trim()) ?? 0.0,
                fechaCreacion: DateTime.now()),
            context,
          );

          Navigator.of(context, rootNavigator: true).pop(); // Quita el loader

          if (exito) {
            //buildSuccesMessage("localizations.objetivoCreado", context);
            Navigator.pop(context, true);
          } else {
            buildErrorMessage(localizations.errorObjetivo, context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
