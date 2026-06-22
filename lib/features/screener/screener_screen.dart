import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/sinhax_card.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

enum _Prediction { bullish, bearish, neutral }

class _StockPrediction {
  const _StockPrediction({
    required this.ticker,
    required this.name,
    required this.sector,
    required this.price,
    required this.prediction,
    required this.confidence,
    required this.bullishPct,
    required this.bearishPct,
    required this.rsi,
    required this.macd,
    required this.bbSignal,
    required this.signals,
    required this.trend,
    required this.sparkData,
  });

  final String ticker;
  final String name;
  final String sector;
  final String price;
  final _Prediction prediction;
  final double confidence; // 0-1
  final double bullishPct;
  final double bearishPct;
  final double rsi;
  final double macd;
  final String bbSignal;
  final List<String> signals;
  final String trend;
  final List<double> sparkData;
}

// ---------------------------------------------------------------------------
// Sample data
// ---------------------------------------------------------------------------

const List<_StockPrediction> _stocks = [
  _StockPrediction(
    ticker: 'RELIANCE',
    name: 'Reliance Industries',
    sector: 'Energy',
    price: '₹2,934',
    prediction: _Prediction.bullish,
    confidence: 0.87,
    bullishPct: 0.87,
    bearishPct: 0.13,
    rsi: 64.2,
    macd: 0.45,
    bbSignal: 'BB Mid',
    signals: ['200 EMA Support', 'Volume Spike', 'Breakout Pattern'],
    trend: 'Uptrend',
    sparkData: [2820, 2841, 2869, 2855, 2890, 2910, 2934],
  ),
  _StockPrediction(
    ticker: 'TCS',
    name: 'Tata Consultancy',
    sector: 'IT',
    price: '₹4,012',
    prediction: _Prediction.bullish,
    confidence: 0.92,
    bullishPct: 0.92,
    bearishPct: 0.08,
    rsi: 71.8,
    macd: 0.82,
    bbSignal: 'BB Upper',
    signals: ['Golden Cross', 'RSI Momentum', 'Institutional Buy'],
    trend: 'Strong Uptrend',
    sparkData: [3840, 3870, 3920, 3960, 3985, 4000, 4012],
  ),
  _StockPrediction(
    ticker: 'HDFC',
    name: 'HDFC Bank',
    sector: 'Banking',
    price: '₹1,678',
    prediction: _Prediction.bearish,
    confidence: 0.63,
    bullishPct: 0.37,
    bearishPct: 0.63,
    rsi: 38.4,
    macd: -0.23,
    bbSignal: 'BB Lower',
    signals: ['Death Cross', 'Volume Drop', 'Resistance Hit'],
    trend: 'Downtrend',
    sparkData: [1740, 1730, 1720, 1710, 1695, 1683, 1678],
  ),
  _StockPrediction(
    ticker: 'INFY',
    name: 'Infosys Ltd',
    sector: 'IT',
    price: '₹1,789',
    prediction: _Prediction.bullish,
    confidence: 0.76,
    bullishPct: 0.76,
    bearishPct: 0.24,
    rsi: 58.6,
    macd: 0.31,
    bbSignal: 'BB Mid',
    signals: ['50 EMA Bounce', 'MACD Crossover', 'Ascending Triangle'],
    trend: 'Uptrend',
    sparkData: [1720, 1735, 1749, 1762, 1770, 1782, 1789],
  ),
  _StockPrediction(
    ticker: 'WIPRO',
    name: 'Wipro Ltd',
    sector: 'IT',
    price: '₹552',
    prediction: _Prediction.neutral,
    confidence: 0.58,
    bullishPct: 0.52,
    bearishPct: 0.48,
    rsi: 51.2,
    macd: 0.04,
    bbSignal: 'BB Mid',
    signals: ['Sideways Channel', 'Low Volume', 'Consolidation'],
    trend: 'Sideways',
    sparkData: [546, 549, 547, 551, 548, 553, 552],
  ),
  _StockPrediction(
    ticker: 'ICICIBANK',
    name: 'ICICI Bank',
    sector: 'Banking',
    price: '₹1,124',
    prediction: _Prediction.bullish,
    confidence: 0.81,
    bullishPct: 0.81,
    bearishPct: 0.19,
    rsi: 62.7,
    macd: 0.56,
    bbSignal: 'BB Upper',
    signals: ['Cup & Handle', 'FII Buying', '200 DMA Support'],
    trend: 'Strong Uptrend',
    sparkData: [1070, 1085, 1094, 1102, 1110, 1118, 1124],
  ),
  _StockPrediction(
    ticker: 'AXISBANK',
    name: 'Axis Bank',
    sector: 'Banking',
    price: '₹1,189',
    prediction: _Prediction.bearish,
    confidence: 0.69,
    bullishPct: 0.31,
    bearishPct: 0.69,
    rsi: 42.1,
    macd: -0.38,
    bbSignal: 'BB Lower',
    signals: ['Head & Shoulders', 'MACD Negative', 'Support Break'],
    trend: 'Downtrend',
    sparkData: [1240, 1228, 1218, 1210, 1201, 1194, 1189],
  ),
  _StockPrediction(
    ticker: 'BHARTIARTL',
    name: 'Bharti Airtel',
    sector: 'Telecom',
    price: '₹1,456',
    prediction: _Prediction.bullish,
    confidence: 0.88,
    bullishPct: 0.88,
    bearishPct: 0.12,
    rsi: 66.3,
    macd: 0.72,
    bbSignal: 'BB Upper',
    signals: ['52-Week High', 'Strong Momentum', 'Volume Breakout'],
    trend: 'Strong Uptrend',
    sparkData: [1380, 1398, 1412, 1425, 1438, 1447, 1456],
  ),
];

// ---------------------------------------------------------------------------
// Filter options
// ---------------------------------------------------------------------------

enum _FilterOption { all, bullish, bearish, neutral, strongSignal }

extension _FilterLabel on _FilterOption {
  String get label {
    return switch (this) {
      _FilterOption.all => 'All',
      _FilterOption.bullish => 'Bullish',
      _FilterOption.bearish => 'Bearish',
      _FilterOption.neutral => 'Neutral',
      _FilterOption.strongSignal => 'Strong Signal',
    };
  }

  IconData get icon {
    return switch (this) {
      _FilterOption.all => Icons.dashboard_rounded,
      _FilterOption.bullish => Icons.trending_up_rounded,
      _FilterOption.bearish => Icons.trending_down_rounded,
      _FilterOption.neutral => Icons.trending_flat_rounded,
      _FilterOption.strongSignal => Icons.bolt_rounded,
    };
  }
}

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------

class ScreenerScreen extends StatefulWidget {
  const ScreenerScreen({super.key});

  @override
  State<ScreenerScreen> createState() => _ScreenerScreenState();
}

class _ScreenerScreenState extends State<ScreenerScreen>
    with SingleTickerProviderStateMixin {
  _FilterOption _selectedFilter = _FilterOption.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  List<_StockPrediction> get _filtered {
    var list = _stocks.where((s) {
      if (_searchQuery.isNotEmpty) {
        return s.ticker.toLowerCase().contains(_searchQuery) ||
            s.name.toLowerCase().contains(_searchQuery);
      }
      return true;
    }).toList();

    return switch (_selectedFilter) {
      _FilterOption.all => list,
      _FilterOption.bullish =>
        list.where((s) => s.prediction == _Prediction.bullish).toList(),
      _FilterOption.bearish =>
        list.where((s) => s.prediction == _Prediction.bearish).toList(),
      _FilterOption.neutral =>
        list.where((s) => s.prediction == _Prediction.neutral).toList(),
      _FilterOption.strongSignal =>
        list.where((s) => s.confidence >= 0.80).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Subtitle banner
          SliverToBoxAdapter(child: _buildSubtitleBanner()),

          // ── Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: _buildSearchBar(),
            ),
          ),

          // ── Filter chips
          SliverToBoxAdapter(
            child: _buildFilterChips(),
          ),

          // ── Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} stocks found',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            size: 10, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'AI Updated',
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
          ),

          // ── Grid of prediction cards
          filtered.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.42,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _PredictionCard(stock: filtered[index]),
                  ),
                ),
        ],
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'Smart Screener',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        _FilterActionButton(),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.border,
        ),
      ),
    );
  }

  // ── Subtitle Banner ────────────────────────────────────────────────────────

  Widget _buildSubtitleBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primaryLight.withValues(alpha: 0.04),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_rounded,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'AI-powered stock prediction & signal analysis',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Live',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 44,
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
      child: TextFormField(
        controller: _searchController,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search stocks — e.g. RELIANCE, TCS…',
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () => _searchController.clear(),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary, size: 16),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  // ── Filter Chips ───────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        children: _FilterOption.values.map((option) {
          final isSelected = _selectedFilter == option;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.border,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option.icon,
                    size: 13,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    option.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

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
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'No stocks found',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your filters or search query',
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

// ---------------------------------------------------------------------------
// Filter Action Button
// ---------------------------------------------------------------------------

class _FilterActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterSheet(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.tune_rounded,
            color: AppColors.primary, size: 18),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 16),
            Text(
              'Advanced Filters',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coming soon — RSI range, sector, market cap filters',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual Prediction Card
// ---------------------------------------------------------------------------

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.stock});

  final _StockPrediction stock;

  Color get _predColor => switch (stock.prediction) {
        _Prediction.bullish => AppColors.success,
        _Prediction.bearish => AppColors.error,
        _Prediction.neutral => AppColors.warning,
      };

  Color get _predSurface => switch (stock.prediction) {
        _Prediction.bullish => AppColors.successSurface,
        _Prediction.bearish => AppColors.errorSurface,
        _Prediction.neutral => AppColors.warningSurface,
      };

  String get _predLabel => switch (stock.prediction) {
        _Prediction.bullish => 'BULLISH',
        _Prediction.bearish => 'BEARISH',
        _Prediction.neutral => 'NEUTRAL',
      };

  IconData get _predIcon => switch (stock.prediction) {
        _Prediction.bullish => Icons.arrow_upward_rounded,
        _Prediction.bearish => Icons.arrow_downward_rounded,
        _Prediction.neutral => Icons.remove_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return SinhaXCard(
      padding: const EdgeInsets.all(12),
      elevation: 1,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: ticker + sector ──────────────────────────────────────
          _buildHeader(),
          const SizedBox(height: 8),

          // ── Price ────────────────────────────────────────────────────────
          _buildPrice(),
          const SizedBox(height: 8),

          // ── Sparkline ────────────────────────────────────────────────────
          _buildSparkline(),
          const SizedBox(height: 8),

          // ── AI Prediction Badge ──────────────────────────────────────────
          _buildPredictionBadge(),
          const SizedBox(height: 8),

          // ── Confidence bar ───────────────────────────────────────────────
          _buildConfidenceBar(),
          const SizedBox(height: 10),

          // ── Bullish / Bearish bars ───────────────────────────────────────
          _buildSentimentBars(),
          const SizedBox(height: 10),

          // ── Divider ──────────────────────────────────────────────────────
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),

          // ── Indicators ───────────────────────────────────────────────────
          _buildIndicators(),
          const SizedBox(height: 8),

          // ── Signals ──────────────────────────────────────────────────────
          _buildSignals(),
          const SizedBox(height: 8),

          // ── Trend badge ──────────────────────────────────────────────────
          _buildTrendBadge(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                stock.ticker,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _predSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(_predIcon, color: _predColor, size: 14),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          stock.name,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            stock.sector,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Price ─────────────────────────────────────────────────────────────────

  Widget _buildPrice() {
    return Text(
      stock.price,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  // ── Sparkline ─────────────────────────────────────────────────────────────

  Widget _buildSparkline() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 38,
        child: MiniSparkline(
          data: stock.sparkData,
          positive: stock.prediction != _Prediction.bearish,
          width: double.infinity,
          height: 38,
          strokeWidth: 1.8,
        ),
      ),
    );
  }

  // ── Prediction Badge ──────────────────────────────────────────────────────

  Widget _buildPredictionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _predSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _predColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_predIcon, color: _predColor, size: 11),
          const SizedBox(width: 4),
          Text(
            _predLabel,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: _predColor,
              letterSpacing: 0.4,
            ),
          ),
          const Spacer(),
          Text(
            '${(stock.confidence * 100).toInt()}%',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: _predColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Confidence Bar ────────────────────────────────────────────────────────

  Widget _buildConfidenceBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(stock.confidence * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: stock.confidence,
            minHeight: 5,
            backgroundColor: AppColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ── Sentiment Bars ────────────────────────────────────────────────────────

  Widget _buildSentimentBars() {
    return Column(
      children: [
        _SentimentBar(
          label: 'Bull',
          value: stock.bullishPct,
          color: AppColors.success,
        ),
        const SizedBox(height: 5),
        _SentimentBar(
          label: 'Bear',
          value: stock.bearishPct,
          color: AppColors.error,
        ),
      ],
    );
  }

  // ── Indicators ────────────────────────────────────────────────────────────

  Widget _buildIndicators() {
    final macdStr =
        stock.macd >= 0 ? '+${stock.macd.toStringAsFixed(2)}' : stock.macd.toStringAsFixed(2);
    final macdColor =
        stock.macd >= 0 ? AppColors.success : AppColors.error;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _IndicatorChip(label: 'RSI ${stock.rsi.toStringAsFixed(1)}'),
        _IndicatorChip(
            label: 'MACD $macdStr', valueColor: macdColor),
        _IndicatorChip(label: stock.bbSignal),
      ],
    );
  }

  // ── Signals ───────────────────────────────────────────────────────────────

  Widget _buildSignals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stock.signals
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _predColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Trend Badge ───────────────────────────────────────────────────────────

  Widget _buildTrendBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _predColor.withValues(alpha: 0.12),
            _predColor.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        stock.trend,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: _predColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper sub-widgets
// ---------------------------------------------------------------------------

class _SentimentBar extends StatelessWidget {
  const _SentimentBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 28,
          child: Text(
            '${(value * 100).toInt()}%',
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  const _IndicatorChip({
    required this.label,
    this.valueColor,
  });

  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: valueColor ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}
