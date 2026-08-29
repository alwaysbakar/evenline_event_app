import 'package:flutter_bloc/flutter_bloc.dart';

class TicketSelectionState {
  const TicketSelectionState({this.quantity = 1});
  final int quantity;
}

class TicketSelectionCubit extends Cubit<TicketSelectionState> {
  TicketSelectionCubit() : super(const TicketSelectionState());
  void increment() => emit(TicketSelectionState(quantity: state.quantity + 1));
  void decrement() {
    if (state.quantity > 1) {
      emit(TicketSelectionState(quantity: state.quantity - 1));
    }
  }
}
