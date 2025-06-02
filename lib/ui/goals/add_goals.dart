import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/network/base_result.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.primary),
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

          bool exito =
              await Provider.of<GoalsProvider>(context, listen: false).addGoal(
                  GoalModel(
                    usuarioId: UserRepository.getId(),
                    nombre: _nombreController.text.trim(),
                    descripcion: _descripcionController.text.trim(),
                    precio: _precioController.text.trim().isEmpty
                        ? 0.0
                        : double.tryParse(_precioController.text.trim())!,
                  ),
                  context);
          Navigator.pop(context, exito);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
