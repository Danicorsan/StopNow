// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/base/widgets/base_textfield.dart';
import 'package:stopnow/ui/settings/settings_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fotoPerfilController = TextEditingController();
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
  bool _borrarFoto = false;

  late String _originalNombreUsuario;
  late String? _originalFotoPerfil;
  late int _originalCigarrosAlDia;
  late int _originalCigarrosPorPaquete;
  late double _originalPrecioPaquete;
  late String _originalFechaDejarFumar;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user != null) {
      _userNameController.text = user.nombreUsuario;
      _fotoPerfilController.text =
          user.fotoPerfil; // Assuming email is stored in fotoPerfil
      _cigarrosAlDiaController.text = user.cigarrosAlDia.toString();
      _fechaDejarDeFumarController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(user.fechaDejarFumar.toLocal());

      _cigarrosPaqueteController.text = user.cigarrosPorPaquete.toString();
      _precioPaqueteController.text = user.precioPaquete.toString();

      // Guardar originales
      _originalNombreUsuario = user.nombreUsuario;
      _originalFotoPerfil = user.fotoPerfil;
      _originalCigarrosAlDia = user.cigarrosAlDia;
      _originalCigarrosPorPaquete = user.cigarrosPorPaquete;
      _originalPrecioPaquete = user.precioPaquete;
      _originalFechaDejarFumar =
          DateFormat('yyyy-MM-dd HH:mm').format(user.fechaDejarFumar.toLocal());
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fotoPerfilController.dispose();
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

  bool _hayCambios() {
    final nombreUsuario = _userNameController.text.trim();
    final cigarrosAlDia = int.tryParse(_cigarrosAlDiaController.text) ?? 0;
    final cigarrosPorPaquete =
        int.tryParse(_cigarrosPaqueteController.text) ?? 0;
    final precioPaquete = double.tryParse(_precioPaqueteController.text) ?? 0.0;
    final fechaDejarFumar = _fechaDejarDeFumarController.text.toString();

    return nombreUsuario != _originalNombreUsuario ||
        cigarrosAlDia != _originalCigarrosAlDia ||
        cigarrosPorPaquete != _originalCigarrosPorPaquete ||
        precioPaquete != _originalPrecioPaquete ||
        fechaDejarFumar != _originalFechaDejarFumar ||
        _selectedImage != null ||
        (_borrarFoto &&
            _originalFotoPerfil != null &&
            _originalFotoPerfil!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: _cargandoImagen ? null : _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: isDarkMode
                          ? const Color.fromARGB(255, 61, 61, 61)
                          : Colors.grey.shade300,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage != null
                          ? null
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
                              ? ClipOval(
                                  child: Image.network(
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .currentUser!
                                        .fotoPerfil,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                )
                              : Icon(Icons.add_a_photo,
                                  size: 30, color: colorScheme.primary),
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
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child:
                              Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),

                  if (_cargandoImagen)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
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
          FocusScope.of(context).unfocus();
          final hayCambios = _hayCambios();

          if (!hayCambios) return;

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
            builder: (_) => Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: colorScheme.primary,
                rightDotColor: colorScheme.secondary,
                size: 50,
              ),
            ),
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
