import 'package:app/domain/models/train_shedule.dart';
import 'package:app/features/shared/models/bottom_menu_model.dart';
import 'package:app/features/train_samples/train_shedule_pick_result.dart';
import 'package:app/shared/auth_provider.dart';
import 'package:app/shared/components/colored_button.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/domain/services/train_samples_state.dart';
import 'package:intl/intl.dart';
import '../../domain/exercises/exercise.dart';
import '../../domain/repositories/provider.dart';
import '../../domain/services/create_exercise_service.dart';
import '../../domain/services/exercise_widgets/exercise_card.dart';
import '../../shared/color.dart';
import '../../shared/model/list_state.dart';
import '../shared/bottom_menu_widget.dart';

class CreateTrainSamplePage extends StatefulWidget {
  const CreateTrainSamplePage({super.key});

  @override
  State<CreateTrainSamplePage> createState() => _CreateTrainSamplePageState();
}

class _CreateTrainSamplePageState extends State<CreateTrainSamplePage> {
  final _textFormFieldController = TextEditingController();
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
    _textFormFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: isSubmitting
            ? Consumer(builder: (ctx, ref, child) {
                final state = ref.read(trainSampleStateProvider);
                final user = ref.read(appUserProvider);
                ref.listen(
                    createTrainSampleProvider(
                        CraeteTrainSampleRequest(user: user, state: state)),
                    (prev, next) {
                  if (next.hasError) {
                    Navigator.of(context).pushNamed('/home');
                  }
                  if (next.hasValue) {
                    Navigator.of(context).pushNamed('/home');
                  }
                });
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
            : Flex(
                direction: Axis.vertical,
                children: [
                  CreateTrainHeader(
                    onAdd: () => setState(() {
                      _listState = _listState.addNewItem();
                    }),
                  ),
                  Consumer(
                    builder: (ctx, ref, child) {
                      final state = ref.watch(trainSampleStateProvider);
                      final notifier =
                          ref.read(trainSampleStateProvider.notifier);
                      if (_listState.isNewElement == true) {
                        _key.currentState!.insertItem(
                            state.exercisesState.length - 1,
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
                      final isSomeNotSubmitting = state.exercisesState
                          .any((item) => !item.isSubmitting);
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
                  SubmitButtonWidget(
                    isSubmitting: () => setState(
                      () {
                        isSubmitting = true;
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback isSubmitting;
  const SubmitButtonWidget({
    super.key,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      final state = ref.watch(trainSampleStateProvider);
      final valid = state.name?.isNotEmpty == true &&
          state.exercisesState.isNotEmpty &&
          state.exercisesState
              .map((e) => !e.isFormEditing && e.isSubmitting)
              .reduce((value, element) => value && element);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !valid
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green,
                              blurRadius: 3.0,
                              spreadRadius: 0.0)
                        ]),
                    width: 70,
                    height: 70,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {
                            var result = await showModalBottomSheet<
                                    TrainShedulePickResult>(
                                context: context,
                                builder: (ctx) => ChooseTrainDateWidget());
                            if (result != null) {
                              isSubmitting();
                              ref
                                  .read(trainSampleStateProvider.notifier)
                                  .submitTrain(result.date, result.type);
                            }
                          },
                          icon: const Icon(Icons.check),
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
      );
    });
  }
}

class ChooseTrainDateWidget extends StatefulWidget {
  const ChooseTrainDateWidget({super.key});

  @override
  State<ChooseTrainDateWidget> createState() => _ChooseTrainDateWidgetState();
}

class _ChooseTrainDateWidgetState extends State<ChooseTrainDateWidget> {
  DateTime? date;
  late final List<TrainSheduleDropDownItem> list;
  TrainScheduleTypes? type;
  @override
  void initState() {
    list = [
      TrainSheduleDropDownItem(
          value: TrainScheduleTypes.one_time, text: 'Один раз'),
      TrainSheduleDropDownItem(
          value: TrainScheduleTypes.every_week, text: 'Каждую неделю')
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month),
              TextButton(
                onPressed: () async {
                  final result = await showDatePicker(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      context: context,
                      initialDate: date ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1));
                  if (result != null) {
                    setState(() {
                      date = result;
                    });
                  }
                },
                child: Text(
                  date == null
                      ? 'Выберите дату'
                      : DateFormat('yMMMEd', 'ru').format(date!),
                  style: TextStyle(fontSize: 18, color: AppColors.main),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.list),
              const SizedBox(
                width: 10,
              ),
              DropdownButton<TrainScheduleTypes>(
                value: type,
                items: list
                    .map((e) => DropdownMenuItem<TrainScheduleTypes>(
                          value: e.value,
                          child: Text(
                            e.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          ColoredButton(
            isDisabled: type == null || date == null,
            width: 200,
            height: 50,
            onpressed: () {
              Navigator.of(context)
                  .pop(TrainShedulePickResult(date: date!, type: type!));
            },
            text: 'Создать',
            fontSize: 16,
            buttonColor: AppColors.accent,
          )
        ],
      ),
    );
  }
}

class CreateTrainHeader extends StatelessWidget {
  const CreateTrainHeader({
    super.key,
    required VoidCallback onAdd,
  }) : _onAdd = onAdd;

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
          ExerciseNameWidget(),
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

class ExerciseNameWidget extends StatefulWidget {
  const ExerciseNameWidget({
    super.key,
  });

  @override
  State<ExerciseNameWidget> createState() => _ExerciseNameWidgetState();
}

class _ExerciseNameWidgetState extends State<ExerciseNameWidget> {
  Debounce debounce = Debounce(duration: Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Consumer(
        builder: (context, ref, child) {
          final notifier = ref.read(trainSampleStateProvider.notifier);
          return TextFormField(
            onChanged: (value) {
              debounce.run(() {
                notifier.updateTrainName(value);
              });
            },
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
          );
        },
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
                            final list = <BottomMenuItem<ExerciseTypes>>[];
                            exerciseMap.forEach(
                              (key, value) {
                                list.add(
                                  BottomMenuItem<ExerciseTypes>(
                                      value: key, text: value),
                                );
                              },
                            );
                            final model = BottomMenuModel(items: list);
                            return BottomMenuWidget(
                              model: model,
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
