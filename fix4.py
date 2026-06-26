import re

with open('lib/features/settings/settings_screen.dart', 'r') as f:
    st = f.read()

st = st.replace("_strengthColor(i)", "_strengthColor(context, i)")
st = st.replace("_strengthColor(passwordStrength - 1)", "_strengthColor(context, passwordStrength - 1)")
st = re.sub(r'const (?=[A-Z_])', '', st)

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(st)

with open('lib/features/backtest/backtest_screen.dart', 'r') as f:
    bt = f.read()

bt = re.sub(r'const (?=[A-Z_])', '', bt)

with open('lib/features/backtest/backtest_screen.dart', 'w') as f:
    f.write(bt)
