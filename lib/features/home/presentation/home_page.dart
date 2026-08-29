import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/design_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final upcoming = store.events.isNotEmpty ? store.events.first : null;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 8, 0, 24),
          children: [
            const LocationHeader(),
            const SizedBox(height: 17),
            const ReferenceSearchField(),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Upcoming Events', showSeeAll: false),
            const SizedBox(height: 10),
            if (upcoming != null) UpcomingEventCard(event: upcoming),
            const SizedBox(height: 25),
            const SectionHeader(title: 'Popular Now'),
            const SizedBox(height: 11),
            SizedBox(
              height: AppDimensions.popularCardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: store.events.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) =>
                    PopularEventCard(event: store.events[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const EvenlineNavigationBar(selectedIndex: 0),
    );
  }
}

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: AppSpacing.screen),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find events near', style: AppTextStyles.caption),
              SizedBox(height: 5),
              Text(
                'California, USA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        _IconButton(onPressed: () {}),
      ],
    ),
  );
}

class ReferenceSearchField extends StatelessWidget {
  const ReferenceSearchField({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(right: AppSpacing.screen),
    child: SizedBox(
      height: AppDimensions.searchHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.field)),
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            Icon(
              Icons.search_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 10),
            Text('Search all events...', style: AppTextStyles.body),
          ],
        ),
      ),
    ),
  );
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: const SizedBox(
      width: 42,
      height: 42,
      child: Center(
        child: Icon(
          Icons.notifications_none_rounded,
          size: 22,
          color: AppColors.textPrimary,
        ),
      ),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.showSeeAll = true, super.key});
  final String title;
  final bool showSeeAll;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: AppSpacing.screen),
    child: Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.section)),
        if (showSeeAll) const Text('See All', style: AppTextStyles.caption),
      ],
    ),
  );
}

class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: AppSpacing.screen),
    child: GestureDetector(
      onTap: () => context.push('/event/${event.id}'),
      child: Container(
        height: AppDimensions.upcomingCardHeight,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadii.card),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D17212B),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            DateBadgeArtwork(event: event),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${event.date}  -  ${event.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 4),
                  const _MetaLine(text: 'California, CA'),
                ],
              ),
            ),
            const SizedBox(width: 7),
            const _SmallAction(label: 'Join'),
          ],
        ),
      ),
    ),
  );
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: AppSpacing.screen, bottom: 10),
      child: UpcomingEventCard(event: event),
    ),
  );
}

class PopularEventCard extends StatelessWidget {
  const PopularEventCard({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: AppDimensions.popularCardWidth,
    child: GestureDetector(
      onTap: () => context.push('/event/${event.id}'),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadii.card),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D17212B),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Artwork(event: event, width: double.infinity, height: 106),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.date}  -  ${event.time}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      const Expanded(
                        child: Text(
                          'California, CA',
                          style: AppTextStyles.caption,
                        ),
                      ),
                      _PriceBadge(event: event),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Artwork extends StatelessWidget {
  const _Artwork({
    required this.event,
    required this.width,
    required this.height,
  });
  final Event event;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    color: Color(event.color),
    child: Stack(
      children: [
        Positioned(
          right: -18,
          top: -22,
          child: Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: Color(0x35FFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: -28,
          child: Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: Color(0x25FFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Center(
          child: Icon(Icons.auto_awesome, size: 31, color: Colors.white),
        ),
      ],
    ),
  );
}

class DateBadgeArtwork extends StatelessWidget {
  const DateBadgeArtwork({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _Artwork(event: event, width: 64, height: 64),
      Positioned(
        left: 4,
        top: 4,
        child: Container(
          width: 27,
          height: 31,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                event.date.split(',').first,
                style: const TextStyle(
                  fontSize: 8,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'MAR',
                style: TextStyle(
                  fontSize: 6,
                  height: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(
        Icons.location_on_outlined,
        size: 13,
        color: AppColors.textSecondary,
      ),
      const SizedBox(width: 3),
      Flexible(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption,
        ),
      ),
    ],
  );
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.surfaceTint,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      event.price == 0 ? 'FREE' : '\$${event.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 10,
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class DateThumbnail extends StatelessWidget {
  const DateThumbnail({required this.event, super.key});
  final Event event;
  @override
  Widget build(BuildContext context) => DateBadgeArtwork(event: event);
}

class EvenlineNavigationBar extends StatelessWidget {
  const EvenlineNavigationBar({required this.selectedIndex, super.key});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => Container(
    height: AppDimensions.bottomNavigationHeight,
    decoration: const BoxDecoration(
      color: AppColors.background,
      border: Border(top: BorderSide(color: AppColors.divider)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _NavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
          active: selectedIndex == 0,
          onTap: () => context.go('/home'),
        ),
        _NavItem(
          icon: Icons.search,
          activeIcon: Icons.search,
          label: 'Explore',
          active: selectedIndex == 1,
          onTap: () => context.go('/explore'),
        ),
        _NavItem(
          icon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          label: 'Favorites',
          active: selectedIndex == 2,
          onTap: () => context.go('/favorites'),
        ),
        _NavItem(
          icon: Icons.confirmation_num_outlined,
          activeIcon: Icons.confirmation_num,
          label: 'Ticket',
          active: selectedIndex == 3,
          onTap: () => context.go('/tickets'),
        ),
        _NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          active: selectedIndex == 4,
          onTap: () => context.go('/profile'),
        ),
      ],
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: SizedBox(
      width: 54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            active ? activeIcon : icon,
            size: 20,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: active ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
