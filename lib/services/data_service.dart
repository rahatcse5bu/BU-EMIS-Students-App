import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/document.dart';

class DataService {
  static const String _loginDataKey = 'login_data';
  static const String _studentDataKey = 'student_data';
  static const String _resultDataKey = 'result_data';
  static const String _documentDataKey = 'document_data';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _rememberMeKey = 'rememberMe';

  // Mock login credentials
  static const String validRegNo = '110-026-18';
  static const String validPassword = '01783307672@Rahat';  // Initialize mock data
  static Future<void> initializeMockData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear all existing data to force refresh
    await prefs.clear();
    
    // Initialize student data
    final student = Student(
      regNo: '110-026-18',
      name: 'Md. Rahat',
      session: '2017-18',
      program: 'BS (Hons)',
      faculty: 'Science and Engineering',
      department: 'Computer Science & Engineering',
      yearSemester: '4th Year',
      classRoll: '18 CSE 026',
      contactNumber: '01793278360',
      email: 'rahat.cse5.bu@gmail.com',
      nidNo: '5103910708',
      dateOfBirth: 'Jan 04, 1999',
      birthCertificateNo: '',
      nationality: 'Bangladeshi',
      religion: 'Islam',
      gender: 'Male',
      bloodGroup: 'A+',
      fatherName: 'Md. Jakir Hossain',
      fatherContact: '01736053297',
      fatherQualification: 'HSC',
      fatherProfession: 'Primary Teacher',
      motherName: 'Kohinur',
      motherContact: '01783307672',
      motherQualification: 'Class Five',
      motherProfession: 'Housewife',
      presentAddress: '15/2, Staff Quarter, Barishal Polytechnic Institute, Alekanda, Barishal - 8200',
      permanentAddress: 'Jangalia, Mollabari, Barguna Sadar, Barguna - 8710',
    );

    await prefs.setString(_studentDataKey, jsonEncode(student.toJson()));

    // Initialize result data
    final resultData = _getMockResultData();
    await prefs.setString(_resultDataKey, jsonEncode(resultData.toJson()));

    // Initialize mock document data
    final documents = _getMockDocuments();
    final documentsJson = documents.map((doc) => doc.toJson()).toList();
    await prefs.setString(_documentDataKey, jsonEncode(documentsJson));
  }

  // Login methods
  static Future<bool> login(String regNo, String password, bool rememberMe) async {
    await initializeMockData();
    
    if (regNo == validRegNo && password == validPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setBool(_rememberMeKey, rememberMe);
      if (rememberMe) {
        await prefs.setString(_loginDataKey, jsonEncode({
          'regNo': regNo,
          'password': password,
        }));
      }
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (!rememberMe) {
      await prefs.remove(_loginDataKey);
    }
  }

  static Future<Map<String, String>?> getSavedLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (rememberMe) {
      final loginDataString = prefs.getString(_loginDataKey);
      if (loginDataString != null) {
        final loginData = jsonDecode(loginDataString);
        return {
          'regNo': loginData['regNo'],
          'password': loginData['password'],
        };
      }
    }
    return null;
  }

  // Student data methods
  static Future<Student?> getStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final studentDataString = prefs.getString(_studentDataKey);
    if (studentDataString != null) {
      final studentData = jsonDecode(studentDataString);
      return Student.fromJson(studentData);
    }
    return null;
  }

  static Future<void> updateStudentData(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentDataKey, jsonEncode(student.toJson()));
  }

  // Result data methods
  static Future<StudentResult?> getResultData() async {
    final prefs = await SharedPreferences.getInstance();
    final resultDataString = prefs.getString(_resultDataKey);
    if (resultDataString != null) {
      final resultData = jsonDecode(resultDataString);
      return StudentResult.fromJson(resultData);
    }
    return null;
  }

  // Document methods
  static Future<List<Document>> getDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final documentsString = prefs.getString(_documentDataKey);
    if (documentsString != null) {
      final documentsJson = jsonDecode(documentsString) as List<dynamic>;
      return documentsJson.map((json) => Document.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> updateDocumentStatus(int serialNo, DocumentStatus newStatus, String? comment) async {
    final documents = await getDocuments();
    final docIndex = documents.indexWhere((doc) => doc.serialNo == serialNo);
    if (docIndex != -1) {
      // Create updated document
      final updatedDoc = Document(
        serialNo: documents[docIndex].serialNo,
        type: documents[docIndex].type,
        requestDate: documents[docIndex].requestDate,
        fee: documents[docIndex].fee,
        checkDate: documents[docIndex].checkDate,
        finalDeliveryDate: documents[docIndex].finalDeliveryDate,
        comments: comment ?? documents[docIndex].comments,
        status: newStatus,
      );
      
      documents[docIndex] = updatedDoc;
      
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = documents.map((doc) => doc.toJson()).toList();
      await prefs.setString(_documentDataKey, jsonEncode(documentsJson));
    }
  }
  // Mock data generators
  static StudentResult _getMockResultData() {
    final semesterResults = [
      // 1st Year 1st Semester
      SemesterResult(
        semester: '1st Year 1st Semester',
        gpa: 3.44,
        grade: 'B+',
        totalCredits: 21.00,
        courses: [
          Course(courseCode: 'CSE-1101', courseTitle: 'Introduction to Computer Systems', internalAssessment: 32.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-1102', courseTitle: 'Computer Systems and Computing Lab', internalAssessment: 33.50, courseCredit: 0.75, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-1103', courseTitle: 'Programming Fundamentals', internalAssessment: 37.00, courseCredit: 3.00, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-1104', courseTitle: 'Programming Fundamentals Lab', internalAssessment: 35.70, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'PHY-1105', courseTitle: 'Physics', internalAssessment: 25.00, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'PHY-1106', courseTitle: 'Physics Lab', internalAssessment: 25.00, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CHEM-1107', courseTitle: 'Chemistry', internalAssessment: 23.00, courseCredit: 3.00, gradePoint: 2.50, letterGrade: 'C+'),
          Course(courseCode: 'CHEM-1108', courseTitle: 'Chemistry Lab', internalAssessment: 24.00, courseCredit: 0.75, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'MATH-1109', courseTitle: 'Differential Calculus and Co-ordinate Geometry', internalAssessment: 27.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'ENG-1110', courseTitle: 'English Communication Skills Lab.', internalAssessment: 33.00, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
        ],
      ),
      
      // 1st Year 2nd Semester
      SemesterResult(
        semester: '1st Year 2nd Semester',
        gpa: 3.12,
        grade: 'B',
        totalCredits: 21.75,
        courses: [
          Course(courseCode: 'CSE-1201', courseTitle: 'Data Structures', internalAssessment: 31.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-1202', courseTitle: 'Data Structures Lab', internalAssessment: 23.00, courseCredit: 0.75, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-1203', courseTitle: 'Discrete Mathematics', internalAssessment: 38.00, courseCredit: 3.00, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-1204', courseTitle: 'Discrete Mathematics Lab', internalAssessment: 35.00, courseCredit: 0.75, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'EEE-1205', courseTitle: 'Introduction to Electrical Engineering', internalAssessment: 29.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'EEE-1206', courseTitle: 'Introduction to Electrical Engineering Lab', internalAssessment: 20.00, courseCredit: 1.50, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'EEE-1207', courseTitle: 'Basic Mechanical Engineering', internalAssessment: 30.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'EEE-1208', courseTitle: 'Engineering Drawing', internalAssessment: 31.00, courseCredit: 0.75, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'MATH-1209', courseTitle: 'Integral Calculus, Ordinary and Partial Differential Equations, and Series Solutions', internalAssessment: 21.00, courseCredit: 3.00, gradePoint: 2.00, letterGrade: 'D'),
          Course(courseCode: 'STAT-1211', courseTitle: 'Statistics and Probability', internalAssessment: 31.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
        ],
      ),
      
      // 2nd Year 1st Semester
      SemesterResult(
        semester: '2nd Year 1st Semester',
        gpa: 3.39,
        grade: 'B+',
        totalCredits: 21.00,
        courses: [
          Course(courseCode: 'CSE-2101', courseTitle: 'Database Management System', internalAssessment: 30.00, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-2102', courseTitle: 'Database Management System Lab', internalAssessment: 35.00, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-2103', courseTitle: 'Digital Logic Design', internalAssessment: 34.00, courseCredit: 3.00, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'CSE-2104', courseTitle: 'Digital Logic Design Lab', internalAssessment: 32.00, courseCredit: 1.50, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'EEE-2105', courseTitle: 'Electronic Devices and Circuits', internalAssessment: 22.50, courseCredit: 3.00, gradePoint: 2.50, letterGrade: 'C+'),
          Course(courseCode: 'EEE-2106', courseTitle: 'Electronic Devices and Circuits Lab', internalAssessment: 28.00, courseCredit: 1.50, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-2107', courseTitle: 'Object Oriented Programming', internalAssessment: 33.50, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-2108', courseTitle: 'Object Oriented Programming Lab.', internalAssessment: 35.00, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'MATH-2109', courseTitle: 'Complex Variables and Matrices', internalAssessment: 28.00, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
        ],
      ),
      
      // 2nd Year 2nd Semester
      SemesterResult(
        semester: '2nd Year 2nd Semester',
        gpa: 3.07,
        grade: 'B',
        totalCredits: 21.00,
        courses: [
          Course(courseCode: 'CSE-2201', courseTitle: 'Design and Analysis of Algorithms', internalAssessment: 31.00, courseCredit: 3.00, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'CSE-2202', courseTitle: 'Design and Analysis of Algorithms Lab.', internalAssessment: 32.00, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-2203', courseTitle: 'Computer Architecture and Organization', internalAssessment: 24.00, courseCredit: 3.00, gradePoint: 2.50, letterGrade: 'C+'),
          Course(courseCode: 'CSE-2205', courseTitle: 'Data Communication', internalAssessment: 28.00, courseCredit: 3.00, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'CSE-2207', courseTitle: 'Operating System', internalAssessment: 27.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-2208', courseTitle: 'Operating System Lab.', internalAssessment: 29.50, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-2210', courseTitle: 'Web Engineering Lab.', internalAssessment: 38.00, courseCredit: 3.00, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'MATH-2211', courseTitle: 'Vectors, Fourier Analysis and Laplace Transforms', internalAssessment: 26.00, courseCredit: 3.00, gradePoint: 2.75, letterGrade: 'B-'),
        ],
      ),
      
      // 3rd Year 1st Semester
      SemesterResult(
        semester: '3rd Year 1st Semester',
        gpa: 3.15,
        grade: 'B',
        totalCredits: 21.50,
        courses: [
          Course(courseCode: 'CSE-3101', courseTitle: 'Microprocessors and Microcontrollers', internalAssessment: 28.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3102', courseTitle: 'Assembly Language, Microprocessors and Microcontrollers Lab.', internalAssessment: 28.00, courseCredit: 1.50, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'CSE-3103', courseTitle: 'Software Engineering and Information System Design', internalAssessment: 24.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3104', courseTitle: 'Software Engineering and Information System Design Lab.', internalAssessment: 32.00, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-3105', courseTitle: 'Computer Networks', internalAssessment: 29.50, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3106', courseTitle: 'Computer Networks Lab', internalAssessment: 26.00, courseCredit: 1.50, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3107', courseTitle: 'Numerical Methods', internalAssessment: 27.00, courseCredit: 3.00, gradePoint: 2.50, letterGrade: 'C+'),
          Course(courseCode: 'HUM-3109', courseTitle: 'Financial and Managerial Accounting', internalAssessment: 31.50, courseCredit: 2.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'HUM-3111', courseTitle: 'Economics', internalAssessment: 27.50, courseCredit: 2.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-3114', courseTitle: 'Technical Writing and Presentation', internalAssessment: 28.50, courseCredit: 1.00, gradePoint: 3.50, letterGrade: 'A-'),
        ],
      ),
      
      // 3rd Year 2nd Semester
      SemesterResult(
        semester: '3rd Year 2nd Semester',
        gpa: 3.35,
        grade: 'B+',
        totalCredits: 20.25,
        courses: [
          Course(courseCode: 'CSE-3210', courseTitle: 'Simulation and Modelling Lab', internalAssessment: 30.00, courseCredit: 0.75, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-3212', courseTitle: 'Mobile Application Development Lab', internalAssessment: 29.20, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-3201', courseTitle: 'Mathematical Analysis for Computer Science', internalAssessment: 24.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3203', courseTitle: 'Theory of Computation', internalAssessment: 24.00, courseCredit: 3.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-3205', courseTitle: 'Artificial Intelligence', internalAssessment: 23.50, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-3206', courseTitle: 'Artificial Intelligence Lab', internalAssessment: 32.00, courseCredit: 1.50, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'CSE-3207', courseTitle: 'Peripherals and Interfacing', internalAssessment: 29.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-3208', courseTitle: 'Peripherals and Interfacing Lab', internalAssessment: 30.00, courseCredit: 1.50, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'CSE-3209', courseTitle: 'Simulation and Modelling', internalAssessment: 31.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
        ],
      ),
      
      // 4th Year 1st Semester
      SemesterResult(
        semester: '4th Year 1st Semester',
        gpa: 3.14,
        grade: 'B',
        totalCredits: 19.50,
        courses: [
          Course(courseCode: 'CSE-4101', courseTitle: 'Robotics and Automation', internalAssessment: 32.00, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-4102', courseTitle: 'Robotics and Automation Lab', internalAssessment: 32.00, courseCredit: 1.50, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-4103', courseTitle: 'Compiler Design and Construction', internalAssessment: 22.00, courseCredit: 3.00, gradePoint: 2.25, letterGrade: 'C'),
          Course(courseCode: 'CSE-4104', courseTitle: 'Compiler Design and Construction Lab', internalAssessment: 30.00, courseCredit: 0.75, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-4105', courseTitle: 'System Programming', internalAssessment: 20.50, courseCredit: 2.00, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'CSE-4106', courseTitle: 'System Programming Lab', internalAssessment: 28.00, courseCredit: 0.75, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-4107', courseTitle: 'Information Retrieval and Search Engine Optimization', internalAssessment: 36.00, courseCredit: 2.00, gradePoint: 3.75, letterGrade: 'A'),
          Course(courseCode: 'CSE-4108', courseTitle: 'Information Retrieval and Search Engine Optimization Lab', internalAssessment: 26.50, courseCredit: 0.75, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'CSE-4109', courseTitle: 'Computer Graphics', internalAssessment: 28.00, courseCredit: 3.00, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'CSE-4110', courseTitle: 'Computer Graphics Lab', internalAssessment: 26.50, courseCredit: 0.75, gradePoint: 4.00, letterGrade: 'A+'),
          Course(courseCode: 'HUM-4111', courseTitle: 'Professional Ethics and Industrial Management', internalAssessment: 30.50, courseCredit: 2.00, gradePoint: 3.25, letterGrade: 'B+'),
        ],
      ),
      
      // 4th Year 2nd Semester
      SemesterResult(
        semester: '4th Year 2nd Semester',
        gpa: 3.17,
        grade: 'B',
        totalCredits: 18.00,
        courses: [
          Course(courseCode: 'CSE-4201', courseTitle: 'Digital Image Processing', internalAssessment: 32.00, courseCredit: 3.00, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-4202', courseTitle: 'Project and Thesis', internalAssessment: 27.00, courseCredit: 6.00, gradePoint: 3.00, letterGrade: 'B'),
          Course(courseCode: 'CSE-4213', courseTitle: 'Machine Learning and Data Mining', internalAssessment: 23.00, courseCredit: 3.00, gradePoint: 3.25, letterGrade: 'B+'),
          Course(courseCode: 'CSE-4214', courseTitle: 'Machine Learning and Data Mining Lab', internalAssessment: 30.00, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
          Course(courseCode: 'CSE-4225', courseTitle: 'Mobile Computing', internalAssessment: 25.50, courseCredit: 3.00, gradePoint: 2.75, letterGrade: 'B-'),
          Course(courseCode: 'CSE-4226', courseTitle: 'Mobile Computing Lab', internalAssessment: 29.50, courseCredit: 1.50, gradePoint: 3.50, letterGrade: 'A-'),
        ],
      ),
    ];

    return StudentResult(
      semesterResults: semesterResults,
      cgpa: 3.23,
    );
  }

  static List<Document> _getMockDocuments() {
    return [
      Document(
        serialNo: 1,
        type: DocumentType.certificate,
        requestDate: DateTime(2024, 1, 15),
        fee: 500.0,
        checkDate: DateTime(2024, 1, 20),
        finalDeliveryDate: null,
        comments: 'Pending review',
        status: DocumentStatus.pending,
      ),
      Document(
        serialNo: 2,
        type: DocumentType.gradesheet,
        requestDate: DateTime(2024, 2, 10),
        fee: 300.0,
        checkDate: DateTime(2024, 2, 12),
        finalDeliveryDate: DateTime(2024, 2, 25),
        comments: 'Approved and ready for collection',
        status: DocumentStatus.approved,
      ),
      Document(
        serialNo: 3,
        type: DocumentType.transcript,
        requestDate: DateTime(2024, 3, 5),
        fee: 800.0,
        checkDate: DateTime(2024, 3, 8),
        finalDeliveryDate: null,
        comments: 'Additional documentation required',
        status: DocumentStatus.hold,
      ),
    ];
  }
}
