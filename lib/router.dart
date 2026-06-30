import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/project_detail/project_detail_screen.dart';
import 'features/session/session_active_screen.dart';
import 'features/inbox/inbox_screen.dart';
import 'features/new_project/new_project_screen.dart';
import 'features/import/import_screen.dart';
import 'features/import/import_preview_screen.dart';
import 'features/weekly_report/weekly_report_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/import_history_screen.dart';
import 'widgets/nav_bar.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => PulseShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/inbox',
          name: 'inbox',
          builder: (context, state) => const InboxScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'import-history',
              name: 'importHistory',
              builder: (context, state) => const ImportHistoryScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/project/:id',
      name: 'projectDetail',
      builder: (context, state) => ProjectDetailScreen(
        projectId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/session/:projectId',
      name: 'sessionActive',
      builder: (context, state) => SessionActiveScreen(
        projectId: state.pathParameters['projectId']!,
        sessionId: state.uri.queryParameters['sessionId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/new-project',
      name: 'newProject',
      builder: (context, state) => const NewProjectScreen(),
    ),
    GoRoute(
      path: '/import',
      name: 'import',
      builder: (context, state) => const ImportScreen(),
    ),
    GoRoute(
      path: '/import/preview',
      name: 'importPreview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ImportPreviewScreen(
          rawYaml: extra['rawYaml'] as String,
          parseResult: extra['parseResult'],
        );
      },
    ),
    GoRoute(
      path: '/weekly-report',
      name: 'weeklyReport',
      builder: (context, state) => const WeeklyReportScreen(),
    ),
  ],
);
