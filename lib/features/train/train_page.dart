import 'package:app/features/train/train_timer.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

import '../../domain/models/sheduled_train_sample.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final train =
        ModalRoute.of(context)!.settings.arguments as SheduledTrainSample;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.main,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: TrainTimer(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
