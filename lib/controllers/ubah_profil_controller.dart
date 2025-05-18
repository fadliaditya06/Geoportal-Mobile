import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahProfilController {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  static const String prefKeyPhotoUrl = 'foto_profil_url';

  Future<String?> pickAndUploadImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile == null) return null;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;

    final fileName = path.basename(pickedFile.path);
    final bytes = await pickedFile.readAsBytes();
    final filePath = 'foto_profil/$userId/$fileName';

    try {
      await supabase.storage.from('images').uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final publicUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // Simpan URL ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKeyPhotoUrl, publicUrl);

      // Simpan URL ke Firestore
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'foto_profil': publicUrl,
      });

      return publicUrl;
    } catch (e) {
      print('Upload gagal: $e');
      return null;
    }
  }

  Future<bool> deleteProfileImage(String? imageUrl) async {
    if (imageUrl == null) return false;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    final uri = Uri.parse(imageUrl);
    final segments = uri.pathSegments;
    final imagesIndex = segments.indexOf('images');
    if (imagesIndex == -1 || imagesIndex + 1 >= segments.length) return false;

    final filePathSegments = segments.sublist(imagesIndex + 1);
    final filePath = filePathSegments.join('/');

    try {
      await supabase.storage.from('images').remove([filePath]);

      // Hapus URL di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(prefKeyPhotoUrl);

      // Hapus dari Firestore
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'foto_profil': FieldValue.delete(),
      });

      return true;
    } catch (e) {
      print('Gagal hapus file: $e');
      return false;
    }
  }

  Future<String?> getSavedProfilePhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefKeyPhotoUrl);
  }
}
