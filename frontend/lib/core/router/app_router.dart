import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/faqs_view.dart';
import '../../views/home_view.dart';
import '../../views/not_found_view.dart';
import '../../views/page_detail_view.dart';
import '../../views/post_detail_view.dart';
import '../../views/posts_view.dart';
import '../../views/questions_view.dart';
import '../../views/submit_question_view.dart';
import '../../widgets/portal_shell.dart';
import '../localization/locale_provider.dart';

GoRouter createAppRouter(LocaleProvider localeProvider) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return PortalShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/posts',
            builder: (context, state) {
              final category = state.uri.queryParameters['category'];
              final query = state.uri.queryParameters['q'];
              return PostsView(
                initialCategory: category,
                initialQuery: query,
              );
            },
          ),
          GoRoute(
            path: '/posts/:slug',
            builder: (context, state) {
              final slug = state.pathParameters['slug'] ?? '';
              return PostDetailView(slug: slug);
            },
          ),
          GoRoute(
            path: '/pages/:slug',
            builder: (context, state) {
              final slug = state.pathParameters['slug'] ?? '';
              return PageDetailView(slug: slug);
            },
          ),
          GoRoute(
            path: '/questions',
            builder: (context, state) {
              final topic = state.uri.queryParameters['topic'];
              final query = state.uri.queryParameters['q'];
              return QuestionsView(
                initialTopic: topic,
                initialQuery: query,
              );
            },
          ),
          GoRoute(
            path: '/questions/new',
            builder: (context, state) => const SubmitQuestionView(),
          ),
          GoRoute(
            path: '/faqs',
            builder: (context, state) {
              final topic = state.uri.queryParameters['topic'];
              final query = state.uri.queryParameters['q'];
              return FaqsView(
                initialTopic: topic,
                initialQuery: query,
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const PortalShell(
      child: NotFoundView(),
    ),
  );
}

