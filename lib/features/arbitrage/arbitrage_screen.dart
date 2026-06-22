import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

class _ArbitrageOpportunity {
  const _ArbitrageOpportunity({
    required this.asset,
    required this.exchangeA,
    required this.exchangeB,
    required this.priceA,
    required this.priceB,
    required this.spreadPct,
    required this.expectedProfit,
    required this.windowSeconds,
    required this.sparkData,
  });

  final String asset;
  final String exchangeA;
  final String exchangeB;
  final String priceA;
  final String priceB;
  final String spreadPct;
  final String expectedProfit;
  final int windowSeconds;
  final List<double> sparkData;
}

class _ArbitrageStrategy {
  const _ArbitrageStrategy({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.active,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool active;
}

class _RecentTrade {
  const _RecentTrade({
    required this.asset,
    required this.exchangePair,
    required this.profit,
    required this.timeAgo,
    required this.status,
  });

  final String asset;
  final String exchangePair;
  final String profit;
  final String timeAgo;
  final StatusType status;
}

// ─────────────────────────────────────────────────────────────────────────────
// Static Data
// ─────────────────────────────────────────────────────────────────────────────

const List<_ArbitrageOpportunity> _opportunities = [
  _ArbitrageOpportunity(
    asset: 'BTC/USDT',
    exchangeA: 'Binance',
    exchangeB: 'Coinbase',
    priceA: '\$67,842.10',
    priceB: '\$68,021.50',
    spreadPct: '+0.26%',
    expectedProfit: '₹1,420',
    windowSeconds: 47,
    sparkData: [42, 45, 43, 48, 52, 50, 55, 58, 62, 65],
  ),
  _ArbitrageOpportunity(
    asset: 'NIFTY50',
    exchangeA: 'NSE',
    exchangeB: 'BSE',
    priceA: '₹24,512.00',
    priceB: '₹24,578.75',
    spreadPct: '+0.27%',
    expectedProfit: '₹2,680',
    windowSeconds: 23,
    sparkData: [30, 35, 32, 38, 42, 40, 45, 48, 44, 50],
  ),
  _ArbitrageOpportunity(
    asset: 'ETH/USDT',
    exchangeA: 'Kraken',
    exchangeB: 'OKX',
    priceA: '\$3,521.80',
    priceB: '\$3,534.45',
    spreadPct: '+0.36%',
    expectedProfit: '₹3,150',
    windowSeconds: 61,
    sparkData: [55, 52, 58, 60, 64, 62, 68, 70, 74, 72],
  ),
];

const List<_ArbitrageStrategy> _strategies = [
  _ArbitrageStrategy(
    name: 'Statistical',
    description: 'Mean-reversion between correlated pairs',
    icon: Icons.bar_chart_rounded,
    color: Color(0xFF6366F1),
    active: true,
  ),
  _ArbitrageStrategy(
    name: 'Triangular',
    description: 'Cross-currency 3-leg opportunity loops',
    icon: Icons.change_circle_rounded,
    color: Color(0xFF0EA5E9),
    active: true,
  ),
  _ArbitrageStrategy(
    name: 'Exchange',
    description: 'Price disparity across spot exchanges',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF22C55E),
    active: false,
  ),
  _ArbitrageStrategy(
    name: 'ETF Arbitrage',
    description: 'NAV vs market price divergence trades',
    icon: Icons.account_balance_rounded,
    color: Color(0xFFF59E0B),
    active: true,
  ),
];

const List<_RecentTrade> _recentTrades = [
  _RecentTrade(
    asset: 'BTC/USDT',
    exchangePair: 'Binance → Bybit',
    profit: '+₹4,820',
    timeAgo: '2m ago',
    status: StatusType.success,
  ),
  _RecentTrade(
    asset: 'NIFTY50',
    exchangePair: 'NSE → BSE',
    profit: '+₹2,100',
    timeAgo: '7m ago',
    status: StatusType.success,
  ),
  _RecentTrade(
    asset: 'ETH/USDT',
    exchangePair: 'Kraken → OKX',
    profit: '-₹320',
    timeAgo: '15m ago',
    status: StatusType.error,
  ),
  _RecentTrade(
    asset: 'GOLD',
    exchangePair: 'MCX → NCDEX',
    profit: '+₹1,560',
    timeAgo: '31m ago',
    status: StatusType.success,
  ),
  _RecentTrade(
    asset: 'SOL/USDT',
    exchangePair: 'Coinbase → Binance',
    profit: '+₹890',
    timeAgo: '48m ago',
    status: StatusType.success,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// ArbitrageScreen
// ─────────────────────────────────────────────────────────────────────────────

class ArbitrageScreen extends StatefulWidget {
  const ArbitrageScreen({super.key});

  @override
  State<ArbitrageScreen> createState() => _ArbitrageScreenState();
}

class _ArbitrageScreenState extends State<ArbitrageScreen> {
  // Track toggle states for strategies (index → active)
  final Map<int, bool> _strategyToggles = {
    0: _strategies[0].active,
    1: _strategies[1].active,
    2: _strategies[2].active,
    3: _strategies[3].active,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSubtitleBanner()),
          SliverToBoxAdapter(child: _buildStatsGrid()),
          SliverToBoxAdapter(child: _buildLiveOpportunitiesSection()),
          SliverToBoxAdapter(child: _buildStrategiesSection()),
          SliverToBoxAdapter(child: _buildRecentTradesSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      titleSpacing: 20,
      title: Text(
        'Arbitrage',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 20),
            onPressed: () => _showInfoSheet(context),
            tooltip: 'About Arbitrage',
          ),
        ),
      ],
    );
  }

  // ── Subtitle Banner ─────────────────────────────────────────────────────────

  Widget _buildSubtitleBanner() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_graph_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-detected cross-exchange opportunities',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const LiveStatusIndicator(label: 'Scanning 12 exchanges'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats 2×2 Grid ──────────────────────────────────────────────────────────

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
        children: const [
          StatCard(
            label: 'Total Trades',
            value: '1,247',
            icon: Icons.swap_horiz_rounded,
            iconColor: AppColors.primary,
            trend: '+42',
            trendPositive: true,
            subValue: 'this month',
          ),
          StatCard(
            label: 'Open Positions',
            value: '8',
            icon: Icons.radio_button_checked_rounded,
            iconColor: Color(0xFF22C55E),
            subValue: '3 pending exec',
          ),
          StatCard(
            label: 'Win Rate',
            value: '89.3%',
            icon: Icons.emoji_events_rounded,
            iconColor: Color(0xFFF59E0B),
            trend: '+2.1%',
            trendPositive: true,
            subValue: 'vs last month',
          ),
          StatCard(
            label: 'Total Profit',
            value: '+₹4.28L',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Color(0xFF22C55E),
            valueColor: Color(0xFF22C55E),
            trend: '+₹28K',
            trendPositive: true,
            subValue: 'today',
          ),
        ],
      ),
    );
  }

  // ── Live Opportunities ──────────────────────────────────────────────────────

  Widget _buildLiveOpportunitiesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Live Opportunities',
            subtitle: '${_opportunities.length} active • refreshes every 5s',
            action: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flash_on_rounded,
                      size: 13, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    'AI Active',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Gradient banner card
          GradientCard(
            padding: const EdgeInsets.all(16),
            gradientColors: const [Color(0xFF064E3B), Color(0xFF065F46)],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt_rounded,
                      color: AppColors.success, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Arbitrage Detected!',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '3 high-confidence opportunities ready to execute',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const LiveStatusIndicator(
                  label: 'LIVE',
                  color: AppColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Opportunity cards
          ...List.generate(_opportunities.length, (i) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: i < _opportunities.length - 1 ? 12 : 0),
              child: _OpportunityCard(opportunity: _opportunities[i]),
            );
          }),
        ],
      ),
    );
  }

  // ── Strategies Grid ─────────────────────────────────────────────────────────

  Widget _buildStrategiesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Arbitrage Strategies',
            subtitle: 'Configure AI scanning parameters',
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _strategies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final strategy = _strategies[index];
              final isActive = _strategyToggles[index] ?? strategy.active;
              return _StrategyCard(
                strategy: strategy,
                isActive: isActive,
                onToggle: (val) {
                  setState(() => _strategyToggles[index] = val);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Recent Trades ───────────────────────────────────────────────────────────

  Widget _buildRecentTradesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent Arbitrage Trades',
            actionLabel: 'View All',
          ),
          const SizedBox(height: 14),
          SinhaXCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(_recentTrades.length, (i) {
                return _RecentTradeRow(
                  trade: _recentTrades[i],
                  isLast: i == _recentTrades.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Bottom Sheet ───────────────────────────────────────────────────────

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About Arbitrage',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'SinhaX AI continuously monitors price discrepancies across 12+ exchanges in real time. When a profitable spread is detected within your risk tolerance, the system alerts you and optionally executes the trade automatically.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.shield_rounded,
              color: AppColors.success,
              title: 'Risk-Managed',
              subtitle: 'Position sizing auto-adjusted to your risk profile',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.speed_rounded,
              color: AppColors.primary,
              title: 'Ultra-Low Latency',
              subtitle: 'Execution under 50ms for time-sensitive windows',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.account_tree_rounded,
              color: Color(0xFF6366F1),
              title: 'Multi-Strategy',
              subtitle: 'Statistical, triangular, exchange & ETF arbitrage',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OpportunityCard
// ─────────────────────────────────────────────────────────────────────────────

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({required this.opportunity});

  final _ArbitrageOpportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: asset + spread badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AssetAvatar(asset: opportunity.asset),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.asset,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          opportunity.exchangeA,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 11, color: AppColors.textTertiary),
                        ),
                        Text(
                          opportunity.exchangeB,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Spread pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  opportunity.spreadPct,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Price comparison row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PriceCell(
                    exchange: opportunity.exchangeA,
                    price: opportunity.priceA,
                    label: 'Buy at',
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _PriceCell(
                    exchange: opportunity.exchangeB,
                    price: opportunity.priceB,
                    label: 'Sell at',
                    alignRight: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Profit / window / sparkline row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expected Profit',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    opportunity.expectedProfit,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Window',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 2),
                  _CountdownBadge(seconds: opportunity.windowSeconds),
                ],
              ),
              const Spacer(),
              MiniSparkline(
                data: opportunity.sparkData,
                positive: true,
                width: 60,
                height: 30,
              ),
              const SizedBox(width: 12),
              // Auto Execute button
              _AutoExecuteButton(asset: opportunity.asset),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AssetAvatar
// ─────────────────────────────────────────────────────────────────────────────

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset});

  final String asset;

  static const Map<String, List<Color>> _gradients = {
    'BTC': [Color(0xFFF7931A), Color(0xFFFFB347)],
    'ETH': [Color(0xFF627EEA), Color(0xFF8FA8FF)],
    'NIFTY': [Color(0xFF2563EB), Color(0xFF60A5FA)],
    'SOL': [Color(0xFF9945FF), Color(0xFF14F195)],
    'GOLD': [Color(0xFFD97706), Color(0xFFFBBF24)],
  };

  List<Color> get _colors {
    final key = asset.split('/').first.toUpperCase();
    for (final entry in _gradients.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return AppColors.primaryGradient;
  }

  String get _initials {
    final parts = asset.split('/');
    return parts.first.length > 3
        ? parts.first.substring(0, 3)
        : parts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: _colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PriceCell
// ─────────────────────────────────────────────────────────────────────────────

class _PriceCell extends StatelessWidget {
  const _PriceCell({
    required this.exchange,
    required this.price,
    required this.label,
    this.alignRight = false,
  });

  final String exchange;
  final String price;
  final String label;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: alignRight ? 12 : 0,
        right: alignRight ? 0 : 12,
      ),
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$label $exchange',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            price,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CountdownBadge
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownBadge extends StatelessWidget {
  const _CountdownBadge({required this.seconds});

  final int seconds;

  Color get _urgencyColor {
    if (seconds < 30) return AppColors.error;
    if (seconds < 60) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_rounded, size: 13, color: _urgencyColor),
        const SizedBox(width: 3),
        Text(
          '${seconds}s',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _urgencyColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AutoExecuteButton
// ─────────────────────────────────────────────────────────────────────────────

class _AutoExecuteButton extends StatelessWidget {
  const _AutoExecuteButton({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showExecuteConfirm(context),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flash_on_rounded,
                color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              'Execute',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExecuteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flash_on_rounded,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Auto Execute',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Execute arbitrage trade for $asset now?\nAI has verified this opportunity with 94.2% confidence.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(
              'Execute Now',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StrategyCard
// ─────────────────────────────────────────────────────────────────────────────

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.isActive,
    required this.onToggle,
  });

  final _ArbitrageStrategy strategy;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + toggle row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: strategy.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(strategy.icon,
                    color: strategy.color, size: 18),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.75,
                alignment: Alignment.topRight,
                child: Switch.adaptive(
                  value: isActive,
                  onChanged: onToggle,
                  activeThumbColor: strategy.color,
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          // Name + description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strategy.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                strategy.description,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive
                      ? strategy.color.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        isActive ? strategy.color : AppColors.textTertiary,
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
// _RecentTradeRow
// ─────────────────────────────────────────────────────────────────────────────

class _RecentTradeRow extends StatelessWidget {
  const _RecentTradeRow({
    required this.trade,
    required this.isLast,
  });

  final _RecentTrade trade;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isProfit = trade.profit.startsWith('+');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Asset icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isProfit
                      ? AppColors.successSurface
                      : AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isProfit
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isProfit ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Asset + exchange
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trade.asset,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trade.exchangePair,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Profit + time + status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    trade.profit,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color:
                          isProfit ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        trade.timeAgo,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      StatusChip(
                        label:
                            trade.status == StatusType.success
                                ? 'Profit'
                                : 'Loss',
                        type: trade.status,
                        compact: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 66,
            endIndent: 16,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoRow (used in bottom sheet)
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
