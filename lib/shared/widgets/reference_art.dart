import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TradingBarsArtwork extends StatelessWidget {
  const TradingBarsArtwork({
    super.key,
    this.height = 170,
    this.borderRadius = 22,
    this.showBadge = true,
  });

  final double height;
  final double borderRadius;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3548FF), Color(0xFF1D28D8)],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22,
            top: -28,
            child: _SoftOrb(
              size: 116,
              color: AppColors.accent.withValues(alpha: 0.24),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -34,
            child: _SoftOrb(
              size: 128,
              color: AppColors.white.withValues(alpha: 0.12),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _TradingBarsPainter())),
          if (showBadge)
            Positioned(
              right: 22,
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: const Icon(
                  Icons.auto_graph_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SoftOrb extends StatelessWidget {
  const _SoftOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _TradingBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFF37DDF5), Color(0xFF8EFFF2)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final bars = <({double left, double top, double width, double height})>[
      (left: size.width * 0.34, top: size.height * 0.56, width: 26, height: 46),
      (left: size.width * 0.47, top: size.height * 0.43, width: 28, height: 68),
      (left: size.width * 0.61, top: size.height * 0.30, width: 30, height: 92),
    ];

    for (final bar in bars) {
      final rect = Rect.fromLTWH(
        bar.left + 6,
        bar.top + 8,
        bar.width,
        bar.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(7)),
        shadowPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bar.left, bar.top, bar.width, bar.height),
          const Radius.circular(7),
        ),
        barPaint,
      );
    }

    final linePaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.22)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.70)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.48,
        size.width * 0.46,
        size.height * 0.78,
        size.width * 0.74,
        size.height * 0.26,
      );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
