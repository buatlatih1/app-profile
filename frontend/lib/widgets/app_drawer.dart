import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/portal_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final portalProvider = context.watch<PortalProvider>();
    final settings = portalProvider.settings;
    final localeProvider = context.watch<LocaleProvider>();
    final currentCode = localeProvider.languageCode;
    final currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.siteName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        if (settings.siteTagline.isNotEmpty)
                          Text(
                            settings.siteTagline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.home_rounded,
                    title: l10n.text('nav_home'),
                    route: '/',
                    isActive: currentPath == '/',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.newspaper_rounded,
                    title: l10n.text('nav_posts'),
                    route: '/posts',
                    isActive: currentPath.startsWith('/posts'),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: l10n.text('nav_questions'),
                    route: '/questions',
                    isActive: currentPath.startsWith('/questions') && currentPath != '/questions/new',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: l10n.text('nav_faqs'),
                    route: '/faqs',
                    isActive: currentPath.startsWith('/faqs'),
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/questions/new');
                      },
                      icon: const Icon(Icons.add_comment_rounded, size: 18),
                      label: Text(l10n.text('nav_ask_question')),
                    ),
                  ),
                ],
              ),
            ),

            // Language Switcher in Drawer Bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, color: AppTheme.textMuted, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.text('language'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildLangButton(
                        label: 'Bahasa ID',
                        isActive: currentCode == 'id',
                        onTap: () => localeProvider.setLocale(const Locale('id')),
                      ),
                      const SizedBox(width: 6),
                      _buildLangButton(
                        label: 'English',
                        isActive: currentCode == 'en',
                        onTap: () => localeProvider.setLocale(const Locale('en')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primary : AppTheme.secondary,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppTheme.primaryDark : AppTheme.textMain,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          fontSize: 14,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppTheme.primaryLight.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }

  Widget _buildLangButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

