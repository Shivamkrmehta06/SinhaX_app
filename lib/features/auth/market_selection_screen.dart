import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/interactive_3d_card.dart';

class MarketSelectionScreen extends StatelessWidget {
  const MarketSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: Stack(
        children: [
          // Background Glow Effects
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: isDark ? 0.1 : 0.05),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: isDark ? 0.15 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.accentGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Choose Your',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text1(context),
                      letterSpacing: -1.0,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: AppColors.heroGradient(context),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Market',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select the market you want to trade in. You can easily switch between them later.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.text2(context),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Market Cards
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _PremiumMarketCard(
                            icon: Icons.account_balance_rounded,
                            title: 'Indian Market',
                            description: 'Trade NSE and BSE listed stocks, derivatives, and indices.',
                            hours: 'Mon–Fri, 9:15 AM – 3:30 PM IST',
                            tags: const ['NSE', 'BSE', 'F&O'],
                            primaryColor: AppColors.primary,
                            onTap: () => context.go('/home'),
                          ),
                          const SizedBox(height: 20),
                          _PremiumMarketCard(
                            icon: Icons.currency_bitcoin_rounded,
                            title: 'Crypto Market',
                            description: 'Trade Bitcoin, Ethereum, and 200+ cryptocurrencies globally.',
                            hours: '24/7 – Always Open',
                            tags: const ['Spot', 'Futures', 'DeFi'],
                            primaryColor: const Color(0xFFF5A623),
                            onTap: () => context.go('/home'),
                          ),
                          const SizedBox(height: 20),
                          _PremiumMarketCard(
                            icon: Icons.public_rounded,
                            title: 'Forex & Global',
                            description: 'Access major currency pairs, commodities, and global indices.',
                            hours: 'Mon–Fri, 24 Hours',
                            tags: const ['USD/INR', 'Gold', 'Oil'],
                            primaryColor: const Color(0xFF10B981),
                            onTap: () => context.go('/home'),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumMarketCard extends StatefulWidget {
  const _PremiumMarketCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.hours,
    required this.tags,
    required this.primaryColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String hours;
  final List<String> tags;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  State<_PremiumMarketCard> createState() => _PremiumMarketCardState();
}

class _PremiumMarketCardState extends State<_PremiumMarketCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final cardBg = isDark ? AppColors.card(context) : Colors.white;
    final borderColor = isDark ? widget.primaryColor.withValues(alpha: 0.3) : AppColors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Interactive3DCard(
            maxTiltAngle: 0.1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: _isHovered && isDark
                    ? LinearGradient(
                        colors: [
                          widget.primaryColor.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? widget.primaryColor.withValues(alpha: 0.08)
                        : widget.primaryColor.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBg.withValues(alpha: isDark ? 0.7 : 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isHovered ? widget.primaryColor.withValues(alpha: 0.5) : borderColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(widget.icon, color: widget.primaryColor, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text1(context),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.schedule_rounded, size: 14, color: widget.primaryColor),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        widget.hours,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: widget.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.text2(context),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark 
                                        ? widget.primaryColor.withValues(alpha: 0.15)
                                        : widget.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: widget.primaryColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.primaryColor.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}
