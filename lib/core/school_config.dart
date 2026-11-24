/// Pengaturan lokasi sekolah untuk validasi absensi.
///
/// Cara mengaktifkan: buka Google Maps, klik lokasi sekolah, salin
/// koordinatnya ke [latitude] dan [longitude], lalu ubah [enforceRadius]
/// menjadi true. Selama false, lokasi hanya dicatat tanpa dicek jaraknya.
class SchoolConfig {
  SchoolConfig._();

  static const bool enforceRadius = false;
  static const double latitude = 0; // TODO: isi koordinat sekolah
  static const double longitude = 0; // TODO: isi koordinat sekolah
  static const double radiusMeters = 200; // jarak maksimal dari sekolah
}
