import 'dart:ui';

import 'package:app/routes.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/riverpod/train_samples/train_samples_page_state.dart';
import '../../shared/components/spinner.dart';
import 'list/get_train_samples_widget.dart';
import 'list/train_samples_data_widget.dart';

class TrainSamplesPage extends StatelessWidget {
  const TrainSamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(trainSamplesPageStateNotifierProvider);
        if (state is ReloadTrainsSamplesPageState) {
          return Stack(
            children: [
              Column(
                children: [
                  const TrainSamplesHeaderWidget(),
                  Expanded(
                      child: TrainSamplesDataWidget(
                    trains: state.trains,
                  ))
                ],
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Spinner(),
                ),
              )
            ],
          );
        }

        if (state is FinishReloadTrainsSamplePageState) {
          return Column(
            children: [
              const TrainSamplesHeaderWidget(),
              Expanded(
                  child: TrainSamplesDataWidget(
                trains: state.trains,
              ))
            ],
          );
        }

        return const Column(
          children: [
            TrainSamplesHeaderWidget(),
            Expanded(child: GetTrainSamplesWidget())
          ],
        );
      },
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
