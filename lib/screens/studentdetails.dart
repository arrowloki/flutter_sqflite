import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cssflutter/models/note.dart';
import 'package:cssflutter/utils/db_helper.dart';
import 'package:cssflutter/screens/studentdetails.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';

class StudentDetails extends StatefulWidget {
  final String appBartitle;
  final Note note;
  StudentDetails(this.note, this.appBartitle);

  @override
  _StudentDetailsState createState() =>
      _StudentDetailsState(this.note, this.appBartitle);
}

class _StudentDetailsState extends State<StudentDetails> {
  static var _gender = ['male', 'female'];

  String appBartitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptonController = TextEditingController();

  _StudentDetailsState(this.note, this.appBartitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.name;
    descriptonController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBartitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, right: 10, left: 10),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: _gender.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: getPriority(note.gender),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint('user selected  $valueSelectedByUser');
                    updatePriority(valueSelectedByUser);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  updateName();
                },
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: descriptonController,
                style: textStyle,
                onChanged: (value) {
                  updatedDescp();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _save();
                      },
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _delete();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void movetoLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case 'male':
        note.gender = 'male';
        break;
      case 'female':
        note.gender = 'female';
        break;
    }
  }

  String getPriority(String value) {
    String gender;
    switch (gender) {
      case 'male':
        gender = 'male';
        break;
      case 'female':
        gender = 'female';
        break;
    }
    return gender;
  }

  void updateName() {
    note.name = titleController.text;
  }

  void updatedDescp() {
    note.description = descriptonController.text;
  }

  void _save() async {
    movetoLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      await DataBaseHelper().updateStudent(note);
    } else {
      result = await DataBaseHelper().insertStudent(note);
    }
    if (result != 0) {
      _showAlterDi('status', 'note saved successfully');
    } else {
      _showAlterDi('status', 'Problem saving note');
    }
  }

  void _showAlterDi(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    movetoLastScreen();
    if (note.id == null) {
      _showAlterDi('status', 'no note was deleted');
      return;
    }
    int result = await DataBaseHelper().deleteStudent(note.id);
    if (result != 0) {
      _showAlterDi('status', 'note deleted successfully');
    } else {
      _showAlterDi('status', 'error in  deleteing');
    }
  }
}
