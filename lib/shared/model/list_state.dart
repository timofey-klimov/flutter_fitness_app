import 'package:flutter/material.dart';

class ListState {
  int count;
  bool? isNewElement;
  bool? isRemoving;
  int? removedIndex;
  Widget? removeWidget;

  ListState(
      {required this.count,
      this.isNewElement,
      this.isRemoving,
      this.removedIndex,
      this.removeWidget});

  factory ListState.initial() => ListState(count: 0, isNewElement: false);

  ListState removeItem(int index, Widget widget) => ListState(
      count: --count,
      isRemoving: true,
      removedIndex: index,
      removeWidget: widget);
  ListState addNewItem() => ListState(count: ++count, isNewElement: true);

  ListState mark() => ListState(
      count: count,
      isNewElement: false,
      isRemoving: false,
      removedIndex: removedIndex,
      removeWidget: removeWidget);
}
