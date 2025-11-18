import 'package:detect_x/core/utils/extensions.dart';
import 'package:detect_x/logic/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/language/language_cubit.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
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
    if(_formKey.currentState!.validate()) {
      // Send Login event to AuthBloc
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          _emailController.text.trim(),
          _passController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    // BlocListener to listen for AuthState changes
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state){
        if(state.status == AuthStatus.error){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? context.l10n.errorLogin),
            backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Language button slector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Vietnamese Button
                      TextButton(
                        onPressed: () => context.read<LanguageCubit>().changeLanguage('vi'),
                        child: Text("Tiếng Việt", style: TextStyle(
                          color: context.locale.languageCode == 'vi' ? Colors.deepPurple : Colors.grey,
                          fontWeight: context.locale.languageCode == 'vi' ? FontWeight.bold : FontWeight.normal,
                        )),
                      ),
                      // English Button
                      TextButton(
                        onPressed: () => context.read<LanguageCubit>().changeLanguage('en'),
                        child: Text("English", style: TextStyle(
                          color: context.locale.languageCode == 'en' ? Colors.deepPurple : Colors.grey,
                          fontWeight: context.locale.languageCode == 'en' ? FontWeight.bold : FontWeight.normal,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Logo or Title
                  const Icon(Icons.security, size:80, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.l10n.emailLabel, 
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return context.l10n.emailErrorEmpty; 
                      if (!value.contains('@')) return context.l10n.emailErrorInvalid; 
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: context.l10n.passwordLabel, 
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return context.l10n.passwordErrorShort; 
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state){
                      if(state.status == AuthStatus.loading){
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: _onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          padding : const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ), 
                        child: Text(context.l10n.loginButton, style: const TextStyle(fontSize: 16)),
                      );
                    }
                  ),

                  const SizedBox(height: 16),

                  // Guest Button
                  OutlinedButton(
                    onPressed: (){
                      context.read<AuthBloc>().add(AuthGuestRequested());
                    }, 
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: Text(context.l10n.guestButton)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}