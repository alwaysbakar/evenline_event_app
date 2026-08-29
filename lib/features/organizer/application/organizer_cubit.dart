import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/app_store.dart';

enum PublishStatus { idle, loading, success, failure }

class PublishState {
  const PublishState({this.status = PublishStatus.idle});
  final PublishStatus status;
}

class OrganizerCubit extends Cubit<PublishState> {
  OrganizerCubit(this.store) : super(const PublishState());
  final AppStore store;
  Future<void> publish({
    required String title,
    required String venue,
    required String date,
    required double price,
  }) async {
    emit(const PublishState(status: PublishStatus.loading));
    try {
      await store.createEvent(
        title: title,
        category: 'Community',
        date: date,
        time: '7:00 PM',
        venue: venue,
        price: price,
      );
      emit(const PublishState(status: PublishStatus.success));
    } catch (_) {
      emit(const PublishState(status: PublishStatus.failure));
    }
  }
}
