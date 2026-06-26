import re

with open('lib/features/backtest/backtest_screen.dart', 'r') as f:
    bt = f.read()

# Fix _isRunning in class level by reading state directly where needed
# _runBacktest uses _isRunning
bt = bt.replace("final _isRunning = ref.watch(backtestProvider).isRunning;\n    final _hasResults = ref.watch(backtestProvider).result != null;", "")

# Replace all `_isRunning` with `ref.watch(backtestProvider).isRunning` in build or config card
# But wait, config card is built inside `build`. So I can do:
bt = bt.replace("  Widget _buildConfigCard() {", "  Widget _buildConfigCard(bool _isRunning) {")
bt = bt.replace("_buildConfigCard(),", "_buildConfigCard(ref.watch(backtestProvider).isRunning),")

bt = bt.replace("  Future<void> _runBacktest() async {", "  Future<void> _runBacktest(bool _isRunning) async {\n    if (_isRunning) return;")
bt = bt.replace("_isRunning ? null : _runBacktest,", "ref.watch(backtestProvider).isRunning ? null : () => _runBacktest(ref.watch(backtestProvider).isRunning),")

# Replace `_hasResults` in build
bt = bt.replace("if (_hasResults) ...[", "if (ref.watch(backtestProvider).result != null) ...[")

# Fix _buildResultsBanner uses result
bt = bt.replace("Widget _buildResultsBanner() {", "Widget _buildResultsBanner(BacktestResult result) {")
bt = bt.replace("Widget _buildStatsGrid() {", "Widget _buildStatsGrid(BacktestResult result) {")
bt = bt.replace("Widget _buildEquityCurveCard() {", "Widget _buildEquityCurveCard(BacktestResult result) {")
bt = bt.replace("Widget _buildMonthlyReturnsCard() {", "Widget _buildMonthlyReturnsCard(BacktestResult result) {")
bt = bt.replace("Widget _buildTradeLogCard() {", "Widget _buildTradeLogCard(BacktestResult result) {")
bt = bt.replace("Widget _buildInterpretationCards() {", "Widget _buildInterpretationCards(BacktestResult result) {")

# Ensure _TradeEntry is completely removed
bt = re.sub(r'class TradeEntry \{.*?\}\n', '', bt, flags=re.DOTALL)

# In _buildStatsGrid, remove 'const' from 'const stats = ['
bt = bt.replace("const stats = [", "final stats = [")

# Fix _buildInterpretationCards usages
bt = bt.replace("_buildInterpretationCards(),", "_buildInterpretationCards(ref.watch(backtestProvider).result!),")

with open('lib/features/backtest/backtest_screen.dart', 'w') as f:
    f.write(bt)


with open('lib/features/settings/settings_screen.dart', 'r') as f:
    st = f.read()

# Fix unused variable plans
st = st.replace("final plans = ref.watch(userProvider).plans;\n", "")
# It is used as `userState.plans`? Wait, I did `ref.watch(userProvider).plans` in `_PlansTab.build`.

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(st)

print("Fixed")
