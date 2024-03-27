class Exercise {
   String name;
   String weight;
   String reps;
   String sets;
   bool isCompleted;

  Exercise({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    this.isCompleted = false,
  });
  void setName(String name){
    this.name=name;
  }
   String getName(){
     return this.name;
   }
   void setWeight(String weight){
     this.weight=weight;
   }
   void setReps(String reps){
     this.reps=reps;
   }
   void setSets(String sets){
     this.sets=sets;
   }
}
