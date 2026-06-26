import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/status_chip.dart';

class ArbitrageOpportunity {
  const ArbitrageOpportunity({
    required this.asset,
    required this.exchangeA,
    required this.exchangeB,
    required this.priceA,
    required this.priceB,
    required this.spreadPct,
    required this.expectedProfit,
    required this.windowSeconds,
    required this.sparkData,
  });

  final String asset;
  final String exchangeA;
  final String exchangeB;
  final String priceA;
  final String priceB;
  final String spreadPct;
  final String expectedProfit;
  final int windowSeconds;
  final List<double> sparkData;

  ArbitrageOpportunity copyWith({
    String? asset,
    String? exchangeA,
    String? exchangeB,
    String? priceA,
    String? priceB,
    String? spreadPct,
    String? expectedProfit,
    int? windowSeconds,
    List<double>? sparkData,
  }) {
    return ArbitrageOpportunity(
      asset: asset ?? this.asset,
      exchangeA: exchangeA ?? this.exchangeA,
      exchangeB: exchangeB ?? this.exchangeB,
      priceA: priceA ?? this.priceA,
      priceB: priceB ?? this.priceB,
      spreadPct: spreadPct ?? this.spreadPct,
      expectedProfit: expectedProfit ?? this.expectedProfit,
      windowSeconds: windowSeconds ?? this.windowSeconds,
      sparkData: sparkData ?? this.sparkData,
    );
  }
}

class ArbitrageStrategy {
  const ArbitrageStrategy({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.active,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool active;

  ArbitrageStrategy copyWith({
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    bool? active,
  }) {
    return ArbitrageStrategy(
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      active: active ?? this.active,
    );
  }
}

class RecentTrade {
  const RecentTrade({
    required this.asset,
    required this.exchangePair,
    required this.profit,
    required this.timeAgo,
    required this.status,
  });

  final String asset;
  final String exchangePair;
  final String profit;
  final String timeAgo;
  final StatusType status;
}

const List<ArbitrageOpportunity> initialOpportunities = [
  ArbitrageOpportunity(
    asset: 'BTC/USDT',
    exchangeA: 'Binance',
    exchangeB: 'Coinbase',
    priceA: '\$67,842.10',
    priceB: '\$68,021.50',
    spreadPct: '+0.26%',
    expectedProfit: '₹1,420',
    windowSeconds: 47,
    sparkData: [42, 45, 43, 48, 52, 50, 55, 58, 62, 65],
  ),
  ArbitrageOpportunity(
    asset: 'NIFTY50',
    exchangeA: 'NSE',
    exchangeB: 'BSE',
    priceA: '₹24,512.00',
    priceB: '₹24,578.75',
    spreadPct: '+0.27%',
    expectedProfit: '₹2,680',
    windowSeconds: 23,
    sparkData: [30, 35, 32, 38, 42, 40, 45, 48, 44, 50],
  ),
  ArbitrageOpportunity(
    asset: 'ETH/USDT',
    exchangeA: 'Kraken',
    exchangeB: 'OKX',
    priceA: '\$3,521.80',
    priceB: '\$3,534.45',
    spreadPct: '+0.36%',
    expectedProfit: '₹3,150',
    windowSeconds: 61,
    sparkData: [55, 52, 58, 60, 64, 62, 68, 70, 74, 72],
  ),
];

const List<ArbitrageStrategy> initialStrategies = [
  ArbitrageStrategy(
    name: 'Statistical',
    description: 'Mean-reversion between correlated pairs',
    icon: Icons.bar_chart_rounded,
    color: Color(0xFF6366F1),
    active: true,
  ),
  ArbitrageStrategy(
    name: 'Triangular',
    description: 'Cross-currency 3-leg opportunity loops',
    icon: Icons.change_circle_rounded,
    color: Color(0xFF0EA5E9),
    active: true,
  ),
  ArbitrageStrategy(
    name: 'Exchange',
    description: 'Price disparity across spot exchanges',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF22C55E),
    active: false,
  ),
  ArbitrageStrategy(
    name: 'ETF Arbitrage',
    description: 'NAV vs market price divergence trades',
    icon: Icons.account_balance_rounded,
    color: Color(0xFFF59E0B),
    active: true,
  ),
];

const List<RecentTrade> initialRecentTrades = [
  RecentTrade(
    asset: 'BTC/USDT',
    exchangePair: 'Binance → Bybit',
    profit: '+₹4,820',
    timeAgo: '2m ago',
    status: StatusType.success,
  ),
  RecentTrade(
    asset: 'NIFTY50',
    exchangePair: 'NSE → BSE',
    profit: '+₹2,100',
    timeAgo: '7m ago',
    status: StatusType.success,
  ),
  RecentTrade(
    asset: 'ETH/USDT',
    exchangePair: 'Kraken → OKX',
    profit: '-₹320',
    timeAgo: '15m ago',
    status: StatusType.error,
  ),
  RecentTrade(
    asset: 'GOLD',
    exchangePair: 'MCX → NCDEX',
    profit: '+₹1,560',
    timeAgo: '31m ago',
    status: StatusType.success,
  ),
  RecentTrade(
    asset: 'SOL/USDT',
    exchangePair: 'Coinbase → Binance',
    profit: '+₹890',
    timeAgo: '48m ago',
    status: StatusType.success,
  ),
];

class ArbitrageState {
  final List<ArbitrageOpportunity> opportunities;
  final List<ArbitrageStrategy> strategies;
  final List<RecentTrade> recentTrades;

  const ArbitrageState({
    required this.opportunities,
    required this.strategies,
    required this.recentTrades,
  });

  ArbitrageState copyWith({
    List<ArbitrageOpportunity>? opportunities,
    List<ArbitrageStrategy>? strategies,
    List<RecentTrade>? recentTrades,
  }) {
    return ArbitrageState(
      opportunities: opportunities ?? this.opportunities,
      strategies: strategies ?? this.strategies,
      recentTrades: recentTrades ?? this.recentTrades,
    );
  }
}

class ArbitrageNotifier extends Notifier<ArbitrageState> {
  Timer? _timer;
  final Random _random = Random();

  @override
  ArbitrageState build() {
    _startSimulation();
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const ArbitrageState(
      opportunities: initialOpportunities,
      strategies: initialStrategies,
      recentTrades: initialRecentTrades,
    );
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final updatedOpportunities = state.opportunities.map((opp) {
        // Randomly adjust spread and profit
        final spreadChange = (_random.nextDouble() - 0.5) * 0.1; 
        final currentSpread = double.tryParse(opp.spreadPct.replaceAll('%', '').replaceAll('+', '')) ?? 0.2;
        final newSpread = (currentSpread + spreadChange).clamp(0.01, 2.0);
        
        final profitChange = (_random.nextInt(100) - 50);
        final currentProfit = int.tryParse(opp.expectedProfit.replaceAll('₹', '').replaceAll(',', '')) ?? 1000;
        final newProfit = (currentProfit + profitChange).clamp(100, 10000);

        final newSparkData = List<double>.from(opp.sparkData)..removeAt(0)..add(opp.sparkData.last + (_random.nextDouble() - 0.5) * 5);

        return opp.copyWith(
          spreadPct: '+${newSpread.toStringAsFixed(2)}%',
          expectedProfit: '₹${newProfit.toString()}',
          sparkData: newSparkData,
        );
      }).toList();

      state = state.copyWith(opportunities: updatedOpportunities);
    });
  }

  void toggleStrategy(int index, bool isActive) {
    final updatedStrategies = List<ArbitrageStrategy>.from(state.strategies);
    updatedStrategies[index] = updatedStrategies[index].copyWith(active: isActive);
    state = state.copyWith(strategies: updatedStrategies);
  }
}

final arbitrageProvider = NotifierProvider<ArbitrageNotifier, ArbitrageState>(() {
  return ArbitrageNotifier();
});
