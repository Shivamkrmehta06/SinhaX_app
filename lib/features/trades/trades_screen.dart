import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/trades_provider.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';

class TradesScreen extends ConsumerStatefulWidget {
  const TradesScreen({super.key});

  @override
  ConsumerState<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends ConsumerState<TradesScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<String> _filters = [
    'All',
    'Executed',
    'Pending',
    'Cancelled',
  ];

  List<TradeModel> _filteredTrades(List<TradeModel> allTrades) {
    return allTrades.where((trade) {
      // Status filter
      final matchesFilter = switch (_selectedFilter) {
        'Executed' => trade.status == TradeStatus.executed,
        'Pending' => trade.status == TradeStatus.pending,
        'Cancelled' => trade.status == TradeStatus.cancelled,
        _ => true,
      };

      // Search filter
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          trade.symbol.toLowerCase().contains(q) ||
          trade.strategy.toLowerCase().contains(q);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // Summary counts
  int _executedCount(List<TradeModel> allTrades) =>
      allTrades.where((t) => t.status == TradeStatus.executed).length;
  int _pendingCount(List<TradeModel> allTrades) =>
      allTrades.where((t) => t.status == TradeStatus.pending).length;
  int _cancelledCount(List<TradeModel> allTrades) =>
      allTrades.where((t) => t.status == TradeStatus.cancelled).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTrades = ref.watch(tradesProvider).trades;
    final filtered = _filteredTrades(allTrades);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Search + filters (sticky)
          _buildSearchAndFilters(context),
          // Summary strip
          _buildSummaryStrip(context, allTrades),
          // Trade list
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _TradeCard(trade: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ───────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card(context),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Text(
        'Trade History',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.text1(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppColors.primarySurfaceColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            tooltip: 'Export Trades',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Exporting trade history…',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.text1(context),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderColor(context)),
      ),
    );
  }

  // ── Search bar + Filter chips ─────────────────
  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      color: AppColors.card(context),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          TextFormField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v.trim()),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.text1(context),
            ),
            decoration: InputDecoration(
              hintText: 'Search symbol or strategy…',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.text3(context),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.text2(context),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.text3(context),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.bg(context),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderColor(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderColor(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final selected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: filter,
                    selected: selected,
                    onTap: () => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Summary strip ─────────────────────────────
  Widget _buildSummaryStrip(BuildContext context, List<TradeModel> allTrades) {
    return Container(
      color: AppColors.card(context),
      child: Column(
        children: [
          Divider(height: 1, color: AppColors.borderColor(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _SummaryStat(
                  label: 'Total',
                  value: '${allTrades.length}',
                  valueColor: AppColors.text1(context),
                ),
                _buildVerticalDivider(context),
                _SummaryStat(
                  label: 'Executed',
                  value: '${_executedCount(allTrades)}',
                  valueColor: AppColors.gainColor(context),
                ),
                _buildVerticalDivider(context),
                _SummaryStat(
                  label: 'Pending',
                  value: '${_pendingCount(allTrades)}',
                  valueColor: AppColors.warning,
                ),
                _buildVerticalDivider(context),
                _SummaryStat(
                  label: 'Cancelled',
                  value: '${_cancelledCount(allTrades)}',
                  valueColor: AppColors.text2(context),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.borderColor(context)),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.borderColor(context),
    );
  }

  // ── Empty state ───────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
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
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No trades found',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.text1(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filter.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.text2(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter Chip Widget
// ─────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.bg(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderColor(context),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                selected ? AppColors.textOnPrimary : AppColors.text2(context),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Summary Stat Widget
// ─────────────────────────────────────────────

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.text3(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Trade Card Widget
// ─────────────────────────────────────────────

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeModel trade;

  // ── Type badge: BUY=blue, SELL=red ─────────
  Widget _buildTypeBadge(BuildContext context) {
    final isBuy = trade.type == TradeType.buy;
    final color = isBuy ? AppColors.primary : AppColors.lossColor(context);
    final bgColor = isBuy ? AppColors.primarySurfaceColor(context) : AppColors.lossSurfaceColor(context);
    final label = isBuy ? 'BUY' : 'SELL';
    final icon = isBuy ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── P&L colour ──────────────────────────────
  Color _pnlColor(BuildContext context) {
    final pnl = trade.pnl;
    if (pnl == null) return AppColors.text3(context);
    return pnl.startsWith('+') ? AppColors.gainColor(context) : AppColors.lossColor(context);
  }

  // ── Status ──────────────────────────────────
  StatusType _statusType() => switch (trade.status) {
        TradeStatus.executed => StatusType.success,
        TradeStatus.pending => StatusType.warning,
        TradeStatus.cancelled => StatusType.neutral,
      };

  String _statusLabel() => switch (trade.status) {
        TradeStatus.executed => 'Executed',
        TradeStatus.pending => 'Pending',
        TradeStatus.cancelled => 'Cancelled',
      };

  // ── Price detail column ─────────────────────
  Widget _buildPriceDetail(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.text3(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text1(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPnl = trade.pnl != null;
    final hasExit = trade.exitPrice != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SinhaXCard(
        elevation: 1,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Symbol + Strategy + Date ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Symbol icon accent
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurfaceColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        trade.symbol.substring(0, 1),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Symbol + Strategy
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trade.symbol,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text1(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trade.strategy,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.text2(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Date + time (right-aligned)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trade.dateTime.split(',').first,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text2(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trade.dateTime.contains(',')
                            ? trade.dateTime.split(',').last.trim()
                            : '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.text3(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: AppColors.borderColor(context)),
            ),
            const SizedBox(height: 12),

            // ── Row 2: Type badge + Qty + Status chip ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTypeBadge(context),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bg(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.borderColor(context)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Qty ',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.text3(context),
                          ),
                        ),
                        Text(
                          trade.qty,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text1(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  StatusChip(
                    label: _statusLabel(),
                    type: _statusType(),
                    icon: switch (trade.status) {
                      TradeStatus.executed => Icons.check_circle_outline_rounded,
                      TradeStatus.pending => Icons.schedule_rounded,
                      TradeStatus.cancelled => Icons.cancel_outlined,
                    },
                    compact: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: AppColors.borderColor(context)),
            ),
            const SizedBox(height: 12),

            // ── Row 3: Entry / Exit / P&L ──────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  _buildPriceDetail(context, 'Entry Price', trade.entryPrice),
                  Container(
                    width: 1,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: AppColors.borderColor(context),
                  ),
                  _buildPriceDetail(
                    context,
                    'Exit Price',
                    hasExit ? trade.exitPrice! : '--',
                  ),
                  const Spacer(),
                  if (hasPnl)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _pnlColor(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trade.pnl!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _pnlColor(context),
                        ),
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
