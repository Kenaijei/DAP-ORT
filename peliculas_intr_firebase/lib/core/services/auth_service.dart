import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static String _displayNameForEmail(String email) {
    return email.trim().split('@').first;
  }

  Future<bool> register(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final displayName = _displayNameForEmail(normalizedEmail);
    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
    final user = credential.user!;
    try {
      await user.updateDisplayName(displayName);
      await _firestore.collection('usuarios').doc(user.uid).set({
        'username': displayName,
        'email': normalizedEmail,
        'photoUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _auth.signOut();
    } catch (_) {
      await user.delete();
      rethrow;
    }
    return true;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final credential = await _auth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
    final user = credential.user!;
    final profile = _firestore.collection('usuarios').doc(user.uid);
    final snapshot = await profile.get();
    await profile.set({
      'username': _displayNameForEmail(normalizedEmail),
      'email': normalizedEmail,
      'photoUrl':
          snapshot.data()?['photoUrl'] as String? ?? user.photoURL ?? '',
      if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return (await profile.get()).data() ?? {};
  }

  Future<String> updateProfilePhoto({
    required Uint8List imageBytes,
    required String contentType,
  }) async {
    final user = _auth.currentUser!;
    final storage = Supabase.instance.client.storage.from('profile-photos');
    final imagePath = '${user.uid}/avatar';
    await storage.uploadBinary(
      imagePath,
      imageBytes,
      fileOptions: FileOptions(
        contentType: contentType,
        cacheControl: '0',
        upsert: true,
      ),
    );
    final photoUrl =
        '${storage.getPublicUrl(imagePath)}?v=${DateTime.now().millisecondsSinceEpoch}';
    await _firestore.collection('usuarios').doc(user.uid).set({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return photoUrl;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser!;
    final email = user.email!;
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> logout() => _auth.signOut();
}
