import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.trend,
    this.trendPositive = true,
    this.backgroundColor,
    this.compact = false,
  });

  final String label;
  final String value;
  final String? subValue;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final String? trend;
  final bool trendPositive;
  final Color? backgroundColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cardColor = backgroundColor ?? AppColors.card(context);
    final labelColor = AppColors.text2(context);
    final valueTextColor = valueColor ?? AppColors.text1(context);
    final trendColor =
        trendPositive ? AppColors.gainColor(context) : AppColors.lossColor(context);

    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDark(context)
                ? Colors.black.withValues(alpha: 0.2)
                : AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color:
                        (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 12 : 14,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: compact ? 6 : 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: compact ? 16 : 20,
              fontWeight: FontWeight.w700,
              color: valueTextColor,
              letterSpacing: -0.3,
            ),
          ),
          if (subValue != null || trend != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (trend != null) ...[
                  Icon(
                    trendPositive
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 12,
                    color: trendColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    trend!,
                    style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: trendColor,
                    ),
                  ),
                  if (subValue != null) const SizedBox(width: 4),
                ],
                if (subValue != null)
                  Expanded(
                    child: Text(
                      subValue!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.text3(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
