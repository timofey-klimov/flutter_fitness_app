import 'package:app/features/history/bloc/history_bloc.dart';
import 'package:app/features/history/bloc/history_event.dart';
import 'package:app/features/history/bloc/history_state.dart';
import 'package:app/features/history/widgets/range_header_widget.dart';
import 'package:app/service_locator.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/spinner.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (ctx) => getIt<HistoryBloc>()..add(LoadingHistoryEvent()),
        child: const HistoryPageContent());
  }
}

class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (ctx, state) {
        if (state is InitialHistoryState) {
          return const Center(
              child: Spinner(),
            );
        }

        if (state is LoadingHistoryState) {
          if (state.pickDateModel == null) {
            return const Center(
              child: Spinner(),
            );
          } else {
            return Flex(
              direction: Axis.vertical,
              children: [
                RangeHeaderWidget(
                    onUpdate: (model) => context.read<HistoryBloc>().add(LoadingHistoryEvent(pickDateModel: model)), pickedDate: state.pickDateModel!),
                const Expanded(
                  child: Center(
                    child: Spinner(),
                  ),
                )
              ],
            );
          }
        }

        return Flex(
          direction: Axis.vertical,
          children: [
            RangeHeaderWidget(
                onUpdate: (model) => context.read<HistoryBloc>().add(LoadingHistoryEvent(pickDateModel: model)),
                pickedDate: state.As<LoadedHistoryState>().pickDateModel),
            const Expanded(
              child: Center(
                child: Text('Loaded'),
              ),
            )
          ],
        );
      },
    );
  }
}
