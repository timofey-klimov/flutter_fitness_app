import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/auth_provider.dart';
import '../train_calendar_repository.dart';

class GetTrainsByDateRequest extends Equatable {
  final DateTime startDate;
  final DateTime? endDate;
  const GetTrainsByDateRequest({
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

final getTrainSamplesByDateProvider = FutureProvider.autoDispose.family(
  (ref, GetTrainsByDateRequest request) async {
    final provider = ref.read(trainCalendarRepositoryProvider);
    final user = ref.read(appUserProvider);
    return await provider.getScheduledTrains(
        user.id!, request.startDate, request.endDate);
  },
);

final removeSheduledTrainSample = FutureProvider.family.autoDispose(
  (ref, String id) async {
    final provider = ref.read(trainCalendarRepositoryProvider);
    await provider.remove(id);
    ref.invalidate(getTrainSamplesByDateProvider);
    ref.read(calendarEventStream).sink.add(CalendarPageReload());
  },
);

class ResheduleRequest extends Equatable {
  final String id;
  final DateTime date;
  const ResheduleRequest({
    required this.id,
    required this.date,
  });
  @override
  List<Object?> get props => [id, date];
}

final rescheduleTrainProvider =
    FutureProvider.family.autoDispose((ref, ResheduleRequest request) async {
  final provider = ref.read(trainCalendarRepositoryProvider);
  await provider.reschedule(request.id, request.date);
  ref.invalidate(getTrainSamplesByDateProvider);
  ref.read(calendarEventStream).sink.add(CalendarPageReload());
});

abstract interface class CalendarEvent {}

class CalendarPageReload extends CalendarEvent {}

class CalendarPageNotification extends CalendarEvent {
  final String message;
  CalendarPageNotification({required this.message});
}

final calendarEventStream =
    Provider((ref) => StreamController<CalendarEvent>());

final calendarNotifierProvider =
    StreamProvider((ref) => ref.watch(calendarEventStream).stream);
