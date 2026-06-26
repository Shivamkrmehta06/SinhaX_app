import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/market_selection_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/markets/markets_screen.dart';
import '../../features/screener/screener_screen.dart';
import '../../features/arbitrage/arbitrage_screen.dart';
import '../../features/backtest/backtest_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/trades/trades_screen.dart';

CustomTransitionPage<T> _build3dPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curveAnim = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curveAnim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.05), // Starts slightly lower
            end: Offset.zero,
          ).animate(curveAnim),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',            pageBuilder: (c, s) => _build3dPage(child: const SplashScreen(), state: s)),
    GoRoute(path: '/landing',           pageBuilder: (c, s) => _build3dPage(child: const LandingScreen(), state: s)),
    GoRoute(path: '/login',             pageBuilder: (c, s) => _build3dPage(child: const LoginScreen(), state: s)),
    GoRoute(path: '/market-selection',  pageBuilder: (c, s) => _build3dPage(child: const MarketSelectionScreen(), state: s)),
    GoRoute(path: '/home',              pageBuilder: (c, s) => _build3dPage(child: const HomeShell(), state: s)),
    GoRoute(path: '/markets',           pageBuilder: (c, s) => _build3dPage(child: const MarketsScreen(), state: s)),
    GoRoute(path: '/screener',          pageBuilder: (c, s) => _build3dPage(child: const ScreenerScreen(), state: s)),
    GoRoute(path: '/arbitrage',         pageBuilder: (c, s) => _build3dPage(child: const ArbitrageScreen(), state: s)),
    GoRoute(path: '/backtest',          pageBuilder: (c, s) => _build3dPage(child: const BacktestScreen(), state: s)),
    GoRoute(path: '/settings',          pageBuilder: (c, s) => _build3dPage(child: const SettingsScreen(), state: s)),
    GoRoute(path: '/trades',            pageBuilder: (c, s) => _build3dPage(child: const TradesScreen(), state: s)),
  ],
);
