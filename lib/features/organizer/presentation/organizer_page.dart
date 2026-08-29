import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../application/organizer_cubit.dart';

class OrganizerPage extends HookWidget {
  const OrganizerPage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final title = useTextEditingController();
    final venue = useTextEditingController();
    final date = useTextEditingController(text: 'Sat, Jul 13');
    final price = useTextEditingController(text: '20');
    return BlocProvider(
      create: (_) => OrganizerCubit(store),
      child: BlocListener<OrganizerCubit, PublishState>(
        listener: (context, state) {
          if (state.status == PublishStatus.success) {
            title.clear();
            venue.clear();
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Event published')));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Organizer studio')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Organizer tools',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/organizer/dashboard'),
                    icon: const Icon(Icons.analytics_outlined),
                  ),
                  IconButton(
                    onPressed: () => context.push('/organizer/scanner'),
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Make a night of it.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Publish the details people need, then keep the room moving.',
              ),
              const SizedBox(height: 28),
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Event name'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: venue,
                decoration: const InputDecoration(labelText: 'Venue'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: date,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ticket price'),
              ),
              const SizedBox(height: 24),
              BlocBuilder<OrganizerCubit, PublishState>(
                builder: (context, state) => SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.status == PublishStatus.loading
                        ? null
                        : () => context.read<OrganizerCubit>().publish(
                            title: title.text.trim(),
                            venue: venue.text.trim(),
                            date: date.text.trim(),
                            price: double.tryParse(price.text) ?? 20,
                          ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.ink,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    child: Text(
                      state.status == PublishStatus.loading
                          ? 'Publishing...'
                          : 'Publish event',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your published events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ...store.events
                  .where((event) => event.organizer == store.displayName)
                  .map(
                    (event) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(event.title),
                      subtitle: Text('${event.date} - ${event.venue}'),
                      trailing: const Icon(Icons.check_circle_outline),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
