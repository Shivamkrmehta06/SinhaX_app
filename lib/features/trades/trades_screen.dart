import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────

enum TradeType { buy, sell }

enum TradeStatus { executed, pending, cancelled }

class TradeModel {
  const TradeModel({
    required this.symbol,
    required this.strategy,
    required this.dateTime,
    required this.type,
    required this.qty,
    required this.status,
    required this.entryPrice,
    this.exitPrice,
    this.pnl,
  });

  final String symbol;
  final String strategy;
  final String dateTime;
  final TradeType type;
  final String qty;
  final TradeStatus status;
  final String entryPrice;
  final String? exitPrice;
  final String? pnl; // e.g. "+₹3,700" or "-₹625"
}

// ─────────────────────────────────────────────
// Sample Data
// ─────────────────────────────────────────────

const List<TradeModel> _allTrades = [
  TradeModel(
    symbol: 'NIFTY23DEC',
    strategy: 'Momentum Breakout',
    dateTime: '16 Jun, 09:32 AM',
    type: TradeType.buy,
    qty: '50',
    status: TradeStatus.executed,
    entryPrice: '₹19,850',
    exitPrice: '₹19,924',
    pnl: '+₹3,700',
  ),
  TradeModel(
    symbol: 'RELIANCE',
    strategy: 'MACD Crossover',
    dateTime: '16 Jun, 10:15 AM',
    type: TradeType.sell,
    qty: '100',
    status: TradeStatus.executed,
    entryPrice: '₹2,934',
    exitPrice: '₹2,898',
    pnl: '+₹3,600',
  ),
  TradeModel(
    symbol: 'BTC/USDT',
    strategy: 'BTC Scalper',
    dateTime: '16 Jun, 11:00 AM',
    type: TradeType.buy,
    qty: '0.5',
    status: TradeStatus.pending,
    entryPrice: '₹67,200',
    exitPrice: null,
    pnl: null,
  ),
  TradeModel(
    symbol: 'TCS',
    strategy: 'RSI Reversal',
    dateTime: '15 Jun, 03:12 PM',
    type: TradeType.buy,
    qty: '25',
    status: TradeStatus.executed,
    entryPrice: '₹4,012',
    exitPrice: '₹3,987',
    pnl: '-₹625',
  ),
  TradeModel(
    symbol: 'HDFC',
    strategy: 'Momentum',
    dateTime: '15 Jun, 01:45 PM',
    type: TradeType.sell,
    qty: '75',
    status: TradeStatus.cancelled,
    entryPrice: '₹1,678',
    exitPrice: null,
    pnl: null,
  ),
  TradeModel(
    symbol: 'ETH/USDT',
    strategy: 'Algo Scalper',
    dateTime: '14 Jun, 06:20 PM',
    type: TradeType.buy,
    qty: '2',
    status: TradeStatus.executed,
    entryPrice: '₹3,521',
    exitPrice: '₹3,589',
    pnl: '+₹9,860',
  ),
  TradeModel(
    symbol: 'INFY',
    strategy: 'MACD',
    dateTime: '14 Jun, 02:05 PM',
    type: TradeType.buy,
    qty: '50',
    status: TradeStatus.executed,
    entryPrice: '₹1,789',
    exitPrice: '₹1,812',
    pnl: '+₹1,150',
  ),
  TradeModel(
    symbol: 'BANKEX',
    strategy: 'Breakout',
    dateTime: '13 Jun, 11:30 AM',
    type: TradeType.buy,
    qty: '30',
    status: TradeStatus.pending,
    entryPrice: '₹52,340',
    exitPrice: null,
    pnl: null,
  ),
];

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────

class TradesScreen extends StatefulWidget {
  const TradesScreen({super.key});

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<String> _filters = [
    'All',
    'Executed',
    'Pending',
    'Cancelled',
  ];

  List<TradeModel> get _filteredTrades {
    return _allTrades.where((trade) {
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
  int get _executedCount =>
      _allTrades.where((t) => t.status == TradeStatus.executed).length;
  int get _pendingCount =>
      _allTrades.where((t) => t.status == TradeStatus.pending).length;
  int get _cancelledCount =>
      _allTrades.where((t) => t.status == TradeStatus.cancelled).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTrades;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search + filters (sticky)
          _buildSearchAndFilters(),
          // Summary strip
          _buildSummaryStrip(),
          // Trade list
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
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
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Text(
        'Trade History',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
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
                  backgroundColor: AppColors.textPrimary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }

  // ── Search bar + Filter chips ─────────────────
  Widget _buildSearchAndFilters() {
    return Container(
      color: AppColors.white,
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
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search symbol or strategy…',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textTertiary,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
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
  Widget _buildSummaryStrip() {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _SummaryStat(
                  label: 'Total',
                  value: '${_allTrades.length}',
                  valueColor: AppColors.textPrimary,
                ),
                _buildVerticalDivider(),
                _SummaryStat(
                  label: 'Executed',
                  value: '$_executedCount',
                  valueColor: AppColors.success,
                ),
                _buildVerticalDivider(),
                _SummaryStat(
                  label: 'Pending',
                  value: '$_pendingCount',
                  valueColor: AppColors.warning,
                ),
                _buildVerticalDivider(),
                _SummaryStat(
                  label: 'Cancelled',
                  value: '$_cancelledCount',
                  valueColor: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.border,
    );
  }

  // ── Empty state ───────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filter.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
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
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                selected ? AppColors.textOnPrimary : AppColors.textSecondary,
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
              color: AppColors.textTertiary,
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
  Widget _buildTypeBadge() {
    final isBuy = trade.type == TradeType.buy;
    final color = isBuy ? AppColors.primary : AppColors.error;
    final bgColor = isBuy ? AppColors.primarySurface : AppColors.errorSurface;
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
  Color _pnlColor() {
    final pnl = trade.pnl;
    if (pnl == null) return AppColors.textTertiary;
    return pnl.startsWith('+') ? AppColors.success : AppColors.error;
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
  Widget _buildPriceDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
                      color: AppColors.primarySurface,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trade.strategy,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
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
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trade.dateTime.contains(',')
                            ? trade.dateTime.split(',').last.trim()
                            : '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textTertiary,
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
              child: Divider(height: 1, color: AppColors.divider),
            ),
            const SizedBox(height: 12),

            // ── Row 2: Type badge + Qty + Status chip ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTypeBadge(),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Qty ',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          trade.qty,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
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
              child: Divider(height: 1, color: AppColors.divider),
            ),
            const SizedBox(height: 12),

            // ── Row 3: Entry / Exit / P&L ──────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  _buildPriceDetail('Entry Price', trade.entryPrice),
                  Container(
                    width: 1,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: AppColors.border,
                  ),
                  _buildPriceDetail(
                    'Exit Price',
                    hasExit ? trade.exitPrice! : '—',
                  ),
                  const Spacer(),
                  // P&L pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: hasPnl
                          ? (trade.pnl!.startsWith('+')
                              ? AppColors.successSurface
                              : AppColors.errorSurface)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasPnl) ...[
                          Icon(
                            trade.pnl!.startsWith('+')
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            size: 14,
                            color: _pnlColor(),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          hasPnl ? trade.pnl! : 'Open',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: hasPnl
                                ? _pnlColor()
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
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
