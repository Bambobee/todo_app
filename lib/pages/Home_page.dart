import 'package:flutter/material.dart';
import 'package:my_app/util/todo_tile.dart';
import 'package:my_app/util/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // //reference the hive box
  // final _myBox = Hive.openBox('mybox');

  // Declare the box
  late Box _myBox;
  //text controller
  final _controller = TextEditingController();
  TodoDatabase db = TodoDatabase();


  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _myBox = await Hive.openBox('mybox');
    //If this is the first time ever opening the app, then create default date
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }else{
      //there already exists data
      db.loadData();
    }
    setState(() {}); // Trigger rebuild after initialization
  }

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDataBase();
  }
  // save new task
  void saveNewTask(){
    setState(() {
      db.todoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }
  //create a new task
  void createNewTask(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index){
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(
            child: Text('To Do')
        ),
        elevation: 0,
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index){
          return TodoTile(
              taskName: db.todoList[index][0],
              taskCompleted: db.todoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
