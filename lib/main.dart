import 'package:flutter/material.dart';
import 'package:flutterfullcourse/main.dart';
import 'package:flutterfullcourse/models/student.dart';
import 'package:flutterfullcourse/screens/student_add.dart';
import 'package:flutterfullcourse/screens/student_remove.dart';
import 'package:flutterfullcourse/screens/student_update.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State {
  List<Student> students = [Student.withId(0, "Hiç Kimse", "", 0)];

  Student selectedStudent = Student.withId(0, "Hiç Kimse", "", 0);
  Student selectedStudentWithUpdate = Student.withId(0, "Hiç Kimse", "", 0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Öğrenci Takip Sistemi"),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    FirebaseFirestore.instance
        .collection('students')
        .snapshots()
        .listen((data) => data.docs.forEach((doc) => students.clear()));

    FirebaseFirestore.instance.collection('students').snapshots().listen(
        (data) => data.docs.forEach((doc) => students.add(Student.withId(
            doc['id'], doc['firstName'], doc['lastName'], doc['grade']))));

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(students[index].firstName +
                      " " +
                      students[index].lastName),
                  subtitle: Text("Sınavdan aldığı not: " +
                      students[index].grade.toString() +
                      "[" +
                      students[index].getStatus +
                      "]"),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2016/12/09/09/52/girl-1894125_960_720.jpg"), //Random Image
                  ),
                  trailing: buildStatusIcon(students[index].grade),
                  onTap: () {
                    if (students.length == 0) {
                      setState(() {});
                      //print("Kayıt yok.");
                    } else {
                      setState(() {
                        this.selectedStudent = students[index];
                        this.selectedStudentWithUpdate = this.selectedStudent;
                      });
                      //print(selectedStudent.firstName);
                    }
                  },
                );
              }),
        ),
        Text("Seçili Öğrenci: " + selectedStudent.firstName),
        Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent, onPrimary: Colors.black),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("Yeni Öğrenci")
                  ],
                ),
                onPressed: () {
                  selectedStudent = Student.withId(0, "Hiç Kimse", "", 0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAdd(students)));
                },
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.grey, onPrimary: Colors.black),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.update),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("Güncelle")
                  ],
                ),
                onPressed: () {
                  if (selectedStudent.firstName == "Hiç Kimse") {
                    setState(() {});
                    //print("Güncellendi");
                  } else {
                    selectedStudent = Student.withId(0, "Hiç Kimse", "", 0);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentUpdate(selectedStudentWithUpdate)));
                  }
                },
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.amberAccent, onPrimary: Colors.black),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.close),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("Sil")
                  ],
                ),
                onPressed: () {
                  //print("Sil");
                  selectedStudent = Student.withId(0, "Hiç Kimse", "", 0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentRemove(students)));
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildStatusIcon(int grade) {
    if (grade >= 50) {
      return Icon(Icons.done);
    } else if (grade >= 40) {
      return Icon(Icons.album);
    } else {
      return Icon(Icons.clear);
    }
  }
}
