import 'package:image_picker/image_picker.dart';

/// Mengambil foto dengan kamera memakai paket image_picker.
class CameraService {
  CameraService._();

  static final ImagePicker _picker = ImagePicker();

  /// Mengembalikan path foto, atau null jika dibatalkan / gagal.
  static Future<String?> takePhoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // kamera depan (selfie)
        imageQuality: 80,
        maxWidth: 1280,
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }
}
