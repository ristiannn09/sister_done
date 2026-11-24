import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Logo + nama aplikasi. Ganti Icon dengan Image.asset('assets/logo.png')
/// bila file logo sudah tersedia.
class AppLogo extends StatelessWidget {
  final double iconSize;
  const AppLogo({super.key, this.iconSize = 64});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme.headlineMedium;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
        Icon(Icons.menu_book_rounded, color: AppColors.primary, size: iconSize),
        const SizedBox(height: 4),
        Text('SISTER', style: text),
        Text('SKANSIKA', style: text),
      ],
    );
  }
}
