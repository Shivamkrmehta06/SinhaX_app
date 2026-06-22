import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/market_ticker_banner.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sample data
// ─────────────────────────────────────────────────────────────────────────────

const List<double> _portfolioSparkline = [
  320000, 324000, 319500, 330000, 327000, 335000, 340000,
  338000, 345000, 352000, 349000, 358000, 362000, 370000,
  375000, 368000, 380000, 385000, 392000, 400000, 410000,
  415000, 408000, 420000, 428500,
];

const List<double> _algoSparkline = [
  10, 14, 11, 18, 15, 20, 17, 22, 19, 25, 23,
];

const List<Map<String, dynamic>> _liveStocks = [
  {
    'symbol': 'RELIANCE',
    'name': 'Reliance Ind.',
    'price': '₹2,934.55',
    'change': '+1.24%',
    'up': true,
    'data': <double>[2880, 2895, 2876, 2910, 2922, 2934, 2930, 2934],
  },
  {
    'symbol': 'TCS',
    'name': 'Tata Cons. Svc.',
    'price': '₹4,012.80',
    'change': '+0.87%',
    'up': true,
    'data': <double>[3960, 3975, 3990, 4002, 3995, 4008, 4012, 4012],
  },
  {
    'symbol': 'INFY',
    'name': 'Infosys Ltd.',
    'price': '₹1,789.45',
    'change': '-0.34%',
    'up': false,
    'data': <double>[1810, 1802, 1798, 1793, 1800, 1795, 1790, 1789],
  },
  {
    'symbol': 'HDFC',
    'name': 'HDFC Bank',
    'price': '₹1,678.90',
    'change': '+0.62%',
    'up': true,
    'data': <double>[1660, 1665, 1670, 1668, 1672, 1675, 1678, 1678],
  },
  {
    'symbol': 'WIPRO',
    'name': 'Wipro Ltd.',
    'price': '₹543.20',
    'change': '-0.21%',
    'up': false,
    'data': <double>[548, 546, 545, 546, 544, 543, 543, 543],
  },
];

const List<Map<String, dynamic>> _signalConditions = [
  {
    'icon': Icons.trending_up_rounded,
    'label': 'RSI Oversold Signal',
    'detail': 'RSI(14) < 30 — 4 stocks matched',
    'status': 'Active',
    'type': StatusType.success,
  },
  {
    'icon': Icons.bar_chart_rounded,
    'label': 'MACD Crossover',
    'detail': 'Bullish crossover detected',
    'status': 'Triggered',
    'type': StatusType.info,
  },
  {
    'icon': Icons.candlestick_chart_rounded,
    'label': 'Bollinger Squeeze',
    'detail': 'Volatility contraction phase',
    'status': 'Pending',
    'type': StatusType.warning,
  },
  {
    'icon': Icons.moving_rounded,
    'label': 'EMA 9/21 Cross',
    'detail': 'Short-term momentum signal',
    'status': 'Active',
    'type': StatusType.success,
  },
];

// ─────────────────────────────────────────────────────────────────────────────
// OverviewScreen
// ─────────────────────────────────────────────────────────────────────────────

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Custom AppBar ──────────────────────────────────────────────
            SliverToBoxAdapter(child: _OverviewAppBar()),

            // ── Market Ticker ──────────────────────────────────────────────
            const SliverToBoxAdapter(child: MarketTickerBanner()),

            // ── Body padding wrapper ───────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Algo Engine Card ─────────────────────────────────────
                  _AlgoEngineCard(),
                  const SizedBox(height: 20),

                  // ── Market Status Row ────────────────────────────────────
                  const SectionHeader(
                    title: 'Market Status',
                    subtitle: 'Live session overview',
                  ),
                  const SizedBox(height: 12),
                  const _MarketStatusRow(),
                  const SizedBox(height: 20),

                  // ── Signal Conditions ────────────────────────────────────
                  const SectionHeader(
                    title: 'Signal Conditions',
                    subtitle: 'Active algo trigger rules',
                    actionLabel: 'View All',
                  ),
                  const SizedBox(height: 12),
                  _SignalConditionsCard(),
                  const SizedBox(height: 20),

                  // ── Stats Grid ───────────────────────────────────────────
                  const SectionHeader(
                    title: 'Portfolio Overview',
                    subtitle: 'Real-time performance metrics',
                  ),
                  const SizedBox(height: 12),
                  const _StatsGrid(),
                  const SizedBox(height: 20),

                  // ── Portfolio Chart ──────────────────────────────────────
                  SinhaXCard(
                    padding: const EdgeInsets.all(16),
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
                                  'Portfolio Performance',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Last 25 trading sessions',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.successSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.trending_up_rounded,
                                      size: 13, color: AppColors.success),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+34.0%',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
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
                        LineChartWidget(
                          data: _portfolioSparkline,
                          height: 200,
                          showGrid: true,
                          lineColor: AppColors.primary,
                          fillGradient: true,
                          labels: const [
                            'Jan', '', '', '', 'Feb', '', '', '', 'Mar',
                            '', '', '', 'Apr', '', '', '', 'May', '',
                            '', '', 'Jun', '', '', '', '',
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Live Prices ──────────────────────────────────────────
                  SectionHeader(
                    title: 'Live Prices',
                    subtitle: 'Real-time market data',
                    actionLabel: 'See All',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  _LivePricesCard(),
                  const SizedBox(height: 20),

                  // ── Market Overview (Top Gainer / Loser) ─────────────────
                  const SectionHeader(
                    title: 'Market Movers',
                    subtitle: "Today's top gainer & loser",
                  ),
                  const SizedBox(height: 12),
                  const _MarketMoversRow(),
                  const SizedBox(height: 8),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom AppBar
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      color: AppColors.background,
      child: Row(
        children: [
          // Greeting block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, Shivam 👋',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Markets are open · Algo running',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 20),
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'S',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Algo Engine Card
// ─────────────────────────────────────────────────────────────────────────────

class _AlgoEngineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(20),
      gradientColors: const [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.memory_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Algo Engine',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const LiveStatusIndicator(
                      label: 'Running',
                      color: Color(0xFF4ADE80),
                    ),
                  ],
                ),
              ),
              // Uptime badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Text(
                  'Uptime 99.8%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 4 mini stats
          Row(
            children: [
              _AlgoStat(label: 'Signals Today', value: '23'),
              _AlgoStatDivider(),
              _AlgoStat(label: 'Executed', value: '18'),
              _AlgoStatDivider(),
              _AlgoStat(label: 'Pending', value: '5'),
              _AlgoStatDivider(),
              _AlgoStat(label: 'Success Rate', value: '78.3%'),
            ],
          ),

          const SizedBox(height: 20),

          // Sparkline chart
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Signal Activity',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 52,
                      child: MiniSparkline(
                        data: _algoSparkline,
                        positive: true,
                        width: double.infinity,
                        height: 52,
                        strokeWidth: 2,
                        showFill: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Next Scan',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '00:04:32',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Auto-refresh ON',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlgoStat extends StatelessWidget {
  const _AlgoStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.65),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AlgoStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Market Status Row
// ─────────────────────────────────────────────────────────────────────────────

class _MarketStatusRow extends StatelessWidget {
  const _MarketStatusRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MarketStatusCard(
            name: 'NSE',
            fullName: 'Natl. Stock Exch.',
            statusLabel: 'Open',
            type: StatusType.success,
            icon: Icons.show_chart_rounded,
            iconColor: AppColors.success,
            time: '09:15 – 15:30',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MarketStatusCard(
            name: 'BSE',
            fullName: 'Bombay Stock Exch.',
            statusLabel: 'Open',
            type: StatusType.success,
            icon: Icons.analytics_rounded,
            iconColor: AppColors.success,
            time: '09:15 – 15:30',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MarketStatusCard(
            name: 'Crypto',
            fullName: 'Digital Assets',
            statusLabel: 'Live',
            type: StatusType.info,
            icon: Icons.currency_bitcoin_rounded,
            iconColor: AppColors.primary,
            time: 'Always Open',
          ),
        ),
      ],
    );
  }
}

class _MarketStatusCard extends StatelessWidget {
  const _MarketStatusCard({
    required this.name,
    required this.fullName,
    required this.statusLabel,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.time,
  });

  final String name;
  final String fullName;
  final String statusLabel;
  final StatusType type;
  final IconData icon;
  final Color iconColor;
  final String time;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: StatusChip(label: statusLabel, type: type, compact: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Signal Conditions Card
// ─────────────────────────────────────────────────────────────────────────────

class _SignalConditionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < _signalConditions.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.divider,
                indent: 16,
                endIndent: 16,
              ),
            _SignalRow(
              icon: _signalConditions[i]['icon'] as IconData,
              label: _signalConditions[i]['label'] as String,
              detail: _signalConditions[i]['detail'] as String,
              status: _signalConditions[i]['status'] as String,
              type: _signalConditions[i]['type'] as StatusType,
            ),
          ],
        ],
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  const _SignalRow({
    required this.icon,
    required this.label,
    required this.detail,
    required this.status,
    required this.type,
  });

  final IconData icon;
  final String label;
  final String detail;
  final String status;
  final StatusType type;

  Color get _iconBg {
    return switch (type) {
      StatusType.success => AppColors.successSurface,
      StatusType.warning => AppColors.warningSurface,
      StatusType.info => AppColors.primarySurface,
      StatusType.error => AppColors.errorSurface,
      StatusType.neutral => AppColors.background,
    };
  }

  Color get _iconColor {
    return switch (type) {
      StatusType.success => AppColors.success,
      StatusType.warning => AppColors.warning,
      StatusType.info => AppColors.primary,
      StatusType.error => AppColors.error,
      StatusType.neutral => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusChip(label: status, type: type, compact: true),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Grid (2 × 2)
// ─────────────────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'PORTFOLIO VALUE',
                value: '₹4,28,500',
                subValue: 'Total invested',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: "TODAY'S P&L",
                value: '+₹3,240',
                trend: '+0.76%',
                trendPositive: true,
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.success,
                valueColor: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'TOTAL TRADES',
                value: '847',
                subValue: 'All time',
                icon: Icons.swap_horiz_rounded,
                iconColor: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'WIN RATE',
                value: '73.2%',
                trend: '+2.1%',
                trendPositive: true,
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.success,
                valueColor: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Prices Card
// ─────────────────────────────────────────────────────────────────────────────

class _LivePricesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Column headers
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Symbol',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Chart',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    'Price',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 56,
                  child: Text(
                    'Chg%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          for (int i = 0; i < _liveStocks.length; i++) ...[
            if (i > 0)
              const Divider(
                  height: 1,
                  color: AppColors.divider,
                  indent: 16,
                  endIndent: 16),
            _LiveStockRow(stock: _liveStocks[i]),
          ],
        ],
      ),
    );
  }
}

class _LiveStockRow extends StatelessWidget {
  const _LiveStockRow({required this.stock});

  final Map<String, dynamic> stock;

  @override
  Widget build(BuildContext context) {
    final bool isUp = stock['up'] as bool;
    final Color changeColor = isUp ? AppColors.success : AppColors.error;
    final List<double> chartData = List<double>.from(stock['data'] as List);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Symbol + name
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['symbol'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stock['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Mini sparkline
          MiniSparkline(
            data: chartData,
            positive: isUp,
            width: 70,
            height: 36,
            strokeWidth: 1.8,
          ),
          const SizedBox(width: 8),
          // Price
          SizedBox(
            width: 72,
            child: Text(
              stock['price'] as String,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          // Change %
          SizedBox(
            width: 56,
            child: Text(
              stock['change'] as String,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: changeColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Market Movers Row (Top Gainer / Top Loser)
// ─────────────────────────────────────────────────────────────────────────────

class _MarketMoversRow extends StatelessWidget {
  const _MarketMoversRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MoverCard(
            title: 'Top Gainer',
            symbol: 'TATAMOTORS',
            fullName: 'Tata Motors Ltd.',
            price: '₹1,023.40',
            change: '+4.87%',
            volume: 'Vol: 2.3M',
            isGainer: true,
            chartData: const [
              870, 882, 895, 910, 921, 940, 955, 970, 985, 1005, 1023
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MoverCard(
            title: 'Top Loser',
            symbol: 'BAJFINANCE',
            fullName: 'Bajaj Finance Ltd.',
            price: '₹6,421.70',
            change: '-3.14%',
            volume: 'Vol: 1.1M',
            isGainer: false,
            chartData: const [
              6850, 6820, 6790, 6755, 6730, 6710, 6690, 6660, 6640, 6630, 6421
            ],
          ),
        ),
      ],
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    required this.title,
    required this.symbol,
    required this.fullName,
    required this.price,
    required this.change,
    required this.volume,
    required this.isGainer,
    required this.chartData,
  });

  final String title;
  final String symbol;
  final String fullName;
  final String price;
  final String change;
  final String volume;
  final bool isGainer;
  final List<double> chartData;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = isGainer ? AppColors.success : AppColors.error;
    final Color bgColor =
        isGainer ? AppColors.successSurface : AppColors.errorSurface;

    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGainer
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  size: 16,
                  color: accentColor,
                ),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Symbol
          Text(
            symbol,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            fullName,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Sparkline
          MiniSparkline(
            data: chartData,
            positive: isGainer,
            width: double.infinity,
            height: 44,
            strokeWidth: 2,
          ),
          const SizedBox(height: 10),

          // Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            volume,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
