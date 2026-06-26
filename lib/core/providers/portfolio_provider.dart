import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class Holding {
  const Holding({
    required this.symbol,
    required this.company,
    required this.qty,
    required this.avgPrice,
    required this.cmp,
    required this.pnl,
    required this.pnlPct,
    required this.sparkline,
    required this.avatarColor,
  });
  final String symbol, company;
  final int qty;
  final double avgPrice, cmp, pnl, pnlPct;
  final List<double> sparkline;
  final Color avatarColor;
}

class Position {
  const Position({
    required this.symbol,
    required this.type,
    required this.qty,
    required this.entryPrice,
    required this.ltp,
    required this.pnl,
    required this.isPositive,
    required this.avatarColor,
  });
  final String symbol, type;
  final int qty;
  final double entryPrice, ltp, pnl;
  final bool isPositive;
  final Color avatarColor;
}

class PortfolioState {
  const PortfolioState({
    required this.totalValue,
    required this.totalInvested,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.dayPnl,
    required this.dayPnlPct,
    required this.holdings,
    required this.positions,
    required this.performanceChart,
  });
  final double totalValue, totalInvested, totalPnl, totalPnlPct;
  final double dayPnl, dayPnlPct;
  final List<Holding> holdings;
  final List<Position> positions;
  final List<double> performanceChart;
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

class PortfolioNotifier extends Notifier<PortfolioState> {
  @override
  PortfolioState build() => _mockState;

  static final _mockState = PortfolioState(
    totalValue: 428500,
    totalInvested: 320000,
    totalPnl: 108500,
    totalPnlPct: 33.91,
    dayPnl: 4320,
    dayPnlPct: 1.02,
    performanceChart: [
      320000, 324000, 319500, 330000, 327000, 335000, 340000,
      338000, 345000, 352000, 349000, 358000, 362000, 370000,
      375000, 368000, 380000, 385000, 392000, 400000, 410000,
      415000, 408000, 420000, 428500,
    ],
    holdings: const [
      Holding(
        symbol: 'RELIANCE', company: 'Reliance Industries', qty: 50,
        avgPrice: 2650.00, cmp: 2934.55, pnl: 14227.50, pnlPct: 10.73,
        sparkline: [2650,2700,2680,2750,2820,2890,2930,2934],
        avatarColor: Color(0xFF4F6EF7),
      ),
      Holding(
        symbol: 'TCS', company: 'Tata Consultancy', qty: 25,
        avgPrice: 3800.00, cmp: 4012.80, pnl: 5320.00, pnlPct: 5.60,
        sparkline: [3800,3840,3820,3900,3950,3990,4010,4012],
        avatarColor: Color(0xFF00D4AA),
      ),
      Holding(
        symbol: 'HDFCBANK', company: 'HDFC Bank', qty: 100,
        avgPrice: 1520.00, cmp: 1678.90, pnl: 15890.00, pnlPct: 10.45,
        sparkline: [1520,1550,1580,1610,1640,1660,1675,1678],
        avatarColor: Color(0xFFF5A623),
      ),
      Holding(
        symbol: 'BAJFINANCE', company: 'Bajaj Finance', qty: 15,
        avgPrice: 6800.00, cmp: 7220.00, pnl: 6300.00, pnlPct: 6.18,
        sparkline: [6800,6850,6920,7000,7080,7140,7200,7220],
        avatarColor: Color(0xFFEA3943),
      ),
      Holding(
        symbol: 'ICICIBANK', company: 'ICICI Bank', qty: 80,
        avgPrice: 1100.00, cmp: 1244.75, pnl: 11580.00, pnlPct: 13.16,
        sparkline: [1100,1130,1160,1190,1210,1230,1240,1244],
        avatarColor: Color(0xFF7B96FF),
      ),
    ],
    positions: const [
      Position(
        symbol: 'NIFTY24DEC', type: 'F&O · LONG', qty: 2,
        entryPrice: 22200, ltp: 22456, pnl: 25600, isPositive: true,
        avatarColor: Color(0xFF4F6EF7),
      ),
      Position(
        symbol: 'BANKNIFTY', type: 'F&O · SHORT', qty: 1,
        entryPrice: 48500, ltp: 47980, pnl: 26000, isPositive: true,
        avatarColor: Color(0xFF00D4AA),
      ),
      Position(
        symbol: 'INFY', type: 'CNC · SHORT', qty: 200,
        entryPrice: 1800, ltp: 1789, pnl: -2200, isPositive: false,
        avatarColor: Color(0xFFEA3943),
      ),
    ],
  );
}

final portfolioProvider = NotifierProvider<PortfolioNotifier, PortfolioState>(
  PortfolioNotifier.new,
);
