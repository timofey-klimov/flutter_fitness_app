import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  Color? buttonColor;
  Color? textColor;
  final void Function() onpressed;
  final String text;
  final double width;
  final double height;
  ColoredButton(
      {this.buttonColor,
      this.textColor,
      required this.width,
      required this.height,
      required this.onpressed,
      required String this.text}) {
    buttonColor = buttonColor ?? AppColors.main;
    textColor = textColor ?? AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onpressed,
        child: Text(text),
        style: TextButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: buttonColor,
            elevation: 10,
            textStyle: TextStyle(color: AppColors.white, fontSize: 20)),
      ),
    );
  }
}
