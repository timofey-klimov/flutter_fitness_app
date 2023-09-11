import 'package:app/domain/models/train_info.dart';
import 'package:app/features/shared/models/bottom_menu_model.dart';
import 'package:app/features/train_samples/create/create_train_header_widget.dart';
import 'package:app/features/train_samples/create/submit_button_widget.dart';
import 'package:app/shared/auth_provider.dart';
import 'package:app/shared/components/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/application/services/train_samples_state.dart';
import '../../../application/riverpod/train_samples/create_train_sample_provider.dart';
import '../../../application/usecases/train_samples/create_train_sample_use_case.dart';
import '../../../application/services/exercise_widgets/exercise_card.dart';
import '../../../shared/color.dart';
import '../../../shared/model/list_state.dart';

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
                        CreateTrainSampleRequest(user: user, state: state)),
                    (prev, next) {
                  if (next.hasError) {
                    Navigator.of(context).pushNamed('/home');
                  }
                  if (next.hasValue) {
                    Navigator.of(context).pushNamed('/home');
                  }
                });
                return const Center(
                  child: Spinner(),
                );
              })
            : Flex(
                direction: Axis.vertical,
                children: [
                  CreateTrainHeaderWidget(
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
