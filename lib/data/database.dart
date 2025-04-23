import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todoList = [];
  //refrence our box
  final _myBox = Hive.box('mybox');
  //run this method if this is the first time ever opening this app
   void createInitialData(){
     todoList = [
       ["Make Tutorial", false],
       ["Do Exercise", false],
     ];
   }

   //load the data from database
    void loadData(){
     todoList = _myBox.get("TODOLIST");
    }

    //updtae the database
    void updateDataBase(){
     _myBox.put("TODOLIST", todoList);
    }
}