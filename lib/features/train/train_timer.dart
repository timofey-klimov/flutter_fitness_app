import 'dart:async';

import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainTimer extends StatefulWidget {
  const TrainTimer({super.key});

  @override
  State<TrainTimer> createState() => _TrainTimerState();
}

class _TrainTimerState extends State<TrainTimer> {
  late Timer timer;
  var time = DateTime(0);
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time = time.add(Duration(seconds: 1));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('HH:mm:ss').format(time),
      style: TextStyle(fontSize: 18, color: AppColors.main),
    );
  }
}
