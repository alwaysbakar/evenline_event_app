import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/reference_widgets.dart';
import '../../home/presentation/home_page.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({required this.store, super.key});
  final AppStore store;
  @override
  Widget build(BuildContext context) => ReferenceScaffold(
        title: 'Explore',
        actions: [GestureDetector(onTap: () => context.push('/filters'), child: const Icon(Icons.tune, size: 19))],
        bottomNavigation: const EvenlineNavigationBar(selectedIndex: 1),
        body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 24), children: [
          const ReferenceSearch(hint: 'Search for events...'),
          const SizedBox(height: 24),
          Row(children: [const Expanded(child: Text('Browse by category', style: AppTextStyles.section)), GestureDetector(onTap: () => context.push('/filters'), child: const Text('See All', style: AppTextStyles.caption))]),
          const SizedBox(height: 12),
          const Row(children: [Expanded(child: CategoryTile(label: 'Arts & Crafts', color: Color(0xFFF6B96D), icon: Icons.palette_outlined)), SizedBox(width: 10), Expanded(child: CategoryTile(label: 'Music', color: Color(0xFFE89B9D), icon: Icons.music_note_outlined))]),
          const SizedBox(height: 10),
          const Row(children: [Expanded(child: CategoryTile(label: 'Career & Business', color: Color(0xFF9BB7C9), icon: Icons.work_outline)), SizedBox(width: 10), Expanded(child: CategoryTile(label: 'Health & Wellness', color: Color(0xFFB4CDA4), icon: Icons.self_improvement_outlined))]),
          const SizedBox(height: 24),
          const Text('All events', style: AppTextStyles.section),
          const SizedBox(height: 12),
          ...store.events.map((event) => ReferenceEventRow(event: event, onTap: () => context.push('/event/${event.id}'))),
        ]),
      );
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.label, required this.color, required this.icon, super.key});
  final String label;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(height: 92, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadii.card)), child: Row(children: [Icon(icon, color: Colors.white, size: 24), const SizedBox(width: 8), Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)))]));
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override State<FilterScreen> createState() => _FilterScreenState();
}
class _FilterScreenState extends State<FilterScreen> {
  String selected = 'Any category';
  @override
  Widget build(BuildContext context) => ReferenceScaffold(title: 'Filters', leading: GestureDetector(onTap: () => context.pop(), child: const SizedBox(width: 40, child: Align(alignment: Alignment.centerLeft, child: Icon(Icons.close, size: 20)))), bottomAction: ReferenceButton(label: 'Apply', expand: true, onPressed: () => context.pop()), body: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), children: [
    const Text('Dates', style: AppTextStyles.cardTitle), const SizedBox(height: 10), const FilterRow(label: 'April 01, 2022 - April 20, 2022', icon: Icons.calendar_month_outlined),
    const SizedBox(height: 22), const Text('Categories', style: AppTextStyles.cardTitle), const SizedBox(height: 8),
    for (final category in ['Any category', 'Arts', 'Career & Business', 'Health & Wellness']) SelectionRow(label: category, selected: selected == category, onTap: () => setState(() => selected = category)),
    const SizedBox(height: 22), const Text('Price', style: AppTextStyles.cardTitle), const SizedBox(height: 10), const FilterRow(label: 'Any price', icon: Icons.keyboard_arrow_down),
    const SizedBox(height: 22), const Text('Event type', style: AppTextStyles.cardTitle), const SizedBox(height: 10), const FilterRow(label: 'Any event type', icon: Icons.keyboard_arrow_down),
  ]));
}

class FilterRow extends StatelessWidget {
  const FilterRow({required this.label, required this.icon, super.key});
  final String label;
  final IconData icon;
  @override Widget build(BuildContext context) => Container(height: 48, padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(AppRadii.field)), child: Row(children: [Expanded(child: Text(label, style: AppTextStyles.body)), Icon(icon, size: 17, color: AppColors.textSecondary)]));
}

class SelectionRow extends StatelessWidget {
  const SelectionRow({required this.label, required this.selected, required this.onTap, super.key});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: SizedBox(height: 42, child: Row(children: [Icon(Icons.circle_outlined, size: 17, color: selected ? AppColors.success : AppColors.textSecondary), const SizedBox(width: 10), Expanded(child: Text(label, style: AppTextStyles.body)), if (selected) const Icon(Icons.check, color: AppColors.success, size: 18)])));
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({required this.store, super.key});
  final AppStore store;
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Favorites', bottomNavigation: const EvenlineNavigationBar(selectedIndex: 2), body: FutureBuilder<List<Event>>(future: store.favoriteEvents(), builder: (context, snapshot) {
    if (snapshot.hasError) return const Center(child: Text('Unable to load saved events.', style: AppTextStyles.body));
    if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(20), child: ReferenceLoading());
    final events = snapshot.data!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 24), children: [const Text('Saved events', style: AppTextStyles.section), const SizedBox(height: 14), if (events.isEmpty) const Padding(padding: EdgeInsets.only(top: 80), child: Center(child: Text('No saved events yet.', style: AppTextStyles.body))), ...events.map((event) => ReferenceEventRow(event: event, action: 'Saved', onTap: () => context.push('/event/${event.id}')))]);
  }));
}

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({required this.store, super.key});
  final AppStore store;
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Following', body: FutureBuilder<List<String>>(future: store.followingIds(), builder: (context, snapshot) {
    if (snapshot.hasError) return const Center(child: Text('Unable to load following.', style: AppTextStyles.body));
    if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(20), child: ReferenceLoading());
    final followed = snapshot.data!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 24), children: [const ReferenceTabs(labels: ['People', 'Organizer'], selected: 1, onSelected: noopIndex), const SizedBox(height: 16), if (followed.isEmpty) const Text('No followed organizers yet.', style: AppTextStyles.body), for (final name in followed) ReferenceSettingRow(icon: Icons.account_circle_outlined, title: name, subtitle: 'Organizer', trailing: ReferenceButton(label: 'Following', onPressed: () => store.setFollowing(name, false))), const SizedBox(height: 25), const Text('Suggestion for you', style: AppTextStyles.section), const SizedBox(height: 14), const Row(children: [Expanded(child: Suggestion(name: 'DJ Alexia')), SizedBox(width: 10), Expanded(child: Suggestion(name: 'Best Art Boss'))])]);
  }));
}

void noopIndex(int _) {}
void noopAction() {}

class Suggestion extends StatelessWidget {
  const Suggestion({required this.name, super.key});
  final String name;
  @override Widget build(BuildContext context) => Column(children: [const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE9C1AE), child: Icon(Icons.person, color: Colors.white)), const SizedBox(height: 7), Text(name, style: AppTextStyles.caption), const SizedBox(height: 7), ReferenceButton(label: 'Follow', outline: true, expand: true, onPressed: noopAction)]);
}

class FollowOrganizerScreen extends StatelessWidget {
  const FollowOrganizerScreen({super.key});
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Follow Organizer', leading: const SizedBox(width: 40), bottomAction: ReferenceButton(label: 'Continue', expand: true, onPressed: () => context.go('/home')), body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), children: [const Align(alignment: Alignment.centerRight, child: Text('Skip for now', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700))), const SizedBox(height: 25), const Text('Follow Organizer', style: AppTextStyles.heading), const SizedBox(height: 8), const Text('Follow a collection to get updates as new events are added.', style: AppTextStyles.body), const SizedBox(height: 20), const ReferenceSearch(hint: 'Search for more...'), const SizedBox(height: 22), const Text('Recommendations', style: AppTextStyles.section), const SizedBox(height: 12), SizedBox(height: 250, child: Row(children: [Expanded(child: OrganizerRecommendation(title: 'Arts and Crafts of 8Ape')), const SizedBox(width: 10), Expanded(child: OrganizerRecommendation(title: 'Dance Party'))]))]));
}

class OrganizerRecommendation extends StatelessWidget {
  const OrganizerRecommendation({required this.title, super.key});
  final String title;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: const [BoxShadow(color: Color(0x0B17212B), blurRadius: 12, offset: Offset(0, 3))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height: 105, decoration: BoxDecoration(color: const Color(0xFFBBC4D0), borderRadius: BorderRadius.circular(8)), child: const Center(child: Icon(Icons.auto_awesome, color: Colors.white, size: 30))), const SizedBox(height: 9), Text(title, maxLines: 2, style: AppTextStyles.cardTitle), const Spacer(), ReferenceButton(label: 'Follow', outline: true, expand: true, onPressed: noopAction)]));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Push Notification', body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), children: [for (final row in const [('Get alert in your phone', 'Get alert in your notifications', Icons.notifications_none), ('Get alert in your email', 'Get alert in your email inbox', Icons.mail_outline), ('Newsletters', 'Receive emails with events recommendations', Icons.article_outlined), ('Followed organizer email', 'Get notified when your favorite organizers create new events', Icons.person_outline), ('Reminders email', 'Allow set reminders for when event go on sale', Icons.error_outline), ('Liked events email', 'Get alerts when your favorite events are happening', Icons.favorite_border)]) ReferenceSettingRow(icon: row.$3, title: row.$1, subtitle: row.$2, trailing: Switch(value: row.$1.contains('alert') || row.$1.contains('Followed'), onChanged: (_) {}))]));
}

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({required this.store, super.key});
  final AppStore store;
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Link Account', bottomAction: ReferenceButton(label: 'Save Changes', expand: true, onPressed: () => context.pop()), body: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 20), children: [const CircleAvatar(radius: 30, backgroundColor: Color(0xFFE9C1AE), child: Icon(Icons.person, color: Colors.white)), const SizedBox(height: 10), Center(child: Text(store.displayName, style: AppTextStyles.cardTitle)), const SizedBox(height: 26), for (final provider in ['Login with Google', 'Login with Apple', 'Login with Twitter']) ReferenceSettingRow(icon: Icons.account_circle_outlined, title: provider, subtitle: 'Connect this account', trailing: Switch(value: provider.contains('Google'), onChanged: (_) {}))]));
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override State<LanguageScreen> createState() => _LanguageScreenState();
}
class _LanguageScreenState extends State<LanguageScreen> {
  String selected = 'English (USA)';
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'Select Language', body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), children: [const ReferenceSearch(hint: 'Search language...'), const SizedBox(height: 16), for (final language in ['English (USA)', 'English (GBR)', 'France (FR)', 'Spain (ES)', 'Italy (IT)', 'Greece (GR)', 'Singapore (SG)', 'Netherlands (NL)', 'India (IN)']) SelectionRow(label: language, selected: selected == language, onTap: () => setState(() => selected = language))]));
}

class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({required this.store, super.key});
  final AppStore store;
  @override Widget build(BuildContext context) => ReferenceScaffold(title: 'The Creative', actions: [const Icon(Icons.more_horiz, size: 20)], bottomNavigation: const EvenlineNavigationBar(selectedIndex: 1), body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), children: [Container(height: 130, decoration: BoxDecoration(color: const Color(0xFFB7C0C8), borderRadius: BorderRadius.circular(AppRadii.card)), child: const Center(child: Icon(Icons.auto_awesome, size: 38, color: Colors.white))), Transform.translate(offset: const Offset(0, -28), child: const CircleAvatar(radius: 30, backgroundColor: Color(0xFFE9C1AE), child: Icon(Icons.person, color: Colors.white))), Transform.translate(offset: const Offset(0, -18), child: const Column(children: [Text('The Creative', style: AppTextStyles.section), SizedBox(height: 4), Text('12,5K followers', style: AppTextStyles.caption)])), Transform.translate(offset: const Offset(0, -8), child: const Row(children: [Expanded(child: ReferenceButton(label: 'Message', outline: true, expand: true, onPressed: noopAction)), SizedBox(width: 10), Expanded(child: ReferenceButton(label: 'Follow', expand: true, onPressed: noopAction))])), const SizedBox(height: 8), const ReferenceTabs(labels: ['Events', 'Collections', 'About'], selected: 0, onSelected: noopIndex), const SizedBox(height: 16), ...store.events.map((event) => ReferenceEventRow(event: event, onTap: () => context.push('/event/${event.id}')))]));
}
