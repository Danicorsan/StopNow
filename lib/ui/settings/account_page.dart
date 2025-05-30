import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
    ColorScheme? colorScheme,
  }) {
    colorScheme ??= Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        onTap: onTap,
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
        readOnly: readOnly,
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
      backgroundColor: colorScheme.background,
      appBar: baseAppBar(
        localizations.perfil,
        actions: [
          IconButton(
            icon: Icon(isEditable ? Icons.check : Icons.edit,
                color: colorScheme.primary),
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
              backgroundColor: colorScheme.surfaceVariant,
              child: isEditable
                  ? IconButton(
                      icon: Icon(Icons.edit, color: colorScheme.onSurface),
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
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _emailController,
              label: localizations.correo,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: !isEditable,
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _cigarrosAlDiaController,
              label: localizations.cigarrosPorDia,
              icon: Icons.smoking_rooms,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
              colorScheme: colorScheme,
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
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _cigarrosPaqueteController,
              label: localizations.cigarrosPorPaquete,
              icon: Icons.local_fire_department,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
              colorScheme: colorScheme,
            ),
            _buildTextField(
              controller: _precioPaqueteController,
              label: localizations.precioPorPaquete,
              icon: Icons.euro,
              keyboardType: TextInputType.number,
              readOnly: !isEditable,
              colorScheme: colorScheme,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
