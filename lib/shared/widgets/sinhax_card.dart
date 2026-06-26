import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Base card widget with consistent styling across SinhaX — dark-mode aware
class SinhaXCard extends StatelessWidget {
  const SinhaXCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border = true,
    this.onTap,
    this.elevation = 0,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final double? borderRadius;
  final bool border;
  final VoidCallback? onTap;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 16.0;
    final isDark = AppColors.isDark(context);
    final defaultColor = AppColors.card(context);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : AppColors.textPrimary.withValues(alpha: 0.05);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? defaultColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border
            ? Border.all(color: AppColors.borderColor(context), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation > 0 ? elevation * 4 : 8,
            offset: Offset(0, elevation > 0 ? elevation * 2 : 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

/// Gradient card (brand gradient or custom)
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.gradientColors,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      border: false,
      onTap: onTap,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors ?? AppColors.primaryGradient,
      ),
      child: child,
    );
  }
}

/// Glassmorphism card — for use on gradient/image backgrounds
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16.0,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
