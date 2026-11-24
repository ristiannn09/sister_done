import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/page_scaffold.dart';

/// Jadwal pelajaran (data dummy). Ganti dengan data dari backend nanti.
class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  static const List<MapEntry<String, List<String>>> _jadwal = [
    MapEntry('Senin', [
      '07.00 - 08.30  Pemrograman Dasar',
      '08.30 - 10.00  Basis Data',
      '10.15 - 11.45  Bahasa Indonesia',
    ]),
    MapEntry('Selasa', [
      '07.00 - 09.15  Pemrograman Mobile',
      '09.15 - 10.45  Matematika',
      '11.00 - 12.30  Bahasa Inggris',
    ]),
    MapEntry('Rabu', [
      '07.00 - 08.30  Desain Web',
      '08.30 - 10.00  PPKn',
      '10.15 - 11.45  Basis Data',
    ]),
    MapEntry('Kamis', [
      '07.00 - 09.15  Pemrograman Mobile',
      '09.15 - 10.45  Pendidikan Agama',
      '11.00 - 12.30  PJOK',
    ]),
    MapEntry('Jumat', [
      '07.00 - 08.30  Projek Kreatif',
      '08.30 - 10.00  Bimbingan Konseling',
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1; // 0 = Senin

    return PageScaffold(
      title: 'Jadwal',
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _jadwal.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final day = _jadwal[i];
          final isToday = i == todayIndex;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isToday ? AppColors.primary : AppColors.fieldBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      day.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 8),
                      const Text(
                        '• Hari ini',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                for (final item in day.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(item, style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
