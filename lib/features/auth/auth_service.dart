/// Hasil autentikasi.
class AuthResult {
  final bool success;
  final String? message;
  final UserRole? role;
  final String? name;

  const AuthResult.ok({required this.role, required this.name})
      : success = true,
        message = null;

  const AuthResult.fail(this.message)
      : success = false,
        role = null,
        name = null;
}

enum UserRole { siswa, waliKelas }

/// Simulasi autentikasi (tanpa backend).
/// Ganti isi [login] dengan panggilan API saat backend siap.
class AuthService {
  // Data dummy: NIS -> (password, nama)
  static const Map<String, ({String password, String name})> _students = {
    '123456': (password: 'siswa123', name: 'Ridho'),
  };

  // Data dummy wali kelas: NIP -> (password, nama)
  static const Map<String, ({String password, String name})> _teachers = {
    'wali01': (password: 'wali123', name: 'Bu Sari'),
  };

  Future<AuthResult> login(String id, String password) async {
    await Future.delayed(const Duration(milliseconds: 900)); // simulasi jaringan

    final student = _students[id];
    if (student != null && student.password == password) {
      return AuthResult.ok(role: UserRole.siswa, name: student.name);
    }

    final teacher = _teachers[id];
    if (teacher != null && teacher.password == password) {
      return AuthResult.ok(role: UserRole.waliKelas, name: teacher.name);
    }

    return const AuthResult.fail('NIS atau password salah');
  }
}
