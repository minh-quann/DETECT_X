import 'package:detect_x/core/utils/extensions.dart';
import 'package:detect_x/logic/auth/auth_bloc.dart';
import 'package:detect_x/presentation/widgets/glass_card.dart';
import 'package:detect_x/presentation/widgets/modern_text_field.dart';
import 'package:detect_x/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/language/language_cubit.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(_emailController.text.trim(), _passController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? context.l10n.errorLogin), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        // Thêm Background Gradient nhẹ để làm nổi hiệu ứng kính
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.brightness == Brightness.light
                  ? [Colors.grey.shade100, Colors.grey.shade300]
                  : [const Color(0xFF121212), const Color(0xFF2C2C2C)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  //Language Switcher
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      borderRadius: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLangBtn("VI", 'vi'),
                          const SizedBox(width: 8),
                          _buildLangBtn("EN", 'en'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  //Logo Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.security, size: 60, color: theme.primaryColor),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    context.l10n.loginTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.loginSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  //Form Section 
                  GlassCard(
                    opacity: 0.08,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ModernTextField(
                            controller: _emailController,
                            label: context.l10n.emailLabel,
                            prefixIcon: Icons.email_outlined,
                            validator: (val) => (val == null || !val.contains('@')) 
                                ? context.l10n.emailErrorInvalid : null,
                          ),
                          const SizedBox(height: 16),
                          ModernTextField(
                            controller: _passController,
                            label: context.l10n.passwordLabel,
                            prefixIcon: Icons.lock_outline,
                            isPassword: _isObscure,
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _isObscure = !_isObscure),
                            ),
                            validator: (val) => (val == null || val.length < 6) 
                                ? context.l10n.passwordErrorShort : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // Login Button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return PrimaryButton(
                                title: context.l10n.loginButton,
                                isLoading: state.status == AuthStatus.loading,
                                onPressed: _onLoginPressed,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Guest Button ---
                  TextButton(
                    onPressed: () => context.read<AuthBloc>().add(AuthGuestRequested()),
                    child: Text(
                      context.l10n.guestButton,
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangBtn(String text, String code) {
    final isSelected = context.locale.languageCode == code;
    return GestureDetector(
      onTap: () => context.read<LanguageCubit>().changeLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}