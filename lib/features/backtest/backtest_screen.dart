import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/backtest_provider.dart';
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

class BacktestScreen extends ConsumerStatefulWidget {
  const BacktestScreen({super.key});

  @override
  ConsumerState<BacktestScreen> createState() => _BacktestScreenState();
}

class _BacktestScreenState extends ConsumerState<BacktestScreen>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
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
  static final List<String> _strategies = [
    'Momentum Breakout',
    'MACD Crossover',
    'RSI Reversal',
    'BTC Scalper',
  ];

  static final List<String> _symbols = [
    'NIFTY 50',
    'RELIANCE',
    'TCS',
    'BTC/USDT',
  ];

  static final List<String> _timeframes = [
    '1 Min',
    '5 Min',
    '15 Min',
    '1 Hour',
    '1 Day',
  ];



  static final List<String> _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];


  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _runAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

  }

  @override
  void dispose() {
    _capitalController.dispose();
    _runAnimController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> _runBacktest(bool isRunning) async {
    if (isRunning) return;
    _runAnimController.repeat();
    await ref.read(backtestProvider.notifier).runBacktest(
      strategy: _selectedStrategy,
      symbol: _selectedSymbol,
      timeframe: _selectedTimeframe,
      riskPercent: _riskPercent,
      start: _startDate,
      end: _endDate,
      capital: _capitalController.text,
    );
    _runAnimController.stop();
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
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.card(context),
          surface: AppColors.card(context),
          onSurface: AppColors.text1(context),
        ),
      ),
      child: child!,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Configuration ──────────────────────────────────────────────
            _buildConfigCard(ref.watch(backtestProvider).isRunning),
            SizedBox(height: 24),

            // ── Results ────────────────────────────────────────────────────
            if (ref.watch(backtestProvider).result != null) ...[
              _buildResultsBanner(ref.watch(backtestProvider).result!),
              SizedBox(height: 20),
              _buildStatsGrid(ref.watch(backtestProvider).result!),
              SizedBox(height: 20),
              _buildEquityCurveCard(ref.watch(backtestProvider).result!),
              SizedBox(height: 16),
              _buildMonthlyReturnsCard(ref.watch(backtestProvider).result!),
              SizedBox(height: 16),
              _buildTradeLogCard(ref.watch(backtestProvider).result!),
              SizedBox(height: 16),
              _buildInterpretationCards(ref.watch(backtestProvider).result!),
            ],
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.card(context),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.science_rounded,
              color: AppColors.card(context),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backtest Engine',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
              Text(
                'Simulate strategies on historical data',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.text2(context),
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderColor(context)),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.history_rounded,
                color: AppColors.text2(context)),
            tooltip: 'History',
          ),
        ),
      ],
    );
  }

  // ── Configuration Card ────────────────────────────────────────────────────
  Widget _buildConfigCard(bool isRunning) {
    return SinhaXCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurfaceColor(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.settings_rounded,
                    color: AppColors.primary, size: 18),
              ),
              SizedBox(width: 10),
              Text(
                'Strategy Configuration',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Strategy Dropdown
          _buildDropdownField(
            label: 'Strategy',
            icon: Icons.auto_graph_rounded,
            value: _selectedStrategy,
            items: _strategies,
            onChanged: (v) => setState(() => _selectedStrategy = v!),
          ),
          SizedBox(height: 14),

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
              SizedBox(width: 12),
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
          SizedBox(height: 14),

          // Date Range
          _buildLabel('Date Range', Icons.date_range_rounded),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDateButton('Start', _startDate, _pickStartDate)),
              SizedBox(width: 12),
              Expanded(child: _buildDateButton('End', _endDate, _pickEndDate)),
            ],
          ),
          SizedBox(height: 14),

          // Risk Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Risk Per Trade', Icons.shield_rounded),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurfaceColor(context),
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
          SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.borderColor(context),
              thumbColor: AppColors.card(context),
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              thumbShape: RoundSliderThumbShape(
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
                      fontSize: 10, color: AppColors.text3(context))),
              Text('Conservative  ·  Moderate  ·  Aggressive',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.text3(context))),
              Text('10%',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.text3(context))),
            ],
          ),
          SizedBox(height: 14),

          // Starting Capital
          _buildLabel('Starting Capital', Icons.account_balance_rounded),
          SizedBox(height: 8),
          TextFormField(
            controller: _capitalController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.text1(context),
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.text2(context),
              ),
              filled: true,
              fillColor: AppColors.bg(context),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
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
                    BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Run Backtest Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: ref.watch(backtestProvider).isRunning ? null : () => _runBacktest(ref.watch(backtestProvider).isRunning),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isRunning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.card(context),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Running Simulation…',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.card(context),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_rounded,
                              color: AppColors.card(context), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Run Backtest',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.card(context),
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
  Widget _buildResultsBanner(BacktestResult result) {
    final result = ref.watch(backtestProvider).result!;

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
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor(context)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.file_download_outlined,
                          size: 14, color: AppColors.text2(context)),
                      SizedBox(width: 4),
                      Text(
                        'Export',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text2(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14),
        GradientCard(
          gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
          padding: EdgeInsets.all(20),
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
                    SizedBox(height: 6),
                    Text(
                      result.totalReturn,
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.card(context),
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      result.totalReturnCapital,
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
                  _buildBannerPill('${result.totalTrades} Trades', Icons.swap_horiz_rounded),
                  SizedBox(height: 8),
                  _buildBannerPill('Jan – Dec 2023', Icons.calendar_today_rounded),
                  SizedBox(height: 8),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white),
          SizedBox(width: 5),
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
  Widget _buildStatsGrid(BacktestResult result) {
    final result = ref.watch(backtestProvider).result!;

    final stats = [
      _StatItem('Win Rate', result.winRate, Icons.emoji_events_rounded,
          AppColors.success, true),
      _StatItem('Profit Factor', result.profitFactor, Icons.trending_up_rounded,
          AppColors.primary, true),
      _StatItem('Max Drawdown', result.maxDrawdown, Icons.trending_down_rounded,
          AppColors.error, false),
      _StatItem('Sharpe Ratio', result.sharpeRatio, Icons.bar_chart_rounded,
          AppColors.primary, true),
      _StatItem('Total Trades', result.totalTrades, Icons.swap_horiz_rounded,
          AppColors.text2(context), true),
      _StatItem('Avg R:R', result.avgRR, Icons.balance_rounded,
          AppColors.warning, true),
      _StatItem('Best Trade', result.bestTrade, Icons.arrow_circle_up_rounded,
          AppColors.success, true),
      _StatItem('Worst Trade', result.worstTrade, Icons.arrow_circle_down_rounded,
          AppColors.error, false),
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
  Widget _buildEquityCurveCard(BacktestResult result) {
    final result = ref.watch(backtestProvider).result!;

    return SinhaXCard(
      padding: EdgeInsets.all(20),
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
                        color: AppColors.text1(context),
                      ),
                    ),
                    Text(
                      'Portfolio value over backtest period',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.text2(context),
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: 'Simulated',
                type: StatusType.info,
                icon: Icons.science_rounded,
              ),
            ],
          ),
          SizedBox(height: 4),
          // Legend
          Row(
            children: [
              _buildLegendDot(AppColors.primary),
              SizedBox(width: 4),
              Text(
                'Portfolio Value (₹ Lakhs)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.text3(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          LineChartWidget(
            data: result.equityCurve,
            height: 200,
            showGrid: true,
            fillGradient: true,
          ),
        ],
      ),
    );
  }

  // ── Monthly Returns ───────────────────────────────────────────────────────
  Widget _buildMonthlyReturnsCard(BacktestResult result) {
    final result = ref.watch(backtestProvider).result!;

    return SinhaXCard(
      padding: EdgeInsets.all(20),
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
                  color: AppColors.text1(context),
                ),
              ),
              Row(
                children: [
                  _buildLegendDot(AppColors.success),
                  SizedBox(width: 3),
                  Text('Profit',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.text3(context))),
                  SizedBox(width: 8),
                  _buildLegendDot(AppColors.error),
                  SizedBox(width: 3),
                  Text('Loss',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.text3(context))),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          BarChartWidget(
            data: result.monthlyReturns,
            height: 120,
            labels: _monthLabels,
          ),
          SizedBox(height: 8),
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
        SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            color: AppColors.text3(context),
          ),
        ),
      ],
    );
  }

  // ── Trade Log Table ───────────────────────────────────────────────────────
  Widget _buildTradeLogCard(BacktestResult result) {
    final result = ref.watch(backtestProvider).result!;

    return SinhaXCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Trade Log',
            subtitle: '${result.trades.length} sample trades shown',
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
          SizedBox(height: 16),

          // Table Header
          _buildTableHeader(),
          SizedBox(height: 8),
          Container(height: 1, color: AppColors.borderColor(context)),
          SizedBox(height: 4),

          // Table Rows
          ...List.generate(result.trades.length, (i) {
            return Column(
              children: [
                _buildTradeRow(result.trades[i]),
                if (i < result.trades.length - 1)
                  Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 2),
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
              color: AppColors.text3(context),
              letterSpacing: 0.5,
            ),
            textAlign: i == headers.length - 1 ? TextAlign.end : TextAlign.start,
          ),
        );
      }),
    );
  }

  Widget _buildTradeRow(TradeEntry t) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              t.symbol,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.text1(context),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.entry,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.text2(context)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.exit,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.text2(context)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t.qty,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.text2(context)),
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
  Widget _buildInterpretationCards(BacktestResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result Interpretation',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.text1(context),
          ),
        ),
        SizedBox(height: 12),
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
        SizedBox(height: 12),
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
        SizedBox(height: 12),
        _buildInterpCard(
          icon: Icons.lightbulb_rounded,
          iconColor: AppColors.primary,
          bgColor: AppColors.primarySurfaceColor(context),
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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1(context),
                  ),
                ),
              ),
              StatusChip(label: badge, type: badgeType),
            ],
          ),
          SizedBox(height: 12),
          ...lines.map(
            (line) => Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                line,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.text2(context),
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
        SizedBox(height: 8),
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
                        color: AppColors.text1(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bg(context),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2(context)),
          dropdownColor: AppColors.card(context),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.bg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded,
                size: 15, color: AppColors.primary),
            SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: AppColors.text3(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${date.day.toString().padLeft(2, '0')} '
                    '${_monthAbbr(date.month)} ${date.year}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text1(context),
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
        Icon(icon, size: 13, color: AppColors.text2(context)),
        SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text2(context),
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
  _StatItem(this.label, this.value, this.icon, this.color, this.positive);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool positive;
}

