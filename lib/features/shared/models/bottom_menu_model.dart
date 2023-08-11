import 'package:flutter/material.dart';

class BottomMenuModel<T> {
  final List<BottomMenuItem<T>> items;
  BottomMenuModel({
    required this.items,
  });
}

class BottomMenuItem<T> {
  final T value;
  final String text;
  final Color? textColor;
  final Icon? icon;
  BottomMenuItem({
    required this.value,
    required this.text,
    this.textColor,
    this.icon,
  });
}
