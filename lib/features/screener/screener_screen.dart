import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/screener_provider.dart';
import '../../shared/widgets/status_chip.dart';

// ---------------------------------------------------------------------------
// Filter chips config
// ---------------------------------------------------------------------------

const _filterChips = [
  'All',
  'Bullish',
  'Bearish',
  'RSI Oversold',
  'MACD Cross',
  'Volume Spike',
  '52W High',
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ScreenerScreen extends ConsumerStatefulWidget {
  const ScreenerScreen({super.key});

  @override
  ConsumerState<ScreenerScreen> createState() => _ScreenerScreenState();
}

class _ScreenerScreenState extends ConsumerState<ScreenerScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _query = _search.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<ScreenerRow> _getFiltered(List<ScreenerRow> allRows) {
    var list = allRows.where((r) {
      if (_query.isNotEmpty) {
        return r.symbol.toLowerCase().contains(_query);
      }
      return true;
    }).toList();

    return switch (_activeFilter) {
      'Bullish'      => list.where((r) => r.signal == 'Bullish').toList(),
      'Bearish'      => list.where((r) => r.signal == 'Bearish').toList(),
      'RSI Oversold' => list.where((r) => r.rsi < 40).toList(),
      'Volume Spike' => list.where((r) => r.volume.contains('M') &&
          double.tryParse(r.volume.replaceAll('M', ''))! > 10).toList(),
      _              => list,
    };
  }

  @override
  Widget build(BuildContext context) {
    final allRows = ref.watch(screenerProvider);
    final rows = _getFiltered(allRows);
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: _buildAppBar(context, isDark),
      body: Column(
        children: [
          // ── Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _buildSearchBar(context, isDark),
          ),

          // ── Filter Chips
          _buildFilterChips(context),

          // ── Results summary row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Text(
                  '${rows.length} stocks found',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text2(context),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurfaceColor(context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 10, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Live',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Table header
          _buildTableHeader(context),

          // ── Results
          Expanded(
            child: rows.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: rows.length,
                    itemBuilder: (context, i) =>
                        _buildTableRow(context, rows[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: AppColors.card(context),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () { if (context.canPop()) { context.pop(); } else { context.go('/home'); } },
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.text1(context), size: 18),
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'Smart Screener',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.text1(context),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderColor(context)),
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: TextField(
        controller: _search,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.text1(context),
        ),
        decoration: InputDecoration(
          hintText: 'Search symbols — RELIANCE, TCS…',
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.text3(context),
          ),
          prefixIcon: Icon(Icons.search_rounded,
              color: AppColors.text2(context), size: 18),
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () => _search.clear(),
                  child: Icon(Icons.close_rounded,
                      color: AppColors.text2(context), size: 16),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  // ── Filter Chips ──────────────────────────────────────────────────────────

  Widget _buildFilterChips(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        itemCount: _filterChips.length,
        itemBuilder: (context, i) {
          final chip = _filterChips[i];
          final isSelected = _activeFilter == chip;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.card(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderColor(context),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                chip,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppColors.text2(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Table Header ──────────────────────────────────────────────────────────

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        border: Border(
          top: BorderSide(color: AppColors.borderColor(context)),
          bottom: BorderSide(color: AppColors.borderColor(context)),
        ),
      ),
      child: Row(
        children: [
          _headerCell('Symbol',   flex: 2, context: context),
          _headerCell('LTP',      flex: 2, context: context, align: TextAlign.right),
          _headerCell('Chg%',     flex: 2, context: context, align: TextAlign.right),
          _headerCell('Volume',   flex: 2, context: context, align: TextAlign.right),
          _headerCell('RSI',      flex: 1, context: context, align: TextAlign.right),
          _headerCell('Signal',   flex: 2, context: context, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _headerCell(String label,
      {required int flex,
      required BuildContext context,
      TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.text3(context),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Table Row ─────────────────────────────────────────────────────────────

  Widget _buildTableRow(BuildContext context, ScreenerRow row, int index) {
    final isGain = row.changePct >= 0;
    final changeColor = isGain
        ? AppColors.gainColor(context)
        : AppColors.lossColor(context);

    StatusType chipType;
    if (row.signal == 'Bullish') {
      chipType = StatusType.success;
    } else if (row.signal == 'Bearish') {
      chipType = StatusType.error;
    } else {
      chipType = StatusType.neutral;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: index.isEven
            ? AppColors.bg(context)
            : AppColors.card(context).withValues(alpha: 0.6),
        border: Border(
          bottom: BorderSide(
              color: AppColors.borderColor(context), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Symbol
          Expanded(
            flex: 2,
            child: Text(
              row.symbol,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.text1(context),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // LTP
          Expanded(
            flex: 2,
            child: Text(
              '₹${row.ltp >= 1000 ? row.ltp.toStringAsFixed(0) : row.ltp.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.text1(context),
              ),
            ),
          ),
          // Change%
          Expanded(
            flex: 2,
            child: Text(
              '${isGain ? '+' : ''}${row.changePct.toStringAsFixed(2)}%',
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: changeColor,
              ),
            ),
          ),
          // Volume
          Expanded(
            flex: 2,
            child: Text(
              row.volume,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.text2(context),
              ),
            ),
          ),
          // RSI
          Expanded(
            flex: 1,
            child: Text(
              row.rsi.toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: row.rsi < 40
                    ? AppColors.lossColor(context)
                    : row.rsi > 70
                        ? AppColors.gainColor(context)
                        : AppColors.text2(context),
              ),
            ),
          ),
          // Signal chip
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: StatusChip(
                label: row.signal,
                type: chipType,
                compact: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySurfaceColor(context),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 14),
          Text(
            'No stocks found',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.text1(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your filters or search',
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
