import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/wave_background.dart';

/// Layar 01 - Splash. Setelah 2 detik pindah ke Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const AppLogo(iconSize: 80),
              const SizedBox(height: 16),
              // RichText: dua gaya teks dalam satu kalimat.
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 13, color: AppColors.textDark),
                  children: [
                    TextSpan(text: 'Smart School, '),
                    TextSpan(
                      text: 'Better Future',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
