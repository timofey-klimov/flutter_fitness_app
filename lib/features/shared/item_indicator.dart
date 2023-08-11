import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

class ItemIndicator extends StatelessWidget {
  final bool isEnabled;
  const ItemIndicator({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.main : Colors.grey,
            shape: BoxShape.circle,
          )),
    );
  }
}
