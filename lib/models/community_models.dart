class Student {
  final String name;
  final String id;
  final String programID;
  final double gpa;

  Student({
    required this.name,
    required this.id,
    required this.programID,
    required this.gpa,
  });

  // Convert Firebase document to model
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['studentName'] ?? '',
      id: map['studentID'] ?? '',
      programID: map['studyProgramID'] ?? '',
      gpa: map['studentGPA']?.toDouble() ?? 0.0,
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'studentName': name,
      'studentID': id,
      'studyProgramID': programID,
      'studentGPA': gpa,
    };
  }
}