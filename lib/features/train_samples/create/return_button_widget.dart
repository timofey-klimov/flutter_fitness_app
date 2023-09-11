import 'package:flutter/material.dart';

import '../../../shared/color.dart';

class ReturnButtomWidget extends StatelessWidget {
  const ReturnButtomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.white,
      ),
    );
  }
}
