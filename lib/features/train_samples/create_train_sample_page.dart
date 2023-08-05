import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/domain/services/train_samples_state.dart';
import '../../domain/exercises/exercise.dart';
import '../../domain/services/create_exercise_service.dart';
import '../../domain/services/exercise_widgets/exercise_card.dart';
import '../../shared/color.dart';
import '../../shared/model/list_state.dart';

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
                final notifier = ref.read(trainSampleStateProvider.notifier);
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
      height: 70,
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
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        style: TextStyle(
            decorationThickness: 0,
            color: AppColors.white,
            fontSize: 20,
            overflow: TextOverflow.ellipsis),
        textAlign: TextAlign.center,
        cursorColor: AppColors.white,
        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: 'Название тренировки',
            hintStyle: TextStyle(
                color: AppColors.white.withOpacity(0.7), fontSize: 20)),
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
        final state = ref.watch(trainSampleStateProvider);
        final isDisabled =
            state.exercisesState.any((item) => item.isFormEditing);
        return IconButton(
          onPressed: isDisabled
              ? null
              : () async {
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
                              height: list.length * 70,
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
            color:
                isDisabled ? AppColors.white.withOpacity(.5) : AppColors.white,
          ),
        );
      },
    );
  }
}
