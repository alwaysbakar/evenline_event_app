import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../home/presentation/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.store, super.key});
  final AppStore store;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile')), body: ListView(padding: const EdgeInsets.all(24), children: [CircleAvatar(radius: 38, backgroundColor: const Color(0xFFFF685D), child: Text(store.displayName.characters.first.toUpperCase(), style: const TextStyle(fontSize: 28, color: Colors.white))), const SizedBox(height: 14), Center(child: Text(store.displayName, style: Theme.of(context).textTheme.headlineSmall)), Center(child: Text(store.email ?? 'Guest')), const SizedBox(height: 32), ListTile(leading: const Icon(Icons.confirmation_num_outlined), title: const Text('My tickets'), trailing: const Icon(Icons.chevron_right), onTap: () => context.go('/tickets')), ListTile(leading: const Icon(Icons.add_business_outlined), title: const Text('Organizer studio'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/organizer')), if (store.isSignedIn) ListTile(leading: const Icon(Icons.logout), title: const Text('Sign out'), onTap: () async { await store.signOut(); if (context.mounted) context.go('/home'); }) else ListTile(leading: const Icon(Icons.login), title: const Text('Sign in'), onTap: () => context.push('/auth'))]), bottomNavigationBar: const EvenlineNavigationBar(selectedIndex: 3));
}