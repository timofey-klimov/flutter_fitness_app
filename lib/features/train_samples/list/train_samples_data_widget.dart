import 'package:app/domain/models/train_info.dart';
import 'package:app/features/train_samples/list/train_card_expanded_widget.dart';
import 'package:app/features/train_samples/list/train_card_widget.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';

class TrainSamplesDataWidget extends StatefulWidget {
  final List<TrainInfo> trains;
  const TrainSamplesDataWidget({super.key, required this.trains});

  @override
  State<TrainSamplesDataWidget> createState() => _TrainSamplesDataWidgetState();
}

class _TrainSamplesDataWidgetState extends State<TrainSamplesDataWidget> {
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            },
            duration: 400.ms,
            child: expandedIndex == index
                ? TrainCardExpandedWidget(
                    key: ValueKey('Expanded$index'),
                    trainSample: widget.trains[index].sample!,
                    onCollapse: () {
                      setState(() {
                        expandedIndex = null;
                      });
                    },
                    id: widget.trains[index].id!,
                  )
                : TrainCardWidget(
                    key: ValueKey('Collapsed$index'),
                    sample: widget.trains[index].sample!,
                    id: widget.trains[index].id!,
                    onExpand: () {
                      setState(() {
                        expandedIndex = index;
                      });
                    },
                  ),
          ),
        );
      },
      itemCount: widget.trains.length,
    );
  }
}
