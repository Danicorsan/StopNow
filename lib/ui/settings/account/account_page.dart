import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsAccountPage extends StatefulWidget {
  const SettingsAccountPage({super.key});

  @override
  State<SettingsAccountPage> createState() => _SettingsAccountPageState();
}

class _SettingsAccountPageState extends State<SettingsAccountPage> {
  bool isEditable = false;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cigarrosAlDiaController =
      TextEditingController();
  final TextEditingController _fechaDejarDeFumarController =
      TextEditingController();
  final TextEditingController _cigarrosPaqueteController =
      TextEditingController();
  final TextEditingController _precioPaqueteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    print(user);
    if (user != null) {
      _userNameController.text = user.nombreUsuario;
      _emailController.text =
          user.fotoPerfil; // Assuming email is stored in fotoPerfil
      _cigarrosAlDiaController.text = user.cigarrosAlDia.toString();
      _fechaDejarDeFumarController.text =
          user.fechaDejarFumar.toIso8601String();
      _cigarrosPaqueteController.text = user.cigarrosPorPaquete.toString();
      _precioPaqueteController.text = user.precioPaquete.toString();
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _cigarrosAlDiaController.dispose();
    _fechaDejarDeFumarController.dispose();
    _cigarrosPaqueteController.dispose();
    _precioPaqueteController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Function()? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF153866)),
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        keyboardType: keyboardType,
        readOnly: readOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(
        localizations.perfil,
        actions: [
          IconButton(
            icon: Icon(isEditable ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
            },
          ),
        ],
        volver: true,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 50,
              child: isEditable
                  ? IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        // Lógica para cambiar la foto de perfil
                      },
                    )
                  : null,
            ),
            SizedBox(height: 20.h),
            _buildTextField(
              controller: _userNameController,
              label: localizations.nombreUsuario,
              icon: Icons.person,
              readOnly: !isEditable,
            ),
            _buildTextField(
              controller: _emailController,
              label: localizations.correo,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: !isEditable,
            ),
            _buildTextField(
              controller: _cigarrosAlDiaController,
              label: localizations.cigarrosPorDia,
              icon: Icons.smoking_rooms,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
            ),
            _buildTextField(
              controller: _fechaDejarDeFumarController,
              label: localizations.fechaDejarFumar,
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: isEditable
                  ? () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _fechaDejarDeFumarController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    }
                  : null,
            ),
            _buildTextField(
              controller: _cigarrosPaqueteController,
              label: localizations.cigarrosPorPaquete,
              icon: Icons.local_fire_department,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
            ),
            _buildTextField(
              controller: _precioPaqueteController,
              label: localizations.precioPorPaquete,
              icon: Icons.euro,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
