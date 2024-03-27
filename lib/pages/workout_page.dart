import 'package:fitness_tracker/components/exercise_tile.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WorkoutPage extends StatefulWidget {
   final String workoutName;
   final int index;
   const WorkoutPage({super.key, required this.workoutName,required this.index});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckBoxChanged(int indexOfWorkout,int indexOfExercise) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOfExercise(indexOfWorkout,indexOfExercise );
  }

// text controller
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

// create a new exercise
  void addExercise(int indexOfWorkout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            TextField(
              decoration: const InputDecoration(hintText: "exercise name"),
              controller: exerciseNameController,

            ),
            //weight
            TextField(
              decoration: const InputDecoration(hintText: "weight"),
              controller: weightController,
            ),
            //reps
            TextField(
              decoration: const InputDecoration(hintText: "reps"),
              controller: repsController,
            ),
            //sets
            TextField(
              decoration: const InputDecoration(hintText: "sets"),
              controller: setsController,
            )
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: ()=>save(indexOfWorkout),
            child: const Text("save"),
          ),
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }

bool checkWorkoutDetailsIfEmpty(String newExerciseName,String weight,String reps,String sets){
    String error=' ';
    if(newExerciseName==''){
      error="exercise name";
    }else if(weight==''){
      error="weight value";
    }else if(reps==''){
      error="reps value";
    }else if(sets==''){
      error="sets value";
    }else{
      return true;
    }
    var snackBar =  SnackBar(content: Text('Please Enter your $error'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return false;
}
// save workout
  void save(int indexOfWorkout) {
    //get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    if(checkWorkoutDetailsIfEmpty(newExerciseName,weight,reps,sets)) {
      // add exercise to workout
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).addExercise(
        indexOfWorkout,
        newExerciseName,
        weight,
        reps,
        sets,
      );
      //pop dialog box
      Navigator.pop(context);
      clear();
    }
  }

// cancel
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }
  //clear controllers
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }
//delete exercise
  void deleteExercise(int indexOfWorkout,int indexOfExcercise){
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).deleteExercise(
        indexOfWorkout,
        indexOfExcercise,
    );
  }
  // open exercise settings to edit
  void updateExercise(int indexOfWorkout,int indexOfExercise,String oldExerciseName,String oldWeight,String oldReps,String oldSets){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update the exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            TextField(
              decoration: InputDecoration(hintText: oldExerciseName),
              controller: exerciseNameController,
            ),
            //weight
            TextField(
              decoration: InputDecoration(hintText: "$oldWeight weight"),
              controller: weightController,
            ),
            //reps
            TextField(
              decoration: InputDecoration(hintText: "$oldReps reps"),
              controller: repsController,
            ),
            //sets
            TextField(
              decoration: InputDecoration(hintText: "$oldSets sets"),
              controller: setsController,
            )
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              saveExistingExercise(indexOfWorkout,indexOfExercise,oldExerciseName,oldWeight,oldReps,oldSets);
            },
              child: const Text("save"),
          ),
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }
void saveExistingExercise(int indexOfWorkout,int indexOfExercise,String oldExerciseName,String oldWeight,String oldReps,String oldSets){
  //get exercise name from text controller
  String newExerciseName = exerciseNameController.text;
  String weight = weightController.text;
  String reps = repsController.text;
  String sets = setsController.text;
  if(newExerciseName==''){
    newExerciseName=oldExerciseName;
  }
  if(weight==''){
    weight= oldWeight;
  }
  if(reps==''){
    reps= oldReps;
  }
  if(sets==''){
    sets= oldSets;
  }
  saveExistingExerciseAfterResetAllParameters(indexOfWorkout,indexOfExercise,newExerciseName,weight,reps,sets);
}
  void saveExistingExerciseAfterResetAllParameters(int indexOfWorkout,int indexOfExercise,String newExerciseName,String weight,String reps,String sets){
      // add exercise to workout
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).updateExercise(
        indexOfWorkout,
        indexOfExercise,
        newExerciseName,
        weight,
        reps,
        sets,
      );
      //pop dialog box
      Navigator.pop(context);
      clear();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.workoutName),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  addExercise(widget.index);
                },
                child: const Icon(Icons.add),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gym.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView.builder(
                  //get the number of exercises in the workout
                  itemCount: value.numberOfExerciseInWorkout(widget.index),
                  itemBuilder: (context, index) => ExerciseTile(
                    exerciseName: value
                        //get a name of exercise in a specific workout
                        .workoutList[widget.index]
                        .exercises[index]
                        .name,
                    //get a weight of this exercise in a specific workout
                    weight: value
                        .workoutList[widget.index]
                        .exercises[index]
                        .weight,
                    //get reps of this exercise in a specific workout
                    reps: value
                        .workoutList[widget.index]
                        .exercises[index]
                        .reps,
                    //get sets of this exercise in a specific workout
                    sets: value
                        .workoutList[widget.index]
                        .exercises[index]
                        .sets,
                    //get check if isCompleted is true or flase of this exercise in a specific workout
                    isCompleted: value
                        .workoutList[widget.index]
                        .exercises[index]
                        .isCompleted,
                    onCheckBoxChanged: (val) => onCheckBoxChanged(
                      //the workout name
                      widget.index,
                      //the exercise name in the workout
                      index,
                    ),
                    settingsTapped: (context) =>updateExercise(
                      widget.index,
                      index,
                      value
                      .workoutList[widget.index]
                      .exercises[index]
                      .name,
                      value
                      //get a name of exercise in a specific workout
                          .workoutList[widget.index]
                          .exercises[index]
                          .weight,
                      value
                      //get a name of exercise in a specific workout
                          .workoutList[widget.index]
                          .exercises[index]
                          .reps,
                      value
                      //get a name of exercise in a specific workout
                          .workoutList[widget.index]
                          .exercises[index]
                          .sets,
                    ),
                    deleteTapped: (context) => deleteExercise(
                        widget.index,
                        index,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

}
