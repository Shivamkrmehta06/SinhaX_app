import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

enum StatusType { success, warning, error, info, neutral }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.info,
    this.icon,
    this.compact = false,
  });

  final String label;
  final StatusType type;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    final (bgColor, textColor) = switch (type) {
      StatusType.success => (
          isDark ? AppColors.darkProfitSurface : AppColors.profitSurface,
          isDark ? AppColors.darkProfit : AppColors.profit,
        ),
      StatusType.warning => (
          isDark ? const Color(0xFF2A1F06) : AppColors.warningSurface,
          AppColors.warning,
        ),
      StatusType.error => (
          isDark ? AppColors.darkLossSurface : AppColors.lossSurface,
          isDark ? AppColors.darkLoss : AppColors.loss,
        ),
      StatusType.info => (
          isDark ? AppColors.darkPrimarySurface : AppColors.primarySurface,
          AppColors.primary,
        ),
      StatusType.neutral => (
          isDark ? AppColors.darkSurfaceAlt : AppColors.background,
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 10 : 12, color: textColor),
            SizedBox(width: compact ? 3 : 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsing live status indicator
class LiveStatusIndicator extends StatefulWidget {
  const LiveStatusIndicator({super.key, this.label = 'Live', this.color});
  final String label;
  final Color? color;

  @override
  State<LiveStatusIndicator> createState() => _LiveStatusIndicatorState();
}

class _LiveStatusIndicatorState extends State<LiveStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.gainColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: _animation.value),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 4, spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
