import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp4_dap/core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? _selectedPhotoBytes;
  String? _selectedPhotoContentType;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickPhoto() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (image == null) return;

    final extension = image.name.split('.').last.toLowerCase();
    final contentType =
        image.mimeType ??
        switch (extension) {
          'png' => 'image/png',
          'webp' => 'image/webp',
          'heic' || 'heif' => 'image/heic',
          _ => 'image/jpeg',
        };
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedPhotoBytes = bytes;
      _selectedPhotoContentType = contentType;
    });
  }

  Future<void> _uploadPhoto() async {
    final imageBytes = _selectedPhotoBytes;
    final contentType = _selectedPhotoContentType;
    if (imageBytes == null || contentType == null) return;

    final uploaded = await ref
        .read(authProvider.notifier)
        .updateProfilePhoto(imageBytes: imageBytes, contentType: contentType);
    if (!mounted) return;
    if (uploaded) {
      setState(() {
        _selectedPhotoBytes = null;
        _selectedPhotoContentType = null;
      });
    }
    _showMessage(
      uploaded
          ? 'Foto de perfil actualizada'
          : ref.read(authProvider).errorMessage ?? 'No se pudo subir la foto',
    );
  }

  Future<void> _changePassword() async {
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();
    String? dialogError;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cambiar contrasena'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contrasena actual',
                ),
              ),
              TextField(
                controller: newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva contrasena',
                ),
              ),
              TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contrasena',
                ),
              ),
              if (dialogError != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dialogError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (currentPassword.text.isEmpty) {
                  setDialogState(
                    () => dialogError = 'Ingresa la contrasena actual',
                  );
                } else if (newPassword.text.length < 6) {
                  setDialogState(
                    () => dialogError = 'Usa al menos 6 caracteres',
                  );
                } else if (newPassword.text != confirmPassword.text) {
                  setDialogState(
                    () => dialogError = 'Las contrasenas no coinciden',
                  );
                } else {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final changed = await ref
          .read(authProvider.notifier)
          .changePassword(
            currentPassword: currentPassword.text,
            newPassword: newPassword.text,
          );
      if (mounted) {
        _showMessage(
          changed
              ? 'Contrasena actualizada'
              : ref.read(authProvider).errorMessage ??
                    'No se pudo cambiar la contrasena',
        );
      }
    }
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: ClipOval(
                    child: SizedBox(
                      width: 112,
                      height: 112,
                      child: _selectedPhotoBytes != null
                          ? Image.memory(
                              _selectedPhotoBytes!,
                              fit: BoxFit.cover,
                            )
                          : (authState.photoUrl == null ||
                                authState.photoUrl!.isEmpty)
                          ? Container(
                              color: const Color(0xFFE2E8F0),
                              child: const Icon(
                                Icons.person,
                                size: 58,
                                color: Color(0xFF475569),
                              ),
                            )
                          : Image.network(
                              authState.photoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFE2E8F0),
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                      size: 42,
                                    ),
                                  ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  initialValue: authState.username ?? 'Usuario',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : _pickPhoto,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Elegir foto de la galeria'),
                ),
                FilledButton.icon(
                  onPressed: authState.isLoading || _selectedPhotoBytes == null
                      ? null
                      : _uploadPhoto,
                  icon: authState.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    authState.isLoading
                        ? 'Subiendo...'
                        : 'Guardar foto en la nube',
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : _changePassword,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Cambiar contrasena'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: authState.isLoading ? null : _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesion'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
