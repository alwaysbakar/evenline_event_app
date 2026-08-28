import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';

const onboardingKey = 'onboarding_completed';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({required this.preferences, super.key});
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            children: [
              Container(height: 300, width: double.infinity, decoration: BoxDecoration(color: AppTheme.coral, borderRadius: BorderRadius.circular(28)), child: const Center(child: Icon(Icons.auto_awesome, size: 92, color: Colors.white))),
              const SizedBox(height: 32),
              Text('Make plans\nworth remembering.', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 14),
              const Text('Discover intimate gatherings, bold ideas, and the people who make every moment count.'),
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () async { await preferences.setBool(onboardingKey, true); if (context.mounted) context.go('/home'); }, style: FilledButton.styleFrom(backgroundColor: AppTheme.ink, padding: const EdgeInsets.symmetric(vertical: 18)), child: const Text('Start exploring'))),
            ],
          ),
        ),
      );
}