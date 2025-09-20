import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/app_colors.dart';
import '../services/data_service.dart';
import '../models/student.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Student? _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final student = await DataService.getStudentData();
      setState(() {
        _student = student;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generatePDF() async {
    if (_student == null) return;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'University of Barishal - Student Profile',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                _student!.name,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              _buildPDFSection('Academic Information', [
                'Session: ${_student!.session}',
                'Program: ${_student!.program}',
                'Faculty: ${_student!.faculty}',
                'Department: ${_student!.department}',
                'Year/Semester: ${_student!.yearSemester}',
                'Reg No: ${_student!.regNo}',
                'Class Roll: ${_student!.classRoll}',
              ]),
              pw.SizedBox(height: 15),
              _buildPDFSection('Personal Information', [
                'Contact Number: ${_student!.contactNumber}',
                'Email: ${_student!.email}',
                'NID No: ${_student!.nidNo}',
                'Date of Birth: ${_student!.dateOfBirth}',
                'Nationality: ${_student!.nationality}',
                'Religion: ${_student!.religion}',
                'Gender: ${_student!.gender}',
                'Blood Group: ${_student!.bloodGroup}',
              ]),
              pw.SizedBox(height: 15),
              _buildPDFSection('Parent Information', [
                'Father Name: ${_student!.fatherName}',
                'Father Contact: ${_student!.fatherContact}',
                'Father Qualification: ${_student!.fatherQualification}',
                'Father Profession: ${_student!.fatherProfession}',
                'Mother Name: ${_student!.motherName}',
                'Mother Contact: ${_student!.motherContact}',
                'Mother Qualification: ${_student!.motherQualification}',
                'Mother Profession: ${_student!.motherProfession}',
              ]),
              pw.SizedBox(height: 15),
              _buildPDFSection('Address Information', [
                'Present Address: ${_student!.presentAddress}',
                'Permanent Address: ${_student!.permanentAddress}',
              ]),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPDFSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        ...items.map((item) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(item, style: const pw.TextStyle(fontSize: 12)),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          if (!_isLoading && _student != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _generatePDF,
              tooltip: 'Download PDF',
            ),
        ],
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : _student == null
              ? const Center(child: Text('No student data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 20),
                      _buildAcademicInfo(),
                      const SizedBox(height: 20),
                      _buildPersonalInfo(),
                      const SizedBox(height: 20),
                      _buildParentInfo(),
                      const SizedBox(height: 20),
                      _buildContactInfo(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile header shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),
            // Info sections shimmer
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              _student!.name.split(' ').map((e) => e[0]).take(2).join(),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _student!.name,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reg: ${_student!.regNo}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  _student!.department,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo() {
    return _buildInfoSection(
      'Academic Information',
      Icons.school,
      AppColors.primary,
      [
        _buildInfoRow('Session', _student!.session),
        _buildInfoRow('Program', _student!.program),
        _buildInfoRow('Faculty', _student!.faculty),
        _buildInfoRow('Department', _student!.department),
        _buildInfoRow('Year / Semester', _student!.yearSemester),
        _buildInfoRow('Reg No', _student!.regNo),
        _buildInfoRow('Class Roll', _student!.classRoll),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return _buildInfoSection(
      'Student Information',
      Icons.person,
      AppColors.secondary,
      [
        _buildInfoRow('Contact Number', _student!.contactNumber),
        _buildInfoRow('Email', _student!.email),
        _buildInfoRow('NID No.', _student!.nidNo),
        _buildInfoRow('Date of Birth', _student!.dateOfBirth),
        _buildInfoRow('Birth Certificate No', _student!.birthCertificateNo.isEmpty ? '-' : _student!.birthCertificateNo),
        _buildInfoRow('Nationality', _student!.nationality),
        _buildInfoRow('Religion', _student!.religion),
        _buildInfoRow('Gender', _student!.gender),
        _buildInfoRow('Blood Group', _student!.bloodGroup),
      ],
    );
  }

  Widget _buildParentInfo() {
    return _buildInfoSection(
      'Parents Information',
      Icons.family_restroom,
      AppColors.accent,
      [
        _buildInfoRow('Father Name', _student!.fatherName),
        _buildInfoRow('Father Contact', _student!.fatherContact),
        _buildInfoRow('Father Qualification', _student!.fatherQualification),
        _buildInfoRow('Father Profession', _student!.fatherProfession),
        _buildInfoRow('Mother Name', _student!.motherName),
        _buildInfoRow('Mother Contact', _student!.motherContact),
        _buildInfoRow('Mother Qualification', _student!.motherQualification),
        _buildInfoRow('Mother Profession', _student!.motherProfession),
      ],
    );
  }

  Widget _buildContactInfo() {
    return _buildInfoSection(
      'Contact Information',
      Icons.location_on,
      AppColors.warning,
      [
        _buildInfoRow('Present Address', _student!.presentAddress),
        _buildInfoRow('Permanent Address', _student!.permanentAddress),
      ],
    );
  }

  Widget _buildInfoSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
