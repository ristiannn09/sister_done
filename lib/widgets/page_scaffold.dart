import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Kerangka layar dalam: header navy (tombol back + judul)
/// dan badan putih dengan sudut atas membulat.
class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const PageScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
