import re

files = ['lib/features/backtest/backtest_screen.dart', 'lib/features/settings/settings_screen.dart']

for file in files:
    with open(file, 'r') as f:
        content = f.read()
    
    content = content.replace("AppColors.background", "AppColors.bg(context)")
    content = content.replace("AppColors.white", "AppColors.card(context)")
    content = content.replace("AppColors.border", "AppColors.borderColor(context)")
    content = content.replace("AppColors.textPrimary", "AppColors.text1(context)")
    content = content.replace("AppColors.textSecondary", "AppColors.text2(context)")
    content = content.replace("AppColors.textTertiary", "AppColors.text3(context)")
    content = content.replace("AppColors.profit", "AppColors.gainColor(context)")
    content = content.replace("AppColors.profitSurface", "AppColors.gainSurface(context)")
    content = content.replace("AppColors.loss", "AppColors.lossColor(context)")
    content = content.replace("AppColors.lossSurface", "AppColors.lossSurfaceColor(context)")
    content = content.replace("AppColors.primarySurface", "AppColors.primarySurfaceColor(context)")

    with open(file, 'w') as f:
        f.write(content)
print("Color fixes applied")
