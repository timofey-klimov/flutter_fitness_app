import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';

class TrainSamplesPage extends StatelessWidget {
  const TrainSamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.article,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Тренировки',
                  style: TextStyle(color: AppColors.white, fontSize: 22),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/createtrains');
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppColors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
