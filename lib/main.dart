import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/data/app_store.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/design_tokens.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/event/presentation/event_detail_page.dart';
import 'features/explore/presentation/explore_page.dart';
import 'features/auth/presentation/forgot_password_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/onboarding/presentation/onboarding_page.dart';
import 'features/organizer/presentation/organizer_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/tickets/presentation/tickets_page.dart';
import 'features/tickets/presentation/booking_flow_page.dart';
import 'features/showcase/presentation/screen_gallery_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preferences = await SharedPreferences.getInstance();
  final store = AppStore(preferences, useFirebase: true);
  await store.load();
  runApp(EvenlineApp(preferences: preferences, store: store));
}

class EvenlineApp extends StatelessWidget {
  EvenlineApp({required this.preferences, AppStore? store, super.key}) : store = store ?? AppStore(preferences) {
    this.store.load();
  }

  final SharedPreferences preferences;
  final AppStore store;

  late final router = GoRouter(
    initialLocation: const bool.fromEnvironment('SHOW_SCREEN_GALLERY') ? '/screens' : preferences.getBool(onboardingKey) == true ? '/home' : '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => OnboardingPage(preferences: preferences)),
      GoRoute(path: '/auth', builder: (_, _) => AuthPage(store: store)),
      GoRoute(path: '/forgot-password', builder: (_, _) => ForgotPasswordPage(store: store)),
      GoRoute(path: '/home', builder: (_, _) => HomePage(store: store)),
      GoRoute(path: '/explore', builder: (_, _) => ExplorePage(store: store)),
      GoRoute(path: '/event/:id', builder: (_, state) => EventDetailPage(event: store.eventById(state.pathParameters['id']!), store: store)),
      GoRoute(path: '/tickets', builder: (_, _) => TicketsPage(store: store)),
      GoRoute(path: '/tickets/select/:id', builder: (_, state) => TicketSelectionPage(event: store.eventById(state.pathParameters['id']!), store: store)),
      GoRoute(path: '/tickets/order/:id', builder: (_, state) => OrderSummaryPage(event: store.eventById(state.pathParameters['id']!), store: store, quantity: int.tryParse(state.uri.queryParameters['quantity'] ?? '1') ?? 1)),
      GoRoute(path: '/profile', builder: (_, _) => ProfilePage(store: store)),
      GoRoute(path: '/organizer', builder: (_, _) => OrganizerPage(store: store)),
      GoRoute(path: '/screens', builder: (_, _) => ScreenGalleryPage(store: store)),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(title: 'Evenline', theme: AppTheme.light, routerConfig: router, builder: (context, child) => ReferenceCanvas(child: child ?? const SizedBox.shrink()));
}