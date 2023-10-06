import 'package:flutter/material.dart';

import '../timer/timer_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TimerWidget(
        seconds: 10,
      ),
    );
  }
}
