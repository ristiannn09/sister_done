enum AttendanceStatus { hadir, izin, sakit }

enum HistoryRange { minggu, bulan, semester }

class AttendanceRecord {
  final DateTime date; // hanya tanggal (tanpa jam)
  final AttendanceStatus status;
  final DateTime? time; // waktu absen sebenarnya
  final String? photoPath; // foto kamera
  final double? latitude;
  final double? longitude;

  const AttendanceRecord(
    this.date,
    this.status, {
    this.time,
    this.photoPath,
    this.latitude,
    this.longitude,
  });
}

/// Penyimpanan absensi sementara di memori (data dummy).
/// Ganti dengan API/database saat backend siap.
class AttendanceStore {
  AttendanceStore._() {
    _seed();
  }
  static final AttendanceStore instance = AttendanceStore._();

  final List<AttendanceRecord> _records = [];

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  void _seed() {
    final today = _today();
    for (var i = 1; i <= 120; i++) {
      final d = today.subtract(Duration(days: i));
      if (d.weekday == DateTime.saturday || d.weekday == DateTime.sunday) {
        continue;
      }
      AttendanceStatus s = AttendanceStatus.hadir;
      if (i % 9 == 0) {
        s = AttendanceStatus.sakit;
      } else if (i % 7 == 3) {
        s = AttendanceStatus.izin;
      }
      _records.add(AttendanceRecord(d, s));
    }
  }

  bool get hasToday {
    final t = _today();
    return _records.any((r) => r.date == t);
  }

  AttendanceRecord? get todayRecord {
    final t = _today();
    for (final r in _records) {
      if (r.date == t) return r;
    }
    return null;
  }

  /// Mencatat absensi hari ini. Mengembalikan false jika sudah tercatat.
  bool addToday(
    AttendanceStatus status, {
    String? photoPath,
    double? latitude,
    double? longitude,
  }) {
    if (hasToday) return false;
    _records.insert(
      0,
      AttendanceRecord(
        _today(),
        status,
        time: DateTime.now(),
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    return true;
  }

  List<AttendanceRecord> filter(HistoryRange range) {
    final today = _today();
    return _records.where((r) {
      switch (range) {
        case HistoryRange.minggu:
          return !r.date.isBefore(today.subtract(const Duration(days: 6)));
        case HistoryRange.bulan:
          return r.date.year == today.year && r.date.month == today.month;
        case HistoryRange.semester:
          return true;
      }
    }).toList();
  }
}
