import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

enum StrategyStatus { active, paused, stopped }

class Strategy {
  const Strategy({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.returnsPct,
    required this.trades,
    required this.winRate,
    required this.sharpe,
    required this.color,
    required this.sparkline,
  });

  final String id, name, description, type;
  final StrategyStatus status;
  final double returnsPct, winRate, sharpe;
  final int trades;
  final Color color;
  final List<double> sparkline;

  Strategy copyWith({StrategyStatus? status}) => Strategy(
    id: id, name: name, description: description, type: type,
    returnsPct: returnsPct, trades: trades, winRate: winRate,
    sharpe: sharpe, color: color, sparkline: sparkline,
    status: status ?? this.status,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

class StrategyNotifier extends Notifier<List<Strategy>> {
  @override
  List<Strategy> build() => _seed;

  void toggleStatus(String id) {
    state = state.map((s) {
      if (s.id != id) return s;
      final next = s.status == StrategyStatus.active
          ? StrategyStatus.paused
          : StrategyStatus.active;
      return s.copyWith(status: next);
    }).toList();
  }

  static final _seed = <Strategy>[
    Strategy(
      id: 's1', name: 'Momentum Alpha', type: 'Intraday · NSE',
      description: 'RSI + MACD crossover with EMA trend filter',
      status: StrategyStatus.active,
      returnsPct: 24.7, trades: 142, winRate: 67.6, sharpe: 1.84,
      color: const Color(0xFF4F6EF7),
      sparkline: [10,13,11,18,15,20,17,22,19,25,23,28],
    ),
    Strategy(
      id: 's2', name: 'Volatility Squeeze', type: 'Swing · NSE/BSE',
      description: 'Bollinger Bands squeeze breakout strategy',
      status: StrategyStatus.active,
      returnsPct: 18.3, trades: 86, winRate: 72.1, sharpe: 2.10,
      color: const Color(0xFF00D4AA),
      sparkline: [8,10,9,13,11,16,14,18,16,20,19,22],
    ),
    Strategy(
      id: 's3', name: 'Mean Reversion', type: 'Positional · NSE',
      description: 'Statistical arbitrage on correlated pairs',
      status: StrategyStatus.paused,
      returnsPct: 11.2, trades: 54, winRate: 58.3, sharpe: 1.23,
      color: const Color(0xFFF5A623),
      sparkline: [5,7,6,9,8,11,10,13,11,14,12,15],
    ),
    Strategy(
      id: 's4', name: 'Crypto DCA Bot', type: 'Crypto · Binance',
      description: 'Dollar-cost averaging on BTC, ETH, SOL',
      status: StrategyStatus.active,
      returnsPct: 34.9, trades: 365, winRate: 61.4, sharpe: 1.56,
      color: const Color(0xFF7B96FF),
      sparkline: [12,15,13,20,17,25,22,30,27,35,32,40],
    ),
    Strategy(
      id: 's5', name: 'Options Straddle', type: 'F&O · NSE',
      description: 'Short straddle on NIFTY expiry days',
      status: StrategyStatus.stopped,
      returnsPct: -2.1, trades: 22, winRate: 40.9, sharpe: 0.42,
      color: const Color(0xFFEA3943),
      sparkline: [20,18,22,17,19,16,18,14,16,13,15,12],
    ),
  ];
}

final strategyProvider = NotifierProvider<StrategyNotifier, List<Strategy>>(
  StrategyNotifier.new,
);
