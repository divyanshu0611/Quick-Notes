import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageHelper {
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not authenticated");
      final uid = user.uid;

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profiles/$uid/profile.jpg');

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("🔥 Error uploading image: $e");
      }
      return null;
    }
  }
}
