import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'core/session.dart';
import 'features/attendance/absensi_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/history/riwayat_screen.dart';
import 'features/home/home_screen.dart';
import 'features/leave/ajukan_izin_screen.dart';
import 'features/profile/profil_screen.dart';
import 'features/schedule/jadwal_screen.dart';
import 'features/splash/splash_screen.dart';

void main() => runApp(const SisterSkansikaApp());

class SisterSkansikaApp extends StatelessWidget {
  const SisterSkansikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sister Skansika',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => HomeScreen(studentName: Session.name),
        AppRoutes.absensi: (_) => const AbsensiScreen(),
        AppRoutes.riwayat: (_) => const RiwayatScreen(),
        AppRoutes.jadwal: (_) => const JadwalScreen(),
        AppRoutes.izin: (_) => const AjukanIzinScreen(),
        AppRoutes.profil: (_) => const ProfilScreen(),
      },
    );
  }
}
