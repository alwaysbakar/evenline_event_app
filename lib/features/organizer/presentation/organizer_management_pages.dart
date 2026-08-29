import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/reference_widgets.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) => ReferenceScaffold(
    title: 'Organizer Dashboard',
    actions: [
      GestureDetector(
        onTap: () => context.push('/organizer/editor'),
        child: const Icon(Icons.add, size: 21),
      ),
    ],
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const Text('Good evening, organizer', style: AppTextStyles.heading),
        const SizedBox(height: 6),
        const Text(
          'Keep an eye on your events and audience.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Events',
                value: '12',
                color: Color(0xFFFFE3D6),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _Metric(
                label: 'Tickets sold',
                value: '248',
                color: Color(0xFFDCECF0),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _Metric(
                label: 'Revenue',
                value: '\$8.4k',
                color: Color(0xFFE5EBD9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            const Expanded(
              child: Text('Your events', style: AppTextStyles.section),
            ),
            GestureDetector(
              onTap: () => context.push('/organizer/editor'),
              child: const Text(
                'Create new',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...store.events.map(
          (event) => ReferenceEventRow(
            event: event,
            action: 'Open',
            onTap: () => context.push('/organizer/attendees/${event.id}'),
          ),
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    height: 86,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppRadii.card),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: AppTextStyles.section),
        Text(label, style: AppTextStyles.caption),
      ],
    ),
  );
}

class OrganizerEditorScreen extends StatefulWidget {
  const OrganizerEditorScreen({required this.store, super.key});
  final AppStore store;
  @override
  State<OrganizerEditorScreen> createState() => _OrganizerEditorScreenState();
}

class _OrganizerEditorScreenState extends State<OrganizerEditorScreen> {
  final title = TextEditingController();
  final venue = TextEditingController();
  final date = TextEditingController(text: 'Sat, Jul 13');
  final price = TextEditingController(text: '20');
  int step = 0;

  @override
  void dispose() {
    title.dispose();
    venue.dispose();
    date.dispose();
    price.dispose();
    super.dispose();
  }

  void save() {
    widget.store.createEvent(
      title: title.text.trim().isEmpty
          ? 'New Evenline event'
          : title.text.trim(),
      category: 'Community',
      date: date.text.trim(),
      time: '7:00 PM',
      venue: venue.text.trim().isEmpty ? 'Your venue' : venue.text.trim(),
      price: double.tryParse(price.text) ?? 20,
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) => ReferenceScaffold(
    title: 'Create Event',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        ReferenceTabs(
          labels: const ['Details', 'Gallery', 'Tickets'],
          selected: step,
          onSelected: (value) => setState(() => step = value),
        ),
        const SizedBox(height: 22),
        if (step == 0) ...[
          const _FieldLabel(label: 'Event name'),
          TextField(
            controller: title,
            decoration: const InputDecoration(hintText: 'Name your event'),
          ),
          const SizedBox(height: 14),
          const _FieldLabel(label: 'Venue'),
          TextField(
            controller: venue,
            decoration: const InputDecoration(
              hintText: 'Where is it happening?',
            ),
          ),
          const SizedBox(height: 14),
          const _FieldLabel(label: 'Date and time'),
          TextField(
            controller: date,
            decoration: const InputDecoration(hintText: 'Choose date'),
          ),
        ] else if (step == 1) ...[
          const _FieldLabel(label: 'Event cover'),
          _UploadBox(label: 'Add cover image', icon: Icons.image_outlined),
          const SizedBox(height: 16),
          const _FieldLabel(label: 'Gallery'),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                    child: _UploadBox(
                      label: '+',
                      icon: Icons.add,
                      compact: true,
                    ),
                  ),
                ),
            ],
          ),
        ] else ...[
          const _FieldLabel(label: 'Ticket type'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(hintText: 'Ticket name'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Price'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Quantity'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '+ Add another ticket type',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 28),
        ReferenceButton(
          label: step == 2 ? 'Publish event' : 'Continue',
          expand: true,
          onPressed: step == 2 ? save : () => setState(() => step += 1),
        ),
      ],
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(label, style: AppTextStyles.cardTitle),
  );
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.label,
    required this.icon,
    this.compact = false,
  });
  final String label;
  final IconData icon;
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
    height: compact ? 74 : 142,
    decoration: BoxDecoration(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(AppRadii.card),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: compact ? 20 : 28, color: AppColors.textSecondary),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    ),
  );
}

class OrganizerAttendeesScreen extends StatelessWidget {
  const OrganizerAttendeesScreen({
    required this.store,
    required this.eventId,
    super.key,
  });
  final AppStore store;
  final String eventId;
  @override
  Widget build(BuildContext context) {
    final event = store.eventById(eventId);
    return ReferenceScaffold(
      title: 'Attendees',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          Text(event.title, style: AppTextStyles.section),
          const SizedBox(height: 5),
          Text('24 checked in  /  80 tickets', style: AppTextStyles.body),
          const SizedBox(height: 18),
          const ReferenceSearch(hint: 'Search attendees...'),
          const SizedBox(height: 14),
          for (final attendee in [
            'Michella Barkin',
            'Alex Morgan',
            'Dana Point',
            'Jordan Lee',
            'Taylor Smith',
          ])
            ReferenceSettingRow(
              icon: Icons.account_circle_outlined,
              title: attendee,
              subtitle: 'Ticket holder  •  1 ticket',
              trailing: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 19,
              ),
            ),
        ],
      ),
    );
  }
}

class OrganizerScannerScreen extends StatefulWidget {
  const OrganizerScannerScreen({super.key});
  @override
  State<OrganizerScannerScreen> createState() => _OrganizerScannerScreenState();
}

class _OrganizerScannerScreenState extends State<OrganizerScannerScreen> {
  bool checked = false;
  @override
  Widget build(BuildContext context) => ReferenceScaffold(
    title: 'Scan QR Code',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Container(
          height: 330,
          decoration: BoxDecoration(
            color: const Color(0xFF162B35),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 3),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 56, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Place QR code inside the frame',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (checked)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5EC),
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ticket checked in successfully',
                    style: AppTextStyles.cardTitle,
                  ),
                ),
              ],
            ),
          )
        else
          const Text(
            'Scan an attendee ticket to verify entry.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        const SizedBox(height: 20),
        ReferenceButton(
          label: checked ? 'Scan another ticket' : 'Simulate scan',
          expand: true,
          onPressed: () => setState(() => checked = !checked),
        ),
      ],
    ),
  );
}
