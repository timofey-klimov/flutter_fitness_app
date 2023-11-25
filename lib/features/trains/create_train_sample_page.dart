import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/features/trains/bloc/train_state.dart';
import 'package:app/features/trains/widgets/header/create_train_header.dart';
import 'package:app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/body/exercise/exercise_card.dart';
import '../../shared/color.dart';
import '../../shared/model/list_state.dart';

class CreateTrainSamplePage extends StatefulWidget {
  const CreateTrainSamplePage({
    super.key,
  });

  @override
  State<CreateTrainSamplePage> createState() => _CreateTrainSamplePageState();
}

class _CreateTrainSamplePageState extends State<CreateTrainSamplePage> {
  final _key = GlobalKey<AnimatedListState>();
  late ListState _listState;
  bool isSubmitting = false;

  @override
  void initState() {
    _listState = ListState.initial();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocProvider(
          create: (ctx) => getIt<TrainBloc>(),
          child: Flex(
            direction: Axis.vertical,
            children: [
              CreateTrainHeaderWidget(
                onAdd: () => setState(() {
                  _listState = _listState.addNewItem();
                }),
              ),
              BlocBuilder<TrainBloc, TrainState>(
                builder: (ctx, state) {
                  if (_listState.isNewElement == true) {
                    _key.currentState!.insertItem(state.exercisesState.length - 1,
                        duration: const Duration(milliseconds: 300));
                  }
                  if (_listState.isRemoving == true) {
                    _key.currentState!.removeItem(
                        _listState.removedIndex!,
                        (context, animation) => SizeTransition(
                              sizeFactor: animation,
                              child: _listState.removeWidget!,
                            ));
                    if (_listState.removedIndex! == 0) {
                      _listState = _listState.mark();
                    }
                  }
                  final isSomeNotSubmitting =
                      state.exercisesState.any((item) => !item.isSubmitting);
                  return Expanded(
                    child: AnimatedList(
                      key: _key,
                      initialItemCount: _listState.count,
                      itemBuilder: (context, index, animation) {
                        final item = state.exercisesState[index];
                        _listState = _listState.mark();
                        return SizeTransition(
                          sizeFactor: animation,
                          child: CreateExerciseCard(
                              enableEditing: !isSomeNotSubmitting,
                              state: item,
                              onRemove: (index, widget) {
                                setState(() {
                                  _listState =
                                      _listState.removeItem(index, widget);
                                });
                                context.read<TrainBloc>().add(RemoveExerciseEvent(index: index));
                              }),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
