import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            //settings option
            SlidableAction(onPressed: settingsTapped,
                backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),
            //delete option
            SlidableAction(onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          color: (isCompleted)?Colors.green:Colors.grey,
          child: ListTile(
            title: Text(
              exerciseName,
            ),
            subtitle: Wrap(
              children: [
                //weight
                Chip(
                  label: Text(
                    "$weight kg",
                  ),
                ),
                //reps
                Chip(
                  label: Text(
                    "$reps reps",
                  ),
                ),
                //sets
                Chip(
                  label: Text(
                    "$sets sets",
                  ),
                ),
              ],
            ),
            trailing: Checkbox(
              value: isCompleted,
              onChanged: (value) => onCheckBoxChanged!(value),
            ),
          ),
        ),
      ),
    );
  }
}
