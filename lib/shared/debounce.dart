import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  Timer? timer;
  final Duration duration;

  Debounce({required this.duration});

  void run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(duration, () {
      action();
    });
  }
}
