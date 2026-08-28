import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/app_store.dart';

enum OrderStatus { idle, loading, success, failure }
class OrderState { const OrderState({this.status = OrderStatus.idle}); final OrderStatus status; }
class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.store) : super(const OrderState());
  final AppStore store;
  Future<void> place(Event event, int quantity) async { emit(const OrderState(status: OrderStatus.loading)); try { await store.book(event, quantity); emit(const OrderState(status: OrderStatus.success)); } catch (_) { emit(const OrderState(status: OrderStatus.failure)); } }
}