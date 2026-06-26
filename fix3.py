import re

with open('lib/features/settings/settings_screen.dart', 'r') as f:
    st = f.read()

# Fix context error in _strengthColor
st = st.replace("Color _strengthColor(int idx) {", "Color _strengthColor(BuildContext context, int idx) {")
st = st.replace("_strengthColor(0),", "_strengthColor(context, 0),")
st = st.replace("_strengthColor(1),", "_strengthColor(context, 1),")
st = st.replace("_strengthColor(2),", "_strengthColor(context, 2),")
st = st.replace("_strengthColor(3),", "_strengthColor(context, 3),")

# Fix const issues in settings
st = st.replace("const BoxDecoration(", "BoxDecoration(")
st = st.replace("const TextStyle(", "TextStyle(")
st = st.replace("const EdgeInsets.", "EdgeInsets.")
st = st.replace("const Border(", "Border(")
st = st.replace("const BoxConstraints(", "BoxConstraints(")
st = st.replace("const _SectionHeader(", "_SectionHeader(")
st = st.replace("const LinearGradient(", "LinearGradient(")
st = st.replace("const CircleAvatar(", "CircleAvatar(")

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(st)

with open('lib/features/backtest/backtest_screen.dart', 'r') as f:
    bt = f.read()

# Fix const issues in backtest
bt = bt.replace("const BoxDecoration(", "BoxDecoration(")
bt = bt.replace("const TextStyle(", "TextStyle(")
bt = bt.replace("const EdgeInsets.", "EdgeInsets.")
bt = bt.replace("const Border(", "Border(")
bt = bt.replace("const _CardHeader(", "_CardHeader(")
bt = bt.replace("const _SectionHeader(", "_SectionHeader(")
bt = bt.replace("const LinearGradient(", "LinearGradient(")

with open('lib/features/backtest/backtest_screen.dart', 'w') as f:
    f.write(bt)

print("Fixed3")
