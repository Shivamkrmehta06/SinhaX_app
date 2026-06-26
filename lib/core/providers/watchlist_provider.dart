import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'market_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Watchlist provider — persists a list of symbol strings in session
// ─────────────────────────────────────────────────────────────────────────────

class WatchlistNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ['RELIANCE', 'TCS', 'HDFCBANK', 'BAJFINANCE'];

  void add(String symbol) {
    if (!state.contains(symbol)) state = [...state, symbol];
  }

  void remove(String symbol) {
    state = state.where((s) => s != symbol).toList();
  }

  void toggle(String symbol) {
    if (state.contains(symbol)) {
      remove(symbol);
    } else {
      add(symbol);
    }
  }

  bool contains(String symbol) => state.contains(symbol);
}

final watchlistProvider = NotifierProvider<WatchlistNotifier, List<String>>(
  WatchlistNotifier.new,
);

/// Derived provider: returns StockQuote objects for watchlisted symbols
final watchlistQuotesProvider = Provider((ref) {
  final symbols = ref.watch(watchlistProvider);
  final allQuotes = ref.watch(marketProvider);
  return allQuotes.where((q) => symbols.contains(q.symbol)).toList();
});
