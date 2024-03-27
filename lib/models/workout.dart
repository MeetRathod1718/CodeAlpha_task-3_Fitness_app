import 'package:fitness_tracker/models/exercise.dart';

class Workout {
   String name;
   final List<Exercise> exercises;
  Workout({required this.name, required this.exercises});

  void setWorkoutName(String name) {
    this.name=name;
  }
  String getWorkoutName(){
    return this.name;
  }
}
