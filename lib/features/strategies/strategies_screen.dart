import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/mini_chart.dart';

// ─────────────────────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────────────────────

enum StrategyCategory { all, indian, crypto, forex }

class _StrategyData {
  const _StrategyData({
    required this.name,
    required this.category,
    required this.description,
    required this.winRate,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.performance,
    required this.sparkData,
    this.isPaperTrading = true,
    this.isBrokerConnected = true,
  });

  final String name;
  final StrategyCategory category;
  final String description;
  final double winRate;
  final double maxDrawdown;
  final double sharpeRatio;
  final double performance;
  final List<double> sparkData;
  final bool isPaperTrading;
  final bool isBrokerConnected;
}

// ─────────────────────────────────────────────────────────────
//  Sample data
// ─────────────────────────────────────────────────────────────

const List<_StrategyData> _strategies = [
  _StrategyData(
    name: 'Momentum Breakout',
    category: StrategyCategory.indian,
    description:
        'Identifies high-momentum breakout setups in NSE mid-cap stocks using volume-price confluence.',
    winRate: 72.4,
    maxDrawdown: 8.2,
    sharpeRatio: 1.84,
    performance: 18.6,
    sparkData: [4, 5, 4.5, 6, 5.8, 7, 6.5, 8, 7.8, 9.2, 10, 11.2],
  ),
  _StrategyData(
    name: 'BTC Scalper Pro',
    category: StrategyCategory.crypto,
    description:
        'High-frequency scalping strategy for BTC/USDT on Binance, targeting 0.3–0.8% moves per trade.',
    winRate: 68.1,
    maxDrawdown: 12.4,
    sharpeRatio: 1.42,
    performance: 34.2,
    sparkData: [10, 12, 9, 14, 13, 16, 15, 18, 20, 19, 22, 25],
  ),
  _StrategyData(
    name: 'MACD Crossover',
    category: StrategyCategory.indian,
    description:
        'Classic MACD signal crossover with RSI confirmation on Nifty 50 constituents, daily timeframe.',
    winRate: 65.8,
    maxDrawdown: 6.1,
    sharpeRatio: 1.67,
    performance: 12.3,
    sparkData: [5, 5.5, 6, 5.8, 6.5, 7, 6.8, 7.5, 8, 8.2, 9, 9.5],
    isPaperTrading: false,
  ),
  _StrategyData(
    name: 'RSI Reversal',
    category: StrategyCategory.forex,
    description:
        'Mean-reversion entries on oversold/overbought RSI extremes for EUR/USD and GBP/JPY pairs.',
    winRate: 61.2,
    maxDrawdown: 9.8,
    sharpeRatio: 1.21,
    performance: -4.1,
    sparkData: [8, 7.5, 9, 8, 7, 8.5, 7.2, 6.8, 7.5, 6.5, 7, 6.8],
    isBrokerConnected: false,
  ),
  _StrategyData(
    name: 'Algo Mean Reversion',
    category: StrategyCategory.indian,
    description:
        'Statistical arbitrage across correlated Nifty sectors using z-score band reversion signals.',
    winRate: 75.0,
    maxDrawdown: 5.4,
    sharpeRatio: 2.1,
    performance: 22.5,
    sparkData: [6, 7, 6.5, 8, 9, 8.5, 10, 11, 10.5, 12, 13, 14],
    isPaperTrading: false,
  ),
];

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────

class StrategiesScreen extends StatefulWidget {
  const StrategiesScreen({super.key});

  @override
  State<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends State<StrategiesScreen> {
  StrategyCategory _selectedFilter = StrategyCategory.all;

  // Tracks which strategies are active (by index in _strategies list)
  final Map<int, bool> _activeStates = {
    0: true,
    1: true,
    2: false,
    3: false,
    4: true,
  };

  List<_StrategyData> get _filtered {
    if (_selectedFilter == StrategyCategory.all) return _strategies;
    return _strategies
        .where((s) => s.category == _selectedFilter)
        .toList();
  }

  List<int> get _filteredIndices {
    if (_selectedFilter == StrategyCategory.all) {
      return List.generate(_strategies.length, (i) => i);
    }
    final result = <int>[];
    for (int i = 0; i < _strategies.length; i++) {
      if (_strategies[i].category == _selectedFilter) result.add(i);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final filteredIndices = _filteredIndices;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Filter chips
          _buildFilterChips(),
          // Strategy count subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: SectionHeader(
              title: '${filtered.length} Strateg${filtered.length == 1 ? 'y' : 'ies'} Found',
              subtitle: 'Tap the switch to activate or deactivate',
              actionLabel: 'Import',
              onAction: () {},
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, listIdx) {
                final strategy = filtered[listIdx];
                final originalIdx = filteredIndices[listIdx];
                final isActive = _activeStates[originalIdx] ?? false;
                return _StrategyCard(
                  strategy: strategy,
                  isActive: isActive,
                  onToggle: (val) {
                    setState(() => _activeStates[originalIdx] = val);
                  },
                );
              },
            ),
          ),
        ],
      ),
      // FAB to create new strategy
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.white),
        label: Text(
          'New Strategy',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Strategies',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Manage & activate your algo strategies',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.divider),
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = [
      (StrategyCategory.all, 'All'),
      (StrategyCategory.indian, 'Indian'),
      (StrategyCategory.crypto, 'Crypto'),
      (StrategyCategory.forex, 'Forex'),
    ];

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        child: Row(
          children: filters.map((entry) {
            final (cat, label) = entry;
            final isSelected = _selectedFilter == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Strategy card
// ─────────────────────────────────────────────────────────────

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.isActive,
    required this.onToggle,
  });

  final _StrategyData strategy;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  String get _categoryLabel {
    return switch (strategy.category) {
      StrategyCategory.indian => 'Indian',
      StrategyCategory.crypto => 'Crypto',
      StrategyCategory.forex => 'Forex',
      StrategyCategory.all => 'All',
    };
  }

  StatusType get _categoryChipType {
    return switch (strategy.category) {
      StrategyCategory.indian => StatusType.info,
      StrategyCategory.crypto => StatusType.warning,
      StrategyCategory.forex => StatusType.success,
      StrategyCategory.all => StatusType.neutral,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = strategy.performance >= 0;
    final perfColor =
        isPositive ? AppColors.chartPositive : AppColors.chartNegative;
    final perfSign = isPositive ? '+' : '';

    return SinhaXCard(
      elevation: 1,
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active stripe indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? AppColors.primaryGradient
                    : [AppColors.border, AppColors.divider],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Name + Category chip ──────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Strategy icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_graph_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strategy.name,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          StatusChip(
                            label: _categoryLabel,
                            type: _categoryChipType,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                    // Performance badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppColors.successSurface
                            : AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 13,
                            color: perfColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$perfSign${strategy.performance.abs().toStringAsFixed(1)}%',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: perfColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Description ──────────────────────────────────────
                Text(
                  strategy.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Metrics row ──────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        label: 'Win Rate',
                        value: '${strategy.winRate.toStringAsFixed(1)}%',
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBox(
                        label: 'Max DD',
                        value: '${strategy.maxDrawdown.toStringAsFixed(1)}%',
                        icon: Icons.show_chart_rounded,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBox(
                        label: 'Sharpe',
                        value: strategy.sharpeRatio.toStringAsFixed(2),
                        icon: Icons.speed_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Divider ──────────────────────────────────────────
                Container(height: 1, color: AppColors.divider),

                const SizedBox(height: 12),

                // ── Bottom row: Toggle + chips + sparkline ───────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Activate switch
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isActive ? 'Active' : 'Inactive',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.success
                                : AppColors.textTertiary,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: isActive,
                            onChanged: onToggle,
                            activeThumbColor: AppColors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: AppColors.white,
                            inactiveTrackColor: AppColors.border,
                            trackOutlineColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 6),

                    // Status chips
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (strategy.isPaperTrading)
                            _CustomChip(
                              label: 'Paper Trading',
                              bgColor: const Color(0xFFFFF7ED),
                              textColor: const Color(0xFFEA580C),
                            ),
                          if (strategy.isBrokerConnected)
                            _CustomChip(
                              label: 'Broker Connected',
                              bgColor: AppColors.successSurface,
                              textColor: AppColors.success,
                            )
                          else
                            _CustomChip(
                              label: 'No Broker',
                              bgColor: AppColors.errorSurface,
                              textColor: AppColors.error,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Sparkline
                    MiniSparkline(
                      data: strategy.sparkData,
                      positive: isPositive,
                      width: 60,
                      height: 32,
                      strokeWidth: 1.8,
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

// ─────────────────────────────────────────────────────────────
//  Metric box widget
// ─────────────────────────────────────────────────────────────

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Custom inline chip
// ─────────────────────────────────────────────────────────────

class _CustomChip extends StatelessWidget {
  const _CustomChip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
