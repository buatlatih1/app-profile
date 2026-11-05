import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/faq_provider.dart';
import 'providers/inquiry_provider.dart';
import 'providers/portal_provider.dart';
import 'providers/post_list_provider.dart';
import 'services/faq_service.dart';
import 'services/inquiry_service.dart';
import 'services/page_service.dart';
import 'services/portal_service.dart';
import 'services/post_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeProvider = LocaleProvider();
  final apiClient = ApiClient(localeProvider: localeProvider);

  final portalService = PortalService(apiClient);
  final postService = PostService(apiClient);
  final pageService = PageService(apiClient);
  final faqService = FaqService(apiClient);
  final inquiryService = InquiryService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
        Provider<ApiClient>.value(value: apiClient),
        Provider<PortalService>.value(value: portalService),
        Provider<PostService>.value(value: postService),
        Provider<PageService>.value(value: pageService),
        Provider<FaqService>.value(value: faqService),
        Provider<InquiryService>.value(value: inquiryService),
        ChangeNotifierProvider<PortalProvider>(
          create: (_) => PortalProvider(
            portalService: portalService,
            postService: postService,
            pageService: pageService,
            faqService: faqService,
            inquiryService: inquiryService,
            localeProvider: localeProvider,
          ),
        ),
        ChangeNotifierProvider<PostListProvider>(
          create: (_) => PostListProvider(
            postService: postService,
            localeProvider: localeProvider,
          ),
        ),
        ChangeNotifierProvider<InquiryProvider>(
          create: (_) => InquiryProvider(
            inquiryService: inquiryService,
            localeProvider: localeProvider,
          ),
        ),
        ChangeNotifierProvider<FaqProvider>(
          create: (_) => FaqProvider(
            faqService: faqService,
            inquiryService: inquiryService,
            localeProvider: localeProvider,
          ),
        ),
      ],
      child: const FrontendPortalApp(),
    ),
  );
}

class FrontendPortalApp extends StatefulWidget {
  const FrontendPortalApp({super.key});

  @override
  State<FrontendPortalApp> createState() => _FrontendPortalAppState();
}

class _FrontendPortalAppState extends State<FrontendPortalApp> {
  late final dynamic _router;

  @override
  void initState() {
    super.initState();
    final localeProvider = context.read<LocaleProvider>();
    _router = createAppRouter(localeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'Portal Resmi Instansi & Layanan Publik',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
