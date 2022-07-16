import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfullcourse/models/student.dart';
import 'package:flutterfullcourse/screens/student_remove.dart';

class StudentRemove extends StatefulWidget {
  List<Student> students;
  //StudentAdd(List<Student> students) {
  //this.students = students;
  //}
  StudentRemove(this.students);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentRemoveStatedState();
  }
}

class _StudentRemoveStatedState extends State<StudentRemove> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenci Silme"),
      ),
      body: studentRemovableList(),
    );
  }

  Widget studentRemovableList() {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 540, // değerler değişecek
      width: 480, // değerler değişecek deneme yanılma
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.students.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(widget.students[index].firstName +
                        " " +
                        widget.students[index].lastName),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/12/09/09/52/girl-1894125_960_720.jpg"), // Random Image
                    ),
                    trailing: Icon(Icons.delete),
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection("students")
                          .doc(widget.students[index].firstName +
                              widget.students[index].lastName)
                          .delete();
                      widget.students.removeAt(index);

                      setState(() {});
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
