import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/mini_chart.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';

// ---------------------------------------------------------------------------
// Backtest Screen
// ---------------------------------------------------------------------------

class BacktestScreen extends StatefulWidget {
  const BacktestScreen({super.key});

  @override
  State<BacktestScreen> createState() => _BacktestScreenState();
}

class _BacktestScreenState extends State<BacktestScreen>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  bool _hasResults = true;
  bool _isRunning = false;

  String _selectedStrategy = 'Momentum Breakout';
  String _selectedSymbol = 'NIFTY 50';
  String _selectedTimeframe = '15 Min';
  double _riskPercent = 2.0;

  DateTime _startDate = DateTime(2023, 1, 1);
  DateTime _endDate = DateTime(2023, 12, 31);

  final _capitalController =
      TextEditingController(text: '10,00,000');

  late AnimationController _runAnimController;

  // ── Static data ───────────────────────────────────────────────────────────
  static const List<String> _strategies = [
    'Momentum Breakout',
    'MACD Crossover',
    'RSI Reversal',
    'BTC Scalper',
  ];

  static const List<String> _symbols = [
    'NIFTY 50',
    'RELIANCE',
    'TCS',
    'BTC/USDT',
  ];

  static const List<String> _timeframes = [
    '1 Min',
    '5 Min',
    '15 Min',
    '1 Hour',
    '1 Day',
  ];

  // Equity curve – upward trend with realistic dips
  static const List<double> _equityCurveData = [
    10.0, 10.3, 10.8, 10.5, 11.1, 11.6, 11.3, 12.0, 12.4, 11.9,
    12.7, 13.1, 12.8, 13.5, 14.0, 13.6, 14.3, 14.8, 14.4, 15.1,
    15.6, 15.2, 15.8, 16.3, 15.9, 16.7, 17.2, 16.8, 17.5, 18.0,
    17.5, 18.2, 18.8, 18.4, 19.0, 19.6, 19.1, 19.8, 20.4, 20.0,
    20.7, 21.3, 20.8, 21.5, 22.1, 21.7, 22.4, 23.0, 22.6, 23.4,
    24.0, 23.5, 24.2, 24.8, 24.4, 25.1, 25.7, 25.2, 25.9, 26.4,
  ];

  // Monthly returns for bar chart (some negative months for realism)
  static const List<double> _monthlyReturns = [
    3.2, 5.1, -1.8, 4.6, 6.3, -2.4,
    7.1, 3.8, 5.9, -1.2, 4.4, 2.8,
  ];

  static const List<String> _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Sample trade log
  static const List<_TradeEntry> _trades = [
    _TradeEntry('NIFTY 50', '₹19,420', '₹19,680', '50', '+₹13,000', true),
    _TradeEntry('NIFTY 50', '₹19,710', '₹19,540', '50', '-₹8,500', false),
    _TradeEntry('NIFTY 50', '₹19,880', '₹20,310', '50', '+₹21,500', true),
    _TradeEntry('NIFTY 50', '₹20,150', '₹20,490', '50', '+₹17,000', true),
    _TradeEntry('NIFTY 50', '₹20,640', '₹20,510', '50', '-₹6,500', false),
  ];

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _runAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

  }

  @override
  void dispose() {
    _capitalController.dispose();
    _runAnimController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> _runBacktest() async {
    setState(() {
      _isRunning = true;
      _hasResults = false;
    });
    _runAnimController.repeat();
    await Future.delayed(const Duration(seconds: 2));
    _runAnimController.stop();
    if (mounted) {
      setState(() {
        _isRunning = false;
        _hasResults = true;
      });
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      builder: (ctx, child) => _datePickerTheme(ctx, child),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (ctx, child) => _datePickerTheme(ctx, child),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Widget _datePickerTheme(BuildContext ctx, Widget? child) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.textPrimary,
        ),
      ),
      child: child!,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Configuration ──────────────────────────────────────────────
            _buildConfigCard(),
            const SizedBox(height: 24),

            // ── Results ────────────────────────────────────────────────────
            if (_hasResults) ...[
              _buildResultsBanner(),
              const SizedBox(height: 20),
              _buildStatsGrid(),
              const SizedBox(height: 20),
              _buildEquityCurveCard(),
              const SizedBox(height: 16),
              _buildMonthlyReturnsCard(),
              const SizedBox(height: 16),
              _buildTradeLogCard(),
              const SizedBox(height: 16),
              _buildInterpretationCards(),
            ],
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.science_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backtest Engine',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Simulate strategies on historical data',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded,
                color: AppColors.textSecondary),
            tooltip: 'History',
          ),
        ),
      ],
    );
  }

  // ── Configuration Card ────────────────────────────────────────────────────
  Widget _buildConfigCard() {
    return SinhaXCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Strategy Configuration',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Strategy Dropdown
          _buildDropdownField(
            label: 'Strategy',
            icon: Icons.auto_graph_rounded,
            value: _selectedStrategy,
            items: _strategies,
            onChanged: (v) => setState(() => _selectedStrategy = v!),
          ),
          const SizedBox(height: 14),

          // Symbol & Timeframe row
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Symbol',
                  icon: Icons.candlestick_chart_rounded,
                  value: _selectedSymbol,
                  items: _symbols,
                  onChanged: (v) => setState(() => _selectedSymbol = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'Timeframe',
                  icon: Icons.access_time_rounded,
                  value: _selectedTimeframe,
                  items: _timeframes,
                  onChanged: (v) => setState(() => _selectedTimeframe = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Date Range
          _buildLabel('Date Range', Icons.date_range_rounded),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDateButton('Start', _startDate, _pickStartDate)),
              const SizedBox(width: 12),
              Expanded(child: _buildDateButton('End', _endDate, _pickEndDate)),
            ],
          ),
          const SizedBox(height: 14),

          // Risk Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Risk Per Trade', Icons.shield_rounded),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_riskPercent.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.white,
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
                elevation: 3,
              ),
              trackHeight: 4,
            ),
            child: Slider(
              value: _riskPercent,
              min: 0,
              max: 10,
              divisions: 20,
              onChanged: (v) => setState(() => _riskPercent = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textTertiary)),
              Text('Conservative  ·  Moderate  ·  Aggressive',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textTertiary)),
              Text('10%',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 14),

          // Starting Capital
          _buildLabel('Starting Capital', Icons.account_balance_rounded),
          const SizedBox(height: 8),
          TextFormField(
            controller: _capitalController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
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
          const SizedBox(height: 20),

          // Run Backtest Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isRunning ? null : _runBacktest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isRunning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Running Simulation…',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_circle_rounded,
                              color: AppColors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Run Backtest',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Results Banner ────────────────────────────────────────────────────────
  Widget _buildResultsBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Backtest Results',
          action: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_download_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Export',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GradientCard(
          gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Return',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '+28.4%',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+₹2,84,000 on ₹10,00,000 capital',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildBannerPill('247 Trades', Icons.swap_horiz_rounded),
                  const SizedBox(height: 8),
                  _buildBannerPill('Jan – Dec 2023', Icons.calendar_today_rounded),
                  const SizedBox(height: 8),
                  _buildBannerPill(_selectedStrategy, Icons.auto_graph_rounded),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Grid 2×4 ────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    const stats = [
      _StatItem('Win Rate', '72.4%', Icons.emoji_events_rounded,
          AppColors.success, true),
      _StatItem('Profit Factor', '2.31', Icons.trending_up_rounded,
          AppColors.primary, true),
      _StatItem('Max Drawdown', '8.2%', Icons.trending_down_rounded,
          AppColors.error, false),
      _StatItem('Sharpe Ratio', '1.84', Icons.bar_chart_rounded,
          AppColors.primary, true),
      _StatItem('Total Trades', '247', Icons.swap_horiz_rounded,
          AppColors.textSecondary, true),
      _StatItem('Avg R:R', '1 : 1.8', Icons.balance_rounded,
          AppColors.warning, true),
      _StatItem('Best Trade', '+₹38,400', Icons.arrow_circle_up_rounded,
          AppColors.success, true),
      _StatItem('Worst Trade', '-₹8,200', Icons.arrow_circle_down_rounded,
          AppColors.error, false),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) {
        final s = stats[i];
        return StatCard(
          label: s.label,
          value: s.value,
          icon: s.icon,
          iconColor: s.color,
          valueColor: s.positive ? s.color : AppColors.error,
          compact: true,
        );
      },
    );
  }

  // ── Equity Curve ──────────────────────────────────────────────────────────
  Widget _buildEquityCurveCard() {
    return SinhaXCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Equity Curve',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Portfolio value over backtest period',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const StatusChip(
                label: 'Simulated',
                type: StatusType.info,
                icon: Icons.science_rounded,
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Legend
          Row(
            children: [
              _buildLegendDot(AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'Portfolio Value (₹ Lakhs)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LineChartWidget(
            data: _equityCurveData,
            height: 200,
            showGrid: true,
            fillGradient: true,
          ),
        ],
      ),
    );
  }

  // ── Monthly Returns ───────────────────────────────────────────────────────
  Widget _buildMonthlyReturnsCard() {
    return SinhaXCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Returns',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildLegendDot(AppColors.success),
                  const SizedBox(width: 3),
                  Text('Profit',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textTertiary)),
                  const SizedBox(width: 8),
                  _buildLegendDot(AppColors.error),
                  const SizedBox(width: 3),
                  Text('Loss',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const BarChartWidget(
            data: _monthlyReturns,
            height: 120,
            labels: _monthLabels,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildReturnPill('Best Month', '+7.1%', AppColors.success),
              _buildReturnPill('Avg Month', '+3.4%', AppColors.primary),
              _buildReturnPill('Worst Month', '-2.4%', AppColors.error),
              _buildReturnPill('Profitable', '9 / 12', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  // ── Trade Log Table ───────────────────────────────────────────────────────
  Widget _buildTradeLogCard() {
    return SinhaXCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Trade Log',
            subtitle: '${_trades.length} sample trades shown',
            action: GestureDetector(
              onTap: () {},
              child: Text(
                'View All 247',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Table Header
          _buildTableHeader(),
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 4),

          // Table Rows
          ...List.generate(_trades.length, (i) {
            return Column(
              children: [
                _buildTradeRow(_trades[i]),
                if (i < _trades.length - 1)
                  Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: AppColors.divider),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    const headers = ['Symbol', 'Entry', 'Exit', 'Qty', 'P&L'];
    const flex = [2, 2, 2, 1, 2];
    return Row(
      children: List.generate(headers.length, (i) {
        return Expanded(
          flex: flex[i],
          child: Text(
            headers[i],
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
            textAlign: i == headers.length - 1 ? TextAlign.end : TextAlign.start,
          ),
        );
      }),
    );
  }

  Widget _buildTradeRow(_TradeEntry t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              t.symbol,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.entry,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.exit,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t.qty,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.pnl,
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: t.positive ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Interpretation Cards ──────────────────────────────────────────────────
  Widget _buildInterpretationCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result Interpretation',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildInterpCard(
          icon: Icons.verified_rounded,
          iconColor: AppColors.success,
          bgColor: AppColors.successSurface,
          title: 'Strategy Performance',
          badge: 'Good',
          badgeType: StatusType.success,
          lines: const [
            '• Win rate of 72.4% is significantly above the 50% breakeven threshold.',
            '• Profit factor of 2.31 indicates strong edge — every ₹1 risked returns ₹2.31.',
            '• Sharpe ratio of 1.84 reflects excellent risk-adjusted returns.',
          ],
        ),
        const SizedBox(height: 12),
        _buildInterpCard(
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.warning,
          bgColor: AppColors.warningSurface,
          title: 'Risk Analysis',
          badge: 'Moderate',
          badgeType: StatusType.warning,
          lines: const [
            '• Max drawdown of 8.2% is within acceptable bounds (< 10% is ideal).',
            '• At 2% risk per trade, capital protection is adequate.',
            '• Consider reducing risk to 1% to lower worst-case drawdown further.',
          ],
        ),
        const SizedBox(height: 12),
        _buildInterpCard(
          icon: Icons.lightbulb_rounded,
          iconColor: AppColors.primary,
          bgColor: AppColors.primarySurface,
          title: 'Optimization Tips',
          badge: 'Insights',
          badgeType: StatusType.info,
          lines: const [
            '• Try 5-Min timeframe — higher signal frequency may improve total trades.',
            '• Add ATR-based stop-loss to reduce worst-trade impact.',
            '• Combine with volume filter to avoid false breakouts in choppy markets.',
          ],
        ),
      ],
    );
  }

  Widget _buildInterpCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String badge,
    required StatusType badgeType,
    required List<String> lines,
  }) {
    return SinhaXCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              StatusChip(label: badge, type: badgeType),
            ],
          ),
          const SizedBox(height: 12),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                line,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, icon),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }

  Widget _buildDateButton(
      String type, DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded,
                size: 15, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${date.day.toString().padLeft(2, '0')} '
                    '${_monthAbbr(date.month)} ${date.year}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _monthAbbr(int month) {
    const abbrs = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return abbrs[month - 1];
  }
}

// ---------------------------------------------------------------------------
// Local data models
// ---------------------------------------------------------------------------

class _StatItem {
  const _StatItem(this.label, this.value, this.icon, this.color, this.positive);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool positive;
}

class _TradeEntry {
  const _TradeEntry(
      this.symbol, this.entry, this.exit, this.qty, this.pnl, this.positive);
  final String symbol;
  final String entry;
  final String exit;
  final String qty;
  final String pnl;
  final bool positive;
}
