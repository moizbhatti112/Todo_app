import 'package:flutter/material.dart';
import 'package:todo_practice/db/db_handler.dart';
import 'package:todo_practice/models/todomodel.dart';

class Tododata extends ChangeNotifier {
  List<Todomodel> tasklist = [];

  List<Todomodel> getlist() {
    return tasklist;
  }

  void addtask(Todomodel newtask) {
    tasklist.add(newtask);
    notifyListeners();
  }

  void deletetask(Todomodel task) {
    tasklist.remove(task);
    notifyListeners();
  }

  void updatetask(Todomodel task) {
    int index = tasklist.indexWhere((t) => t.id == task.id);
    if(index!=-1)
    {
      tasklist[index] = task;
      notifyListeners();
    }
  }

  void toggleisdone(Todomodel task) async {
    task.isdone = !task.isdone;
    await DbHandler().updateisdone(task);
    notifyListeners();
  }

  void setTasks(List<Todomodel> tasks) {
    tasklist = tasks;
    notifyListeners();
  }
}
