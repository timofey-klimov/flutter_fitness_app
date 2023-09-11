import 'package:app/features/train_samples/list/train_card_expanded_widget.dart';
import 'package:app/features/train_samples/list/train_card_widget.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/riverpod/train_samples/get_all_train_samples_provider.dart';
import '../../../shared/components/spinner.dart';

class GetTrainSamplesWidget extends StatefulWidget {
  const GetTrainSamplesWidget({super.key});

  @override
  State<GetTrainSamplesWidget> createState() => _GetTrainSamplesWidgetState();
}

class _GetTrainSamplesWidgetState extends State<GetTrainSamplesWidget> {
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      final provider = ref.watch(getAllTrainSamplesProvider);
      return provider.when(
          data: (data) => ListView.builder(
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: AnimatedSwitcher(
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        );
                      },
                      duration: 300.ms,
                      child: expandedIndex == index
                          ? TrainCardExpandedWidget(
                              key: ValueKey('Expanded$index'),
                              trainSample: data[index].sample!,
                              onCollapse: () {
                                setState(() {
                                  expandedIndex = null;
                                });
                              },
                              id: data[index].id!,
                            )
                          : TrainCardWidget(
                              key: ValueKey('Collapsed$index'),
                              sample: data[index].sample!,
                              id: data[index].id!,
                              onExpand: () {
                                setState(() {
                                  expandedIndex = index;
                                });
                              },
                            ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
          error: (s, e) => Container(),
          loading: () => const Spinner());
    });
  }
}
