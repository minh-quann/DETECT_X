import 'package:detect_x/core/utils/extensions.dart';
import 'package:detect_x/l10n/app_localizations.dart';
import 'package:detect_x/logic/auth/auth_bloc.dart';
import 'package:detect_x/logic/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isGuest = authState.status == AuthStatus.guest;


    final List<Widget> pages = [
      _buildFeaturePlaceholder(context, "Upload", Icons.upload_file),
      _buildFeaturePlaceholder(context, "URL", Icons.link),
      _buildFeaturePlaceholder(context, "Realtime", Icons.remove_red_eye),
    ];


    if (!isGuest) {
      pages.add(_buildFeaturePlaceholder(context, "History", Icons.history));
    }

    // Get the current language to display the title
    final l10n = context.l10n; 
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Change Theme button
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(!isDark),
              );
            },
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.upload), label: l10n.translate("Upload")),
          NavigationDestination(icon: const Icon(Icons.link), label: l10n.translate("URL")),
          NavigationDestination(icon: const Icon(Icons.videocam), label: l10n.translate("Realtime")),
     
          if (!isGuest)
            NavigationDestination(icon: const Icon(Icons.history), label: l10n.translate("History")),
        ],
      ),
    );
  }


  Widget _buildFeaturePlaceholder(BuildContext context, String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text("Feature: $title", 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          const Text("Màn hình này đang được phát triển...", 
            style: TextStyle(color: Colors.grey)
          ),
        ],
      ),
    );
  }
}


extension AppLocalizationsHelper on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case "Upload": return this.uploadButton ?? "Upload";
      case "URL": return "URL";
      case "Realtime": return "Realtime";
      case "History": return "Lịch sử";
      default: return key;
    }
  }

  String get uploadButton => "Tải lên";
}