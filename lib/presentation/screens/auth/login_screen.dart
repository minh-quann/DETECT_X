import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extensions.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // Helper to get the correct icon for the current theme mode
  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness; // System icon
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.l10n.errorLogin),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LiquidBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: RepaintBoundary(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        _buildTopControls(context, theme),
                        const SizedBox(height: 48),
                        _buildFormPanel(context, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 22,
              showGlow: false,
              child: IconButton(
                icon: Icon(_getThemeIcon(mode), color: theme.primaryColor),
                onPressed: () => context.read<ThemeCubit>().cycleTheme(),
                tooltip: "Switch Theme",
              ),
            );
          },
        ),
        const Spacer(),
        GlassCard(
          borderRadius: 18,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          showGlow: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLangBtn("VI", 'vi'),
              const SizedBox(width: 6),
              _buildLangBtn("EN", 'en'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormPanel(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return GlassCard(
      opacity: isDark ? 0.12 : 0.45,
      blur: 40,
      borderRadius: 32,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: theme.primaryColor),
              const SizedBox(width: 12),
              Text(
                context.l10n.loginTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                ModernTextField(
                  controller: _emailController,
                  label: context.l10n.emailLabel,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => (val == null || !val.contains('@'))
                      ? context.l10n.emailErrorInvalid
                      : null,
                ),
                const SizedBox(height: 18),
                ModernTextField(
                  controller: _passController,
                  label: context.l10n.passwordLabel,
                  prefixIcon: Icons.lock_outline,
                  isPassword: _isObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  validator: (val) => (val == null || val.length < 6)
                      ? context.l10n.passwordErrorShort
                      : null,
                ),
                const SizedBox(height: 28),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      title: context.l10n.loginButton,
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              _emailController.text.trim(),
                              _passController.text.trim(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(AuthGuestRequested()),
                  child: Text(
                    context.l10n.guestButton,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String text, String code) {
    final isSelected = context.locale.languageCode == code;
    final activeColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => context.read<LanguageCubit>().changeLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
