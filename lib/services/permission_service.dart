import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

enum PermissionResult { granted, denied, permanentlyDenied }

/// Meminta izin kamera dan lokasi memakai paket permission_handler.
class PermissionService {
  PermissionService._();

  static Future<PermissionResult> requestCameraAndLocation() async {
    // Di web, browser meminta izin sendiri saat kamera/lokasi dipakai.
    if (kIsWeb) return PermissionResult.granted;

    final statuses = await [
      Permission.camera,
      Permission.locationWhenInUse,
    ].request();

    final values = statuses.values;
    if (values.every((s) => s.isGranted)) return PermissionResult.granted;
    if (values.any((s) => s.isPermanentlyDenied)) {
      return PermissionResult.permanentlyDenied;
    }
    return PermissionResult.denied;
  }

  /// Buka pengaturan aplikasi (untuk izin yang ditolak permanen).
  static Future<bool> openSettings() => openAppSettings();
}
