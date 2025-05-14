import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/screens/main_screen/add_page.dart';
import 'package:med_reminder/screens/main_screen/home_page.dart';
import 'package:med_reminder/screens/main_screen/profile_page.dart';
import 'package:med_reminder/screens/sign_screens/reset/forgot_password.dart';
import 'package:med_reminder/screens/sign_screens/reset/get_code.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_in.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_up.dart';

import '../core/widgets/bottom_nav_bar.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SignUp(),
        routes: [
          GoRoute(
            path: 'signIn',
            builder: (BuildContext context, GoRouterState state) => SignIn(),
            routes: [
              GoRoute(
                path: 'forgotPassword',
                builder:
                    (BuildContext context, GoRouterState state) =>
                        ForgotPassword(),
                routes: [
                  GoRoute(
                    path: 'getCode',
                    builder:
                        (BuildContext context, GoRouterState state) =>
                            GetCode(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        parentNavigatorKey: rootNavigatorKey,
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
            builder: (BuildContext context, GoRouterState state) => HomePage(),
          ),
          GoRoute(
            path: '/add',
            builder: (BuildContext context, GoRouterState state) => AddPage(),
          ),
          GoRoute(
            path: '/profile',
            builder:
                (BuildContext context, GoRouterState state) => ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
