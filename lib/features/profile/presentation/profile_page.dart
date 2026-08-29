import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/reference_widgets.dart';
import '../../home/presentation/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) => ReferenceScaffold(
    title: 'Profile',
    actions: [
      GestureDetector(
        onTap: () => context.push('/linked-accounts'),
        child: const Icon(Icons.edit_outlined, size: 19),
      ),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: () => context.push('/notifications'),
        child: const Icon(Icons.settings_outlined, size: 19),
      ),
    ],
    bottomNavigation: const EvenlineNavigationBar(selectedIndex: 4),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 31,
            backgroundColor: AppColors.primary,
            child: Text(
              store.displayName.characters.first.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(child: Text(store.displayName, style: AppTextStyles.section)),
        const SizedBox(height: 4),
        Center(
          child: Text(store.email ?? 'Guest', style: AppTextStyles.caption),
        ),
        const SizedBox(height: 20),
        Container(
          height: 62,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(value: '150', label: 'Likes'),
              _Stat(value: '50', label: 'My Ticket'),
              _Stat(value: '250', label: 'Following'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const ReferenceTabs(
          labels: ['Events', 'Collections', 'About'],
          selected: 0,
          onSelected: _ignore,
        ),
        const SizedBox(height: 14),
        ...store.events.map(
          (event) => ReferenceEventRow(
            event: event,
            onTap: () => context.push('/event/${event.id}'),
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/following'),
          child: const ReferenceSettingRow(
            icon: Icons.people_outline,
            title: 'Following organizers',
            subtitle: 'Manage your followed organizers',
            trailing: Icon(Icons.chevron_right, size: 18),
          ),
        ),
        if (store.isSignedIn)
          ReferenceSettingRow(
            icon: Icons.logout,
            title: 'Sign out',
            subtitle: 'Leave this account',
            trailing: const SizedBox.shrink(),
          ),
      ],
    ),
  );
}

void _ignore(int _) {}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(value, style: AppTextStyles.cardTitle),
      const SizedBox(height: 3),
      Text(label, style: AppTextStyles.caption),
    ],
  );
}
