import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF153866)),
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        autocorrect: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Añadir objetivo", volver: true, onTap: () {
        Navigator.pop(context);
      }),
      drawer: baseDrawer(context,),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre',
              icon: Icons.workspaces_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce el nombre del objetivo';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _descripcionController,
              label: 'Descripción',
              icon: Icons.description,
              validator: (value) => null,
            ),
            _buildTextField(
              controller: _precioController,
              label: '¿Cuánto cuesta?',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    double.tryParse(value) == null) {
                  return 'Introduce un número válido';
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        backgroundColor: const Color(0xFF153866),
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor, revisa todos los campos'),
                backgroundColor: Color(0xFF8A0000),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          Provider.of<GoalsProvider>(context, listen: false).addGoal(
            GoalModel(
              usuarioId: UserRepository.getId(),
              nombre: _nombreController.text.trim(),
              precio: _precioController.text.trim().isEmpty
                  ? 0.0
                  : double.tryParse(_precioController.text.trim())!,
            ),
          );

          Navigator.pop(context);
        },
      ),
    );
  }
}
