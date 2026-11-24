import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/session.dart';
import '../../widgets/page_scaffold.dart';

/// Layar 06 - Profil (Data Diri, Pengaturan Akun, Tentang Aplikasi, Keluar).
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  void _dataDiri(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Diri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow('Nama', Session.name),
            _InfoRow('NIS', Session.nis),
            _InfoRow('Kelas', Session.kelas),
            _InfoRow('Sekolah', Session.sekolah),
          ],
        ),
      ),
    );
  }

  void _tentang(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Sister Skansika',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Smart School, Better Future',
    );
  }

  Future<void> _keluar(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      // Hapus semua halaman, lalu buka login.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Profil',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.surfaceBlue,
              child: Icon(Icons.person, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              Session.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'NIS : ${Session.nis}',
              style: const TextStyle(fontSize: 12, color: AppColors.textDark),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                children: [
                  _MenuRow(
                    icon: Icons.person,
                    label: 'Data Diri',
                    onTap: () => _dataDiri(context),
                  ),
                  const Divider(height: 1, color: AppColors.fieldBorder),
                  _MenuRow(
                    icon: Icons.settings,
                    label: 'Pengaturan Akun',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Segera hadir')),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.fieldBorder),
                  _MenuRow(
                    icon: Icons.info,
                    label: 'Tentang Aplikasi',
                    onTap: () => _tentang(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => _keluar(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Keluar dari akun'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
