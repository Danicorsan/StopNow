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
      if (mounted && url != null) {
        setState(() => _avatarUrl = url);
      }
    } catch (e) {
      print('Error loading avatar: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: null, // Puedes activar _updateAvatar si lo deseas
      child: CircleAvatar(
        radius: 50,
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        backgroundImage: _isLoading || _avatarUrl.isEmpty
            ? const AssetImage('assets/default_avatar.png') as ImageProvider
            : NetworkImage(_avatarUrl),
        child: _isLoading
            ? CircularProgressIndicator(
                color: colorScheme.primary,
              )
            : null,
      ),
    );
  }
}
