import 'dart:async';

import 'package:app/features/history/bloc/history_bloc.dart';
import 'package:app/features/history/bloc/history_event.dart';
import 'package:app/features/history/bloc/history_state.dart';
import 'package:app/features/history/model/pick_date_model.dart';
import 'package:app/features/history/widgets/range_header_widget.dart';
import 'package:app/features/history/widgets/trains_list_widget.dart';
import 'package:app/service_locator.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/spinner.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (ctx) => getIt<HistoryBloc>()
          ..add(LoadingHistoryEvent(userId: context.userId)),
        child: const HistoryPageContent());
  }
}

class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (ctx, state) {
        final bloc = context.read<HistoryBloc>();
        final userId = context.userId;
        if (state is InitialHistoryState ||
            (state is LoadingHistoryState && state.pickDateModel == null)) {
          return const Center(
            child: Spinner(),
          );
        }
        if (state is ErrorState) {
          return RefreshIndicator(
            color: AppColors.main,
            onRefresh: () async {
              await Future.delayed(200.ms);
              final completer = Completer();
              bloc.add(
                RefreshHistoryEvent(
                  completer: completer,
                  pickDateModel: state.pickDateModel,
                  userId: userId,
                ),
              );
              return completer.future;
            },
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      RangeHeaderWidget(
                          onUpdate: (model) => context.read<HistoryBloc>().add(
                                LoadingHistoryEvent(
                                    pickDateModel: model,
                                    userId: context.userId),
                              ),
                          pickedDate: state.pickDateModel),
                      const Expanded(
                        child: Center(
                          child: Text('Тренировки не найдены'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }

        if (state is LoadingHistoryState) {
          return Flex(
            direction: Axis.vertical,
            children: [
              RangeHeaderWidget(
                  onUpdate: (model) => context.read<HistoryBloc>().add(
                      LoadingHistoryEvent(
                          pickDateModel: model, userId: context.userId)),
                  pickedDate: state.pickDateModel!),
              const Expanded(
                child: Center(
                  child: Spinner(),
                ),
              )
            ],
          );
        }
        var loaded = state as LoadedHistoryState;
        return RefreshIndicator(
          color: AppColors.main,
          onRefresh: () async {
            await Future.delayed(200.ms);
            final completer = Completer();
            bloc.add(
              RefreshHistoryEvent(
                completer: completer,
                pickDateModel: state.pickDateModel,
                userId: userId,
              ),
            );
            return completer.future;
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              RangeHeaderWidget(
                  onUpdate: (model) => context.read<HistoryBloc>().add(
                      LoadingHistoryEvent(
                          pickDateModel: model, userId: context.userId)),
                  pickedDate: state.As<LoadedHistoryState>().pickDateModel),
              Expanded(
                child: Center(
                  child: TrainsListWidget(trains: loaded.trains),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
