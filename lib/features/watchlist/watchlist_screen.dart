import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/watchlist_provider.dart';
import '../../shared/widgets/mini_chart.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistQuotes = ref.watch(watchlistQuotesProvider);
    final allQuotes = ref.watch(marketProvider);


    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        backgroundColor: AppColors.card(context),
        elevation: 0,
        title: Text(
          'My Watchlist',
          style: GoogleFonts.inter(
            color: AppColors.text1(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: AppColors.text2(context)),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(marketProvider.notifier).refresh();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SearchAddBar(allQuotes: allQuotes),
                    const SizedBox(height: 16),
                    _SummaryRow(quotes: watchlistQuotes),
                  ],
                ),
              ),
            ),
            if (watchlistQuotes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border_rounded, size: 80, color: AppColors.text3(context)),
                      const SizedBox(height: 16),
                      Text(
                        'Add stocks to track them here',
                        style: GoogleFonts.inter(
                          color: AppColors.text2(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final quote = watchlistQuotes[index];
                    return _WatchlistTile(quote: quote);
                  },
                  childCount: watchlistQuotes.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchAddBar extends ConsumerWidget {
  const _SearchAddBar({required this.allQuotes});
  final List<StockQuote> allQuotes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.card(context),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _AddSymbolSheet(allQuotes: allQuotes),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardAlt(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.text3(context)),
            const SizedBox(width: 12),
            Text(
              'Search symbols to add...',
              style: GoogleFonts.inter(color: AppColors.text3(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSymbolSheet extends ConsumerWidget {
  const _AddSymbolSheet({required this.allQuotes});
  final List<StockQuote> allQuotes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);
    final available = allQuotes.where((q) => !watchlist.contains(q.symbol)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Add to Watchlist',
                style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.text1(context),
                ),
              ),
            ),
            Expanded(
              child: available.isEmpty
                  ? Center(child: Text('All symbols added!', style: TextStyle(color: AppColors.text2(context))))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final quote = available[index];
                        return ListTile(
                          title: Text(quote.symbol, style: TextStyle(color: AppColors.text1(context))),
                          subtitle: Text(quote.name, style: TextStyle(color: AppColors.text2(context))),
                          trailing: IconButton(
                            icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
                            onPressed: () {
                              ref.read(watchlistProvider.notifier).add(quote.symbol);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.quotes});
  final List<StockQuote> quotes;

  @override
  Widget build(BuildContext context) {
    final upCount = quotes.where((q) => q.isUp).length;


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${quotes.length} Symbols',
          style: GoogleFonts.inter(
            color: AppColors.text2(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.gainColor(context)),
            const SizedBox(width: 4),
            Text(
              '$upCount Advancing',
              style: GoogleFonts.inter(
                color: AppColors.gainColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WatchlistTile extends ConsumerWidget {
  const _WatchlistTile({required this.quote});
  final StockQuote quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(quote.symbol),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(watchlistProvider.notifier).remove(quote.symbol);
      },
      background: Container(
        color: AppColors.lossColor(context),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.symbol,
                    style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.text1(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quote.name,
                    style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.text2(context),
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 36,
                child: MiniSparkline(
                  data: quote.sparkline,
                  positive: quote.isUp,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${quote.price.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.text1(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: quote.isUp ? AppColors.gainSurface(context) : AppColors.lossSurfaceColor(context),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${quote.changePct > 0 ? '+' : ''}${quote.changePct}%',
                      style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: quote.isUp ? AppColors.gainColor(context) : AppColors.lossColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
