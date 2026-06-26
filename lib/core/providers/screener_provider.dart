import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenerRow {
  const ScreenerRow({
    required this.symbol,
    required this.ltp,
    required this.changePct,
    required this.volume,
    required this.rsi,
    required this.signal,
  });

  final String symbol;
  final double ltp;
  final double changePct;
  final String volume;
  final double rsi;
  final String signal;
}

const List<ScreenerRow> _allRows = [
  ScreenerRow(symbol: 'RELIANCE',   ltp: 2934.0, changePct:  2.14, volume: '18.4M', rsi: 64.2, signal: 'Bullish'),
  ScreenerRow(symbol: 'TCS',        ltp: 4012.0, changePct:  3.67, volume: '9.1M',  rsi: 71.8, signal: 'Bullish'),
  ScreenerRow(symbol: 'HDFC',       ltp: 1678.0, changePct: -1.23, volume: '11.7M', rsi: 38.4, signal: 'Bearish'),
  ScreenerRow(symbol: 'INFY',       ltp: 1789.0, changePct:  1.56, volume: '7.2M',  rsi: 58.6, signal: 'Bullish'),
  ScreenerRow(symbol: 'WIPRO',      ltp:  552.0, changePct:  0.18, volume: '4.8M',  rsi: 51.2, signal: 'Neutral'),
  ScreenerRow(symbol: 'ICICIBANK',  ltp: 1124.0, changePct:  2.89, volume: '14.5M', rsi: 62.7, signal: 'Bullish'),
  ScreenerRow(symbol: 'AXISBANK',   ltp: 1189.0, changePct: -2.31, volume: '8.9M',  rsi: 42.1, signal: 'Bearish'),
  ScreenerRow(symbol: 'BHARTIARTL', ltp: 1456.0, changePct:  4.12, volume: '6.3M',  rsi: 66.3, signal: 'Bullish'),
  ScreenerRow(symbol: 'MARUTI',     ltp: 11204.0,changePct: -0.87, volume: '2.1M',  rsi: 48.5, signal: 'Neutral'),
  ScreenerRow(symbol: 'HCLTECH',    ltp: 1698.0, changePct:  1.92, volume: '5.6M',  rsi: 59.1, signal: 'Bullish'),
];

class ScreenerNotifier extends Notifier<List<ScreenerRow>> {
  @override
  List<ScreenerRow> build() {
    return _allRows;
  }
}

final screenerProvider = NotifierProvider<ScreenerNotifier, List<ScreenerRow>>(
  ScreenerNotifier.new,
);
