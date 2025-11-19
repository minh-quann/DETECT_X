import 'package:detect_x/core/utils/extensions.dart';
import 'package:detect_x/l10n/app_localizations.dart';
import 'package:detect_x/logic/auth/auth_bloc.dart';
import 'package:detect_x/logic/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/glass_card.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/primary_button.dart';

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
    final l10n = context.l10n;

    final features = _buildFeatureData(context, isGuest);
    final navItems = [
      const _NavItem("Upload", Icons.upload),
      const _NavItem("URL", Icons.link),
      const _NavItem("Realtime", Icons.videocam),
      if (!isGuest) const _NavItem("History", Icons.history),
    ];

    Widget bodyContent;
    if (_selectedIndex == 0) {
      bodyContent = _buildDashboardList(context, features, isGuest);
    } else {
      final item = navItems[_selectedIndex];
      bodyContent = _buildFeaturePlaceholder(
        context,
        l10n.translate(item.key),
        item.icon,
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                _buildHeader(context, isGuest),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: bodyContent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 32,
          child: NavigationBar(
            height: 72,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            destinations: navItems
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    label: l10n.translate(item.key),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardList(
    BuildContext context,
    List<_FeatureCardData> features,
    bool isGuest,
  ) {
    return ListView(
      key: ValueKey(_selectedIndex),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _buildHeroBanner(context, isGuest),
        const SizedBox(height: 28),
        Text(
          "Quick actions",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildFeatureGrid(features),
        const SizedBox(height: 28),
        _buildStatusSection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isGuest) {
    final theme = Theme.of(context);
    final subtitle = isGuest
        ? "Guest session · Limited history access"
        : "Secure workspace ready";
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xin chào${isGuest ? '' : ', Analyst'}",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              context.l10n.appTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const Spacer(),
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            IconData icon;
            switch (mode) {
              case ThemeMode.light:
                icon = Icons.light_mode;
                break;
              case ThemeMode.dark:
                icon = Icons.dark_mode;
                break;
              default:
                icon = Icons.settings_brightness;
            }
            return GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 20,
              child: IconButton(
                icon: Icon(icon),
                onPressed: () => context.read<ThemeCubit>().cycleTheme(),
                tooltip: "Đổi giao diện",
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isGuest) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(28),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theme.primaryColor.withValues(alpha: 0.18),
                ),
                child: Text(
                  isGuest ? "Preview mode" : "Protected workspace",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                title: "Start scan",
                icon: Icons.play_arrow_rounded,
                expand: false,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Liquid glass dashboard",
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Monitor uploads, streaming detection and URL analysis from a single immersive dashboard.",
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildHeroChip(Icons.shield_moon, "AES-256 encryption"),
              _buildHeroChip(Icons.flash_on, "Realtime vision"),
              _buildHeroChip(Icons.history, "Deep log insights"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroChip(IconData icon, String label) {
    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      showGlow: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
      ),
    );
  }

  List<_FeatureCardData> _buildFeatureData(BuildContext context, bool isGuest) {
    final l10n = context.l10n;
    final items = [
      _FeatureCardData(
        title: l10n.translate("Upload"),
        description: "Drop files or folders for instant inspection",
        icon: Icons.cloud_upload_outlined,
        accent: Colors.cyanAccent,
      ),
      _FeatureCardData(
        title: l10n.translate("URL"),
        description: "Paste links to verify authenticity within seconds",
        icon: Icons.link,
        accent: Colors.amberAccent,
      ),
      _FeatureCardData(
        title: l10n.translate("Realtime"),
        description: "Connect to live feeds for on-the-fly detection",
        icon: Icons.remove_red_eye_outlined,
        accent: Colors.pinkAccent,
      ),
      _FeatureCardData(
        title: l10n.translate("History"),
        description: "Review and audit previous scans with filters",
        icon: Icons.history,
        accent: Colors.limeAccent,
        requiresAuth: true,
      ),
    ];

    return isGuest ? items.where((item) => !item.requiresAuth).toList() : items;
  }

  Widget _buildFeatureGrid(List<_FeatureCardData> features) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 1000
            ? 3
            : width > 640
            ? 2
            : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final item = features[index];
            return GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.accent.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(item.icon, size: 28, color: item.accent),
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Live insights",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildStatusCard(
              icon: Icons.security,
              title: "Integrity",
              value: "All checks stable",
              color: Colors.greenAccent,
            ),
            _buildStatusCard(
              icon: Icons.cloud_sync,
              title: "Realtime link",
              value: "Ready for new feed",
              color: Colors.blueAccent,
            ),
            _buildStatusCard(
              icon: Icons.auto_graph,
              title: "Weekly delta",
              value: "+18% detections",
              color: Colors.purpleAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final titleColor = theme.brightness == Brightness.dark
        ? Colors.white
        : theme.colorScheme.onSurface;
    final valueColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.8)
        : theme.colorScheme.onSurface.withValues(alpha: 0.75);
    return SizedBox(
      width: 260,
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  Text(value, style: TextStyle(color: valueColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePlaceholder(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Center(
      child: GlassCard(
        borderRadius: 32,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              "$title module is brewing",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "We are finalizing the liquid glass experience for $title. Stay tuned!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

extension AppLocalizationsHelper on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case "Upload":
        return uploadButton;
      case "URL":
        return "URL";
      case "Realtime":
        return "Realtime";
      case "History":
        return "Lịch sử";
      default:
        return key;
    }
  }

  String get uploadButton => "Tải lên";
}

class _FeatureCardData {
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final bool requiresAuth;

  const _FeatureCardData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    this.requiresAuth = false,
  });
}

class _NavItem {
  final String key;
  final IconData icon;

  const _NavItem(this.key, this.icon);
}
