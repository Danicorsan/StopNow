// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/base/widgets/base_textfield.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/settings/settings_provider.dart';
import 'package:stopnow/utils/validators/validator.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
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

  File? _selectedImage;
  bool _cargandoImagen = false;
  bool _borrarFoto = false; // NUEVO: para saber si hay que borrar la foto

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
          "${user.fechaDejarFumar.year}-${user.fechaDejarFumar.month.toString().padLeft(2, '0')}-${user.fechaDejarFumar.day.toString().padLeft(2, '0')} "
          "${user.fechaDejarFumar.hour.toString().padLeft(2, '0')}:${user.fechaDejarFumar.minute.toString().padLeft(2, '0')}";

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

  Future<void> _pickImage() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    final localizations = AppLocalizations.of(context)!;

    PermissionStatus status;
    if (sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.permisoDenegado)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: baseAppBar(
        localizations.editarPerfil,
        volver: true,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Stack(alignment: Alignment.center, children: [
                GestureDetector(
                  onTap: _cargandoImagen ? null : _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (!_borrarFoto &&
                                Provider.of<UserProvider>(context,
                                            listen: false)
                                        .currentUser
                                        ?.fotoPerfil !=
                                    null &&
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .currentUser!
                                    .fotoPerfil
                                    .isNotEmpty)
                            ? NetworkImage(Provider.of<UserProvider>(context,
                                    listen: false)
                                .currentUser!
                                .fotoPerfil)
                            : null,
                    child: _cargandoImagen
                        ? Container(
                            color: Colors.amber,
                            child: const CircularProgressIndicator())
                        : (_selectedImage == null &&
                                (_borrarFoto ||
                                    Provider.of<UserProvider>(context,
                                                listen: false)
                                            .currentUser
                                            ?.fotoPerfil ==
                                        null ||
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .currentUser!
                                        .fotoPerfil
                                        .isEmpty))
                            ? Icon(Icons.add_a_photo,
                                size: 30, color: colorScheme.primary)
                            : null,
                  ),
                ),
                // Botón "X" para quitar la imagen
                if (_selectedImage != null ||
                    (!_borrarFoto &&
                        Provider.of<UserProvider>(context, listen: false)
                                .currentUser
                                ?.fotoPerfil !=
                            null &&
                        Provider.of<UserProvider>(context, listen: false)
                            .currentUser!
                            .fotoPerfil
                            .isNotEmpty))
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                          _borrarFoto = true;
                        });
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                if (_cargandoImagen)
                  const Center(child: CircularProgressIndicator()),
              ]),
              SizedBox(height: 20.h),
              baseTextField(
                controller: _userNameController,
                label: localizations.nombreUsuario,
                icon: Icons.person,
                colorScheme: colorScheme,
                context: context,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.introduceNombreUsuario;
                  }
                  if (value.length < 3) {
                    return localizations.nombreMinimoCaracteres;
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
              ),
              baseTextField(
                controller: _cigarrosAlDiaController,
                label: localizations.cigarrosPorDia,
                icon: Icons.smoking_rooms,
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
                context: context,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.introduceCantidad;
                  }
                  if (int.tryParse(value) == null) {
                    return localizations.introduceNumeroValido;
                  }
                  return null;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              baseTextField(
                controller: _fechaDejarDeFumarController,
                label: localizations.fechaDejarFumar,
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    DateTime finalDateTime = pickedDate;
                    if (pickedTime != null) {
                      finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                    _fechaDejarDeFumarController.text =
                        "${finalDateTime.year}-${finalDateTime.month.toString().padLeft(2, '0')}-${finalDateTime.day.toString().padLeft(2, '0')} "
                        "${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                colorScheme: colorScheme,
                context: context,
                validator: (value) => (value == null || value.isEmpty)
                    ? localizations.introduceFecha
                    : null,
              ),
              baseTextField(
                controller: _cigarrosPaqueteController,
                label: localizations.cigarrosPorPaquete,
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
                context: context,
                validator: (value) =>
                    (value == null || int.tryParse(value) == null)
                        ? localizations.introduceNumeroValido
                        : null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              baseTextField(
                controller: _precioPaqueteController,
                label: localizations.precioPorPaquete,
                icon: Icons.euro,
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
                context: context,
                validator: (value) =>
                    (value == null || double.tryParse(value) == null)
                        ? localizations.introduceNumeroValido
                        : null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            buildErrorMessage(localizations.revisaCampos, context);
            return;
          }

          final user =
              Provider.of<UserProvider>(context, listen: false).currentUser;
          if (user == null) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          String? fotoPerfilUrl = user.fotoPerfil;

          // Si hay una nueva imagen seleccionada, súbela y obtén la nueva URL
          if (_selectedImage != null) {
            final exito = await settingsProvider.actualizarFotoPerfil(
                _selectedImage!, context);
            if (exito) {
              fotoPerfilUrl = Provider.of<UserProvider>(context, listen: false)
                  .currentUser!
                  .fotoPerfil;
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              buildErrorMessage(
                settingsProvider.errorMessage ?? localizations.errorDesconocido,
                context,
              );
              return;
            }
          } else if (_borrarFoto) {
            fotoPerfilUrl = null; // Si se quitó la foto, sube null
          }

          final result = await settingsProvider.actualizarPerfil(
            id: UserRepository.getId(),
            nombreUsuario: _userNameController.text.trim(),
            fechaDejarFumar:
                DateTime.tryParse(_fechaDejarDeFumarController.text) ??
                    user.fechaDejarFumar,
            cigarrosAlDia: int.tryParse(_cigarrosAlDiaController.text) ??
                user.cigarrosAlDia,
            cigarrosPorPaquete: int.tryParse(_cigarrosPaqueteController.text) ??
                user.cigarrosPorPaquete,
            precioPaquete: double.tryParse(_precioPaqueteController.text) ??
                user.precioPaquete,
            fotoPerfil: fotoPerfilUrl,
            context: context,
          );

          Navigator.of(context, rootNavigator: true).pop();

          if (result) {
            buildSuccesMessage(localizations.perfilActualizado, context);
            Navigator.pop(context);
          } else {
            buildErrorMessage(
              settingsProvider.errorMessage ?? localizations.errorDesconocido,
              context,
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
