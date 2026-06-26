import re

with open('lib/features/backtest/backtest_screen.dart', 'r') as f:
    bt = f.read()

# Fix 1 positional argument expected
bt = bt.replace("_buildResultsBanner(),", "_buildResultsBanner(ref.watch(backtestProvider).result!),")
bt = bt.replace("_buildStatsGrid(),", "_buildStatsGrid(ref.watch(backtestProvider).result!),")
bt = bt.replace("_buildEquityCurveCard(),", "_buildEquityCurveCard(ref.watch(backtestProvider).result!),")
bt = bt.replace("_buildMonthlyReturnsCard(),", "_buildMonthlyReturnsCard(ref.watch(backtestProvider).result!),")
bt = bt.replace("_buildTradeLogCard(),", "_buildTradeLogCard(ref.watch(backtestProvider).result!),")

# Fix invalid constant values (LineChartWidget and BarChartWidget that take result values)
bt = bt.replace("const LineChartWidget(", "LineChartWidget(")
bt = bt.replace("const BarChartWidget(", "BarChartWidget(")
bt = bt.replace("const StatusChip(", "StatusChip(")

with open('lib/features/backtest/backtest_screen.dart', 'w') as f:
    f.write(bt)


with open('lib/features/settings/settings_screen.dart', 'r') as f:
    st = f.read()

# Fix undefined plans
st = st.replace("...plans.map", "...ref.watch(userProvider).plans.map")

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(st)

print("Fixed2")
