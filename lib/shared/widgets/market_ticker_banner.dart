import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class MarketTickerBanner extends StatefulWidget {
  const MarketTickerBanner({super.key});

  @override
  State<MarketTickerBanner> createState() => _MarketTickerBannerState();
}

class _MarketTickerBannerState extends State<MarketTickerBanner> {
  late ScrollController _scrollController;
  bool _isAutoScrolling = true;

  final List<Map<String, dynamic>> _tickers = [
    {'symbol': 'NIFTY 50',  'price': '22,456.80', 'change': '+0.82%', 'up': true},
    {'symbol': 'SENSEX',    'price': '73,961.31', 'change': '+0.76%', 'up': true},
    {'symbol': 'RELIANCE',  'price': '2,934.55',  'change': '+1.24%', 'up': true},
    {'symbol': 'TCS',       'price': '4,012.80',  'change': '+0.87%', 'up': true},
    {'symbol': 'BTC/USDT',  'price': '\$67,234',  'change': '+2.11%', 'up': true},
    {'symbol': 'ETH/USDT',  'price': '\$3,521',   'change': '+1.87%', 'up': true},
    {'symbol': 'EUR/USD',   'price': '1.0842',    'change': '-0.12%', 'up': false},
    {'symbol': 'GOLD',      'price': '\$2,345',   'change': '+0.45%', 'up': true},
    {'symbol': 'INFY',      'price': '1,789.45',  'change': '-0.34%', 'up': false},
    {'symbol': 'HDFCBANK',  'price': '1,678.90',  'change': '+0.62%', 'up': true},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScroll());
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !_isAutoScrolling) continue;
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        if (current >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            current + 1.5,
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
    final isDark = AppColors.isDark(context);
    final bgColor = isDark ? AppColors.darkSurfaceAlt : AppColors.surfaceAlt;
    
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onPanDown: (_) => _isAutoScrolling = false,
            onPanCancel: () => _isAutoScrolling = true,
            onPanEnd: (_) => _isAutoScrolling = true,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    bgColor,
                    Colors.transparent,
                    Colors.transparent,
                    bgColor,
                  ],
                  stops: const [0.0, 0.05, 0.95, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstOut,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _tickers.length * 4,
                itemBuilder: (context, index) {
                  final ticker = _tickers[index % _tickers.length];
                  return _TickerItem(
                    symbol: ticker['symbol'] as String,
                    price: ticker['price'] as String,
                    change: ticker['change'] as String,
                    isUp: ticker['up'] as bool,
                  );
                },
              ),
            ),
          ),
        ],
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
  });

  final String symbol;
  final String price;
  final String change;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    final color = isUp ? AppColors.gainColor(context) : AppColors.lossColor(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            symbol,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.text1(context),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            price,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text2(context),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isUp ? AppColors.gainSurface(context) : AppColors.lossSurfaceColor(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              change,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
