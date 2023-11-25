import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/shared/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/activities/approach_activities.dart';

class ApproachActivityState {
  final List<Approach> approaches;
  ApproachActivityState({
    required this.approaches,
  });

  ApproachActivityState addNew() {
    final weightApproach = Approach(index: approaches.length, count: '');
    final weightApproaches = [...approaches, weightApproach];
    return ApproachActivityState(approaches: weightApproaches);
  }

  ApproachActivityState removeFrom(int index) {
    final currentApproaches = approaches.map((e) {
      if (e.index > index) {
        return Approach(index: e.index - 1, count: e.count);
      }
      return e;
    }).toList();
    return ApproachActivityState(approaches: currentApproaches);
  }

  ApproachActivityState update(int index, String? count, String? weight) {
    var currentApproaches = approaches.map((item) {
      if (item.index == index) {
        return item.copyWith(count: count);
      }
      return item;
    }).toList();

    return ApproachActivityState(approaches: currentApproaches);
  }

  ApproachActivityState remove(int index) {
    approaches.removeAt(index);
    var currentApproaches = approaches.map((item) {
      if (item.index > index) {
        return item.copyWith(index: item.index - 1);
      }
      return item;
    }).toList();

    return ApproachActivityState(approaches: currentApproaches);
  }
}

class EditApproachActivityWdiget extends StatefulWidget {
  const EditApproachActivityWdiget({
    super.key,
    required this.exerciseIndex,
    this.activity,
  });
  final int exerciseIndex;
  final ApproachActivity? activity;
  @override
  State<EditApproachActivityWdiget> createState() =>
      _ApproachActivitWidgetyState();
}

class _ApproachActivitWidgetyState extends State<EditApproachActivityWdiget> {
  late ApproachActivityState state;
  final _key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    final approaches = widget.activity == null
        ? [Approach(index: 0, count: '')]
        : widget.activity!.approaches;
    state = ApproachActivityState(approaches: approaches);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: state.approaches.length * 62,
              child: AnimatedList(
                key: _key,
                initialItemCount: state.approaches.length,
                itemBuilder: (ctx, index, animation) {
                  return ApproachWidget(
                    length: state.approaches.length,
                    approach: state.approaches[index],
                    index: index,
                    update: ({count, required appIndex, weight}) {
                      setState(() {
                        state = state.update(appIndex, count, weight);
                      });
                      context.read<TrainBloc>().add(UpdateActivityEvent(
                          activity:
                              ApproachActivity(approaches: state.approaches),
                          index: widget.exerciseIndex));
                    },
                    onRemove: (index) {
                      setState(() {
                        state = state.remove(index);
                      });
                      _key.currentState!.removeItem(index,
                          (context, animation) {
                        return Container();
                      });
                      context.read<TrainBloc>().add(UpdateActivityEvent(
                          activity:
                              ApproachActivity(approaches: state.approaches),
                          index: widget.exerciseIndex));
                    },
                  );
                },
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  state = state.addNew();
                });
                _key.currentState!.insertItem(state.approaches.length - 1);
                context.read<TrainBloc>().add(UpdateActivityEvent(
                    activity: ApproachActivity(approaches: state.approaches),
                    index: widget.exerciseIndex));
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ApproachWidget extends StatefulWidget {
  final int index;
  final Approach approach;
  final int length;
  final void Function(int index) onRemove;
  final void Function({String? weight, String? count, required int appIndex})
      update;
  const ApproachWidget(
      {super.key,
      required this.index,
      required this.approach,
      required this.onRemove,
      required this.length,
      required this.update});

  @override
  State<ApproachWidget> createState() => _ApproachWidgetState();
}

class _ApproachWidgetState extends State<ApproachWidget> {
  late final Debounce countDebounce;
  @override
  void initState() {
    countDebounce = Debounce(duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.length == 1
        ? ApproachCardWidget(
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
      required this.countDebounce});

  final int index;
  final Approach approach;
  final void Function({required int appIndex, String? count, String? weight})
      update;
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
