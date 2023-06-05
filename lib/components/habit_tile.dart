import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitComplete;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingTaped;
  final Function(BuildContext)? deleteTaped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitComplete,
    required this.onChanged,
    required this.deleteTaped,
    required this.settingTaped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // settings option
            SlidableAction(
              onPressed: settingTaped,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),

            // delete option
            SlidableAction(
              onPressed: deleteTaped,
              backgroundColor: Colors.red.shade300,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              // checkbox
              Checkbox(value: habitComplete, onChanged: onChanged),

              // habit name
              Text(habitName),
            ],
          ),
        ),
      ),
    );
  }
}
