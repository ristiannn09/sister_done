const List<String> _hari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
const List<String> _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Contoh: "Sen, 24 Nov 2026"
String formatTanggal(DateTime d) =>
    '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]} ${d.year}';

/// Contoh: "09:05"
String formatJam(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
