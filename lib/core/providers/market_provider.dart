import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class StockQuote {
  const StockQuote({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePct,
    required this.sparkline,
    required this.volume,
    required this.isUp,
  });

  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePct;
  final List<double> sparkline;
  final String volume;
  final bool isUp;

  StockQuote copyWith({double? price, double? change, double? changePct,
      List<double>? sparkline, bool? isUp}) {
    return StockQuote(
      symbol: symbol, name: name, volume: volume,
      price: price ?? this.price,
      change: change ?? this.change,
      changePct: changePct ?? this.changePct,
      sparkline: sparkline ?? this.sparkline,
      isUp: isUp ?? this.isUp,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Market Provider — ticks every 3 seconds to simulate live data
// ─────────────────────────────────────────────────────────────────────────────

class MarketNotifier extends Notifier<List<StockQuote>> {
  Timer? _timer;
  final _rng = Random();

  static const _seed = <StockQuote>[
    StockQuote(symbol: 'RELIANCE', name: 'Reliance Ind.', price: 2934.55,
        change: 35.90, changePct: 1.24, volume: '12.4M',
        isUp: true, sparkline: [2880,2895,2876,2910,2922,2934,2930,2934]),
    StockQuote(symbol: 'TCS', name: 'Tata Cons. Svc.', price: 4012.80,
        change: 34.70, changePct: 0.87, volume: '4.1M',
        isUp: true, sparkline: [3960,3975,3990,4002,3995,4008,4012,4012]),
    StockQuote(symbol: 'INFY', name: 'Infosys Ltd.', price: 1789.45,
        change: -6.10, changePct: -0.34, volume: '7.8M',
        isUp: false, sparkline: [1810,1802,1798,1793,1800,1795,1790,1789]),
    StockQuote(symbol: 'HDFCBANK', name: 'HDFC Bank', price: 1678.90,
        change: 10.40, changePct: 0.62, volume: '9.2M',
        isUp: true, sparkline: [1660,1665,1670,1668,1672,1675,1678,1678]),
    StockQuote(symbol: 'WIPRO', name: 'Wipro Ltd.', price: 543.20,
        change: -1.15, changePct: -0.21, volume: '5.5M',
        isUp: false, sparkline: [548,546,545,546,544,543,543,543]),
    StockQuote(symbol: 'BAJFINANCE', name: 'Bajaj Finance', price: 7220.00,
        change: 144.40, changePct: 2.04, volume: '2.1M',
        isUp: true, sparkline: [7050,7080,7100,7140,7160,7200,7210,7220]),
    StockQuote(symbol: 'TATAMOTORS', name: 'Tata Motors', price: 924.30,
        change: -12.70, changePct: -1.36, volume: '18.3M',
        isUp: false, sparkline: [940,936,930,928,926,924,923,924]),
    StockQuote(symbol: 'ICICIBANK', name: 'ICICI Bank', price: 1244.75,
        change: 18.25, changePct: 1.49, volume: '11.6M',
        isUp: true, sparkline: [1220,1228,1232,1238,1241,1244,1243,1244]),
  ];

  @override
  List<StockQuote> build() {
    _startTicking();
    ref.onDispose(() => _timer?.cancel());
    return List.from(_seed);
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _tick());
  }

  void _tick() {
    state = state.map((q) {
      final jitter = (_rng.nextDouble() - 0.5) * q.price * 0.003;
      final newPrice = (q.price + jitter).clamp(q.price * 0.95, q.price * 1.05);
      final delta = newPrice - (q.sparkline.first);
      final newSparkline = [...q.sparkline.skip(1), newPrice];
      return q.copyWith(
        price: double.parse(newPrice.toStringAsFixed(2)),
        change: double.parse(delta.toStringAsFixed(2)),
        changePct: double.parse((delta / q.sparkline.first * 100).toStringAsFixed(2)),
        sparkline: newSparkline,
        isUp: newPrice >= q.price,
      );
    }).toList();
  }

  void refresh() => _tick();
}

final marketProvider = NotifierProvider<MarketNotifier, List<StockQuote>>(
  MarketNotifier.new,
);
