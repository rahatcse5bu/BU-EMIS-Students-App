class Student {
  final String regNo;
  final String name;
  final String session;
  final String program;
  final String faculty;
  final String department;
  final String yearSemester;
  final String classRoll;
  final String contactNumber;
  final String email;
  final String nidNo;
  final String dateOfBirth;
  final String birthCertificateNo;
  final String nationality;
  final String religion;
  final String gender;
  final String bloodGroup;
  final String fatherName;
  final String fatherContact;
  final String fatherQualification;
  final String fatherProfession;
  final String motherName;
  final String motherContact;
  final String motherQualification;
  final String motherProfession;
  final String presentAddress;
  final String permanentAddress;

  Student({
    required this.regNo,
    required this.name,
    required this.session,
    required this.program,
    required this.faculty,
    required this.department,
    required this.yearSemester,
    required this.classRoll,
    required this.contactNumber,
    required this.email,
    required this.nidNo,
    required this.dateOfBirth,
    required this.birthCertificateNo,
    required this.nationality,
    required this.religion,
    required this.gender,
    required this.bloodGroup,
    required this.fatherName,
    required this.fatherContact,
    required this.fatherQualification,
    required this.fatherProfession,
    required this.motherName,
    required this.motherContact,
    required this.motherQualification,
    required this.motherProfession,
    required this.presentAddress,
    required this.permanentAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'regNo': regNo,
      'name': name,
      'session': session,
      'program': program,
      'faculty': faculty,
      'department': department,
      'yearSemester': yearSemester,
      'classRoll': classRoll,
      'contactNumber': contactNumber,
      'email': email,
      'nidNo': nidNo,
      'dateOfBirth': dateOfBirth,
      'birthCertificateNo': birthCertificateNo,
      'nationality': nationality,
      'religion': religion,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'fatherName': fatherName,
      'fatherContact': fatherContact,
      'fatherQualification': fatherQualification,
      'fatherProfession': fatherProfession,
      'motherName': motherName,
      'motherContact': motherContact,
      'motherQualification': motherQualification,
      'motherProfession': motherProfession,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      regNo: json['regNo'] ?? '',
      name: json['name'] ?? '',
      session: json['session'] ?? '',
      program: json['program'] ?? '',
      faculty: json['faculty'] ?? '',
      department: json['department'] ?? '',
      yearSemester: json['yearSemester'] ?? '',
      classRoll: json['classRoll'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      nidNo: json['nidNo'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      birthCertificateNo: json['birthCertificateNo'] ?? '',
      nationality: json['nationality'] ?? '',
      religion: json['religion'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      fatherName: json['fatherName'] ?? '',
      fatherContact: json['fatherContact'] ?? '',
      fatherQualification: json['fatherQualification'] ?? '',
      fatherProfession: json['fatherProfession'] ?? '',
      motherName: json['motherName'] ?? '',
      motherContact: json['motherContact'] ?? '',
      motherQualification: json['motherQualification'] ?? '',
      motherProfession: json['motherProfession'] ?? '',
      presentAddress: json['presentAddress'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
    );
  }
}
