import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../tickets/application/ticket_selection_cubit.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({required this.event, required this.store, super.key});
  final Event event;
  final AppStore store;
  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => TicketSelectionCubit(), child: BlocBuilder<TicketSelectionCubit, TicketSelectionState>(builder: (context, state) => _EventDetailContent(event: event, store: store, quantity: state.quantity)));
}

class _EventDetailContent extends StatelessWidget {
  const _EventDetailContent({required this.event, required this.store, required this.quantity});
  final Event event;
  final AppStore store;
  final int quantity;
  void _book(BuildContext context) {
    if (!store.isSignedIn) { context.push('/auth'); return; }
    context.push('/tickets/select/${event.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share_outlined)), IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(height: 174, color: Color(event.color), child: const Center(child: Icon(Icons.auto_awesome, size: 64, color: Colors.white)))),
          const SizedBox(height: 14),
          Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE6E8ED)), borderRadius: BorderRadius.circular(10)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(event.date.split(',').first, style: const TextStyle(fontWeight: FontWeight.w700)), const Text('MAR', style: TextStyle(fontSize: 8, color: AppTheme.muted))])),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event.date, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)), Text(event.time, style: const TextStyle(fontSize: 10, color: AppTheme.muted))]),
          ]),
          const SizedBox(height: 22),
          const Text('About this event', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(event.description),
          const SizedBox(height: 12),
          const Text('Show more', style: TextStyle(color: AppTheme.coral, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 26),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('\$${event.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)), const Text('100 Spot left', style: TextStyle(fontSize: 10, color: AppTheme.muted))]),
            const Spacer(),
            IconButton(onPressed: quantity > 1 ? context.read<TicketSelectionCubit>().decrement : null, icon: const Icon(Icons.remove_circle_outline)),
            Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
            IconButton(onPressed: context.read<TicketSelectionCubit>().increment, icon: const Icon(Icons.add_circle_outline)),
            const SizedBox(width: 8),
            FilledButton(onPressed: () => _book(context), style: FilledButton.styleFrom(backgroundColor: AppTheme.coral, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Get a Ticket')),
          ]),
        ],
      ),
    );
  }
}