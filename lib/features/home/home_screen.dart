import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/date_format.dart';
import '../../core/session.dart';
import '../../data/attendance_store.dart';

/// Layar 03 - Beranda Siswa.
///
/// Dari beranda, siswa tidak bisa kembali ke halaman login:
/// tombol back langsung menutup aplikasi.
class HomeScreen extends StatefulWidget {
  final String studentName;
  const HomeScreen({super.key, required this.studentName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = AttendanceStore.instance;

  @override
  void initState() {
    super.initState();
    Session.name = widget.studentName;
  }

  /// Buka layar lain, lalu segarkan beranda saat kembali.
  Future<void> _open(String route) async {
    await Navigator.of(context).pushNamed(route);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final today = _store.todayRecord;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) SystemNavigator.pop(); // tutup aplikasi
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _Header(name: widget.studentName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  children: [
                    _TodayCard(record: today),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: [
                        _MenuTile(
                          icon: Icons.check_circle,
                          label: 'Absensi',
                          onTap: () => _open(AppRoutes.absensi),
                        ),
                        _MenuTile(
                          icon: Icons.calendar_month,
                          label: 'Jadwal',
                          onTap: () => _open(AppRoutes.jadwal),
                        ),
                        _MenuTile(
                          icon: Icons.receipt_long,
                          label: 'Riwayat\nAbsensi',
                          onTap: () => _open(AppRoutes.riwayat),
                        ),
                        _MenuTile(
                          icon: Icons.send,
                          label: 'Ajukan\nIzin',
                          onTap: () => _open(AppRoutes.izin),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (i) {
            if (i == 1) _open(AppRoutes.profil);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        width: double.infinity,
        color: AppColors.primary,
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 18,
          20,
          52,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $name!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Selamat datang di\nSISTER SKANSIKA',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.surfaceBlue,
              child: Icon(Icons.person, color: AppColors.primary, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..lineTo(0, h - 26)
      ..quadraticBezierTo(w * 0.25, h, w * 0.55, h - 18)
      ..quadraticBezierTo(w * 0.82, h - 36, w, h - 10)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TodayCard extends StatelessWidget {
  final AttendanceRecord? record;
  const _TodayCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final sudah = record != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hari Ini',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  formatTanggal(DateTime.now()),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            sudah ? 'Sudah absen' : 'Belum absen',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: sudah ? const Color(0xFF1E8E4E) : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.fieldFill,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 38),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
