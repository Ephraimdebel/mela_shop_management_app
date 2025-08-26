import 'package:firebase_core/firebase_core.dart';
import 'package:hiracosmetics/core/constants/constants.dart';
import 'package:hiracosmetics/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/configs/router-configs/router.dart';
import 'features/onboarding/presentation/onboarding/onboarding_provider.dart';
// import 'features/auth/presentation/controller/auth/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sh = await SharedPreferences.getInstance();
  final hasSeenOnboarding = sh.get(hasOnboardingInitialized) as bool?;
  await _initializeFirebase();
  runApp(
    ProviderScope(
      overrides: [
        hasSeenOnboardingProvider
            .overrideWith((ref) => hasSeenOnboarding ?? false)
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final hasOnboardingSeen = ref.watch(hasSeenOnboardingProvider);
    // final user = ref.watch(authNotifierProvider);
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      title: 'Hira Cosmetics',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          surface: Color(0xFF1A237E),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1344),
        cardTheme: CardTheme(
          color: const Color(0xFF1A237E),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.white.withOpacity(0.1),
          backgroundColor: const Color(0xFF1A237E),
        ),
      ),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      //routeInformationParser: router.routeInformationParser,
      // home: hasOnboardingSeen
      //     ? (user?.isAuthenticated == true
      //         ? const MainScreen()
      //         : const SignInScreen())
      //     : const OnboardingScreen(),
    );
  }
}
