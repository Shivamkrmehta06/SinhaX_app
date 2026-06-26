import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeEntry {
  final String symbol;
  final String entry;
  final String exit;
  final String qty;
  final String pnl;
  final bool positive;
  const TradeEntry(this.symbol, this.entry, this.exit, this.qty, this.pnl, this.positive);
}

class BacktestResult {
  final List<double> equityCurve;
  final List<double> monthlyReturns;
  final List<TradeEntry> trades;
  final String totalReturn;
  final String totalReturnCapital;
  final String winRate;
  final String profitFactor;
  final String maxDrawdown;
  final String sharpeRatio;
  final String totalTrades;
  final String avgRR;
  final String bestTrade;
  final String worstTrade;

  BacktestResult({
    required this.equityCurve,
    required this.monthlyReturns,
    required this.trades,
    required this.totalReturn,
    required this.totalReturnCapital,
    required this.winRate,
    required this.profitFactor,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.totalTrades,
    required this.avgRR,
    required this.bestTrade,
    required this.worstTrade,
  });
}

class BacktestState {
  final bool isRunning;
  final BacktestResult? result;

  const BacktestState({this.isRunning = false, this.result});

  BacktestState copyWith({bool? isRunning, BacktestResult? result}) {
    return BacktestState(
      isRunning: isRunning ?? this.isRunning,
      result: result ?? this.result,
    );
  }
}

class BacktestNotifier extends Notifier<BacktestState> {
  @override
  BacktestState build() => const BacktestState();

  Future<void> runBacktest({
    required String strategy,
    required String symbol,
    required String timeframe,
    required double riskPercent,
    required DateTime start,
    required DateTime end,
    required String capital,
  }) async {
    state = state.copyWith(isRunning: true, result: null);
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(
      isRunning: false,
      result: BacktestResult(
        equityCurve: const [
          10.0, 10.3, 10.8, 10.5, 11.1, 11.6, 11.3, 12.0, 12.4, 11.9,
          12.7, 13.1, 12.8, 13.5, 14.0, 13.6, 14.3, 14.8, 14.4, 15.1,
          15.6, 15.2, 15.8, 16.3, 15.9, 16.7, 17.2, 16.8, 17.5, 18.0,
          17.5, 18.2, 18.8, 18.4, 19.0, 19.6, 19.1, 19.8, 20.4, 20.0,
          20.7, 21.3, 20.8, 21.5, 22.1, 21.7, 22.4, 23.0, 22.6, 23.4,
          24.0, 23.5, 24.2, 24.8, 24.4, 25.1, 25.7, 25.2, 25.9, 26.4,
        ],
        monthlyReturns: const [
          3.2, 5.1, -1.8, 4.6, 6.3, -2.4,
          7.1, 3.8, 5.9, -1.2, 4.4, 2.8,
        ],
        trades: const [
          TradeEntry('NIFTY 50', '₹19,420', '₹19,680', '50', '+₹13,000', true),
          TradeEntry('NIFTY 50', '₹19,710', '₹19,540', '50', '-₹8,500', false),
          TradeEntry('NIFTY 50', '₹19,880', '₹20,310', '50', '+₹21,500', true),
          TradeEntry('NIFTY 50', '₹20,150', '₹20,490', '50', '+₹17,000', true),
          TradeEntry('NIFTY 50', '₹20,640', '₹20,510', '50', '-₹6,500', false),
        ],
        totalReturn: '+28.4%',
        totalReturnCapital: '+₹2,84,000 on ₹$capital capital',
        winRate: '72.4%',
        profitFactor: '2.31',
        maxDrawdown: '8.2%',
        sharpeRatio: '1.84',
        totalTrades: '247',
        avgRR: '1 : 1.8',
        bestTrade: '+₹38,400',
        worstTrade: '-₹8,200',
      )
    );
  }
}

final backtestProvider = NotifierProvider<BacktestNotifier, BacktestState>(() {
  return BacktestNotifier();
});
