import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class MarketTickerBanner extends StatefulWidget {
  const MarketTickerBanner({super.key, this.onDark = false});
  final bool onDark;

  @override
  State<MarketTickerBanner> createState() => _MarketTickerBannerState();
}

class _MarketTickerBannerState extends State<MarketTickerBanner>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  final List<Map<String, dynamic>> _tickers = [
    {'symbol': 'NIFTY 50', 'price': '22,456.80', 'change': '+0.82%', 'up': true},
    {'symbol': 'SENSEX', 'price': '73,961.31', 'change': '+0.76%', 'up': true},
    {'symbol': 'RELIANCE', 'price': '2,934.55', 'change': '-0.34%', 'up': false},
    {'symbol': 'TCS', 'price': '4,012.80', 'change': '+1.24%', 'up': true},
    {'symbol': 'BTC/USDT', 'price': '\$67,234', 'change': '+2.11%', 'up': true},
    {'symbol': 'ETH/USDT', 'price': '\$3,521', 'change': '+1.87%', 'up': true},
    {'symbol': 'EUR/USD', 'price': '1.0842', 'change': '-0.12%', 'up': false},
    {'symbol': 'GOLD', 'price': '\$2,345', 'change': '+0.45%', 'up': true},
    {'symbol': 'INFY', 'price': '1,789.45', 'change': '+0.95%', 'up': true},
    {'symbol': 'HDFC', 'price': '1,678.90', 'change': '-0.21%', 'up': false},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScroll();
    });
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) break;
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        if (current >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            current + 1,
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.onDark;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
          bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tickers.length * 4, // repeat items
        itemBuilder: (context, index) {
          final ticker = _tickers[index % _tickers.length];
          return _TickerItem(
            symbol: ticker['symbol'] as String,
            price: ticker['price'] as String,
            change: ticker['change'] as String,
            isUp: ticker['up'] as bool,
            onDark: isDark,
          );
        },
      ),
    );
  }
}

class _TickerItem extends StatelessWidget {
  const _TickerItem({
    required this.symbol,
    required this.price,
    required this.change,
    required this.isUp,
    required this.onDark,
  });

  final String symbol;
  final String price;
  final String change;
  final bool isUp;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final changeColor = isUp ? AppColors.success : AppColors.error;
    final textColor = onDark ? AppColors.white : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            symbol,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            price,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: onDark ? AppColors.white.withValues(alpha: 0.85) : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            change,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: changeColor,
            ),
          ),
          Container(
            width: 1,
            height: 16,
            margin: const EdgeInsets.only(left: 12),
            color: onDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border,
          ),
        ],
      ),
    );
  }
}
