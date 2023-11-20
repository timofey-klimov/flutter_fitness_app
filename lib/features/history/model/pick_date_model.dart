import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PickDateModel extends Equatable{
  final DateTimeRange dateTimeRange;

  PickDateModel({required this.dateTimeRange});

  factory PickDateModel.initial() => PickDateModel(
        dateTimeRange: DateTimeRange(
            start: DateTime.now().subtract(
              Duration(days: 7),
            ),
            end: DateTime.now()),
      );

  PickDateModel copyWith({DateTime? start, DateTime? end}) {
    return PickDateModel(dateTimeRange: DateTimeRange(start: start ?? dateTimeRange.start, end: end ?? dateTimeRange.end));
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [dateTimeRange];
}
