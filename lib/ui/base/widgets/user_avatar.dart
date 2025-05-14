// Widget para mostrar el avatar
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String _avatarUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    setState(() => _isLoading = true);
    try {
      final url = await Provider.of<UserProvider>(context, listen: false)
          .currentUser
          ?.fotoPerfil;
      if (mounted) {
        setState(() => _avatarUrl = url!);
      }
    } catch (e) {
      print('Error loading avatar: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /*
  Future<void> _updateAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final file = File(pickedFile.path);
        final newUrl = await UserRepository.uploadUserAvatar(file);
        if (mounted) {
          setState(() => _avatarUrl = newUrl);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al actualizar avatar: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, //_updateAvatar,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _isLoading || _avatarUrl.isEmpty
            ? const AssetImage('assets/default_avatar.png') as ImageProvider
            : NetworkImage(_avatarUrl),
        child: _isLoading ? const CircularProgressIndicator( color: Colors.black,) : null,
      ),
    );
  }
}
