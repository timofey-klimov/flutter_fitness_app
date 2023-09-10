import 'package:app/domain/services/train_samples_state.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/shared/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../activities/approach_activities.dart';

class WeightApproachActivityState {
  final List<WeightApproach> approaches;
  WeightApproachActivityState({
    required this.approaches,
  });

  WeightApproachActivityState addNew() {
    final weightApproach =
        WeightApproach(index: approaches.length, weight: '', count: '');
    final weightApproaches = [...approaches, weightApproach];
    return WeightApproachActivityState(approaches: weightApproaches);
  }

  WeightApproachActivityState removeFrom(int index) {
    final weightApproaches = approaches.map((e) {
      if (e.index > index) {
        return WeightApproach(
            index: e.index - 1, weight: e.weight, count: e.count);
      }
      return e;
    }).toList();
    return WeightApproachActivityState(approaches: weightApproaches);
  }

  WeightApproachActivityState update(int index, String? count, String? weight) {
    var weightApproaches = approaches.map((item) {
      if (item.index == index) {
        return item.copyWith(count: count, weight: weight);
      }
      return item;
    }).toList();

    return WeightApproachActivityState(approaches: weightApproaches);
  }

  WeightApproachActivityState remove(int index) {
    approaches.removeAt(index);
    var weightApproaches = approaches.map((item) {
      if (item.index > index) {
        return item.copyWith(index: item.index - 1);
      }
      return item;
    }).toList();

    return WeightApproachActivityState(approaches: weightApproaches);
  }
}

class EditWeightApproachActivityWdiget extends StatefulWidget {
  const EditWeightApproachActivityWdiget({
    super.key,
    required this.exerciseIndex,
    this.activity,
  });
  final int exerciseIndex;
  final WeightApproachActivity? activity;
  @override
  State<EditWeightApproachActivityWdiget> createState() =>
      _WeightApproachActivitWidgetyState();
}

class _WeightApproachActivitWidgetyState
    extends State<EditWeightApproachActivityWdiget> {
  late WeightApproachActivityState state;
  final _key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    final approaches = widget.activity == null
        ? [WeightApproach(index: 0, weight: '', count: '')]
        : widget.activity!.approaches;
    state = WeightApproachActivityState(approaches: approaches);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(trainSampleStateProvider.notifier);
        return IntrinsicHeight(
          child: Row(
            children: [
              Flexible(
                flex: 7,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: state.approaches.length * 62,
                  child: AnimatedList(
                    key: _key,
                    initialItemCount: state.approaches.length,
                    itemBuilder: (ctx, index, animation) {
                      return WeightApproachWidget(
                        length: state.approaches.length,
                        approach: state.approaches[index],
                        index: index,
                        update: ({count, required appIndex, weight}) {
                          setState(() {
                            state = state.update(appIndex, count, weight);
                          });
                          notifier.updateActivity(
                              widget.exerciseIndex,
                              WeightApproachActivity(
                                  approaches: state.approaches));
                        },
                        onRemove: (index) {
                          setState(() {
                            state = state.remove(index);
                          });
                          _key.currentState!.removeItem(index,
                              (context, animation) {
                            return Container();
                          });
                          notifier.updateActivity(
                              widget.exerciseIndex,
                              WeightApproachActivity(
                                  approaches: state.approaches));
                        },
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      state = state.addNew();
                    });
                    _key.currentState!.insertItem(state.approaches.length - 1);
                    notifier.updateActivity(widget.exerciseIndex,
                        WeightApproachActivity(approaches: state.approaches));
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class WeightApproachWidget extends StatefulWidget {
  final int index;
  final WeightApproach approach;
  final int length;
  final void Function(int index) onRemove;
  final void Function({String? weight, String? count, required int appIndex})
      update;
  const WeightApproachWidget(
      {super.key,
      required this.index,
      required this.approach,
      required this.onRemove,
      required this.length,
      required this.update});

  @override
  State<WeightApproachWidget> createState() => _WeightApproachWidgetState();
}

class _WeightApproachWidgetState extends State<WeightApproachWidget> {
  late final Debounce weightDebounce;
  late final Debounce countDebounce;
  @override
  void initState() {
    weightDebounce = Debounce(duration: const Duration(milliseconds: 400));
    countDebounce = Debounce(duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.length == 1
        ? ApproachCardWidget(
            weightDebounce: weightDebounce,
            countDebounce: countDebounce,
            index: widget.index,
            approach: widget.approach,
            update: widget.update)
        : Dismissible(
            key: ValueKey(widget.index),
            background: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(color: Colors.red),
            ),
            onDismissed: (direction) => widget.onRemove(widget.index),
            child: ApproachCardWidget(
                weightDebounce: weightDebounce,
                countDebounce: countDebounce,
                index: widget.index,
                approach: widget.approach,
                update: widget.update),
          );
  }
}

class ApproachCardWidget extends StatelessWidget {
  const ApproachCardWidget(
      {super.key,
      required this.index,
      required this.approach,
      required this.update,
      required this.weightDebounce,
      required this.countDebounce});

  final int index;
  final WeightApproach approach;
  final void Function({required int appIndex, String? count, String? weight})
      update;
  final Debounce weightDebounce;
  final Debounce countDebounce;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 220,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${(index + 1).toString()}.',
              style: const TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                  width: 70,
                  child: TextFormField(
                    initialValue: approach.weight,
                    onChanged: (value) {
                      weightDebounce
                          .run(() => update(weight: value, appIndex: index));
                    },
                    decoration: const InputDecoration(
                        hintText: 'Вес',
                        hintStyle: TextStyle(color: Colors.grey)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  )),
            ),
            const Text(
              'X',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: approach.count,
                  onChanged: (value) {
                    countDebounce
                        .run(() => update(count: value, appIndex: index));
                  },
                  cursorColor: AppColors.accent,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                  decoration: const InputDecoration(
                      hintText: 'Кол-во',
                      hintStyle: TextStyle(color: Colors.grey)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
