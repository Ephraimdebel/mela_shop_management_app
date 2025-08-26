import 'dart:async';

import 'package:hiracosmetics/core/configs/router-configs/route_names.dart';
// import 'package:hiracosmetics/core/extensions/user_ref_extension.dart';
// import 'package:hiracosmetics/features/auth/presentation/controller/auth/state/auth_state.dart';
import 'package:hiracosmetics/features/main_screen.dart';
import 'package:hiracosmetics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:hiracosmetics/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:hiracosmetics/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hiracosmetics/features/product/presentation/screen/add_product_page.dart';
import 'package:hiracosmetics/features/product/presentation/screen/daily_stats_page.dart';
import 'package:hiracosmetics/features/product/presentation/screen/edit_product_page.dart';
import 'package:hiracosmetics/features/product/presentation/screen/monthly_stats_page.dart';
import 'package:hiracosmetics/features/product/presentation/screen/products_page.dart';
import 'package:hiracosmetics/features/product/presentation/screen/sold_products.dart';

import '../../../features/auth/presentation/controller/auth/auth_provider.dart';
import '../../../features/onboarding/presentation/onboarding/onboarding_provider.dart';
import '../../../features/splash_screen.dart';
part 'redirection.dart';
part 'refresh_listener.dart';

final routeProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/splash-screen",
    errorBuilder: (context, state) {
      return const Scaffold(body: Center(child: Text("Page not found")));
    },
    redirect: (context, state) {
      final redirect = handleRedirect(context, state, ref);
      return redirect;
    },
    refreshListenable: _refreshListener(ref),
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: "/splash-screen",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: "/onboarding",
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: RouteNames.signUp,
        path: "/sign-up",
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: RouteNames.signIn,
        path: "/sign-in",
        builder: (context, state) => const SignInScreen(),
      ),

      GoRoute(
        name: RouteNames.addProduct,
        path: "/add-product",
        builder: (context, state) => const AddProductPage(),
      ),
      GoRoute(
        name: RouteNames.editProduct,
        path: "/edit-product/:id",
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EditProductPage(id);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.products,
                path: "/products",
                builder: (context, state) => const ProductsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.sales,
                path: "/sales",
                builder: (context, state) => const SalesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.dailyStats,
                path: "/daily-stats",
                builder: (context, state) => const DailyStatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/monthly-stats",
                name: RouteNames.monthlyStats,
                builder: (context, state) => const MonthlyStatsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
