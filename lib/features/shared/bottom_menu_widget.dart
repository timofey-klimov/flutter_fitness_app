import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

import 'models/bottom_menu_model.dart';

class BottomMenuWidget<T> extends StatelessWidget {
  final BottomMenuModel<T> model;
  const BottomMenuWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: model.items.length * 80,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (ctx, index) {
              final item = model.items[index];
              return TextButton(
                onPressed: () {
                  Navigator.of(context).pop(item.value);
                },
                child: item.icon == null
                    ? Text(
                        item.text,
                        style: TextStyle(
                            color: item.textColor ?? Colors.black,
                            fontSize: 18),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          item.icon!,
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            item.text,
                            style: TextStyle(
                                color: item.textColor ?? Colors.black,
                                fontSize: 18),
                          )
                        ],
                      ),
              );
            },
            separatorBuilder: (ctx, index) => Divider(
                  color: AppColors.main,
                ),
            itemCount: model.items.length),
      ),
    );
  }
}
