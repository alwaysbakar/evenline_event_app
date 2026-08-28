import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 24),
          children: [
            Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Find events near', style: TextStyle(fontSize: 10, color: AppTheme.muted)), SizedBox(height: 4), Text('California, USA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.ink))])),
              IconButton(onPressed: () => context.push('/screens'), icon: const Icon(Icons.dashboard_customize_outlined)),
              const SizedBox(width: 8),
            ]),
            const Padding(padding: EdgeInsets.only(right: 16, top: 10), child: TextField(decoration: InputDecoration(hintText: 'Search all events...', prefixIcon: Icon(Icons.search_rounded, size: 18)))),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Featured events'),
            const SizedBox(height: 8),
            ...store.events.map((event) => CompactEventTile(event: event, onTap: () => context.push('/event/${event.id}'))),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Popular Now'),
            const SizedBox(height: 10),
            SizedBox(height: 220, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: store.events.length, separatorBuilder: (_, _) => const SizedBox(width: 12), itemBuilder: (_, index) => PopularEventCard(event: store.events[index]))),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Who to follow'),
            ListTile(contentPadding: const EdgeInsets.only(right: 16), leading: const CircleAvatar(backgroundColor: Color(0xFFE9E2D8), child: Icon(Icons.person_outline)), title: const Text('Discover local organizers'), subtitle: const Text('Follow hosts and find your next favorite event.'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/organizer')),
          ],
        ),
      ),
      bottomNavigationBar: const EvenlineNavigationBar(selectedIndex: 0),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 16), child: Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)), TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(fontSize: 11)))]));
}

class EventCard extends StatelessWidget {
  const EventCard({required this.event, super.key});
  final Event event;
  @override
  Widget build(BuildContext context) => PopularEventCard(event: event);
}

class CompactEventTile extends StatelessWidget {
  const CompactEventTile({required this.event, required this.onTap, super.key});
  final Event event;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 10),
        child: Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            leading: DateThumbnail(event: event),
            title: Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.muted), const SizedBox(width: 3), Flexible(child: Text(event.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)))]),
            trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFFFEEE9), borderRadius: BorderRadius.circular(7)), child: Text(event.price == 0 ? 'FREE' : '\$${event.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 10, color: AppTheme.coral, fontWeight: FontWeight.w700))),
          ),
        ),
      );
}

class PopularEventCard extends StatelessWidget {
  const PopularEventCard({required this.event, super.key});
  final Event event;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 188,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: InkWell(
            onTap: () => context.push('/event/${event.id}'),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Container(color: Color(event.color), child: const Center(child: Icon(Icons.auto_awesome, size: 42, color: Colors.white)))),
              Padding(padding: const EdgeInsets.fromLTRB(9, 8, 9, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${event.date} - ${event.time}', style: const TextStyle(fontSize: 9, color: AppTheme.muted)),
                const SizedBox(height: 5),
                Text(event.title, maxLines: 2, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 7),
                Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.muted), const SizedBox(width: 3), Expanded(child: Text(event.venue, style: const TextStyle(fontSize: 9, color: AppTheme.muted)))]),
              ])),
            ]),
          ),
        ),
      );
}

class DateThumbnail extends StatelessWidget {
  const DateThumbnail({required this.event, super.key});
  final Event event;
  @override
  Widget build(BuildContext context) => Container(width: 58, height: 62, decoration: BoxDecoration(color: Color(event.color), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(event.date.split(',').first, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)), const Text('JUN', style: TextStyle(fontSize: 8, color: AppTheme.muted)), const Icon(Icons.auto_awesome, size: 18, color: Colors.white)]));
}

class EvenlineNavigationBar extends StatelessWidget {
  const EvenlineNavigationBar({required this.selectedIndex, super.key});
  final int selectedIndex;
  @override
  Widget build(BuildContext context) => NavigationBar(selectedIndex: selectedIndex, onDestinationSelected: (index) { if (index == 0) context.go('/home'); if (index == 1) context.go('/explore'); if (index == 2) context.go('/tickets'); if (index == 3) context.go('/profile'); }, destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppTheme.coral), label: 'Home'), NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search, color: AppTheme.coral), label: 'Explore'), NavigationDestination(icon: Icon(Icons.confirmation_num_outlined), selectedIcon: Icon(Icons.confirmation_num, color: AppTheme.coral), label: 'Ticket'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppTheme.coral), label: 'Profile')]);
}