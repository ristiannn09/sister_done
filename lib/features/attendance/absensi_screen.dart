import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/date_format.dart';
import '../../core/school_config.dart';
import '../../data/attendance_store.dart';
import '../../services/camera_service.dart';
import '../../services/location_service.dart';
import '../../services/permission_service.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/photo_image.dart';

/// Layar 04 - Absensi.
/// Alur: izin kamera + lokasi -> deteksi lokasi -> foto -> konfirmasi -> simpan.
class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  final _store = AttendanceStore.instance;
  bool _busy = false;
  String _status = '';

  void _setStatus(String text) {
    if (mounted) setState(() => _status = text);
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _absen() async {
    if (_busy) return;
    if (_store.hasToday) {
      _snack('Anda sudah tercatat hari ini');
      return;
    }

    setState(() => _busy = true);
    try {
      // 1. Izin kamera dan lokasi.
      _setStatus('Memeriksa izin...');
      final perm = await PermissionService.requestCameraAndLocation();
      if (!mounted) return;
      if (perm != PermissionResult.granted) {
        await _showPermissionDialog(perm == PermissionResult.permanentlyDenied);
        return;
      }

      // 2. Deteksi lokasi.
      _setStatus('Mencari lokasi...');
      final loc = await LocationService.getCurrent();
      if (!mounted) return;
      if (!loc.success) {
        _snack(_locationMessage(loc.failure!));
        return;
      }
      final lat = loc.latitude!;
      final lng = loc.longitude!;

      // 3. Cek jarak ke sekolah (jika diaktifkan di SchoolConfig).
      if (SchoolConfig.enforceRadius) {
        final jarak = LocationService.distanceMeters(
          lat,
          lng,
          SchoolConfig.latitude,
          SchoolConfig.longitude,
        );
        if (jarak > SchoolConfig.radiusMeters) {
          await _showInfoDialog(
            'Di luar area sekolah',
            'Jarak Anda dari sekolah sekitar ${jarak.round()} m. '
                'Absensi hanya bisa dilakukan dalam radius '
                '${SchoolConfig.radiusMeters.round()} m.',
          );
          return;
        }
      }

      // 4. Ambil foto.
      _setStatus('Membuka kamera...');
      final photo = await CameraService.takePhoto();
      if (!mounted) return;
      if (photo == null) {
        _snack('Pengambilan foto dibatalkan');
        return;
      }

      // 5. Konfirmasi.
      final ok = await _showConfirmDialog(photo, lat, lng);
      if (ok != true || !mounted) return;

      // 6. Simpan.
      _store.addToday(
        AttendanceStatus.hadir,
        photoPath: photo,
        latitude: lat,
        longitude: lng,
      );
      await _showInfoDialog(
        'Absensi berhasil',
        'Anda tercatat Hadir\n${formatTanggal(DateTime.now())}, '
            '${formatJam(DateTime.now())}',
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _status = '';
        });
      }
    }
  }

  String _locationMessage(LocationFailure f) {
    switch (f) {
      case LocationFailure.serviceOff:
        return 'GPS belum aktif. Aktifkan lokasi lalu coba lagi';
      case LocationFailure.permissionDenied:
        return 'Izin lokasi ditolak';
      case LocationFailure.unavailable:
        return 'Lokasi tidak dapat dideteksi. Coba lagi di tempat terbuka';
    }
  }

  Future<void> _showPermissionDialog(bool permanent) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Izin diperlukan'),
        content: Text(
          permanent
              ? 'Izin kamera dan lokasi ditolak permanen. '
                  'Aktifkan lewat Pengaturan aplikasi.'
              : 'Absensi membutuhkan izin kamera dan lokasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          if (permanent)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                PermissionService.openSettings();
              },
              child: const Text('Buka Pengaturan'),
            ),
        ],
      ),
    );
  }

  Future<void> _showInfoDialog(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String photo, double lat, double lng) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Kirim absensi?'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PhotoImage(path: photo, height: 220),
              ),
              const SizedBox(height: 12),
              Text(
                '${formatTanggal(DateTime.now())}, ${formatJam(DateTime.now())}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Lokasi: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sudah = _store.hasToday;
    final hint = _busy
        ? _status
        : sudah
            ? 'Anda sudah absen hari ini'
            : 'Tap untuk melakukan\nabsensi';

    return PageScaffold(
      title: 'Absensi',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(
                painter: _FramePainter(),
                child: Center(
                  child: Material(
                    color: AppColors.surfaceBlue,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _absen,
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: _busy
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(
                                Icons.photo_camera,
                                size: 72,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pastikan GPS aktif',
              style: TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empat sudut bingkai kamera.
class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const l = 36.0;
    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()..moveTo(0, l)..lineTo(0, 0)..lineTo(l, 0),
      p,
    );
    canvas.drawPath(
      Path()..moveTo(w - l, 0)..lineTo(w, 0)..lineTo(w, l),
      p,
    );
    canvas.drawPath(
      Path()..moveTo(0, h - l)..lineTo(0, h)..lineTo(l, h),
      p,
    );
    canvas.drawPath(
      Path()..moveTo(w - l, h)..lineTo(w, h)..lineTo(w, h - l),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
