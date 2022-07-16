import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfullcourse/models/student.dart';
import 'package:flutterfullcourse/screens/student_add.dart';
import 'dart:math';

class StudentAdd extends StatefulWidget {
  List<Student> students;
  //StudentAdd(List<Student> students) {
  //this.students = students;
  //}
  StudentAdd(this.students);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentAddStatedState();
  }
}

class _StudentAddStatedState extends State<StudentAdd> {
  var formKey = GlobalKey<FormState>();

  Student student = Student("", "", 0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni öğrenci ekle."),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildFirstNameField(),
              buildLastNameField(),
              buildGradeField(),
              buildSubmitField()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Öğrenci Adı:", hintText: "Engin"),
      onSaved: (String? value) {
        student.firstName = value!;
      },
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: "Öğrenci Soyad:", hintText: "Demiroğ"),
      onSaved: (String? value) {
        student.lastName = value!;
      },
    );
  }

  Widget buildGradeField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Aldığı Not:", hintText: "65"),
      onSaved: (String? value) {
        student.grade = int.parse(value!);
      },
    );
  }

  Widget buildSubmitField() {
    Random random = Random();

    if (student.grade >= 50) {
      student.status = "Geçti";
    } else if (student.grade >= 40) {
      student.status = "Bütünlemeye Kaldı";
    } else {
      student.status = "Kaldı";
    }

    return ElevatedButton(
        child: Text("Ekle"),
        onPressed: () {
          formKey.currentState!.save();
          widget.students.add(student);
          FirebaseFirestore.instance
              .collection("students")
              .doc(student.firstName + student.lastName)
              .set({
            'id': random.nextInt(100),
            'firstName': student.firstName,
            'lastName': student.lastName,
            'grade': student.grade,
            'status': student.status
          });
          Navigator.pop(context);
        });
  }
}
