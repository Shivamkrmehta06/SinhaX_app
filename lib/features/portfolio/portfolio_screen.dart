import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/portfolio_provider.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';

// ---------------------------------------------------------------------------
// PortfolioScreen
// ---------------------------------------------------------------------------

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _tabs = ['Holdings', 'Positions'];

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

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = ref.watch(portfolioProvider);
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: _buildAppBar(context, isDark),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.card(context),
              child: _buildHeader(context, portfolio),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: _buildTabBar(context, isDark),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _HoldingsTab(holdings: portfolio.holdings),
            _PositionsTab(positions: portfolio.positions),
          ],
        ),
      ),
    );
  }

  // ── App Bar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: AppColors.card(context),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Text(
        'Portfolio',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.text1(context),
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.download_rounded,
              color: AppColors.text2(context), size: 22),
          onPressed: () {},
          tooltip: 'Export Report',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderColor(context)),
      ),
    );
  }

  // ── Header (above tabs) ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, PortfolioState portfolio) {
    return Container(
      color: AppColors.bg(context),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryBanner(context, portfolio),
          const SizedBox(height: 16),
          _buildStatsRow(context, portfolio),
          const SizedBox(height: 20),
          _buildPerformanceChart(context, portfolio),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Summary Banner ───────────────────────────────────────────────────────

  Widget _buildSummaryBanner(BuildContext context, PortfolioState p) {
    final isDark = AppColors.isDark(context);
    final gradColors = isDark
        ? const [Color(0xFF0F1E80), Color(0xFF1A2EB0), Color(0xFF2B44CC)]
        : const [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)];

    final dayPositive = p.dayPnl >= 0;
    final totalPositive = p.totalPnl >= 0;

    return GradientCard(
      gradientColors: gradColors,
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
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.8)),
                    const SizedBox(width: 4),
                    Text(
                      'As of 3:30 PM IST',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
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
            '₹${_formatAmount(p.totalValue)}',
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 10),
          // Day change row
          Row(
            children: [
              _PnlBadge(
                amount: '${dayPositive ? '+' : ''}₹${_formatAmount(p.dayPnl.abs())} Today',
                isPositive: dayPositive,
                showArrow: true,
              ),
              const SizedBox(width: 8),
              _PnlBadge(
                amount:
                    '${totalPositive ? '+' : ''}${p.totalPnlPct.toStringAsFixed(2)}%',
                isPositive: totalPositive,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 14),
          Row(
            children: [
              _bannerStat('Invested', '₹${_formatAmount(p.totalInvested)}'),
              _bannerDivider(),
              _bannerStat('Total P&L',
                  '${totalPositive ? '+' : ''}₹${_formatAmount(p.totalPnl.abs())}'),
              _bannerDivider(),
              _bannerStat('Day P&L',
                  '${dayPositive ? '+' : '-'}₹${_formatAmount(p.dayPnl.abs())}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerStat(String label, String value) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      );

  Widget _bannerDivider() => Container(
        width: 1,
        height: 28,
        color: Colors.white.withValues(alpha: 0.15),
        margin: const EdgeInsets.symmetric(horizontal: 12),
      );

  // ── Stats Row ────────────────────────────────────────────────────────────

  Widget _buildStatsRow(BuildContext context, PortfolioState p) {
    final winRate = p.holdings.isEmpty
        ? 0.0
        : p.holdings.where((h) => h.pnl >= 0).length /
            p.holdings.length *
            100;
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'INVESTED',
            value: '₹${_formatAmount(p.totalInvested)}',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.primary,
            compact: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'TOTAL P&L',
            value: '₹${_formatAmount(p.totalPnl.abs())}',
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.gainColor(context),
            valueColor: AppColors.gainColor(context),
            trend: '+${p.totalPnlPct.toStringAsFixed(1)}%',
            trendPositive: p.totalPnl >= 0,
            compact: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'DAY P&L',
            value: '₹${_formatAmount(p.dayPnl.abs())}',
            icon: Icons.today_rounded,
            iconColor: p.dayPnl >= 0
                ? AppColors.gainColor(context)
                : AppColors.lossColor(context),
            valueColor: p.dayPnl >= 0
                ? AppColors.gainColor(context)
                : AppColors.lossColor(context),
            compact: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'WIN RATE',
            value: '${winRate.toStringAsFixed(0)}%',
            icon: Icons.emoji_events_rounded,
            iconColor: AppColors.warning,
            valueColor: AppColors.warning,
            compact: true,
          ),
        ),
      ],
    );
  }

  // ── Performance Chart ────────────────────────────────────────────────────

  Widget _buildPerformanceChart(BuildContext context, PortfolioState p) {
    return SinhaXCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: AppColors.card(context),
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
                    'Performance Chart',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Portfolio value over time',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.text3(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.gainSurface(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward_rounded,
                        size: 12, color: AppColors.gainColor(context)),
                    const SizedBox(width: 3),
                    Text(
                      '+${p.totalPnlPct.toStringAsFixed(1)}% All Time',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gainColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LineChartWidget(
            data: p.performanceChart,
            height: 120,
            showGrid: true,
            lineColor: AppColors.primary,
            fillGradient: true,
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      color: AppColors.card(context),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.text2(context),
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.borderColor(context),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabs.map((t) => Tab(text: t, height: 44)).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatAmount(double value) {
  if (value >= 10000000) {
    return '${(value / 10000000).toStringAsFixed(2)}Cr';
  } else if (value >= 100000) {
    return '${(value / 100000).toStringAsFixed(2)}L';
  } else if (value >= 1000) {
    final s = value.toStringAsFixed(0);
    if (s.length > 3) {
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return s;
  }
  return value.toStringAsFixed(0);
}

// ---------------------------------------------------------------------------
// PnL Badge (used in summary banner on gradient bg)
// ---------------------------------------------------------------------------

class _PnlBadge extends StatelessWidget {
  const _PnlBadge({
    required this.amount,
    required this.isPositive,
    this.showArrow = false,
  });

  final String amount;
  final bool isPositive;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    const greenLight = Color(0xFF86EFAC);
    const greenSurface = Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPositive
            ? greenSurface.withValues(alpha: 0.18)
            : Colors.red.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isPositive
                ? greenSurface.withValues(alpha: 0.3)
                : Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showArrow) ...[
            Icon(
              isPositive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 13,
              color: isPositive ? greenLight : const Color(0xFFFCA5A5),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: showArrow ? 12 : 13,
              fontWeight: FontWeight.w700,
              color: isPositive ? greenLight : const Color(0xFFFCA5A5),
            ),
          ),
        ],
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Holdings Tab
// ---------------------------------------------------------------------------

class _HoldingsTab extends StatelessWidget {
  const _HoldingsTab({required this.holdings});
  final List<Holding> holdings;

  @override
  Widget build(BuildContext context) {
    if (holdings.isEmpty) {
      return _EmptyTabState(
        icon: Icons.account_balance_wallet_outlined,
        message: 'No holdings yet',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: holdings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _HoldingCard(holding: holdings[index]),
    );
  }
}

class _HoldingCard extends StatelessWidget {
  const _HoldingCard({required this.holding});
  final Holding holding;

  @override
  Widget build(BuildContext context) {
    final isGain = holding.pnl >= 0;

    return SinhaXCard(
      color: AppColors.card(context),
      border: true,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: holding.avatarColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                holding.symbol.length > 2
                    ? holding.symbol.substring(0, 2)
                    : holding.symbol,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: holding.avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Symbol + company
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  holding.company,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text2(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${holding.qty} × ₹${holding.avgPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text3(context),
                  ),
                ),
              ],
            ),
          ),
          // Sparkline
          MiniSparkline(
            data: holding.sparkline,
            positive: isGain,
            width: 56,
            height: 30,
          ),
          const SizedBox(width: 12),
          // CMP + P&L
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${holding.cmp.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isGain
                      ? AppColors.gainSurface(context)
                      : AppColors.lossSurfaceColor(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${isGain ? '+' : ''}₹${holding.pnl.toStringAsFixed(0)} (${holding.pnlPct.toStringAsFixed(2)}%)',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isGain
                        ? AppColors.gainColor(context)
                        : AppColors.lossColor(context),
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

// ---------------------------------------------------------------------------
// Positions Tab
// ---------------------------------------------------------------------------

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});
  final List<Position> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return _EmptyTabState(
        icon: Icons.candlestick_chart_outlined,
        message: 'No open positions',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: positions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _PositionCard(position: positions[index]),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});
  final Position position;

  @override
  Widget build(BuildContext context) {
    final isGain = position.isPositive;

    return SinhaXCard(
      color: AppColors.card(context),
      border: true,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: position.avatarColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                position.symbol.length > 2
                    ? position.symbol.substring(0, 2)
                    : position.symbol,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: position.avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Symbol + type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurfaceColor(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    position.type,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${position.qty}  Entry: ₹${position.entryPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text3(context),
                  ),
                ),
              ],
            ),
          ),
          // LTP + P&L
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'LTP ₹${position.ltp.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isGain
                      ? AppColors.gainSurface(context)
                      : AppColors.lossSurfaceColor(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${isGain ? '+' : '-'}₹${position.pnl.abs().toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isGain
                        ? AppColors.gainColor(context)
                        : AppColors.lossColor(context),
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

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------

class _EmptyTabState extends StatelessWidget {
  const _EmptyTabState({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primarySurfaceColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text1(context),
            ),
          ),
        ],
      ),
    );
  }
}
