import 'package:app/features/authorization/bloc/authentication/authentication_bloc.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension DateTimeExtensin on DateTime {
  bool equals(DateTime dateTime) {
    return day == dateTime.day &&
        month == dateTime.month &&
        year == dateTime.year;
  }
}

extension NullStringExtension on String? {
  bool isValid() => this != null && this!.isNotEmpty;
}

extension IntExtension on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get sc => Duration(seconds: this);
  Duration get ml => Duration(milliseconds: this);
}

extension GlobalExtension on Object {
  T As<T>() => this as T;
}

extension BuildContextExt on BuildContext {
  String get userId => read<AuthenticationBloc>().state.As<AuthenticationSuccess>().uid;
}
