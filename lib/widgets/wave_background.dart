import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Dekorasi gelombang biru di pojok atas (mengikuti desain).
class WaveBackground extends StatelessWidget {
  final Widget child;
  const WaveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 170),
            painter: _WavePainter(),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final back = Paint()..color = AppColors.surfaceBlue;
    final backPath = Path()
      ..moveTo(size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.55,
          size.width * 0.8, size.height * 0.3)
      ..quadraticBezierTo(
          size.width * 0.95, size.height * 0.15, size.width, size.height * 0.4)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(backPath, back);

    final front = Paint()..color = AppColors.surfaceBlue.withOpacity(0.6);
    final frontPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.7,
          size.width * 0.5, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.05,
          size.width * 0.7, 0)
      ..close();
    canvas.drawPath(frontPath, front);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
