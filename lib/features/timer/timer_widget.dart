import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/components/train_timer.dart';

class TimerWidget extends StatefulWidget {
  final int seconds;
  const TimerWidget({super.key, required this.seconds});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late TrainTimerController trainController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animation = CurvedAnimation(
        parent:
            Tween<double>(begin: 0.0, end: 1.0).animate(animationController),
        curve: Curves.ease);
    trainController = TrainTimerController(widget.seconds, animationController);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: trainController,
      child: Stack(
        children: [
          TrainTimer(),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      trainController.forward();
                    },
                    icon: AnimatedIcon(
                      size: 40,
                      color: AppColors.main,
                      icon: AnimatedIcons.play_pause,
                      progress: animation,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        trainController.restart();
                      },
                      icon: Icon(
                        Icons.restart_alt,
                        size: 40,
                        color: AppColors.main,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
