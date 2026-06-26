import re

# --- BACKTEST SCREEN ---
with open('lib/features/backtest/backtest_screen.dart', 'r') as f:
    bt = f.read()

bt = bt.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../core/providers/backtest_provider.dart';")
bt = bt.replace("class BacktestScreen extends StatefulWidget", "class BacktestScreen extends ConsumerStatefulWidget")
bt = bt.replace("State<BacktestScreen> createState() => _BacktestScreenState();", "ConsumerState<BacktestScreen> createState() => _BacktestScreenState();")
bt = bt.replace("class _BacktestScreenState extends State<BacktestScreen>", "class _BacktestScreenState extends ConsumerState<BacktestScreen>")

bt = re.sub(r'  bool _hasResults = true;\n  bool _isRunning = false;\n\n', '', bt)
# We only want to remove the specific mock data arrays and _TradeEntry class, leaving _strategies, _symbols, _timeframes, _monthLabels.
bt = re.sub(r'  // Equity curve.*?  \];\n', '', bt, flags=re.DOTALL)
bt = re.sub(r'  // Monthly returns.*?  \];\n', '', bt, flags=re.DOTALL)
bt = re.sub(r'  // Sample trade log.*?  \];\n', '', bt, flags=re.DOTALL)
bt = re.sub(r'class _TradeEntry \{.*?\}\n\n', '', bt, flags=re.DOTALL)
bt = bt.replace('_TradeEntry', 'TradeEntry')

run_bt_replacement = """  Future<void> _runBacktest() async {
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
  }"""
bt = re.sub(r'  Future<void> _runBacktest\(\) async \{.*?\n  \}', run_bt_replacement, bt, flags=re.DOTALL)

bt = bt.replace("  Widget build(BuildContext context) {", "  Widget build(BuildContext context) {\n    final _isRunning = ref.watch(backtestProvider).isRunning;\n    final _hasResults = ref.watch(backtestProvider).result != null;", 1)

bt = bt.replace("Widget _buildResultsBanner() {", "Widget _buildResultsBanner() {\n    final result = ref.watch(backtestProvider).result!;\n")
bt = bt.replace("Widget _buildStatsGrid() {", "Widget _buildStatsGrid() {\n    final result = ref.watch(backtestProvider).result!;\n")
bt = bt.replace("Widget _buildEquityCurveCard() {", "Widget _buildEquityCurveCard() {\n    final result = ref.watch(backtestProvider).result!;\n")
bt = bt.replace("Widget _buildMonthlyReturnsCard() {", "Widget _buildMonthlyReturnsCard() {\n    final result = ref.watch(backtestProvider).result!;\n")
bt = bt.replace("Widget _buildTradeLogCard() {", "Widget _buildTradeLogCard() {\n    final result = ref.watch(backtestProvider).result!;\n")

bt = bt.replace("_monthlyReturns", "result.monthlyReturns")
bt = bt.replace("_equityCurveData", "result.equityCurve")
bt = bt.replace("_trades", "result.trades")
bt = bt.replace("'+28.4%'", "result.totalReturn")
bt = bt.replace("'+₹2,84,000 on ₹10,00,000 capital'", "result.totalReturnCapital")
bt = bt.replace("'72.4%'", "result.winRate")
bt = bt.replace("'2.31'", "result.profitFactor")
bt = bt.replace("'8.2%'", "result.maxDrawdown")
bt = bt.replace("'1.84'", "result.sharpeRatio")
bt = bt.replace("'247'", "result.totalTrades")
bt = bt.replace("'1 : 1.8'", "result.avgRR")
bt = bt.replace("'+₹38,400'", "result.bestTrade")
bt = bt.replace("'-₹8,200'", "result.worstTrade")
bt = bt.replace("'247 Trades'", "'${result.totalTrades} Trades'")

with open('lib/features/backtest/backtest_screen.dart', 'w') as f:
    f.write(bt)


# --- SETTINGS SCREEN ---
with open('lib/features/settings/settings_screen.dart', 'r') as f:
    st = f.read()

st = st.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../core/providers/user_provider.dart';")

st = st.replace("class SettingsScreen extends StatefulWidget", "class SettingsScreen extends ConsumerStatefulWidget")
st = st.replace("State<SettingsScreen> createState() => _SettingsScreenState();", "ConsumerState<SettingsScreen> createState() => _SettingsScreenState();")
st = st.replace("class _SettingsScreenState extends State<SettingsScreen>", "class _SettingsScreenState extends ConsumerState<SettingsScreen>")

st = re.sub(r'class _BrokerInfo \{.*?\}\n', '', st, flags=re.DOTALL)
st = re.sub(r'class _PlanInfo \{.*?\}\n', '', st, flags=re.DOTALL)
st = st.replace('_BrokerInfo', 'BrokerInfo')
st = st.replace('_PlanInfo', 'PlanInfo')

st = re.sub(r'  late List<BrokerInfo> _brokers;.*?\n  static const _plans = \[.*?\];\n', '', st, flags=re.DOTALL)
st = re.sub(r'    _brokers = \[.*?\];\n', '', st, flags=re.DOTALL)

# Make tabs ConsumerWidgets
st = st.replace("class _ProfileTab extends StatelessWidget {", "class _ProfileTab extends ConsumerWidget {")
st = st.replace("class _AvatarSection extends StatelessWidget {", "class _AvatarSection extends ConsumerWidget {")
st = st.replace("class _BrokersTab extends StatelessWidget {", "class _BrokersTab extends ConsumerWidget {")
st = st.replace("class _PlansTab extends StatelessWidget {", "class _PlansTab extends ConsumerWidget {")

# Instead of blindly replacing all builds, be careful
st = re.sub(r'(class _ProfileTab extends ConsumerWidget \{.*?)(Widget build\(BuildContext context\))', r'\1Widget build(BuildContext context, WidgetRef ref)', st, flags=re.DOTALL)
st = re.sub(r'(class _AvatarSection extends ConsumerWidget \{.*?)(Widget build\(BuildContext context\))', r'\1Widget build(BuildContext context, WidgetRef ref)', st, flags=re.DOTALL)
st = re.sub(r'(class _BrokersTab extends ConsumerWidget \{.*?)(Widget build\(BuildContext context\))', r'\1Widget build(BuildContext context, WidgetRef ref)', st, flags=re.DOTALL)
st = re.sub(r'(class _PlansTab extends ConsumerWidget \{.*?)(Widget build\(BuildContext context\))', r'\1Widget build(BuildContext context, WidgetRef ref)', st, flags=re.DOTALL)

# Connect state
st = st.replace("class _BrokersTab extends ConsumerWidget {\n  const _BrokersTab({\n    required this.brokers,\n    required this.selectedFilter,\n    required this.onFilterChanged,\n    required this.onToggleConnection,\n  });\n\n  final List<BrokerInfo> brokers;", "class _BrokersTab extends ConsumerWidget {\n  const _BrokersTab({\n    required this.selectedFilter,\n    required this.onFilterChanged,\n  });\n")
st = st.replace("  final void Function(int) onToggleConnection;", "")

st = st.replace("          _BrokersTab(\n            brokers: _brokers,\n            selectedFilter: _selectedBrokerFilter,\n            onFilterChanged: (f) =>\n                setState(() => _selectedBrokerFilter = f),\n            onToggleConnection: (idx) => setState(() {\n              final b = _brokers[idx];\n              _brokers[idx] = BrokerInfo(\n                name: b.name,\n                api: b.api,\n                category: b.category,\n                avatarColor: b.avatarColor,\n                connected: !b.connected,\n              );\n            }),\n          ),", "          _BrokersTab(\n            selectedFilter: _selectedBrokerFilter,\n            onFilterChanged: (f) => setState(() => _selectedBrokerFilter = f),\n          ),")

st = st.replace("    final filtered = brokers\n        .asMap()", "    final brokers = ref.watch(userProvider).brokers;\n    final filtered = brokers\n        .asMap()")
st = st.replace("                  onToggle: () => onToggleConnection(entry.key),", "                  onToggle: () => ref.read(userProvider.notifier).toggleBrokerConnection(entry.key),")

st = st.replace("          const _PlansTab(plans: _plans),", "          const _PlansTab(),")
st = st.replace("class _PlansTab extends ConsumerWidget {\n  const _PlansTab({required this.plans});\n  final List<PlanInfo> plans;", "class _PlansTab extends ConsumerWidget {\n  const _PlansTab({super.key});")
st = st.replace("Widget build(BuildContext context, WidgetRef ref) {\n    return SingleChildScrollView", "Widget build(BuildContext context, WidgetRef ref) {\n    final plans = ref.watch(userProvider).plans;\n    return SingleChildScrollView")

# Inside _ProfileTab, replace hardcoded names with userState
st = st.replace("'Shivam Mehta'", "ref.watch(userProvider).user.name")
st = st.replace("'Pro Plan'", "ref.watch(userProvider).user.planType")
st = st.replace("ref.watch(userProvider).user.name", "ref.watch(userProvider).user.name", 1) # First occurrence is _nameCtrl

st = st.replace("final _nameCtrl = TextEditingController(text: ref.watch(userProvider).user.name);", "final _nameCtrl = TextEditingController(text: 'Shivam Mehta');")

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(st)

print("Done")
