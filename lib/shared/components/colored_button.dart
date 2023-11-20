import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  Color? buttonColor;
  Color? textColor;
  final void Function() onpressed;
  final String text;
  final double width;
  final double height;
  final bool? isDisabled;
  final double? fontSize;
  final bool? isLoading;
  ColoredButton(
      {this.buttonColor,
      this.textColor,
      required this.width,
      required this.height,
      required this.onpressed,
      this.fontSize,
      this.isDisabled,
      this.isLoading,
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
        onPressed: isDisabled == true ? null : onpressed,
        style: TextButton.styleFrom(
            foregroundColor:
                isDisabled == true ? textColor!.withOpacity(.5) : textColor,
            backgroundColor:
                isDisabled == true ? buttonColor!.withOpacity(.5) : buttonColor,
            elevation: 10,
            textStyle:
                TextStyle(color: AppColors.white, fontSize: fontSize ?? 20)),
        child: isLoading == true ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2,)) : Text(text),
      ),
    );
  }
}
