import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskapp/models/task.dart';

class Homepage extends StatefulWidget {
  Homepage();

  @override
  State<Homepage> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  late double _deviceheight, _devicewidth;

  String? _newTaskContent;
  Box? _box;
  _HomepageState(); // Correct placement of the constructor.

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    print("enter value of : $_newTaskContent");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceheight * 0.15,
        title: Text(
          "TaskApp",
          style: GoogleFonts.lato(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),
      body: _taskview(),
      floatingActionButton: _addtaskbotton(),
    );
  }

  Widget _taskview() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _Snapshot) {
        if (_Snapshot.hasData) {
          _box = _Snapshot.data;
          return _tasklists();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _tasklists() {
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (
          BuildContext _context,
          int _index,
        ) {
          var task = Task.fromMap(tasks[_index]);
          return ListTile(
            title: Text(
              task.content,
              style: GoogleFonts.aDLaMDisplay(
                  decoration: task.done ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(
              task.timestamp.toString(),
            ),
            trailing: Icon(
              task.done
                  ? Icons.check_box_sharp
                  : Icons.check_box_outline_blank_outlined,
              color: Colors.green,
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(
                _index,
                task.toMap(),
              );
              setState(() {});
            },
            // Replace your current onLongPress with this code
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      "Delete Task",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text("Are you sure you want to delete this task?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _box!.deleteAt(_index); // Delete the task
                          setState(() {}); // Update the UI
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        });
  }

  Widget _addtaskbotton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: Icon(Icons.add),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Add New Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            constraints: BoxConstraints(maxHeight: 100),
            child: TextField(
              onSubmitted: (_value) {
                if (_newTaskContent != null) {
                  var _task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(_task.toMap());
                  setState(() {
                    _newTaskContent = null;
                  });
                  Navigator.of(_context).pop();
                }
              },
              onChanged: (_value) {
                setState(() {
                  _newTaskContent = _value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                hintText: "Enter your task...",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(_context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newTaskContent != null) {
                  var _task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(_task.toMap());
                  setState(() {
                    _newTaskContent = null;
                  });
                  Navigator.of(_context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
