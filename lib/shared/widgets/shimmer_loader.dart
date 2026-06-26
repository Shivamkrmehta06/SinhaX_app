import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Generic shimmer wrapper — wraps any widget with a shimmer effect.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width, height, borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E2340) : const Color(0xFFE8EAF6),
      highlightColor: isDark ? const Color(0xFF2A3060) : const Color(0xFFF5F6FF),
      child: Container(
        width: width, height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2340) : const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a stat card
class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 80, height: 10, borderRadius: 5),
          const SizedBox(height: 10),
          ShimmerBox(width: 120, height: 20, borderRadius: 6),
          const SizedBox(height: 8),
          ShimmerBox(width: 60, height: 10, borderRadius: 5),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for a list tile
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ShimmerBox(width: 44, height: 44, borderRadius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 12, borderRadius: 6),
                const SizedBox(height: 6),
                ShimmerBox(width: 80, height: 10, borderRadius: 5),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 70, height: 12, borderRadius: 6),
              const SizedBox(height: 6),
              ShimmerBox(width: 50, height: 10, borderRadius: 5),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer for a chart area
class ShimmerChart extends StatelessWidget {
  const ShimmerChart({super.key, this.height = 180});
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: double.infinity,
      height: height,
      borderRadius: 12,
    );
  }
}
