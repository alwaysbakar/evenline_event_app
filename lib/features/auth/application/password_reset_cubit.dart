import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/app_store.dart';

enum ResetStatus { idle, loading, success, failure }

class ResetState {
  const ResetState({this.status = ResetStatus.idle});
  final ResetStatus status;
}

class PasswordResetCubit extends Cubit<ResetState> {
  PasswordResetCubit(this.store) : super(const ResetState());
  final AppStore store;
  Future<void> send(String email) async {
    emit(const ResetState(status: ResetStatus.loading));
    try {
      await store.sendPasswordReset(email);
      emit(const ResetState(status: ResetStatus.success));
    } catch (_) {
      emit(const ResetState(status: ResetStatus.failure));
    }
  }
}
