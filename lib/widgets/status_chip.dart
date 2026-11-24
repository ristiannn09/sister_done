import 'package:flutter/material.dart';
import '../data/attendance_store.dart';

/// Label status absensi (Hadir / Izin / Sakit) berwarna.
class StatusChip extends StatelessWidget {
  final AttendanceStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    late final Color fg;
    switch (status) {
      case AttendanceStatus.hadir:
        label = 'Hadir';
        bg = const Color(0xFFD9F5E3);
        fg = const Color(0xFF1E8E4E);
        break;
      case AttendanceStatus.izin:
        label = 'Izin';
        bg = const Color(0xFFFFE8C2);
        fg = const Color(0xFFB7791F);
        break;
      case AttendanceStatus.sakit:
        label = 'Sakit';
        bg = const Color(0xFFFAD1D6);
        fg = const Color(0xFFC0392B);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
