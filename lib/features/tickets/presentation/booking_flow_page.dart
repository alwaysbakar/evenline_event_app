import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../application/ticket_selection_cubit.dart';
import '../application/order_cubit.dart';

class TicketSelectionPage extends StatelessWidget {
  const TicketSelectionPage({required this.event, required this.store, super.key});
  final Event event; final AppStore store;
  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => TicketSelectionCubit(), child: BlocBuilder<TicketSelectionCubit, TicketSelectionState>(builder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Get a Ticket'), leading: const BackButton()),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Row(children: [Expanded(child: DatePill(label: '27 Mar')), SizedBox(width: 5), Expanded(child: DatePill(label: '28 Mar')), SizedBox(width: 5), Expanded(child: DatePill(label: '29 Mar', selected: true)), SizedBox(width: 5), Expanded(child: DatePill(label: '30 Mar')), SizedBox(width: 5), Expanded(child: DatePill(label: '31 Mar'))]),
      const SizedBox(height: 28), const Text('Choose the ticket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), const SizedBox(height: 12),
      TicketOption(event: event, selected: true, quantity: state.quantity, onMinus: state.quantity > 1 ? context.read<TicketSelectionCubit>().decrement : null, onPlus: context.read<TicketSelectionCubit>().increment), const SizedBox(height: 12), TicketOption(event: event, selected: false, quantity: 0), const SizedBox(height: 26),
      Row(children: [Text('\$${(event.price * state.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), const Spacer(), FilledButton(onPressed: () => context.push('/tickets/order/${event.id}?quantity=${state.quantity}'), style: FilledButton.styleFrom(backgroundColor: AppTheme.coral), child: const Text('Continue'))]),
    ]),
  )));
}

class DatePill extends StatelessWidget {
  const DatePill({required this.label, this.selected = false, super.key});
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: selected ? AppTheme.ink : AppTheme.field, borderRadius: BorderRadius.circular(9)), child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: selected ? Colors.white : AppTheme.muted)));
}

class TicketOption extends StatelessWidget {
  const TicketOption({required this.event, required this.selected, required this.quantity, this.onMinus, this.onPlus, super.key});
  final Event event; final bool selected; final int quantity; final VoidCallback? onMinus; final VoidCallback? onPlus;
  @override
  Widget build(BuildContext context) => Container(decoration: BoxDecoration(border: Border.all(color: selected ? AppTheme.ink : const Color(0xFFE6E8ED)), borderRadius: BorderRadius.circular(12)), child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: selected ? AppTheme.ink : AppTheme.field, borderRadius: const BorderRadius.vertical(top: Radius.circular(11))), child: Row(children: [Text(selected ? 'Premium price' : 'Regular price', style: TextStyle(color: selected ? Colors.white : AppTheme.ink, fontSize: 11)), const Spacer(), Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? Colors.white : AppTheme.muted, size: 16)])), Padding(padding: const EdgeInsets.all(14), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: Color(event.color), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_awesome, color: Colors.white)), const SizedBox(width: 10), Expanded(child: Text(event.title, maxLines: 2, style: Theme.of(context).textTheme.titleMedium)), Text('\$${event.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))])), if (selected) Row(children: [const Padding(padding: EdgeInsets.all(14), child: Text('Show benefit', style: TextStyle(color: AppTheme.coral, fontSize: 10))), const Spacer(), IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_circle_outline, size: 18)), Text('$quantity'), IconButton(onPressed: onPlus, icon: const Icon(Icons.add_circle_outline, size: 18)), const SizedBox(width: 8)])]));
}

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({required this.event, required this.store, required this.quantity, super.key});
  final Event event;
  final AppStore store;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    final total = event.price * quantity;
    return BlocProvider(
      create: (_) => OrderCubit(store),
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) { if (state.status == OrderStatus.success) context.go('/tickets'); },
        child: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Detail Order'), leading: const BackButton()),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            Card(elevation: 0, child: ListTile(leading: Container(width: 58, height: 58, decoration: BoxDecoration(color: Color(event.color), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_awesome, color: Colors.white)), title: Text(event.title), subtitle: Text('${event.date}\n${event.time}'))),
            const SizedBox(height: 22), const Text('Order summary', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE6E8ED)), borderRadius: BorderRadius.circular(12)), child: Column(children: [SummaryRow(label: '${quantity}x Premium price', value: '\$${total.toStringAsFixed(2)}'), const Divider(), SummaryRow(label: 'Subtotal', value: '\$${total.toStringAsFixed(2)}'), const SummaryRow(label: 'Fees', value: '\$0.00'), const Divider(), SummaryRow(label: 'Total', value: '\$${total.toStringAsFixed(2)}', strong: true)])),
            const SizedBox(height: 22), const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 12), const Card(elevation: 0, child: ListTile(title: Text('Paypal'), subtitle: Text('Payment will be processed securely'))), const SizedBox(height: 30),
            Row(children: [Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)), const Spacer(), FilledButton(onPressed: state.status == OrderStatus.loading ? null : () => context.read<OrderCubit>().place(event, quantity), style: FilledButton.styleFrom(backgroundColor: AppTheme.coral), child: Text(state.status == OrderStatus.loading ? 'Placing...' : 'Place Order'))]),
          ]),
        )),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget { const SummaryRow({required this.label, required this.value, this.strong = false, super.key}); final String label; final String value; final bool strong; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [Expanded(child: Text(label, style: TextStyle(fontSize: 11, color: strong ? AppTheme.ink : AppTheme.muted, fontWeight: strong ? FontWeight.w700 : FontWeight.normal))), Text(value, style: TextStyle(fontSize: strong ? 16 : 11, fontWeight: strong ? FontWeight.w700 : FontWeight.normal))])); }