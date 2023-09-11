import 'package:app/shared/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/services/factory/create_activity_service.dart';
import '../../../domain/models/train_sample.dart';
import '../../../shared/color.dart';
import '../../shared/expanded_train_card_widget.dart';

class TrainCardExpandedWidget extends StatelessWidget {
  final TrainSample trainSample;
  final Function() onCollapse;
  final String id;
  const TrainCardExpandedWidget({
    super.key,
    required this.trainSample,
    required this.id,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCollapse();
      },
      child: Card(
        color: AppColors.lightBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 20),
              child: Text(
                trainSample.name.capitalize(),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, ref, child) {
                final drawer = ref.read(activityDrawerProvider);
                return Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: trainSample.sample
                        .map(
                          (item) => ExpandExerciseWidget(
                            exercise: item,
                            drawer: drawer,
                          ),
                        )
                        .toList(),
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
