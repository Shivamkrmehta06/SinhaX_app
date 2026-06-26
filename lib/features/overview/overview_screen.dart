import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/portfolio_provider.dart';
import '../../shared/widgets/interactive_3d_card.dart';
import '../../shared/widgets/market_ticker_banner.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Static data (signal conditions — not from a provider)
// ─────────────────────────────────────────────────────────────────────────────

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

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    final quotes = ref.watch(marketProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.read(marketProvider.notifier).refresh();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ── Custom AppBar ─────────────────────────────────────────────
              SliverToBoxAdapter(child: _OverviewAppBar()),

              // ── Market Ticker ─────────────────────────────────────────────
              const SliverToBoxAdapter(child: MarketTickerBanner()),

              // ── Body ──────────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Portfolio Performance Card ──────────────────────────
                    _PortfolioCard(portfolio: portfolio),
                    const SizedBox(height: 20),

                    // ── Market Status ───────────────────────────────────────
                    const SectionHeader(
                      title: 'Market Status',
                      subtitle: 'Live session overview',
                    ),
                    const SizedBox(height: 12),
                    const _MarketStatusRow(),
                    const SizedBox(height: 20),

                    // ── Signal Conditions ───────────────────────────────────
                    const SectionHeader(
                      title: 'Signal Conditions',
                      subtitle: 'Active algo trigger rules',
                      actionLabel: 'View All',
                    ),
                    const SizedBox(height: 12),
                    _SignalConditionsCard(),
                    const SizedBox(height: 20),

                    // ── Stats Grid ──────────────────────────────────────────
                    const SectionHeader(
                      title: 'Portfolio Overview',
                      subtitle: 'Real-time performance metrics',
                    ),
                    const SizedBox(height: 12),
                    _StatsGrid(portfolio: portfolio),
                    const SizedBox(height: 20),

                    // ── Portfolio Line Chart ────────────────────────────────
                    _PortfolioChartCard(portfolio: portfolio),
                    const SizedBox(height: 20),

                    // ── Live Prices ─────────────────────────────────────────
                    SectionHeader(
                      title: 'Live Prices',
                      subtitle: 'Real-time market data',
                      actionLabel: 'See All',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    _LivePricesCard(quotes: quotes),
                    const SizedBox(height: 20),

                    // ── Market Movers ───────────────────────────────────────
                    const SectionHeader(
                      title: 'Market Movers',
                      subtitle: "Today's top gainer & loser",
                    ),
                    const SizedBox(height: 12),
                    _MarketMoversRow(quotes: quotes),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
            ],
          ),
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
    final isDark = AppColors.isDark(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkSurfaceAlt : AppColors.surfaceAlt,
              border: Border.all(
                color: AppColors.borderColor(context),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          
          // Greeting block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.text2(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Shivam Mehta',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1(context),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Market Status & Notification
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text1(context),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 1,
                  height: 14,
                  color: AppColors.borderColor(context),
                ),
                const SizedBox(width: 10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.text1(context),
                      size: 20,
                    ),
                    Positioned(
                      top: -1,
                      right: -1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.card(context),
                            width: 1.5,
                          ),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Portfolio Performance Card  (was _AlgoEngineCard)
// ─────────────────────────────────────────────────────────────────────────────

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.portfolio});

  final PortfolioState portfolio;

  @override
  Widget build(BuildContext context) {
    final isDayUp = portfolio.dayPnl >= 0;
    final daySign = isDayUp ? '+' : '';

    return Interactive3DCard(
      child: GradientCard(
        padding: const EdgeInsets.all(20),
        gradientColors: const [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
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
                        'Portfolio Value',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const LiveStatusIndicator(
                        label: 'Live',
                        color: Color(0xFF4ADE80),
                      ),
                    ],
                  ),
                ),
                // Day P&L badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDayUp
                        ? const Color(0xFF16C784).withValues(alpha: 0.25)
                        : const Color(0xFFEA3943).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDayUp
                          ? const Color(0xFF16C784).withValues(alpha: 0.45)
                          : const Color(0xFFEA3943).withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    '$daySign₹${portfolio.dayPnl.abs().toStringAsFixed(0)} • '
                    '$daySign${portfolio.dayPnlPct.abs().toStringAsFixed(2)}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDayUp
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFFF6B6B),
                    ),
                  ),
                ),
              ],
            ),
  
            const SizedBox(height: 16),
  
            // Big number
            Text(
              '₹${_formatValue(portfolio.totalValue)}',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
  
            const SizedBox(height: 16),
  
            // Sparkline
            SizedBox(
              height: 56,
              child: MiniSparkline(
                data: portfolio.performanceChart,
                positive: true,
                width: double.infinity,
                height: 56,
                strokeWidth: 2,
                showFill: true,
              ),
            ),
  
            const SizedBox(height: 16),
  
            // Bottom stats row
            Row(
              children: [
                _CardStat(
                  label: 'Invested',
                  value: '₹${_formatValue(portfolio.totalInvested)}',
                ),
                _CardDivider(),
                _CardStat(
                  label: 'Total P&L',
                  value: '+₹${_formatValue(portfolio.totalPnl)}',
                ),
                _CardDivider(),
                _CardStat(
                  label: 'Returns',
                  value: '+${portfolio.totalPnlPct.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(double v) {
    if (v >= 100000) {
      return '${(v / 100000).toStringAsFixed(2)}L';
    }
    return v.toStringAsFixed(0);
  }
}

class _CardStat extends StatelessWidget {
  const _CardStat({required this.label, required this.value});
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.65),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
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
            statusLabel: 'Open',
            type: StatusType.success,
            icon: Icons.show_chart_rounded,
            iconColor: AppColors.gainColor(context),
            time: '09:15 – 15:30',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MarketStatusCard(
            name: 'BSE',
            statusLabel: 'Open',
            type: StatusType.success,
            icon: Icons.analytics_rounded,
            iconColor: AppColors.gainColor(context),
            time: '09:15 – 15:30',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MarketStatusCard(
            name: 'Crypto',
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
    required this.statusLabel,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.time,
  });

  final String name;
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
                  color: iconColor.withValues(alpha: 0.12),
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
              color: AppColors.text1(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.text3(context),
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
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderColor(context),
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

  Color _iconBg(BuildContext context) {
    return switch (type) {
      StatusType.success => AppColors.gainSurface(context),
      StatusType.warning => AppColors.isDark(context)
          ? AppColors.warningSurface.withValues(alpha: 0.15)
          : AppColors.warningSurface,
      StatusType.info => AppColors.primarySurfaceColor(context),
      StatusType.error => AppColors.lossSurfaceColor(context),
      StatusType.neutral => AppColors.cardAlt(context),
    };
  }

  Color _iconColor(BuildContext context) {
    return switch (type) {
      StatusType.success => AppColors.gainColor(context),
      StatusType.warning => AppColors.warning,
      StatusType.info => AppColors.primary,
      StatusType.error => AppColors.lossColor(context),
      StatusType.neutral => AppColors.text2(context),
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
              color: _iconBg(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: _iconColor(context)),
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
                    color: AppColors.text1(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text2(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusChip(label: status, type: type, compact: true),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Grid
// ─────────────────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.portfolio});
  final PortfolioState portfolio;

  @override
  Widget build(BuildContext context) {
    final isDayUp = portfolio.dayPnl >= 0;
    final isTotalUp = portfolio.totalPnl >= 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        StatCard(
          label: 'TOTAL VALUE',
          value: '₹4,28,500',
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppColors.primary,
          subValue: 'Invested ₹3,20,000',
        ),
        StatCard(
          label: 'DAY P&L',
          value:
              '${isDayUp ? '+' : ''}₹${portfolio.dayPnl.abs().toStringAsFixed(0)}',
          icon: isDayUp
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          iconColor: isDayUp ? AppColors.gainColor(context) : AppColors.lossColor(context),
          valueColor: isDayUp ? AppColors.gainColor(context) : AppColors.lossColor(context),
          trend: '${isDayUp ? '+' : ''}${portfolio.dayPnlPct.toStringAsFixed(2)}%',
          trendPositive: isDayUp,
        ),
        StatCard(
          label: 'TOTAL P&L',
          value:
              '${isTotalUp ? '+' : ''}₹${_fmt(portfolio.totalPnl.abs())}',
          icon: isTotalUp
              ? Icons.show_chart_rounded
              : Icons.show_chart_rounded,
          iconColor:
              isTotalUp ? AppColors.gainColor(context) : AppColors.lossColor(context),
          valueColor:
              isTotalUp ? AppColors.gainColor(context) : AppColors.lossColor(context),
          trend: '${isTotalUp ? '+' : ''}${portfolio.totalPnlPct.toStringAsFixed(1)}%',
          trendPositive: isTotalUp,
        ),
        StatCard(
          label: 'WIN RATE',
          value: '67.6%',
          icon: Icons.emoji_events_rounded,
          iconColor: AppColors.warning,
          subValue: '142 trades',
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(2)}L';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Portfolio Chart Card
// ─────────────────────────────────────────────────────────────────────────────

class _PortfolioChartCard extends StatelessWidget {
  const _PortfolioChartCard({required this.portfolio});
  final PortfolioState portfolio;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
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
                      color: AppColors.text1(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Last 25 trading sessions',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.text2(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.gainSurface(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 13, color: AppColors.gainColor(context)),
                    const SizedBox(width: 4),
                    Text(
                      '+${portfolio.totalPnlPct.toStringAsFixed(1)}%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
            data: portfolio.performanceChart,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Prices Card
// ─────────────────────────────────────────────────────────────────────────────

class _LivePricesCard extends StatelessWidget {
  const _LivePricesCard({required this.quotes});
  final List<StockQuote> quotes;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < quotes.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderColor(context),
                indent: 16,
                endIndent: 16,
              ),
            _StockRow(quote: quotes[i]),
          ],
        ],
      ),
    );
  }
}

class _StockRow extends StatelessWidget {
  const _StockRow({required this.quote});
  final StockQuote quote;

  @override
  Widget build(BuildContext context) {
    final changeColor =
        quote.isUp ? AppColors.gainColor(context) : AppColors.lossColor(context);
    final sign = quote.changePct >= 0 ? '+' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Symbol avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primarySurfaceColor(context),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              quote.symbol.substring(0, quote.symbol.length.clamp(0, 2)),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1(context),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  quote.name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text2(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Sparkline
          MiniSparkline(
            data: quote.sparkline,
            positive: quote.isUp,
            width: 56,
            height: 30,
            strokeWidth: 1.6,
            showFill: false,
          ),
          const SizedBox(width: 12),
          // Price + change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${quote.price.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: quote.isUp
                      ? AppColors.gainSurface(context)
                      : AppColors.lossSurfaceColor(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '$sign${quote.changePct.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────────────────────────────────────
// Market Movers Row
// ─────────────────────────────────────────────────────────────────────────────

class _MarketMoversRow extends StatelessWidget {
  const _MarketMoversRow({required this.quotes});
  final List<StockQuote> quotes;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) return const SizedBox.shrink();

    final sorted = [...quotes]..sort((a, b) => b.changePct.compareTo(a.changePct));
    final topGainer = sorted.first;
    final topLoser = sorted.last;

    return Row(
      children: [
        Expanded(child: _MoverCard(quote: topGainer, isGainer: true)),
        const SizedBox(width: 12),
        Expanded(child: _MoverCard(quote: topLoser, isGainer: false)),
      ],
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({required this.quote, required this.isGainer});
  final StockQuote quote;
  final bool isGainer;

  @override
  Widget build(BuildContext context) {
    final color =
        isGainer ? AppColors.gainColor(context) : AppColors.lossColor(context);
    final surfaceColor =
        isGainer ? AppColors.gainSurface(context) : AppColors.lossSurfaceColor(context);
    final sign = quote.changePct >= 0 ? '+' : '';

    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isGainer ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isGainer ? 'Top Gainer' : 'Top Loser',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text2(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            quote.symbol,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text1(context),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${quote.price.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text2(context),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$sign${quote.changePct.toStringAsFixed(2)}%',
              style: GoogleFonts.inter(
                fontSize: 14,
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
