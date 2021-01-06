import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cssflutter/models/note.dart';
import 'package:cssflutter/utils/db_helper.dart';
import 'package:cssflutter/screens/studentdetails.dart';

import 'package:sqflite/sqflite.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Note> noteList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('DETAILS'),
      ),
      body: getDetailsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 'male'), 'ADD DETAILS');
        },
        tooltip: 'Add Details',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getDetailsListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle2;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].gender),
              child: Icon(
                Icons.contacts,
                color: Colors.black,
              ),
            ),
            title: Text(
              this.noteList[position].name,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              debugPrint("list tapped");
              navigateToDetail(this.noteList[position], 'EDIT DETAILS');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(String gender) {
    switch (gender) {
      case 'male':
        return Colors.green;
        break;
      case 'female':
        return Colors.pink;
        break;
      default:
        return Colors.grey;
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await dataBaseHelper.deleteStudent(note.id);
    if (result != 0) {
      _showSnackBar(context, 'details deleted successsfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentDetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
