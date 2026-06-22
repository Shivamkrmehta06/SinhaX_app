import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';

// ---------------------------------------------------------------------------
// Data Models
// ---------------------------------------------------------------------------

class _Holding {
  const _Holding({
    required this.symbol,
    required this.company,
    required this.qty,
    required this.avgPrice,
    required this.cmp,
    required this.pnl,
    required this.pnlPct,
    required this.sparkline,
    required this.avatarColor,
  });

  final String symbol;
  final String company;
  final int qty;
  final double avgPrice;
  final double cmp;
  final double pnl;
  final double pnlPct;
  final List<double> sparkline;
  final Color avatarColor;
}

class _Position {
  const _Position({
    required this.symbol,
    required this.type,
    required this.qty,
    required this.entryPrice,
    required this.ltp,
    required this.pnl,
    required this.isPositive,
    required this.avatarColor,
  });

  final String symbol;
  final String type;
  final int qty;
  final double entryPrice;
  final double ltp;
  final double pnl;
  final bool isPositive;
  final Color avatarColor;
}

class _Trade {
  const _Trade({
    required this.symbol,
    required this.action,
    required this.qty,
    required this.price,
    required this.date,
    required this.total,
    required this.isBuy,
  });

  final String symbol;
  final String action;
  final int qty;
  final double price;
  final String date;
  final double total;
  final bool isBuy;
}

// ---------------------------------------------------------------------------
// Sample Data per Tab
// ---------------------------------------------------------------------------

final Map<String, List<_Holding>> _tabHoldings = {
  'Stocks': [
    _Holding(
      symbol: 'RELIANCE',
      company: 'Reliance Industries',
      qty: 25,
      avgPrice: 2745,
      cmp: 2934,
      pnl: 4725,
      pnlPct: 6.88,
      sparkline: [2700, 2720, 2695, 2760, 2810, 2880, 2934],
      avatarColor: const Color(0xFF2563EB),
    ),
    _Holding(
      symbol: 'INFY',
      company: 'Infosys Limited',
      qty: 40,
      avgPrice: 1480,
      cmp: 1562,
      pnl: 3280,
      pnlPct: 5.54,
      sparkline: [1470, 1495, 1488, 1510, 1530, 1548, 1562],
      avatarColor: const Color(0xFF059669),
    ),
    _Holding(
      symbol: 'HDFCBANK',
      company: 'HDFC Bank Ltd',
      qty: 15,
      avgPrice: 1620,
      cmp: 1589,
      pnl: -465,
      pnlPct: -1.91,
      sparkline: [1640, 1625, 1610, 1630, 1600, 1595, 1589],
      avatarColor: const Color(0xFFDC2626),
    ),
  ],
  'Options': [
    _Holding(
      symbol: 'NIFTY 24500 CE',
      company: 'NIFTY Call Option Jun\'25',
      qty: 50,
      avgPrice: 185,
      cmp: 243,
      pnl: 2900,
      pnlPct: 31.35,
      sparkline: [180, 192, 175, 210, 225, 238, 243],
      avatarColor: const Color(0xFF7C3AED),
    ),
    _Holding(
      symbol: 'BANKNIFTY 52000 PE',
      company: 'BankNifty Put Option Jun\'25',
      qty: 25,
      avgPrice: 320,
      cmp: 275,
      pnl: -1125,
      pnlPct: -14.06,
      sparkline: [330, 315, 308, 290, 280, 272, 275],
      avatarColor: const Color(0xFFEA580C),
    ),
    _Holding(
      symbol: 'RELIANCE 3000 CE',
      company: 'Reliance Call Option Jun\'25',
      qty: 10,
      avgPrice: 62,
      cmp: 88,
      pnl: 260,
      pnlPct: 41.94,
      sparkline: [58, 63, 55, 70, 79, 84, 88],
      avatarColor: const Color(0xFF2563EB),
    ),
  ],
  'Crypto': [
    _Holding(
      symbol: 'BTC',
      company: 'Bitcoin',
      qty: 1,
      avgPrice: 5420000,
      cmp: 5948000,
      pnl: 528000,
      pnlPct: 9.74,
      sparkline: [5400000, 5350000, 5480000, 5600000, 5720000, 5880000, 5948000],
      avatarColor: const Color(0xFFF59E0B),
    ),
    _Holding(
      symbol: 'ETH',
      company: 'Ethereum',
      qty: 5,
      avgPrice: 280000,
      cmp: 312000,
      pnl: 160000,
      pnlPct: 11.43,
      sparkline: [275000, 268000, 282000, 295000, 305000, 308000, 312000],
      avatarColor: const Color(0xFF6366F1),
    ),
    _Holding(
      symbol: 'SOL',
      company: 'Solana',
      qty: 20,
      avgPrice: 12800,
      cmp: 11950,
      pnl: -17000,
      pnlPct: -6.64,
      sparkline: [13200, 12900, 12500, 12200, 12000, 11850, 11950],
      avatarColor: const Color(0xFF14B8A6),
    ),
  ],
  'Forex': [
    _Holding(
      symbol: 'USD/INR',
      company: 'US Dollar / Indian Rupee',
      qty: 10000,
      avgPrice: 83.25,
      cmp: 84.10,
      pnl: 8500,
      pnlPct: 1.02,
      sparkline: [83.1, 83.3, 83.5, 83.8, 83.9, 84.0, 84.10],
      avatarColor: const Color(0xFF2563EB),
    ),
    _Holding(
      symbol: 'EUR/INR',
      company: 'Euro / Indian Rupee',
      qty: 5000,
      avgPrice: 91.50,
      cmp: 90.80,
      pnl: -3500,
      pnlPct: -0.77,
      sparkline: [91.8, 91.6, 91.4, 91.1, 90.9, 90.75, 90.80],
      avatarColor: const Color(0xFF059669),
    ),
    _Holding(
      symbol: 'GBP/INR',
      company: 'British Pound / Indian Rupee',
      qty: 3000,
      avgPrice: 105.40,
      cmp: 107.20,
      pnl: 5400,
      pnlPct: 1.71,
      sparkline: [104.8, 105.2, 105.6, 106.1, 106.5, 107.0, 107.20],
      avatarColor: const Color(0xFF7C3AED),
    ),
  ],
};

final Map<String, List<_Position>> _tabPositions = {
  'Stocks': [
    _Position(
      symbol: 'TCS',
      type: 'Long Intraday',
      qty: 10,
      entryPrice: 3820,
      ltp: 3875,
      pnl: 550,
      isPositive: true,
      avatarColor: const Color(0xFF059669),
    ),
    _Position(
      symbol: 'WIPRO',
      type: 'Short Intraday',
      qty: 30,
      entryPrice: 498,
      ltp: 493,
      pnl: 150,
      isPositive: true,
      avatarColor: const Color(0xFF7C3AED),
    ),
  ],
  'Options': [
    _Position(
      symbol: 'NIFTY 24400 PE',
      type: 'Long Option',
      qty: 75,
      entryPrice: 142,
      ltp: 178,
      pnl: 2700,
      isPositive: true,
      avatarColor: const Color(0xFF2563EB),
    ),
    _Position(
      symbol: 'BANKNIFTY 51500 CE',
      type: 'Short Option',
      qty: 50,
      entryPrice: 285,
      ltp: 310,
      pnl: -1250,
      isPositive: false,
      avatarColor: const Color(0xFFDC2626),
    ),
  ],
  'Crypto': [
    _Position(
      symbol: 'BTC/USDT',
      type: 'Long Futures',
      qty: 2,
      entryPrice: 5880000,
      ltp: 5948000,
      pnl: 136000,
      isPositive: true,
      avatarColor: const Color(0xFFF59E0B),
    ),
    _Position(
      symbol: 'ETH/USDT',
      type: 'Short Futures',
      qty: 10,
      entryPrice: 315000,
      ltp: 312000,
      pnl: 30000,
      isPositive: true,
      avatarColor: const Color(0xFF6366F1),
    ),
  ],
  'Forex': [
    _Position(
      symbol: 'USD/INR',
      type: 'Long Spot',
      qty: 5000,
      entryPrice: 83.90,
      ltp: 84.10,
      pnl: 1000,
      isPositive: true,
      avatarColor: const Color(0xFF2563EB),
    ),
    _Position(
      symbol: 'EUR/USD',
      type: 'Short Spot',
      qty: 3000,
      entryPrice: 1.085,
      ltp: 1.082,
      pnl: 900,
      isPositive: true,
      avatarColor: const Color(0xFF059669),
    ),
  ],
};

final Map<String, List<_Trade>> _tabTrades = {
  'Stocks': [
    _Trade(symbol: 'ICICIBANK', action: 'BUY', qty: 20, price: 1124, date: 'Today, 10:32 AM', total: 22480, isBuy: true),
    _Trade(symbol: 'RELIANCE', action: 'SELL', qty: 5, price: 2920, date: 'Today, 09:48 AM', total: 14600, isBuy: false),
    _Trade(symbol: 'SBIN', action: 'BUY', qty: 50, price: 812, date: 'Yesterday, 3:15 PM', total: 40600, isBuy: true),
  ],
  'Options': [
    _Trade(symbol: 'NIFTY 24500 CE', action: 'BUY', qty: 50, price: 185, date: 'Today, 09:20 AM', total: 9250, isBuy: true),
    _Trade(symbol: 'BANKNIFTY 52500 PE', action: 'SELL', qty: 25, price: 410, date: 'Today, 11:05 AM', total: 10250, isBuy: false),
    _Trade(symbol: 'RELIANCE 2900 CE', action: 'BUY', qty: 10, price: 95, date: 'Yesterday, 2:45 PM', total: 950, isBuy: true),
  ],
  'Crypto': [
    _Trade(symbol: 'BTC', action: 'BUY', qty: 1, price: 5420000, date: 'Today, 08:15 AM', total: 5420000, isBuy: true),
    _Trade(symbol: 'ETH', action: 'SELL', qty: 2, price: 318000, date: 'Yesterday, 06:30 PM', total: 636000, isBuy: false),
    _Trade(symbol: 'SOL', action: 'BUY', qty: 20, price: 12800, date: 'Jun 14, 11:00 AM', total: 256000, isBuy: true),
  ],
  'Forex': [
    _Trade(symbol: 'USD/INR', action: 'BUY', qty: 10000, price: 83.25, date: 'Today, 10:00 AM', total: 832500, isBuy: true),
    _Trade(symbol: 'EUR/INR', action: 'SELL', qty: 2500, price: 91.80, date: 'Today, 09:15 AM', total: 229500, isBuy: false),
    _Trade(symbol: 'GBP/INR', action: 'BUY', qty: 3000, price: 105.40, date: 'Yesterday, 4:00 PM', total: 316200, isBuy: true),
  ],
};

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _tabs = ['Stocks', 'Options', 'Crypto', 'Forex'];

  static const List<double> _pnlData = [2400, -1200, 3800, 1600, -800, 4200, 2800];
  static const List<String> _pnlLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: _buildTabBar(),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) => _TabContent(tabKey: tab)).toList(),
        ),
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Text(
        'Portfolio',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary, size: 22),
          onPressed: () {},
          tooltip: 'Export Report',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  // ── Header (above tabs) ───────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary gradient banner
          _buildSummaryBanner(),
          const SizedBox(height: 16),
          // Stats row
          _buildStatsRow(),
          const SizedBox(height: 20),
          // 7-Day P&L Chart
          _buildPnlChart(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner() {
    return GradientCard(
      gradientColors: const [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: label + timestamp chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Portfolio Value',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: 0.75),
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.white.withValues(alpha: 0.8)),
                    const SizedBox(width: 4),
                    Text(
                      'As of 3:30 PM IST',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Main value
          Text(
            '₹24,85,340',
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 10),
          // Today's change row
          Row(
            children: [
              // Absolute change chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded,
                        size: 13, color: Color(0xFF86EFAC)),
                    const SizedBox(width: 4),
                    Text(
                      '+₹1,24,560 Today',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF86EFAC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // % badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+5.27%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF86EFAC),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Divider line
          Container(height: 1, color: AppColors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 14),
          // Bottom quick stats row
          Row(
            children: [
              _bannerStat('Day High', '₹25,12,880'),
              _bannerDivider(),
              _bannerStat('Day Low', '₹24,08,420'),
              _bannerDivider(),
              _bannerStat('P&L MTD', '+₹3,18,240'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.white.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'INVESTED',
            value: '₹20,42,800',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.primary,
            compact: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'RETURNS',
            value: '₹4,42,540',
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.success,
            valueColor: AppColors.success,
            trend: '+21.7%',
            trendPositive: true,
            compact: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'XIRR',
            value: '21.7%',
            icon: Icons.speed_rounded,
            iconColor: const Color(0xFF7C3AED),
            valueColor: const Color(0xFF7C3AED),
            subValue: 'Annualised',
            compact: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPnlChart() {
    return SinhaXCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7-Day P&L',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Weekly profit & loss performance',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded,
                        size: 12, color: AppColors.success),
                    const SizedBox(width: 3),
                    Text(
                      '₹12,800 Net',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BarChartWidget(
            data: _pnlData,
            height: 120,
            labels: _pnlLabels,
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.border,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabs
            .map((t) => Tab(text: t, height: 44))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky Tab Bar Delegate
// ---------------------------------------------------------------------------

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.child});
  final Widget child;

  @override
  double get minExtent => 46.5;

  @override
  double get maxExtent => 46.5;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Tab Content
// ---------------------------------------------------------------------------

class _TabContent extends StatelessWidget {
  const _TabContent({required this.tabKey});

  final String tabKey;

  @override
  Widget build(BuildContext context) {
    final holdings = _tabHoldings[tabKey] ?? [];
    final positions = _tabPositions[tabKey] ?? [];
    final trades = _tabTrades[tabKey] ?? [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // Holdings section
        SectionHeader(
          title: 'Holdings',
          actionLabel: 'View All',
          onAction: () {},
          subtitle: '${holdings.length} positions',
        ),
        const SizedBox(height: 12),
        SinhaXCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: holdings.asMap().entries.map((e) {
              return Column(
                children: [
                  _HoldingTile(holding: e.value),
                  if (e.key < holdings.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Open Positions section
        SectionHeader(
          title: 'Open Positions',
          actionLabel: 'Manage',
          onAction: () {},
          subtitle: '${positions.length} live positions',
        ),
        const SizedBox(height: 12),
        ...positions.map((pos) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PositionCard(position: pos),
            )),

        const SizedBox(height: 14),

        // Trade History section
        SectionHeader(
          title: 'Trade History',
          actionLabel: 'Full History',
          onAction: () {},
          subtitle: 'Recent transactions',
        ),
        const SizedBox(height: 12),
        SinhaXCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: trades.asMap().entries.map((e) {
              return Column(
                children: [
                  _TradeRow(trade: e.value),
                  if (e.key < trades.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Holding Tile
// ---------------------------------------------------------------------------

class _HoldingTile extends StatelessWidget {
  const _HoldingTile({required this.holding});

  final _Holding holding;

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.pnl >= 0;
    final pnlColor = isPositive ? AppColors.success : AppColors.error;
    final pnlBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;
    final pnlPrefix = isPositive ? '+' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: holding.avatarColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: holding.avatarColor.withValues(alpha: 0.2)),
            ),
            alignment: Alignment.center,
            child: Text(
              holding.symbol[0],
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: holding.avatarColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Symbol + company
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        holding.symbol,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusChip(
                      label: 'Qty: ${holding.qty}',
                      type: StatusType.neutral,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  holding.company,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _microLabel('Avg', _formatPrice(holding.avgPrice)),
                    const SizedBox(width: 10),
                    _microLabel('CMP', _formatPrice(holding.cmp)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Sparkline + P&L
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MiniSparkline(
                data: holding.sparkline,
                positive: isPositive,
                width: 60,
                height: 32,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pnlBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pnlPrefix₹${_formatCompact(holding.pnl.abs())}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: pnlColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      '$pnlPrefix${holding.pnlPct.toStringAsFixed(2)}%',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: pnlColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _microLabel(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)}L';
    } else if (price >= 1000) {
      return '₹${price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+$)'),
            (m) => '${m[1]},',
          )}';
    }
    return '₹${price.toStringAsFixed(2)}';
  }

  String _formatCompact(double value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

// ---------------------------------------------------------------------------
// Position Card
// ---------------------------------------------------------------------------

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final _Position position;

  @override
  Widget build(BuildContext context) {
    final isPositive = position.isPositive;
    final pnlColor = isPositive ? AppColors.success : AppColors.error;
    final pnlBg = isPositive ? AppColors.successSurface : AppColors.errorSurface;
    final pnlPrefix = isPositive ? '+' : '-';

    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: position.avatarColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              position.symbol[0],
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: position.avatarColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        position.symbol,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusChip(
                      label: position.type,
                      type: isPositive ? StatusType.success : StatusType.error,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      _posLabel('Qty', position.qty.toString()),
                      const SizedBox(width: 12),
                      _posLabel('Entry', '₹${position.entryPrice.toStringAsFixed(2)}'),
                      const SizedBox(width: 12),
                      _posLabel('LTP', '₹${position.ltp.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // P&L
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: pnlBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$pnlPrefix₹${_fmtPnl(position.pnl)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: pnlColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Unrealised',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: pnlColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _posLabel(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textTertiary),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _fmtPnl(double v) {
    final abs = v.abs();
    if (abs >= 100000) return '${(abs / 100000).toStringAsFixed(2)}L';
    if (abs >= 1000) return '${(abs / 1000).toStringAsFixed(1)}K';
    return abs.toStringAsFixed(0);
  }
}

// ---------------------------------------------------------------------------
// Trade Row
// ---------------------------------------------------------------------------

class _TradeRow extends StatelessWidget {
  const _TradeRow({required this.trade});

  final _Trade trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.isBuy;
    final actionColor = isBuy ? AppColors.success : AppColors.error;
    final actionBg = isBuy ? AppColors.successSurface : AppColors.errorSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Action badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: actionBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              isBuy ? Icons.add_rounded : Icons.remove_rounded,
              size: 20,
              color: actionColor,
            ),
          ),
          const SizedBox(width: 12),

          // Symbol + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        trade.symbol,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: actionBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        trade.action,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: actionColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${trade.qty} shares × ₹${_formatPrice(trade.price)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trade.date,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_formatTotal(trade.total)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Total',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+$)'),
            (m) => '${m[1]},',
          );
    }
    return price.toStringAsFixed(2);
  }

  String _formatTotal(double value) {
    if (value >= 10000000) return '${(value / 10000000).toStringAsFixed(2)} Cr';
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
    if (value >= 1000) {
      return value.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+$)'),
            (m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(0);
  }
}
