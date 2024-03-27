import 'package:fitness_tracker/data/hive_database.dart';
import 'package:fitness_tracker/datetime/date_time.dart';
import 'package:fitness_tracker/models/exercise.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:flutter/cupertino.dart';


class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /*
  Workout Data Structure
  - This overall list contains the different workouts
  - Each workout has a name, and list of exercise
  
  */
  List<Workout> workoutList = [];
  // if there are workouts already in database, then get that workout list,

  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    // otherwise use default workouts
    else {
      db.saveToDatabase(workoutList);
    }
    //load heat map
    loadHeapMap();
  }

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get the length of a given workout
  int numberOfExerciseInWorkout(int index) {
    return workoutList[index].exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    // add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  // add an exercise to a workout
  void addExercise(int indexOfWorkout,String exerciseName, String weight, String reps, String sets) {
      workoutList[indexOfWorkout].exercises.add(Exercise(
            name: exerciseName,
            weight: weight,
            reps: reps,
            sets: sets,
          ));
      notifyListeners();
      //save to database
      db.saveToDatabase(workoutList);
      loadHeapMap();
  }
  void deleteExercise(int indexOfWorkout,int indexOfExercise){
      workoutList[indexOfWorkout].exercises.removeAt(indexOfExercise);
      // Notify listeners of the change
      notifyListeners();
      // Save the updated workout list to the database
      db.saveToDatabase(workoutList);
      //load heat map
      loadHeapMap();
  }
  void updateWorkout(int indexOfWorkout,String newWorkoutName){
    workoutList[indexOfWorkout].setWorkoutName(newWorkoutName);
    // Notify listeners of the change
    notifyListeners();
    // Save the updated workout list to the database
    db.saveToDatabase(workoutList);
  }

  void deleteWorkout(int indexOfWorkout){
        workoutList.removeAt(indexOfWorkout);
        notifyListeners();
        // Save to database
        db.saveToDatabase(workoutList);
        // Load heat map
        loadHeapMap();
  }

  void updateExercise(int indexOfWorkout,int indexOfExercise,String newExerciseName, String weight, String reps, String sets) {
      // Update the exercise details
      workoutList[indexOfWorkout].exercises[indexOfExercise].setName(newExerciseName);
      workoutList[indexOfWorkout].exercises[indexOfExercise].setWeight(weight);
      workoutList[indexOfWorkout].exercises[indexOfExercise].setReps(reps);
      workoutList[indexOfWorkout].exercises[indexOfExercise].setSets(sets);
      // Notify listeners of the change
      notifyListeners();
      // Save the updated workout list to the database
      db.saveToDatabase(workoutList);
  }



  // check off exercise
  void checkOfExercise(int indexOfWorkout,int indexOfExercise) {
    // find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = workoutList[indexOfWorkout].exercises[indexOfExercise];
    // check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heat map
    loadHeapMap();
  }


  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*
  HEAT MAP
  */
  Map<DateTime, int> heapMapDataSet = {};
  void loadHeapMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    //go from start date to today, and add each completion status to the dataset
    //"COMPLETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));
      //completion status= 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);
      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;
      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      //add to the heap map dataset
      heapMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
