import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PageChangeEventType { None, FromNavigation, FromSwipe }

class PageState extends Equatable {
  final PageChangeEventType eventType;
  final int index;
  const PageState({
    required this.eventType,
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class PageStateNotifier extends StateNotifier<PageState> {
  PageStateNotifier()
      : super(const PageState(index: 0, eventType: PageChangeEventType.None));

  toPage(int index, PageChangeEventType type) =>
      state = PageState(index: index, eventType: type);
  clearEventType() => state =
      PageState(eventType: PageChangeEventType.None, index: state.index);
}

final pageStateProvider = StateNotifierProvider<PageStateNotifier, PageState>(
    (ref) => PageStateNotifier());
