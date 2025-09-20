class Course {
  final String courseCode;
  final String courseTitle;
  final double internalAssessment;
  final double courseCredit;
  final double gradePoint;
  final String letterGrade;

  Course({
    required this.courseCode,
    required this.courseTitle,
    required this.internalAssessment,
    required this.courseCredit,
    required this.gradePoint,
    required this.letterGrade,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'internalAssessment': internalAssessment,
      'courseCredit': courseCredit,
      'gradePoint': gradePoint,
      'letterGrade': letterGrade,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['courseCode'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      internalAssessment: (json['internalAssessment'] ?? 0.0).toDouble(),
      courseCredit: (json['courseCredit'] ?? 0.0).toDouble(),
      gradePoint: (json['gradePoint'] ?? 0.0).toDouble(),
      letterGrade: json['letterGrade'] ?? '',
    );
  }
}

class SemesterResult {
  final String semester;
  final List<Course> courses;
  final double gpa;
  final String grade;
  final double totalCredits;

  SemesterResult({
    required this.semester,
    required this.courses,
    required this.gpa,
    required this.grade,
    required this.totalCredits,
  });

  Map<String, dynamic> toJson() {
    return {
      'semester': semester,
      'courses': courses.map((course) => course.toJson()).toList(),
      'gpa': gpa,
      'grade': grade,
      'totalCredits': totalCredits,
    };
  }

  factory SemesterResult.fromJson(Map<String, dynamic> json) {
    return SemesterResult(
      semester: json['semester'] ?? '',
      courses: (json['courses'] as List<dynamic>?)
          ?.map((courseJson) => Course.fromJson(courseJson))
          .toList() ?? [],
      gpa: (json['gpa'] ?? 0.0).toDouble(),
      grade: json['grade'] ?? '',
      totalCredits: (json['totalCredits'] ?? 0.0).toDouble(),
    );
  }
}

class StudentResult {
  final List<SemesterResult> semesterResults;
  final double cgpa;

  StudentResult({
    required this.semesterResults,
    required this.cgpa,
  });

  Map<String, dynamic> toJson() {
    return {
      'semesterResults': semesterResults.map((result) => result.toJson()).toList(),
      'cgpa': cgpa,
    };
  }

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    return StudentResult(
      semesterResults: (json['semesterResults'] as List<dynamic>?)
          ?.map((resultJson) => SemesterResult.fromJson(resultJson))
          .toList() ?? [],
      cgpa: (json['cgpa'] ?? 0.0).toDouble(),
    );
  }
}
