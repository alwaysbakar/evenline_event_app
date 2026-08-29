import 'package:flutter/material.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/presentation/home_page.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({required this.store, super.key});
  final AppStore store;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your tickets')),
    body: store.bookings.isEmpty
        ? const Center(child: Text('Your next good night starts here.'))
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: store.bookings.length,
            itemBuilder: (_, index) {
              final booking = store.bookings[index];
              final event = store.eventById(booking.eventId);
              return Card(
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    backgroundColor: Color(event.color),
                    child: const Icon(
                      Icons.confirmation_num_outlined,
                      color: AppTheme.ink,
                    ),
                  ),
                  title: Text(event.title),
                  subtitle: Text(
                    '${event.date} at ${event.time}\n${booking.quantity} ticket${booking.quantity == 1 ? '' : 's'}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Cancel booking',
                    onPressed: () => store.cancelBooking(booking.id),
                    icon: const Icon(Icons.close),
                  ),
                ),
              );
            },
          ),
    bottomNavigationBar: const EvenlineNavigationBar(selectedIndex: 3),
  );
}
