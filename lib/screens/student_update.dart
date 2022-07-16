import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfullcourse/models/student.dart';
import 'package:flutterfullcourse/screens/student_update.dart';
import 'dart:math';

class StudentUpdate extends StatefulWidget {
  Student student;
  StudentUpdate(this.student);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentUpdateStatedState();
  }
}

class _StudentUpdateStatedState extends State<StudentUpdate> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          title: Text("Öğrenci Güncelleme"),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                updatableStudent(),
                buildFirstNameField(),
                buildLastNameField(),
                buildGradeField(),
                buildSubmitField()
              ],
            ),
          ),
        ));
  }

  Widget updatableStudent() {
    return Center(
      child: Text(
        widget.student.firstName + " " + widget.student.lastName,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      initialValue: widget.student.firstName,
      decoration: InputDecoration(labelText: "Öğrenci Adı:", hintText: "İsim"),
      onSaved: (String? value) {
        widget.student.firstName = value!;
      },
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      initialValue: widget.student.lastName,
      decoration:
          InputDecoration(labelText: "Öğrenci Soyad:", hintText: "Soyisim"),
      onSaved: (String? value) {
        widget.student.lastName = value!;
      },
    );
  }

  Widget buildGradeField() {
    return TextFormField(
      initialValue: widget.student.grade.toString(),
      decoration: InputDecoration(
        labelText: "Aldığı Not:",
        hintText: "Not",
      ),
      onSaved: (String? value) {
        widget.student.grade = int.parse(value!);
      },
    );
  }

  Widget buildSubmitField() {
    Random random = Random();
    if (widget.student.grade >= 50) {
      widget.student.status = "Geçti";
    } else if (widget.student.grade >= 40) {
      widget.student.status = "Bütünlemeye Kaldı";
    } else {
      widget.student.status = "Kaldı";
    }

    return ElevatedButton(
        child: Text("Kaydet"),
        onPressed: () {
          formKey.currentState!.save();
          FirebaseFirestore.instance
              .collection("students")
              .doc(widget.student.firstName + widget.student.lastName)
              .update({
            'id': random.nextInt(100),
            'firstName': widget.student.firstName,
            'lastName': widget.student.lastName,
            'grade': widget.student.grade,
            'status': widget.student.status
          });
          Navigator.pop(context);
        });
  }
}
