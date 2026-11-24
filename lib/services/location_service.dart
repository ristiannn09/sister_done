import 'dart:math' as math;
import 'package:location/location.dart';

enum LocationFailure { serviceOff, permissionDenied, unavailable }

class LocationResult {
  final double? latitude;
  final double? longitude;
  final LocationFailure? failure;

  const LocationResult.ok(this.latitude, this.longitude) : failure = null;
  const LocationResult.fail(this.failure)
      : latitude = null,
        longitude = null;

  bool get success => failure == null;
}

/// Mendeteksi lokasi memakai paket location.
class LocationService {
  LocationService._();

  static final Location _location = Location();

  static Future<LocationResult> getCurrent() async {
    try {
      // 1. GPS harus aktif.
      var serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return const LocationResult.fail(LocationFailure.serviceOff);
        }
      }

      // 2. Izin lokasi.
      var permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.grantedLimited) {
        return const LocationResult.fail(LocationFailure.permissionDenied);
      }

      // 3. Ambil koordinat.
      final data =
          await _location.getLocation().timeout(const Duration(seconds: 20));
      final lat = data.latitude;
      final lng = data.longitude;
      if (lat == null || lng == null) {
        return const LocationResult.fail(LocationFailure.unavailable);
      }
      return LocationResult.ok(lat, lng);
    } catch (_) {
      return const LocationResult.fail(LocationFailure.unavailable);
    }
  }

  /// Jarak dua titik dalam meter (rumus Haversine).
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const r = 6371000.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(lat2 - lat1);
    final dLng = rad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(rad(lat1)) *
            math.cos(rad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * r * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}
