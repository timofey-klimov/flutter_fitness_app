import 'package:app/routes.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

class TrainSamplesPage extends StatelessWidget {
  const TrainSamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.article,
                    color: AppColors.main,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Routes.CreateTrainsScreen);
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppColors.main,
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
