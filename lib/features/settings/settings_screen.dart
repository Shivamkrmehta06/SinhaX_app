import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/sinhax_card.dart';
import '../../shared/widgets/status_chip.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------



// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Profile tab state ──────────────────────────────────────────
  final _profileFormKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Shivam Mehta');
  final _emailCtrl = TextEditingController(text: 'shivam@example.com');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  final _panCtrl = TextEditingController(text: 'ABCPM1234F');

  // ── Password tab state ──────────────────────────────────────────
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();
  bool _showCurrentPwd = false;
  bool _showNewPwd = false;
  bool _showConfirmPwd = false;
  int _passwordStrength = 0; // 0-4

  // ── Brokers tab state ──────────────────────────────────────────
  String _selectedBrokerFilter = 'Indian';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _panCtrl.dispose();
    _currentPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────

  void _checkPasswordStrength(String val) {
    int strength = 0;
    if (val.length >= 8) strength++;
    if (val.contains(RegExp(r'[A-Z]'))) strength++;
    if (val.contains(RegExp(r'[0-9]'))) strength++;
    if (val.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength++;
    setState(() => _passwordStrength = strength);
  }

  String _maskPan(String pan) {
    if (pan.length < 6) return pan;
    return '${pan.substring(0, 3)}${'*' * (pan.length - 5)}${pan.substring(pan.length - 2)}';
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        backgroundColor: AppColors.card(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.text1(context),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderColor(context), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2(context),
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Password'),
                Tab(text: 'Brokers'),
                Tab(text: 'Plans'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProfileTab(
            formKey: _profileFormKey,
            nameCtrl: _nameCtrl,
            emailCtrl: _emailCtrl,
            phoneCtrl: _phoneCtrl,
            panCtrl: _panCtrl,
            maskPan: _maskPan,
          ),
          _PasswordTab(
            formKey: _passwordFormKey,
            currentPwdCtrl: _currentPwdCtrl,
            newPwdCtrl: _newPwdCtrl,
            confirmPwdCtrl: _confirmPwdCtrl,
            showCurrentPwd: _showCurrentPwd,
            showNewPwd: _showNewPwd,
            showConfirmPwd: _showConfirmPwd,
            passwordStrength: _passwordStrength,
            onToggleCurrentPwd: () =>
                setState(() => _showCurrentPwd = !_showCurrentPwd),
            onToggleNewPwd: () =>
                setState(() => _showNewPwd = !_showNewPwd),
            onToggleConfirmPwd: () =>
                setState(() => _showConfirmPwd = !_showConfirmPwd),
            onPasswordChanged: _checkPasswordStrength,
          ),
          _BrokersTab(
            selectedFilter: _selectedBrokerFilter,
            onFilterChanged: (f) => setState(() => _selectedBrokerFilter = f),
          ),
          _PlansTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// PROFILE TAB
// ============================================================================

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.panCtrl,
    required this.maskPan,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController panCtrl;
  final String Function(String) maskPan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // ── Avatar Section ──────────────────────────────────────
          _AvatarSection(),
          SizedBox(height: 24),

          // ── Form Card ──────────────────────────────────────────
          SinhaXCard(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Update your profile details below.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.text2(context),
                    ),
                  ),
                  SizedBox(height: 20),
                  _SettingsField(
                    label: 'Full Name',
                    controller: nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 14),
                  _SettingsField(
                    label: 'Email Address',
                    controller: emailCtrl,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 14),
                  _SettingsField(
                    label: 'Phone Number',
                    controller: phoneCtrl,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 14),
                  _SettingsField(
                    label: 'PAN Number',
                    controller: panCtrl,
                    prefixIcon: Icons.credit_card_outlined,
                    helperText: 'Stored securely and encrypted',
                  ),
                  SizedBox(height: 14),
                  // Plan Type (disabled)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Type',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text2(context),
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurfaceColor(context),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded,
                                color: AppColors.primary, size: 18),
                            SizedBox(width: 10),
                            Text(
                              ref.watch(userProvider).user.planType,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            Spacer(),
                            StatusChip(
                              label: 'Active',
                              type: StatusType.success,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSnackBar('Profile updated successfully!',
                              AppColors.success),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.card(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Update Profile',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AvatarSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'S',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          ref.watch(userProvider).user.name,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text1(context),
          ),
        ),
        SizedBox(height: 6),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Pro',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PASSWORD TAB
// ============================================================================

class _PasswordTab extends StatelessWidget {
  const _PasswordTab({
    required this.formKey,
    required this.currentPwdCtrl,
    required this.newPwdCtrl,
    required this.confirmPwdCtrl,
    required this.showCurrentPwd,
    required this.showNewPwd,
    required this.showConfirmPwd,
    required this.passwordStrength,
    required this.onToggleCurrentPwd,
    required this.onToggleNewPwd,
    required this.onToggleConfirmPwd,
    required this.onPasswordChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController currentPwdCtrl;
  final TextEditingController newPwdCtrl;
  final TextEditingController confirmPwdCtrl;
  final bool showCurrentPwd;
  final bool showNewPwd;
  final bool showConfirmPwd;
  final int passwordStrength;
  final VoidCallback onToggleCurrentPwd;
  final VoidCallback onToggleNewPwd;
  final VoidCallback onToggleConfirmPwd;
  final void Function(String) onPasswordChanged;

  Color _strengthColor(BuildContext context, int idx) {
    if (passwordStrength == 0) return AppColors.borderColor(context);
    if (passwordStrength == 1) return AppColors.error;
    if (passwordStrength == 2) return AppColors.warning;
    if (passwordStrength == 3) return Color(0xFF3B82F6);
    return AppColors.success;
  }

  String get _strengthLabel {
    return switch (passwordStrength) {
      0 => 'Enter a password',
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Good',
      4 => 'Strong',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // ── Password Card ────────────────────────────────────────
          SinhaXCard(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurfaceColor(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change Password',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text1(context),
                            ),
                          ),
                          Text(
                            'Keep your account secure',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.text2(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _PasswordField(
                    label: 'Current Password',
                    controller: currentPwdCtrl,
                    obscure: !showCurrentPwd,
                    onToggle: onToggleCurrentPwd,
                  ),
                  SizedBox(height: 14),
                  _PasswordField(
                    label: 'New Password',
                    controller: newPwdCtrl,
                    obscure: !showNewPwd,
                    onToggle: onToggleNewPwd,
                    onChanged: onPasswordChanged,
                  ),
                  SizedBox(height: 10),
                  // Strength indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(4, (i) {
                          final filled = i < passwordStrength;
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: filled
                                    ? _strengthColor(context, i)
                                    : AppColors.borderColor(context),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 6),
                      Text(
                        _strengthLabel,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: passwordStrength == 0
                              ? AppColors.text3(context)
                              : _strengthColor(context, passwordStrength - 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  _PasswordField(
                    label: 'Confirm New Password',
                    controller: confirmPwdCtrl,
                    obscure: !showConfirmPwd,
                    onToggle: onToggleConfirmPwd,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSnackBar(
                              'Password updated successfully!', AppColors.success),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.card(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Update Password',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // ── Security Tips ────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySurfaceColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Security Tips',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...[
                  'Use at least 8 characters with mixed case letters.',
                  'Include numbers and special characters.',
                  'Avoid using personal information like your name.',
                  'Never share your password with anyone.',
                ].map((tip) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.primary, size: 14),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.text2(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text2(context),
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.text1(context),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline_rounded,
                color: AppColors.text3(context), size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.text3(context),
                size: 18,
              ),
              onPressed: onToggle,
            ),
            hintText: '••••••••',
            hintStyle:
                GoogleFonts.inter(color: AppColors.text3(context), fontSize: 14),
            filled: true,
            fillColor: AppColors.bg(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BROKERS TAB
// ============================================================================

class _BrokersTab extends ConsumerWidget {
  const _BrokersTab({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String selectedFilter;
  final void Function(String) onFilterChanged;


  static final _filters = ['Indian', 'Crypto', 'Forex'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brokers = ref.watch(userProvider).brokers;
    final filtered = brokers
        .asMap()
        .entries
        .where((e) => e.value.category == selectedFilter)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Text(
            'Connected Brokers',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text1(context),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Connect your trading accounts to enable live trading.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.text2(context),
            ),
          ),
          SizedBox(height: 16),

          // ── Filter Chips ─────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final selected = f == selectedFilter;
                return GestureDetector(
                  onTap: () => onFilterChanged(f),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.card(context),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.borderColor(context),
                      ),
                    ),
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            selected ? Colors.white : AppColors.text2(context),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),

          // ── Broker Cards ─────────────────────────────────────────
          ...filtered.map((entry) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _BrokerCard(
                  broker: entry.value,
                  onToggle: () => ref.read(userProvider.notifier).toggleBrokerConnection(entry.key),
                ),
              )),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BrokerCard extends StatelessWidget {
  const _BrokerCard({required this.broker, required this.onToggle});

  final BrokerInfo broker;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final initial = broker.name[0].toUpperCase();

    return SinhaXCard(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: broker.avatarColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: broker.avatarColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 14),

          // ── Details ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  broker.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1(context),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  broker.api,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.text2(context),
                  ),
                ),
                SizedBox(height: 6),
                StatusChip(
                  label: broker.connected ? 'Connected' : 'Not Connected',
                  type: broker.connected ? StatusType.success : StatusType.neutral,
                  icon: broker.connected
                      ? Icons.check_circle_outline_rounded
                      : Icons.radio_button_unchecked_rounded,
                  compact: true,
                ),
              ],
            ),
          ),

          // ── Button ──────────────────────────────────────────────
          TextButton(
            onPressed: onToggle,
            style: TextButton.styleFrom(
              backgroundColor: broker.connected
                  ? AppColors.errorSurface
                  : AppColors.primarySurfaceColor(context),
              foregroundColor:
                  broker.connected ? AppColors.error : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: Text(
              broker.connected ? 'Disconnect' : 'Connect',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLANS TAB
// ============================================================================

class _PlansTab extends ConsumerWidget {
  const _PlansTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────
          Text(
            'Choose Your Plan',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text1(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'Scale your trading with the right features for you.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.text2(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // ── Plan Cards ───────────────────────────────────────────
          ...ref.watch(userProvider).plans.map((plan) => Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: _PlanCard(plan: plan),
              )),

          // ── Money-back note ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_outlined,
                    color: AppColors.text3(context), size: 14),
                SizedBox(width: 6),
                Text(
                  '7-day money-back guarantee · No credit card required',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.text3(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});
  final PlanInfo plan;

  @override
  Widget build(BuildContext context) {
    final isPopular = plan.isPopular;
    final isCurrent = plan.isCurrent;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Outer border for popular ─────────────────────────────
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isPopular
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  )
                : null,
            color: isPopular ? null : Colors.transparent,
          ),
          padding: isPopular
              ? EdgeInsets.all(2)
              : EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: isPopular
                  ? Color(0xFFF0F7FF)
                  : AppColors.card(context),
              borderRadius: BorderRadius.circular(isPopular ? 19 : 20),
              border: Border.all(
                color: isPopular ? Colors.transparent : AppColors.borderColor(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: isPopular
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.text1(context).withValues(alpha: 0.04),
                  blurRadius: isPopular ? 24 : 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Plan name row ──────────────────────────────────
                Row(
                  children: [
                    Text(
                      plan.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isPopular
                            ? AppColors.primary
                            : AppColors.text1(context),
                      ),
                    ),
                    Spacer(),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Current Plan',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),

                // ── Price ─────────────────────────────────────────
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: plan.price,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: isPopular
                              ? AppColors.primary
                              : AppColors.text1(context),
                        ),
                      ),
                      TextSpan(
                        text: plan.period,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text2(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // ── Divider ───────────────────────────────────────
                Divider(
                  color: isPopular
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.borderColor(context),
                  height: 1,
                ),
                SizedBox(height: 16),

                // ── Features ─────────────────────────────────────
                ...plan.features.map((f) => Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isPopular
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : AppColors.successSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: isPopular
                                  ? AppColors.primary
                                  : AppColors.success,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            f,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.text1(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 8),

                // ── CTA Button ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: isCurrent ? null : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrent
                          ? AppColors.borderColor(context)
                          : (isPopular
                              ? AppColors.primary
                              : AppColors.bg(context)),
                      foregroundColor: isCurrent
                          ? AppColors.text2(context)
                          : (isPopular ? Colors.white : AppColors.primary),
                      disabledBackgroundColor: AppColors.borderColor(context),
                      disabledForegroundColor: AppColors.text2(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isCurrent || isPopular
                            ? BorderSide.none
                            : BorderSide(color: AppColors.primary),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isCurrent ? 'Current Plan' : 'Upgrade to ${plan.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── MOST POPULAR Badge ───────────────────────────────────
        if (isPopular)
          Positioned(
            top: -13,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded,
                        color: Colors.amber, size: 13),
                    SizedBox(width: 5),
                    Text(
                      'MOST POPULAR',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// SHARED HELPERS
// ============================================================================

class _SettingsField extends StatelessWidget {
  const _SettingsField({
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.keyboardType,
    this.helperText,
  });

  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text2(context),
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.text1(context),
          ),
          decoration: InputDecoration(
            prefixIcon:
                Icon(prefixIcon, color: AppColors.text3(context), size: 18),
            filled: true,
            fillColor: AppColors.bg(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            helperText: helperText,
            helperStyle: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.text3(context),
            ),
          ),
        ),
      ],
    );
  }
}

SnackBar _buildSnackBar(String message, Color color) {
  return SnackBar(
    content: Row(
      children: [
        Icon(
          color == AppColors.success
              ? Icons.check_circle_rounded
              : Icons.error_rounded,
          color: Colors.white,
          size: 18,
        ),
        SizedBox(width: 10),
        Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.all(16),
    duration: Duration(seconds: 3),
  );
}
