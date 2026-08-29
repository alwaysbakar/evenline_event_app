import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/presentation/home_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Explore'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText: 'Search all events',
            prefixIcon: Icon(Icons.search_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Browse by category',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 12),
        CategoryPanel(
          title: 'Arts\n& Crafts',
          count: '12 upcoming events',
          color: const Color(0xFF29C5B5),
          onTap: () {},
        ),
        CategoryPanel(
          title: 'Health\n& Wellness',
          count: '10 upcoming events',
          color: const Color(0xFFFF7043),
          onTap: () {},
        ),
        CategoryPanel(
          title: 'Career\n& Business',
          count: '16 upcoming events',
          color: const Color(0xFF7968E9),
          onTap: () {},
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'All events'),
        ...store.events.map(
          (event) => CompactEventTile(
            event: event,
            onTap: () => context.push('/event/${event.id}'),
          ),
        ),
      ],
    ),
    bottomNavigationBar: const EvenlineNavigationBar(selectedIndex: 1),
  );
}

class CategoryPanel extends StatelessWidget {
  const CategoryPanel({
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
    super.key,
  });
  final String title;
  final String count;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: 115,
      width: double.infinity,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    count,
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
