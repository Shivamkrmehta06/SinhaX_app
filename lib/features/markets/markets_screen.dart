import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';

// ─────────────────────────────────────────────
//  Data Models
// ─────────────────────────────────────────────

class _IndexData {
  const _IndexData({
    required this.name,
    required this.value,
    required this.change,
    required this.changePct,
    required this.sparkline,
  });
  final String name;
  final String value;
  final String change;
  final double changePct;
  final List<double> sparkline;
}

class _StockData {
  const _StockData({
    required this.name,
    required this.ticker,
    required this.price,
    required this.changePct,
    required this.sparkline,
    this.tag = '',
  });
  final String name;
  final String ticker;
  final String price;
  final double changePct;
  final List<double> sparkline;
  final String tag;
}

class _ForexData {
  const _ForexData({
    required this.pair,
    required this.rate,
    required this.changePct,
    required this.flag1,
    required this.flag2,
    required this.sparkline,
  });
  final String pair;
  final String rate;
  final double changePct;
  final String flag1;
  final String flag2;
  final List<double> sparkline;
}

class _CommodityData {
  const _CommodityData({
    required this.name,
    required this.price,
    required this.changePct,
    required this.icon,
    required this.sparkline,
  });
  final String name;
  final String price;
  final double changePct;
  final IconData icon;
  final List<double> sparkline;
}

// ─────────────────────────────────────────────
//  Static Market Data
// ─────────────────────────────────────────────

const _niftySparkline = [22100.0, 22200.0, 22150.0, 22300.0, 22250.0, 22400.0, 22380.0, 22456.0];
const _sensexSparkline = [73200.0, 73400.0, 73350.0, 73600.0, 73500.0, 73800.0, 73900.0, 73961.0];
const _bankniftySparkline = [48200.0, 48100.0, 47950.0, 47900.0, 47850.0, 47800.0, 47840.0, 47832.0];
const _niftyItSparkline = [31800.0, 32000.0, 32100.0, 32200.0, 32300.0, 32400.0, 32440.0, 32456.0];

const List<_IndexData> _indices = [
  _IndexData(name: 'NIFTY 50', value: '22,456.80', change: '+182.40', changePct: 0.82, sparkline: _niftySparkline),
  _IndexData(name: 'SENSEX', value: '73,961.00', change: '+556.71', changePct: 0.76, sparkline: _sensexSparkline),
  _IndexData(name: 'BANKNIFTY', value: '47,832.00', change: '-163.45', changePct: -0.34, sparkline: _bankniftySparkline),
  _IndexData(name: 'NIFTY IT', value: '32,456.00', change: '+394.23', changePct: 1.23, sparkline: _niftyItSparkline),
];

const _relSparkline = [2850.0, 2870.0, 2890.0, 2910.0, 2905.0, 2920.0, 2928.0, 2934.0];
const _tcsSparkline = [3900.0, 3930.0, 3960.0, 3980.0, 3995.0, 4005.0, 4010.0, 4012.0];
const _hdfcSparkline = [1720.0, 1710.0, 1700.0, 1695.0, 1688.0, 1682.0, 1679.0, 1678.0];
const _infySparkline = [1750.0, 1760.0, 1768.0, 1774.0, 1780.0, 1784.0, 1788.0, 1789.0];

const List<_StockData> _topMovers = [
  _StockData(name: 'Reliance Ind.', ticker: 'RELIANCE', price: '₹2,934', changePct: 1.2, sparkline: _relSparkline, tag: 'Energy'),
  _StockData(name: 'Tata Consult.', ticker: 'TCS', price: '₹4,012', changePct: 2.4, sparkline: _tcsSparkline, tag: 'IT'),
  _StockData(name: 'HDFC Bank', ticker: 'HDFC', price: '₹1,678', changePct: -0.8, sparkline: _hdfcSparkline, tag: 'Banking'),
  _StockData(name: 'Infosys', ticker: 'INFY', price: '₹1,789', changePct: 0.95, sparkline: _infySparkline, tag: 'IT'),
];

const _trendingStocks = [
  _StockData(name: 'Adani Ports', ticker: 'ADANIPORTS', price: '₹1,342', changePct: 3.12, sparkline: [1280.0, 1295.0, 1310.0, 1320.0, 1330.0, 1336.0, 1340.0, 1342.0]),
  _StockData(name: 'Sun Pharma', ticker: 'SUNPHARMA', price: '₹1,587', changePct: -1.45, sparkline: [1620.0, 1612.0, 1605.0, 1598.0, 1594.0, 1590.0, 1588.0, 1587.0]),
  _StockData(name: 'Bajaj Finance', ticker: 'BAJFINANCE', price: '₹7,234', changePct: 0.67, sparkline: [7180.0, 7190.0, 7200.0, 7210.0, 7220.0, 7228.0, 7232.0, 7234.0]),
  _StockData(name: 'Maruti Suzuki', ticker: 'MARUTI', price: '₹12,456', changePct: -0.23, sparkline: [12480.0, 12470.0, 12465.0, 12462.0, 12459.0, 12457.0, 12456.0, 12456.0]),
  _StockData(name: 'Asian Paints', ticker: 'ASIANPAINT', price: '₹2,876', changePct: 1.89, sparkline: [2820.0, 2835.0, 2845.0, 2855.0, 2862.0, 2868.0, 2873.0, 2876.0]),
];

// Crypto
const _btcSparkline = [64000.0, 65000.0, 64500.0, 66000.0, 65800.0, 66500.0, 67000.0, 67234.0];
const _ethSparkline = [3400.0, 3430.0, 3450.0, 3480.0, 3490.0, 3505.0, 3515.0, 3521.0];
const _bnbSparkline = [408.0, 409.0, 410.0, 411.0, 410.5, 411.5, 412.0, 412.0];
const _solSparkline = [165.0, 168.0, 170.0, 172.0, 174.0, 175.0, 177.0, 178.0];

const List<_StockData> _cryptoPairs = [
  _StockData(name: 'Bitcoin', ticker: 'BTC/USDT', price: '\$67,234', changePct: 2.1, sparkline: _btcSparkline, tag: 'Layer-1'),
  _StockData(name: 'Ethereum', ticker: 'ETH/USDT', price: '\$3,521', changePct: 1.87, sparkline: _ethSparkline, tag: 'Layer-1'),
  _StockData(name: 'BNB', ticker: 'BNB/USDT', price: '\$412', changePct: 0.54, sparkline: _bnbSparkline, tag: 'Exchange'),
  _StockData(name: 'Solana', ticker: 'SOL/USDT', price: '\$178', changePct: 3.2, sparkline: _solSparkline, tag: 'Layer-1'),
];

const List<_StockData> _cryptoGainers = [
  _StockData(name: 'Avalanche', ticker: 'AVAX/USDT', price: '\$38.4', changePct: 8.12, sparkline: [33.0, 34.0, 35.0, 36.0, 37.0, 37.8, 38.2, 38.4], tag: 'DeFi'),
  _StockData(name: 'Chainlink', ticker: 'LINK/USDT', price: '\$18.76', changePct: 5.67, sparkline: [17.5, 17.7, 17.9, 18.1, 18.3, 18.5, 18.65, 18.76], tag: 'Oracle'),
  _StockData(name: 'Polkadot', ticker: 'DOT/USDT', price: '\$8.23', changePct: 4.45, sparkline: [7.6, 7.7, 7.8, 7.9, 8.0, 8.1, 8.18, 8.23], tag: 'Layer-0'),
  _StockData(name: 'Uniswap', ticker: 'UNI/USDT', price: '\$11.45', changePct: 3.91, sparkline: [10.8, 10.9, 11.0, 11.1, 11.2, 11.3, 11.4, 11.45], tag: 'DeFi'),
];

// Forex
const List<_ForexData> _forexPairs = [
  _ForexData(pair: 'EUR/USD', rate: '1.0842', changePct: -0.12, flag1: '🇪🇺', flag2: '🇺🇸', sparkline: [1.0862, 1.0858, 1.0855, 1.0850, 1.0848, 1.0845, 1.0843, 1.0842]),
  _ForexData(pair: 'GBP/USD', rate: '1.2734', changePct: 0.08, flag1: '🇬🇧', flag2: '🇺🇸', sparkline: [1.2720, 1.2724, 1.2726, 1.2728, 1.2730, 1.2731, 1.2733, 1.2734]),
  _ForexData(pair: 'USD/JPY', rate: '149.32', changePct: 0.31, flag1: '🇺🇸', flag2: '🇯🇵', sparkline: [148.80, 148.95, 149.00, 149.10, 149.18, 149.24, 149.29, 149.32]),
  _ForexData(pair: 'AUD/USD', rate: '0.6521', changePct: -0.19, flag1: '🇦🇺', flag2: '🇺🇸', sparkline: [0.6535, 0.6531, 0.6528, 0.6526, 0.6524, 0.6523, 0.6522, 0.6521]),
];

const List<_CommodityData> _commodities = [
  _CommodityData(name: 'Gold', price: '\$2,345/oz', changePct: 0.45, icon: Icons.brightness_7_rounded, sparkline: [2330.0, 2335.0, 2338.0, 2340.0, 2341.0, 2342.0, 2344.0, 2345.0]),
  _CommodityData(name: 'Silver', price: '\$29.4/oz', changePct: 0.8, icon: Icons.circle_outlined, sparkline: [29.0, 29.1, 29.15, 29.2, 29.25, 29.3, 29.36, 29.4]),
  _CommodityData(name: 'Crude Oil', price: '\$78.2/bbl', changePct: -0.6, icon: Icons.local_gas_station_rounded, sparkline: [78.8, 78.7, 78.6, 78.5, 78.4, 78.3, 78.25, 78.2]),
];

// ─────────────────────────────────────────────
//  MarketsScreen
// ─────────────────────────────────────────────

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _IndianMarketTab(),
                _CryptoMarketTab(),
                _ForexMarketTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Text(
        'Markets',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary, size: 24),
          tooltip: 'Search',
        ),
        IconButton(
          onPressed: () {},
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 18),
          ),
          tooltip: 'Filter',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Indian Market'),
          Tab(text: 'Crypto Market'),
          Tab(text: 'Forex Market'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Indian Market Tab
// ─────────────────────────────────────────────

class _IndianMarketTab extends StatelessWidget {
  const _IndianMarketTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _MarketBanner(
          title: 'NSE/BSE Equities',
          subtitle: 'Total Traded Value · ₹58,432 Cr',
          statusLabel: 'Market Open',
          statusType: StatusType.success,
          gradientColors: AppColors.heroGradient,
          icon: Icons.trending_up_rounded,
          stats: const [
            _BannerStat(label: 'Advances', value: '1,842'),
            _BannerStat(label: 'Declines', value: '867'),
            _BannerStat(label: 'Unchanged', value: '123'),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Indices',
          actionLabel: 'View All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 136,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _indices.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) =>
                _IndexCard(data: _indices[index]),
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Top Movers',
          actionLabel: 'See All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
          ),
          itemCount: _topMovers.length,
          itemBuilder: (context, index) =>
              _StockGridCard(data: _topMovers[index]),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Trending',
          actionLabel: 'See All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        ...List.generate(_trendingStocks.length, (i) {
          final stock = _trendingStocks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _StockListTile(data: stock, rank: i + 1),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Crypto Market Tab
// ─────────────────────────────────────────────

class _CryptoMarketTab extends StatelessWidget {
  const _CryptoMarketTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _MarketBanner(
          title: 'Crypto Markets',
          subtitle: 'Global Market Cap · \$2.41 Trillion',
          statusLabel: '24/7 Live',
          statusType: StatusType.info,
          gradientColors: const [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF3B82F6)],
          icon: Icons.currency_bitcoin_rounded,
          stats: const [
            _BannerStat(label: 'BTC Dom.', value: '52.4%'),
            _BannerStat(label: 'Vol 24h', value: '\$89.2B'),
            _BannerStat(label: 'Fear Index', value: '68 Greed'),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Major Pairs',
          actionLabel: 'View All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 156,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cryptoPairs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) =>
                _CryptoHorizontalCard(data: _cryptoPairs[index]),
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Top Gainers',
          actionLabel: 'See All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
          ),
          itemCount: _cryptoGainers.length,
          itemBuilder: (context, index) =>
              _StockGridCard(data: _cryptoGainers[index]),
        ),
        const SizedBox(height: 24),
        _CryptoMarketSentiment(),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Forex Market Tab
// ─────────────────────────────────────────────

class _ForexMarketTab extends StatelessWidget {
  const _ForexMarketTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _MarketBanner(
          title: 'Forex Markets',
          subtitle: 'Daily Volume · \$7.5 Trillion',
          statusLabel: 'NY Session',
          statusType: StatusType.warning,
          gradientColors: const [Color(0xFF1E40AF), Color(0xFF0369A1), Color(0xFF0284C7)],
          icon: Icons.language_rounded,
          stats: const [
            _BannerStat(label: 'USD Index', value: '104.32'),
            _BannerStat(label: 'Volatility', value: 'Low'),
            _BannerStat(label: 'Session', value: 'NY Open'),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Major Pairs',
          actionLabel: 'View All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        ...List.generate(_forexPairs.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ForexListTile(data: _forexPairs[i]),
          );
        }),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Commodities',
          actionLabel: 'See All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        ...List.generate(_commodities.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _CommodityListTile(data: _commodities[i]),
          );
        }),
        const SizedBox(height: 24),
        _ForexHeatmapCard(),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Shared Widgets
// ─────────────────────────────────────────────

class _BannerStat {
  const _BannerStat({required this.label, required this.value});
  final String label;
  final String value;
}

class _MarketBanner extends StatelessWidget {
  const _MarketBanner({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusType,
    required this.gradientColors,
    required this.icon,
    required this.stats,
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final StatusType statusType;
  final List<Color> gradientColors;
  final IconData icon;
  final List<_BannerStat> stats;

  Color get _statusBg {
    return switch (statusType) {
      StatusType.success => const Color(0xFF16A34A),
      StatusType.info => const Color(0xFF1E40AF),
      StatusType.warning => const Color(0xFFB45309),
      _ => const Color(0xFF374151),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circle decoration
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            statusLabel,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: stats.map((s) => _BannerStatWidget(stat: s)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerStatWidget extends StatelessWidget {
  const _BannerStatWidget({required this.stat});
  final _BannerStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

// ── Index Horizontal Card ──────────────────────

class _IndexCard extends StatelessWidget {
  const _IndexCard({required this.data});
  final _IndexData data;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      elevation: 1,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: changeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              data.value,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.change,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: changeColor,
              ),
            ),
            const Spacer(),
            MiniSparkline(
              data: data.sparkline,
              positive: isPositive,
              width: double.infinity,
              height: 30,
              strokeWidth: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stock 2-column Grid Card ───────────────────

class _StockGridCard extends StatelessWidget {
  const _StockGridCard({required this.data});
  final _StockData data;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    return SinhaXCard(
      padding: const EdgeInsets.all(12),
      elevation: 1,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    data.ticker.substring(0, data.ticker.length > 2 ? 2 : data.ticker.length),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              MiniSparkline(
                data: data.sparkline,
                positive: isPositive,
                width: 52,
                height: 28,
                strokeWidth: 1.5,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.ticker,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            data.name,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.price,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
          if (data.tag.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                data.tag,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Trending Stock List Tile ───────────────────

class _StockListTile extends StatelessWidget {
  const _StockListTile({required this.data, required this.rank});
  final _StockData data;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    return SinhaXCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      elevation: 1,
      onTap: () {},
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.primarySurface : AppColors.divider,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: rank <= 3 ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name & ticker
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.ticker,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Sparkline
          MiniSparkline(
            data: data.sparkline,
            positive: isPositive,
            width: 56,
            height: 30,
          ),
          const SizedBox(width: 12),
          // Price & change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.price,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Crypto Horizontal Card ─────────────────────

class _CryptoHorizontalCard extends StatelessWidget {
  const _CryptoHorizontalCard({required this.data});
  final _StockData data;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    // Crypto icon colors
    final iconColors = {
      'BTC/USDT': const Color(0xFFF7931A),
      'ETH/USDT': const Color(0xFF627EEA),
      'BNB/USDT': const Color(0xFFF3BA2F),
      'SOL/USDT': const Color(0xFF9945FF),
    };
    final iconColor = iconColors[data.ticker] ?? AppColors.primary;

    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      elevation: 1,
      child: SizedBox(
        width: 152,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      data.ticker.split('/').first.substring(0, data.ticker.split('/').first.length > 3 ? 3 : data.ticker.split('/').first.length),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: changeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              data.ticker,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              data.price,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            MiniSparkline(
              data: data.sparkline,
              positive: isPositive,
              width: double.infinity,
              height: 24,
              strokeWidth: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Crypto Market Sentiment Card ───────────────

class _CryptoMarketSentiment extends StatelessWidget {
  const _CryptoMarketSentiment();

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Market Sentiment',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              StatusChip(label: 'Greed', type: StatusType.warning),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SentimentBar(label: 'Fear', value: 0.32, color: AppColors.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SentimentBar(label: 'Greed', value: 0.68, color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SentimentStat(label: 'Fear & Greed Index', value: '68'),
              _SentimentStat(label: 'Yesterday', value: '64'),
              _SentimentStat(label: 'Last Week', value: '55'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentBar extends StatelessWidget {
  const _SentimentBar({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _SentimentStat extends StatelessWidget {
  const _SentimentStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Forex List Tile ────────────────────────────

class _ForexListTile extends StatelessWidget {
  const _ForexListTile({required this.data});
  final _ForexData data;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    return SinhaXCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      elevation: 1,
      onTap: () {},
      child: Row(
        children: [
          // Flag pair
          Row(
            children: [
              Text(data.flag1, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 4),
              Text(data.flag2, style: const TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.pair,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPositive ? 'Bullish trend' : 'Bearish trend',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: changeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          MiniSparkline(
            data: data.sparkline,
            positive: isPositive,
            width: 56,
            height: 30,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.rate,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Commodity List Tile ────────────────────────

class _CommodityListTile extends StatelessWidget {
  const _CommodityListTile({required this.data});
  final _CommodityData data;

  @override
  Widget build(BuildContext context) {
    final isPositive = data.changePct >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final changeBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;

    final iconColor = switch (data.name) {
      'Gold' => const Color(0xFFD97706),
      'Silver' => const Color(0xFF64748B),
      _ => const Color(0xFF374151),
    };

    return SinhaXCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      elevation: 1,
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPositive ? 'Bullish' : 'Bearish',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: changeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          MiniSparkline(
            data: data.sparkline,
            positive: isPositive,
            width: 56,
            height: 30,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.price,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${data.changePct.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Forex Heatmap Card ─────────────────────────

class _ForexHeatmapCard extends StatelessWidget {
  const _ForexHeatmapCard();

  static const _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD'];

  static const _matrix = [
    // USD  EUR   GBP   JPY   AUD   CAD
    [0.00, -0.12, 0.04, 0.31, -0.19, 0.08],   // USD
    [0.12, 0.00, 0.16, 0.43, -0.07, 0.20],    // EUR
    [-0.04, -0.16, 0.00, 0.27, -0.23, 0.04],  // GBP
    [-0.31, -0.43, -0.27, 0.00, -0.50, -0.23], // JPY
    [0.19, 0.07, 0.23, 0.50, 0.00, 0.27],     // AUD
    [-0.08, -0.20, -0.04, 0.23, -0.27, 0.00], // CAD
  ];

  Color _cellColor(double val) {
    if (val == 0.00) return AppColors.divider;
    if (val > 0.3) return AppColors.success.withValues(alpha: 0.8);
    if (val > 0.1) return AppColors.success.withValues(alpha: 0.45);
    if (val > 0) return AppColors.success.withValues(alpha: 0.2);
    if (val < -0.3) return AppColors.error.withValues(alpha: 0.8);
    if (val < -0.1) return AppColors.error.withValues(alpha: 0.45);
    return AppColors.error.withValues(alpha: 0.2);
  }

  Color _textColor(double val) {
    if (val == 0.00) return AppColors.textTertiary;
    if (val.abs() > 0.3) return Colors.white;
    return val > 0 ? AppColors.success : AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Currency Heatmap',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const StatusChip(label: 'Live', type: StatusType.success, compact: true),
            ],
          ),
          const SizedBox(height: 14),
          // Header row
          Row(
            children: [
              const SizedBox(width: 36),
              ..._currencies.map(
                (c) => Expanded(
                  child: Center(
                    child: Text(
                      c,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Grid rows
          ...List.generate(_currencies.length, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      _currencies[row],
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ...List.generate(_currencies.length, (col) {
                    final val = _matrix[row][col];
                    return Expanded(
                      child: Container(
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: _cellColor(val),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: val == 0.00
                              ? null
                              : Text(
                                  '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w700,
                                    color: _textColor(val),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
