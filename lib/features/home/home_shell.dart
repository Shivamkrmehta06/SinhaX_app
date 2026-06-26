import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../overview/overview_screen.dart';
import '../strategies/strategies_screen.dart';
import '../portfolio/portfolio_screen.dart';
import '../watchlist/watchlist_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OverviewScreen(),
    StrategiesScreen(),
    PortfolioScreen(),
    WatchlistScreen(),
  ];

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  void _showMoreMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MoreMenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              ?currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: SizedBox(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : AppColors.textPrimary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Overview',
                  isSelected: _currentIndex == 0,
                  onTap: () => _onTabTap(0),
                ),
                _NavItem(
                  icon: Icons.auto_graph_rounded,
                  label: 'Strategies',
                  isSelected: _currentIndex == 1,
                  onTap: () => _onTabTap(1),
                ),
                _NavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Portfolio',
                  isSelected: _currentIndex == 2,
                  onTap: () => _onTabTap(2),
                ),
                _NavItem(
                  icon: Icons.bookmark_rounded,
                  label: 'Watchlist',
                  isSelected: _currentIndex == 3,
                  onTap: () => _onTabTap(3),
                ),
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'More',
                  isSelected: false,
                  onTap: () => _showMoreMenu(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav Item
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );
    
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _rotateAnim = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.002) // Perspective
              ..rotateY(_rotateAnim.value * 3.14159) // 3D Y-axis flip
              ..multiply(Matrix4.diagonal3Values(_scaleAnim.value, _scaleAnim.value, 1.0));
              
            return Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? AppColors.primarySurfaceColor(context)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 22,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.text3(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.text3(context),
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// More Menu Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _MoreMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final items = [
      (Icons.receipt_long_rounded, 'Trades', '/trades',
          const Color(0xFF4F6EF7)),
      (Icons.candlestick_chart_rounded, 'Markets', '/markets',
          const Color(0xFF00D4AA)),
      (Icons.search_rounded, 'Screener', '/screener',
          const Color(0xFF7C3AED)),
      (Icons.compare_arrows_rounded, 'Arbitrage', '/arbitrage',
          const Color(0xFFF5A623)),
      (Icons.history_rounded, 'Backtest', '/backtest',
          const Color(0xFF16C784)),
      (Icons.settings_rounded, 'Settings', '/settings',
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'More Options',
            style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w700,
              color: AppColors.text1(context),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...items.map((item) => GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.pop();
                  context.push(item.$3);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: item.$4.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item.$4.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(item.$1, color: item.$4, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.$2,
                      style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.text1(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
              // Logout
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.pop();
                  context.go('/landing');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lossSurfaceColor(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.lossColor(context)
                              .withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: AppColors.lossColor(context), size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.text1(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
