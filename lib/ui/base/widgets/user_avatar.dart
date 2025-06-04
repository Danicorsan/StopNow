import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatefulWidget {
  final String? avatarUrl;

  const UserAvatar({super.key, this.avatarUrl});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String _avatarUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(widget.avatarUrl);

    _loadAvatar();
    print(_avatarUrl);
  }

  Future<void> _loadAvatar() async {
    setState(() => _isLoading = true);
    try {
      final url = widget.avatarUrl;
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
      onTap: null, // Activa _updateAvatar si deseas permitir edición
      child: CircleAvatar(
        radius: 50,
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        child: _isLoading
            ? CircularProgressIndicator(color: colorScheme.primary)
            : ClipOval(
                child: _avatarUrl.isEmpty
                    ? Image.asset(
                        'assets/default_avatar.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: _avatarUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/default_avatar.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
      ),
    );
  }
}
