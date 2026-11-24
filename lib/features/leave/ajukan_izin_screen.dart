import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/date_format.dart';
import '../../data/attendance_store.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/primary_button.dart';

/// Ajukan Izin / Sakit. Memakai TextEditingController untuk keterangan.
class AjukanIzinScreen extends StatefulWidget {
  const AjukanIzinScreen({super.key});

  @override
  State<AjukanIzinScreen> createState() => _AjukanIzinScreenState();
}

class _AjukanIzinScreenState extends State<AjukanIzinScreen> {
  final _ketCtrl = TextEditingController();
  AttendanceStatus _jenis = AttendanceStatus.izin;
  String? _error;

  @override
  void dispose() {
    _ketCtrl.dispose();
    super.dispose();
  }

  void _kirim() {
    if (_ketCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Keterangan wajib diisi');
      return;
    }
    final ok = AttendanceStore.instance.addToday(_jenis);
    final msg = ok
        ? 'Pengajuan terkirim'
        : 'Anda sudah tercatat hari ini, pengajuan tidak dapat dikirim';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Ajukan Izin',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jenis', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Izin'),
                  selected: _jenis == AttendanceStatus.izin,
                  onSelected: (_) =>
                      setState(() => _jenis = AttendanceStatus.izin),
                ),
                ChoiceChip(
                  label: const Text('Sakit'),
                  selected: _jenis == AttendanceStatus.sakit,
                  onSelected: (_) =>
                      setState(() => _jenis = AttendanceStatus.sakit),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Tanggal',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Text(formatTanggal(DateTime.now())),
            ),
            const SizedBox(height: 20),
            const Text('Keterangan',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _ketCtrl,
              maxLines: 4,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(
                hintText: 'Tulis alasan izin atau sakit',
                hintStyle: const TextStyle(color: AppColors.textHint),
                errorText: _error,
                filled: true,
                fillColor: AppColors.fieldFill,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Kirim Pengajuan', onPressed: _kirim),
          ],
        ),
      ),
    );
  }
}
