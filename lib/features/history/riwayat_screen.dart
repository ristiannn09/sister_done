import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/date_format.dart';
import '../../data/attendance_store.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/status_chip.dart';

/// Layar 05 - Riwayat Absensi (tab Minggu / Bulan / Semester Ini).
class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  HistoryRange _range = HistoryRange.minggu;

  static const _labels = {
    HistoryRange.minggu: 'Minggu Ini',
    HistoryRange.bulan: 'Bulan Ini',
    HistoryRange.semester: 'Semester Ini',
  };

  @override
  Widget build(BuildContext context) {
    final records = AttendanceStore.instance.filter(_range);

    return PageScaffold(
      title: 'Riwayat Absensi',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: HistoryRange.values.map((r) {
                  final selected = r == _range;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _range = r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _labels[r]!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data absensi',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: records.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final r = records[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.fieldFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatTanggal(r.date),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  if (r.time != null)
                                    Text(
                                      'Jam ${formatJam(r.time!)}'
                                      '${r.latitude != null ? ' • lokasi tercatat' : ''}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            StatusChip(status: r.status),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
