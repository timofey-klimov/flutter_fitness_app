import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/train_samples/train_samples_state.dart';

import '../../domain/exercises/exercise.dart';
import '../../domain/services/create_exercise_service.dart';
import '../../shared/color.dart';

class ListState {
  int count;
  bool? isNewElement;
  bool? isRemoving;
  int? removedIndex;

  ListState(
      {required this.count,
      this.isNewElement,
      this.isRemoving,
      this.removedIndex});

  factory ListState.initial() => ListState(count: 0, isNewElement: false);

  ListState removeItem(int index) =>
      ListState(count: --count, isRemoving: true, removedIndex: index);
  ListState addNewItem() => ListState(count: ++count, isNewElement: true);

  ListState mark() => ListState(
      count: count, isNewElement: false, isRemoving: false, removedIndex: null);
}

class CreateTrainSamplePage extends StatefulWidget {
  const CreateTrainSamplePage({super.key});

  @override
  State<CreateTrainSamplePage> createState() => _CreateTrainSamplePageState();
}

class _CreateTrainSamplePageState extends State<CreateTrainSamplePage> {
  final _textFormFieldController = TextEditingController();
  final _key = GlobalKey<AnimatedListState>();
  late ListState _listState;

  @override
  void initState() {
    _listState = ListState.initial();
    super.initState();
  }

  @override
  void dispose() {
    _textFormFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            CreateTrainHeader(
              onAdd: () => setState(() {
                _listState = _listState.addNewItem();
              }),
              textFormFieldController: _textFormFieldController,
            ),
            Consumer(
              builder: (ctx, ref, child) {
                final state = ref.watch(trainSampleStateProvider);
                final drawerService = ref.read(createExerciseServiceProvider);
                final notifier = ref.read(trainSampleStateProvider.notifier);
                if (_listState.isNewElement == true) {
                  _key.currentState!.insertItem(state.exercisesState.length - 1,
                      duration: const Duration(milliseconds: 300));
                }
                if (_listState.isRemoving == true) {
                  _key.currentState!.removeItem(_listState.removedIndex! - 1,
                      (context, animation) => Container());
                  if (_listState.removedIndex! - 1 == 0) {
                    _listState = _listState.mark();
                  }
                }
                return Expanded(
                  child: AnimatedList(
                    key: _key,
                    initialItemCount: _listState.count,
                    itemBuilder: (context, index, animation) {
                      final item = state.exercisesState[index];
                      _listState = _listState.mark();
                      return SizeTransition(
                        sizeFactor: animation,
                        child: drawerService.drawForm(item.type, item.index,
                            (index) {
                          setState(() {
                            _listState = _listState.removeItem(index);
                          });
                          notifier.removeItem(index);
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
    );
  }
}

class CreateTrainHeader extends StatelessWidget {
  const CreateTrainHeader({
    super.key,
    required TextEditingController textFormFieldController,
    required VoidCallback onAdd,
  })  : _textFormFieldController = textFormFieldController,
        _onAdd = onAdd;

  final TextEditingController _textFormFieldController;
  final VoidCallback _onAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      color: AppColors.main,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReturnButtomWidget(),
          ExerciseNameWidget(textFormFieldController: _textFormFieldController),
          AddNewExerciseWidget(onAdd: _onAdd)
        ],
      ),
    );
  }
}

class ReturnButtomWidget extends StatelessWidget {
  const ReturnButtomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.white,
      ),
    );
  }
}

class ExerciseNameWidget extends StatelessWidget {
  const ExerciseNameWidget({
    super.key,
    required TextEditingController textFormFieldController,
  }) : _textFormFieldController = textFormFieldController;

  final TextEditingController _textFormFieldController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(25)],
        style: TextStyle(
            decorationThickness: 0,
            color: AppColors.white,
            fontSize: 18,
            overflow: TextOverflow.ellipsis),
        textAlign: TextAlign.center,
        cursorColor: AppColors.white,
        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: 'Название тренировки',
            hintStyle: TextStyle(
                color: AppColors.white.withOpacity(0.7), fontSize: 18)),
        controller: _textFormFieldController,
      ),
    );
  }
}

class AddNewExerciseWidget extends StatelessWidget {
  const AddNewExerciseWidget({
    super.key,
    required VoidCallback onAdd,
  }) : _onAdd = onAdd;

  final VoidCallback _onAdd;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, child) {
        return IconButton(
          onPressed: () async {
            final result = await showModalBottomSheet<ExerciseTypes>(
                context: ctx,
                builder: (context) {
                  return Consumer(
                    builder: (ctx, ref, child) {
                      final provider = ref.read(exerciseMapperProvider);
                      final exerciseMap = provider.map();
                      final list = <PopupMenuItem<ExerciseTypes>>[];
                      exerciseMap.forEach(
                        (key, value) {
                          list.add(
                            PopupMenuItem<ExerciseTypes>(
                              value: key,
                              child: Center(
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      return SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [...list],
                        ),
                      );
                    },
                  );
                });
            if (result != null) {
              _onAdd();
              ref
                  .read(trainSampleStateProvider.notifier)
                  .addNewExercise(result);
            }
          },
          icon: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        );
      },
    );
  }
}
