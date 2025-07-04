import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/screens/main_screen/add_page.dart';
import 'package:med_reminder/screens/main_screen/home_page.dart';
import 'package:med_reminder/screens/main_screen/profile_page.dart';
import 'package:med_reminder/screens/welcome.dart';

import '../core/widgets/bottom_nav_bar.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey();

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => WelcomeScreen()
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return Main(
            currentIndex: switch (state.uri.path) {
              final p when p.startsWith('/home') => 0,
              final p when p.startsWith('/add') => 1,
              final p when p.startsWith('/profile') => 2,
              _ => 0,
            },
            key: state.pageKey,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (BuildContext context, GoRouterState state) => HomePage(),
          ),
          GoRoute(
            path: '/add',
            name: 'add',
            builder: (BuildContext context, GoRouterState state) => AddPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder:
                (BuildContext context, GoRouterState state) => ProfilePage(name: WelcomeScreen.name),
          ),
        ],
      ),
    ],
  );
}
