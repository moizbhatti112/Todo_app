import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_practice/dataholder/data.dart';
import 'package:todo_practice/db/db_handler.dart';
import 'package:todo_practice/models/todomodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todocontroller = TextEditingController();
  Todomodel? _editingTask; // Add this to track the task being edited

  @override
  void initState() {
    super.initState();
    loadtasks();
  }

  void loadtasks() async {
    List<Todomodel> tasks = await DbHandler().gettasks();
    Provider.of<Tododata>(context, listen: false).setTasks(tasks);
  }

  newtask() {
    _editingTask = null; // Reset the editing task
    todocontroller.clear(); // Clear the text field

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(controller: todocontroller),
        actions: [
          MaterialButton(
            onPressed: () {
              onsave();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              oncancel();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  edittask(Todomodel task) {
    _editingTask = task; // Set the editing task
    todocontroller.text =
        task.name; // Populate the text field with the task name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(controller: todocontroller),
        actions: [
          MaterialButton(
            onPressed: () {
              onsave();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              oncancel();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void onsave() async {
    if (_editingTask == null) {
      // If no task is being edited, add a new task
      Todomodel newtask = Todomodel(name: todocontroller.text, isdone: false);
      int id = await DbHandler().insertdata(newtask);
      newtask.id = id;

      Provider.of<Tododata>(context, listen: false).addtask(newtask);
    } else {
      // If a task is being edited, update it
      _editingTask!.name = todocontroller.text;
      await DbHandler().edit(_editingTask!);

      Provider.of<Tododata>(context, listen: false).updatetask(_editingTask!);
      _editingTask = null; // Reset the editing task
    }

    todocontroller.clear();
    Navigator.pop(context);
  }

  void oncancel() {
    Navigator.pop(context);
  }

  void ondelete(Todomodel task) async {
    await DbHandler().deltask(task.name);
    Provider.of<Tododata>(context, listen: false).deletetask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Tododata>(
      builder: (context, value, child) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Todo App',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                newtask();
              },
              child: const Icon(Icons.add),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
            body:  Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text('All Todos',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                   const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: value.getlist().length,
                        itemBuilder: (context, index) {
                          final task = value.getlist()[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Slidable(
                              startActionPane:
                                  ActionPane(motion: const StretchMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    ondelete(task);
                                  },
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    edittask(task); // Pass the task to be edited
                                  },
                                  backgroundColor: Colors.green,
                                  icon: Icons.edit,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ]),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: ListTile(
                                      title: Text(
                                        task.name,
                                        style: TextStyle(
                                            decoration: task.isdone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      leading: GestureDetector(
                                        onTap: () {
                                          Provider.of<Tododata>(context, listen: false)
                                              .toggleisdone(task);
                                        },
                                        child: task.isdone
                                            ? const Icon(
                                                Icons.check_box,
                                                color: Colors.deepPurple,
                                              )
                                            : const Icon(Icons.check_box_outline_blank),
                                      )),
                                ),
                              ),
                              // ],
                              // ),
                            ),
                          );
                          //   ],
                          // );
                        }),
                  ),
                ],
              ),
            
          ),
       
      ),
    );
  }
}
