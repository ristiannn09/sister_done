import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/wave_background.dart';
import '../home/home_screen.dart';
import 'auth_service.dart';

/// Layar 02 - Login Siswa & Wali Kelas.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _nisCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateNis(String? v) {
    if (v == null || v.trim().isEmpty) return 'NIS wajib diisi';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final result = await _auth.login(_nisCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Login gagal'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Navigasi berdasarkan peran.
    if (result.role == UserRole.siswa) {
      // -> Layar 03: Beranda Siswa
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(studentName: result.name ?? 'Siswa'),
        ),
      );
    } else {
      // TODO: arahkan ke Beranda Wali Kelas (tahap berikutnya).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beranda Wali Kelas belum tersedia')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 24),
                    const Text(
                      'Masuk ke Akun Anda',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _nisCtrl,
                      hint: 'NIS',
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                      validator: _validateNis,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _passCtrl,
                      hint: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: _validatePass,
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Masuk',
                      isLoading: _loading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
