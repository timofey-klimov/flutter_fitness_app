import 'dart:async';
import 'dart:math';

import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainTimerController extends ChangeNotifier {
  TrainTimerController(int seconds, AnimationController animationController) {
    _total = seconds * 1000;
    _currentMilliSeconds = seconds * 1000;
    _animationController = animationController;
  }
  AnimationController? _animationController;
  Timer? timer;
  int? _total;
  int? _currentMilliSeconds;
  bool _initial = true;
  bool _isPause = true;
  int? get currentMilliSeconds => _currentMilliSeconds;
  int? get total => _total;
  bool get initial => _initial;

  void forward() {
    _isPause = !_isPause;
    if (!_isPause) {
      _animationController?.forward();
      _initial = false;
      timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        _currentMilliSeconds = _currentMilliSeconds! - 1;
        notifyListeners();
        if (_currentMilliSeconds! <= 0) {
          timer.cancel();
          _initial = true;
          _animationController?.reverse();
        }
      });
    } else {
      _animationController?.reverse();
      timer?.cancel();
    }
  }

  void restart() {
    timer?.cancel();
    _isPause = true;
    _animationController?.reverse();
    _initial = true;
    _currentMilliSeconds = _total!;
    notifyListeners();
  }
}

class TrainTimer extends StatelessWidget {
  const TrainTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrainTimerController>();
    return AnimatedSwitcher(
      duration: 300.ms,
      child: controller.initial
          ? InitialTimer()
          : CustomPaint(
              painter: TimerPolygon(
                  total: controller.total!,
                  current: controller.currentMilliSeconds!),
              child: Container(
                child: Center(
                    child: Text(
                  (controller.currentMilliSeconds! / 1000).ceil().toString(),
                  style: const TextStyle(fontSize: 50),
                )),
              ),
            ),
    );
  }
}

class InitialTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TrainTimerController>();
    return CustomPaint(
      painter: const TimerPolygon(current: 0, total: 1),
      child: Center(
        child: Text(
          (controller.total! / 1000).ceil().toString(),
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}

class TimerPolygon extends CustomPainter {
  final int total;
  final int current;
  const TimerPolygon({required this.total, required this.current});
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.2;
    Paint rectPaint = Paint()
      ..color = AppColors.main
      ..blendMode = BlendMode.darken
      ..style = PaintingStyle.fill;
    const startAngle = 90.0;
    final endAngle = 90 - 360 * (total - current) / total;
    for (double angle = startAngle; angle >= endAngle; angle = angle - 4) {
      double angleInRadians = angle * pi / 180;
      double x = radius * cos(angleInRadians);
      double y = radius * sin(angleInRadians);
      y -= radius;
      y = -y;
      x += size.width / 2;
      canvas.save();
      canvas.translate(x, y + size.height / 4);
      canvas.rotate(-angleInRadians);
      canvas.drawRect(
          Rect.fromCenter(height: 4, width: 15, center: Offset.zero),
          rectPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
