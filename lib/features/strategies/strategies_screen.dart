import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/strategy_provider.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/mini_chart.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StrategiesScreen
// ─────────────────────────────────────────────────────────────────────────────

class StrategiesScreen extends ConsumerStatefulWidget {
  const StrategiesScreen({super.key});

  @override
  ConsumerState<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends ConsumerState<StrategiesScreen> {
  @override
  Widget build(BuildContext context) {
    final strategies = ref.watch(strategyProvider);

    final activeCount =
        strategies.where((s) => s.status == StrategyStatus.active).length;
    final avgReturn = strategies.isEmpty
        ? 0.0
        : strategies.map((s) => s.returnsPct).reduce((a, b) => a + b) /
            strategies.length;
    final bestSharpe = strategies.isEmpty
        ? 0.0
        : strategies.map((s) => s.sharpe).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // ── Summary row ──────────────────────────────────────────────────
          _SummaryRow(
            activeCount: activeCount,
            avgReturn: avgReturn,
            bestSharpe: bestSharpe,
          ),

          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SectionHeader(
              title: '${strategies.length} '
                  'Strateg${strategies.length == 1 ? 'y' : 'ies'}',
              subtitle: 'Tap the switch to toggle status',
              actionLabel: 'Import',
              onAction: () {},
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: strategies.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final strategy = strategies[i];
                return _StrategyCard(
                  strategy: strategy,
                  onToggle: () =>
                      ref.read(strategyProvider.notifier).toggleStatus(strategy.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Strategy builder coming soon!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
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
      backgroundColor: AppColors.card(context),
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
              color: AppColors.text1(context),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Manage & activate your algo strategies',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.text2(context),
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySurfaceColor(context),
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
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderColor(context)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary row — 3 mini stat chips
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.activeCount,
    required this.avgReturn,
    required this.bestSharpe,
  });

  final int activeCount;
  final double avgReturn;
  final double bestSharpe;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card(context),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.play_circle_rounded,
            label: 'Active',
            value: '$activeCount',
            color: AppColors.gainColor(context),
            bgColor: AppColors.gainSurface(context),
          ),
          const SizedBox(width: 10),
          _SummaryChip(
            icon: Icons.trending_up_rounded,
            label: 'Avg Return',
            value:
                '${avgReturn >= 0 ? '+' : ''}${avgReturn.toStringAsFixed(1)}%',
            color: avgReturn >= 0
                ? AppColors.gainColor(context)
                : AppColors.lossColor(context),
            bgColor: avgReturn >= 0
                ? AppColors.gainSurface(context)
                : AppColors.lossSurfaceColor(context),
          ),
          const SizedBox(width: 10),
          _SummaryChip(
            icon: Icons.speed_rounded,
            label: 'Best Sharpe',
            value: bestSharpe.toStringAsFixed(2),
            color: AppColors.primary,
            bgColor: AppColors.primarySurfaceColor(context),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: color.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Strategy Card
// ─────────────────────────────────────────────────────────────────────────────

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.onToggle,
  });

  final Strategy strategy;
  final VoidCallback onToggle;

  StatusType get _statusType => switch (strategy.status) {
        StrategyStatus.active => StatusType.success,
        StrategyStatus.paused => StatusType.warning,
        StrategyStatus.stopped => StatusType.error,
      };

  String get _statusLabel => switch (strategy.status) {
        StrategyStatus.active => 'Active',
        StrategyStatus.paused => 'Paused',
        StrategyStatus.stopped => 'Stopped',
      };

  bool get _isActive => strategy.status == StrategyStatus.active;
  bool get _isStopped => strategy.status == StrategyStatus.stopped;

  @override
  Widget build(BuildContext context) {
    final isUp = strategy.returnsPct >= 0;
    final returnColor =
        isUp ? AppColors.gainColor(context) : AppColors.lossColor(context);
    final returnSurface =
        isUp ? AppColors.gainSurface(context) : AppColors.lossSurfaceColor(context);
    final cardOpacity = _isStopped ? 0.55 : 1.0;

    return Opacity(
      opacity: cardOpacity,
      child: SinhaXCard(
        elevation: 1,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active stripe
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isActive
                      ? [strategy.color, strategy.color.withValues(alpha: 0.6)]
                      : [
                          AppColors.borderColor(context),
                          AppColors.borderColor(context)
                        ],
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
                  // ── Name + type badge ──────────────────────────────────
                  Row(
                    children: [
                      // Icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: strategy.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.auto_graph_rounded,
                          color: strategy.color,
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
                                color: AppColors.text1(context),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              strategy.type,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.text2(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Returns badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: returnSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUp
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 13,
                              color: returnColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${isUp ? '+' : ''}${strategy.returnsPct.toStringAsFixed(1)}%',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: returnColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Description ────────────────────────────────────────
                  Text(
                    strategy.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: AppColors.text2(context),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Sparkline (small, colored by strategy.color) ───────
                  SizedBox(
                    height: 44,
                    child: MiniSparkline(
                      data: strategy.sparkline,
                      positive: isUp,
                      width: double.infinity,
                      height: 44,
                      strokeWidth: 1.8,
                      showFill: true,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Stats row ──────────────────────────────────────────
                  Row(
                    children: [
                      _MetricBox(
                        label: 'Returns',
                        value:
                            '${isUp ? '+' : ''}${strategy.returnsPct.toStringAsFixed(1)}%',
                        color: returnColor,
                      ),
                      const SizedBox(width: 8),
                      _MetricBox(
                        label: 'Trades',
                        value: '${strategy.trades}',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _MetricBox(
                        label: 'Win Rate',
                        value: '${strategy.winRate.toStringAsFixed(1)}%',
                        color: AppColors.gainColor(context),
                      ),
                      const SizedBox(width: 8),
                      _MetricBox(
                        label: 'Sharpe',
                        value: strategy.sharpe.toStringAsFixed(2),
                        color: AppColors.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Divider(height: 1, color: AppColors.borderColor(context)),

                  const SizedBox(height: 12),

                  // ── Bottom: toggle + status chip ───────────────────────
                  Row(
                    children: [
                      // Status chip
                      StatusChip(
                        label: _statusLabel,
                        type: _statusType,
                        compact: true,
                      ),
                      const Spacer(),
                      // Toggle switch
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _isActive ? 'Running' : 'Disabled',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _isActive
                                  ? AppColors.gainColor(context)
                                  : AppColors.text3(context),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: _isActive,
                              onChanged: (_) => onToggle(),
                              activeThumbColor: AppColors.white,
                              activeTrackColor: strategy.color,
                              inactiveThumbColor: AppColors.white,
                              inactiveTrackColor: AppColors.borderColor(context),
                              trackOutlineColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric Box
// ─────────────────────────────────────────────────────────────────────────────

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.text3(context),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
