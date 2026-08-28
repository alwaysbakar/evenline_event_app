import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';

class ScreenGalleryPage extends StatelessWidget {
  const ScreenGalleryPage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Evenline screens'), leading: const BackButton()),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          const Text('Primary screens', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink)),
          const SizedBox(height: 12),
          _ScreenTile(title: 'Home / recommendations', icon: Icons.home_outlined, onTap: () => context.go('/home')),
          _ScreenTile(title: 'Explore / categories', icon: Icons.search, onTap: () => context.go('/explore')),
          _ScreenTile(title: 'Event detail', icon: Icons.event_outlined, onTap: () => context.go('/event/${store.events.first.id}')),
          _ScreenTile(title: 'Ticket selection', icon: Icons.confirmation_num_outlined, onTap: () => context.go('/tickets/select/${store.events.first.id}')),
          _ScreenTile(title: 'Order summary', icon: Icons.receipt_long_outlined, onTap: () => context.go('/tickets/order/${store.events.first.id}?quantity=1')),
          _ScreenTile(title: 'My tickets', icon: Icons.local_activity_outlined, onTap: () => context.go('/tickets')),
          _ScreenTile(title: 'Profile', icon: Icons.person_outline, onTap: () => context.go('/profile')),
          _ScreenTile(title: 'Organizer studio', icon: Icons.add_business_outlined, onTap: () => context.go('/organizer')),
          const SizedBox(height: 22),
          const Text('Account states', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink)),
          const SizedBox(height: 12),
          _ScreenTile(title: 'Sign in / create account', icon: Icons.login, onTap: () => context.go('/auth')),
          _ScreenTile(title: 'Forgot password', icon: Icons.lock_reset_outlined, onTap: () => context.go('/forgot-password')),
          _ScreenTile(title: 'Onboarding', icon: Icons.auto_awesome_outlined, onTap: () => context.go('/onboarding')),
        ]),
      );
}

class _ScreenTile extends StatelessWidget {
  const _ScreenTile({required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Card(elevation: 1, child: ListTile(onTap: onTap, leading: Icon(icon, color: AppTheme.coral), title: Text(title), trailing: const Icon(Icons.chevron_right))));
}
