import 'package:app/routes.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/factory/create_activity_service.dart';
import '../../domain/models/train_sample.dart';
import '../shared/expanded_train_card_widget.dart';
import 'list/get_train_samples_widget.dart';

class TrainSamplesPage extends StatelessWidget {
  const TrainSamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TrainSamplesHeaderWidget(),
        Expanded(child: GetTrainSamplesWidget())
      ],
    );
  }
}

class TrainSamplesHeaderWidget extends StatelessWidget {
  const TrainSamplesHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.article,
                color: AppColors.main,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.CreateTrainsScreen);
              },
              icon: Icon(
                Icons.add,
                color: AppColors.main,
              ),
            ),
          )
        ],
      ),
    );
  }
}
