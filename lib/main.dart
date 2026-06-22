import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinhax_mobile/core/constants/app_constants.dart';
import 'package:sinhax_mobile/core/theme/app_theme.dart';
import 'package:sinhax_mobile/features/splash/splash_screen.dart';
import 'package:sinhax_mobile/features/landing/landing_screen.dart';
import 'package:sinhax_mobile/features/auth/login_screen.dart';
import 'package:sinhax_mobile/features/auth/market_selection_screen.dart';
import 'package:sinhax_mobile/features/home/home_shell.dart';
import 'package:sinhax_mobile/features/markets/markets_screen.dart';
import 'package:sinhax_mobile/features/screener/screener_screen.dart';
import 'package:sinhax_mobile/features/arbitrage/arbitrage_screen.dart';
import 'package:sinhax_mobile/features/backtest/backtest_screen.dart';
import 'package:sinhax_mobile/features/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SinhaXApp());
}

class SinhaXApp extends StatelessWidget {
  const SinhaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/market-selection': (context) => const MarketSelectionScreen(),
        '/home': (context) => const HomeShell(),
        '/markets': (context) => const MarketsScreen(),
        '/screener': (context) => const ScreenerScreen(),
        '/arbitrage': (context) => const ArbitrageScreen(),
        '/backtest': (context) => const BacktestScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
