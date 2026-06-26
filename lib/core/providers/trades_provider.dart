import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TradeType { buy, sell }
enum TradeStatus { executed, pending, cancelled }

class TradeModel {
  const TradeModel({
    required this.symbol,
    required this.strategy,
    required this.dateTime,
    required this.type,
    required this.qty,
    required this.status,
    required this.entryPrice,
    this.exitPrice,
    this.pnl,
  });

  final String symbol;
  final String strategy;
  final String dateTime;
  final TradeType type;
  final String qty;
  final TradeStatus status;
  final String entryPrice;
  final String? exitPrice;
  final String? pnl;
}

const List<TradeModel> initialTrades = [
  TradeModel(
    symbol: 'NIFTY23DEC',
    strategy: 'Momentum Breakout',
    dateTime: '16 Jun, 09:32 AM',
    type: TradeType.buy,
    qty: '50',
    status: TradeStatus.executed,
    entryPrice: '₹19,850',
    exitPrice: '₹19,924',
    pnl: '+₹3,700',
  ),
  TradeModel(
    symbol: 'RELIANCE',
    strategy: 'MACD Crossover',
    dateTime: '16 Jun, 10:15 AM',
    type: TradeType.sell,
    qty: '100',
    status: TradeStatus.executed,
    entryPrice: '₹2,934',
    exitPrice: '₹2,898',
    pnl: '+₹3,600',
  ),
  TradeModel(
    symbol: 'BTC/USDT',
    strategy: 'BTC Scalper',
    dateTime: '16 Jun, 11:00 AM',
    type: TradeType.buy,
    qty: '0.5',
    status: TradeStatus.pending,
    entryPrice: '₹67,200',
    exitPrice: null,
    pnl: null,
  ),
  TradeModel(
    symbol: 'TCS',
    strategy: 'RSI Reversal',
    dateTime: '15 Jun, 03:12 PM',
    type: TradeType.buy,
    qty: '25',
    status: TradeStatus.executed,
    entryPrice: '₹4,012',
    exitPrice: '₹3,987',
    pnl: '-₹625',
  ),
  TradeModel(
    symbol: 'HDFC',
    strategy: 'Momentum',
    dateTime: '15 Jun, 01:45 PM',
    type: TradeType.sell,
    qty: '75',
    status: TradeStatus.cancelled,
    entryPrice: '₹1,678',
    exitPrice: null,
    pnl: null,
  ),
  TradeModel(
    symbol: 'ETH/USDT',
    strategy: 'Algo Scalper',
    dateTime: '14 Jun, 06:20 PM',
    type: TradeType.buy,
    qty: '2',
    status: TradeStatus.executed,
    entryPrice: '₹3,521',
    exitPrice: '₹3,589',
    pnl: '+₹9,860',
  ),
  TradeModel(
    symbol: 'INFY',
    strategy: 'MACD',
    dateTime: '14 Jun, 02:05 PM',
    type: TradeType.buy,
    qty: '50',
    status: TradeStatus.executed,
    entryPrice: '₹1,789',
    exitPrice: '₹1,812',
    pnl: '+₹1,150',
  ),
  TradeModel(
    symbol: 'BANKEX',
    strategy: 'Breakout',
    dateTime: '13 Jun, 11:30 AM',
    type: TradeType.buy,
    qty: '30',
    status: TradeStatus.pending,
    entryPrice: '₹52,340',
    exitPrice: null,
    pnl: null,
  ),
];

class TradesState {
  final List<TradeModel> trades;

  const TradesState({required this.trades});
}

class TradesNotifier extends Notifier<TradesState> {
  @override
  TradesState build() {
    return const TradesState(trades: initialTrades);
  }
}

final tradesProvider = NotifierProvider<TradesNotifier, TradesState>(() {
  return TradesNotifier();
});
