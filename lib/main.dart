import 'package:detect_x/l10n/app_localizations.dart';
import 'package:detect_x/presentation/screens/auth/login_screen.dart';
import 'package:detect_x/presentation/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'logic/theme/theme_cubit.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/language/language_cubit.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {

          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'AI Detector', 
                debugShowCheckedModeBanner: false,
                theme: AppTheme.LightTheme,
                darkTheme: AppTheme.DarkTheme,
                themeMode: themeMode,
                
                //LANGUAGE CONFIGURATION
                locale: locale,  
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                  Locale('vi'), // Vietnamese
                ],
                // ---------------------------

                home: const AppNavigator(),
              );
            },
          );
        },
      ),
    );
  }
}


class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
          case AuthStatus.guest:
            //
            return const HomeScreen(); 
          default:
            //
            return const LoginScreen(); 
        }
      },
    );
  }
}