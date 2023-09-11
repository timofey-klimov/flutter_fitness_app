import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/services/train_samples_state.dart';
import '../../../shared/color.dart';
import '../../../shared/debounce.dart';

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
