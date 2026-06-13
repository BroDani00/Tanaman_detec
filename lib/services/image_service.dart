import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Service untuk mengelola pengambilan gambar dari kamera/galeri
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Mengambil gambar dari kamera
  /// Mengembalikan File gambar atau null jika dibatalkan
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('❌ Error mengambil gambar dari kamera: $e');
      return null;
    }
  }

  /// Mengambil gambar dari galeri
  /// Mengembalikan File gambar atau null jika dibatalkan
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('❌ Error mengambil gambar dari galeri: $e');
      return null;
    }
  }
}
