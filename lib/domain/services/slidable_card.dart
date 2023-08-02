import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableCard extends StatelessWidget {
  const SlidableCard(
      {super.key,
      required Function(int index) onRemove,
      required int index,
      required Widget card})
      : _onRemove = onRemove,
        _index = index,
        _card = card;

  final Function(int index) _onRemove;
  final int _index;
  final Widget _card;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        dismissible: DismissiblePane(onDismissed: () {
          _onRemove(_index);
        }),
        extentRatio: .4,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {},
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: _card,
    );
  }
}
