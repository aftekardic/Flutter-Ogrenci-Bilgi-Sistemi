class Student {
  int id = 0;
  String firstName = "";
  String lastName = "";
  int grade = 0;
  String status = "";

  Student(String firsName, String lastName, int grade) {
    this.firstName = firsName;
    this.lastName = lastName;
    this.grade = grade;
  }

  Student.withId(int id, String firsName, String lastName, int grade) {
    this.id = id;
    this.firstName = firsName;
    this.lastName = lastName;
    this.grade = grade;
  }

  String get getStatus {
    String message = "";
    if (this.grade >= 50) {
      message = "Geçti";
    } else if (this.grade >= 40) {
      message = "Bütünlemeye Kaldı";
    } else {
      message = "Kaldı";
    }
    this.status = message;
    return this.status;
  }
}
