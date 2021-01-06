import 'package:flutter/cupertino.dart';

class Note {
  int _id;
  String _name;
  String _description;
  String _date;
  String _gender;

  Note(this._name, this._date, this._gender, [this._description]);
  Note.withId(this._id, this._name, this._date, this._gender,
      [this._description]);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get gender => _gender;
  String get date => _date;

  set name(String newName) {
    if (newName.length <= 20) {
      this._name = newName;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 50) {
      this._description = newDescription;
    }
  }

  set gender(String newGender) {
    if (newGender == 'male' && newGender == 'female') {
      this._gender = newGender;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['gender'] = _gender;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._gender = map['gender'];
    this.date = map['date'];
  }
}
