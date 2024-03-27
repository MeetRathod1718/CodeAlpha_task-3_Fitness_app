import 'package:fitness_tracker/components/heat_map.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:fitness_tracker/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  // text controller
  TextEditingController newWorkoutNameController = TextEditingController();

  // create a new workout
  void addWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Create a new workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
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

// go to Workout Page
  void goToWorkoutPage(String workoutName, int indexOfWorkout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
          index: indexOfWorkout,
        ),
      ),
    );
  }

  bool checkNewWorkoutNameIfEmpty(String newWorkoutName){
    if(newWorkoutName==''){
      var snackBar = const SnackBar(content: Text('No Data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }
// save workout
  void save() {
    //get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    //check if the workout is empty
    if(checkNewWorkoutNameIfEmpty(newWorkoutName)){
      // add workout to workoutdata list
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).addWorkout(newWorkoutName);
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
    newWorkoutNameController.clear();
  }

  void updateWorkout(int indexOfWorkout,String oldWorkoutName){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update the workout"),
        content: TextField(
          decoration: InputDecoration(hintText: oldWorkoutName),
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              saveExistingWorkout(indexOfWorkout,oldWorkoutName);
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
  void saveExistingWorkout(int indexOfWorkout,String oldWorkoutName){
    String newWorkoutName = newWorkoutNameController.text;
    if(newWorkoutName!='') {
      // add exercise to workout
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).updateWorkout(
        indexOfWorkout,
        newWorkoutName,
      );
    }
    //pop dialog box
    Navigator.pop(context);
    clear();
  }
  void deleteWorkout(int indexOfWorkout){
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).deleteWorkout(
      indexOfWorkout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: const Text("Fitness Tracker"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addWorkout,
          child: const Icon(Icons.add),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/gym2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              // Heap Map
              MyHeatMap(
                  datasets: value.heapMapDataSet,
                  startDateYYYYMMDD: value.getStartDate()),
              //Workout List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        //update option
                        SlidableAction(onPressed: (context) =>updateWorkout(index,value.getWorkoutList()[index].name),
                          backgroundColor: Colors.grey.shade800,
                          icon: Icons.settings,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        //delete option
                          SlidableAction(onPressed: (context) =>deleteWorkout(index),
                          backgroundColor: Colors.red.shade400,
                          icon: Icons.delete,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                    child: Container(
                      // color: Colors.amberAccent[200],
                      color: Colors.purple[400],
                      child: ListTile(
                      //print each workout name
                      title: Text(
                        value.getWorkoutList()[index].name,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                        onPressed: () =>
                            goToWorkoutPage(value.getWorkoutList()[index].name,index),
                      ),
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
