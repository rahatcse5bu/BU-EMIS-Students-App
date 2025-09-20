import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../services/data_service.dart';
import '../models/student.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Student? _originalStudent;
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers for editable fields
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _nidController;
  late TextEditingController _birthCertController;
  late TextEditingController _fatherNameController;
  late TextEditingController _fatherContactController;
  late TextEditingController _fatherQualificationController;
  late TextEditingController _fatherProfessionController;
  late TextEditingController _motherNameController;
  late TextEditingController _motherContactController;
  late TextEditingController _motherQualificationController;
  late TextEditingController _motherProfessionController;
  late TextEditingController _presentAddressController;
  late TextEditingController _permanentAddressController;

  String _selectedGender = 'Male';
  String _selectedNationality = 'Bangladeshi';
  String _selectedReligion = 'Islam';
  String _selectedBloodGroup = 'A+';
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadStudentData();
  }
  void _initializeControllers() {
    _contactController = TextEditingController();
    _emailController = TextEditingController();
    _nidController = TextEditingController();
    _birthCertController = TextEditingController();
    _fatherNameController = TextEditingController();
    _fatherContactController = TextEditingController();
    _fatherQualificationController = TextEditingController();
    _fatherProfessionController = TextEditingController();
    _motherNameController = TextEditingController();
    _motherContactController = TextEditingController();
    _motherQualificationController = TextEditingController();
    _motherProfessionController = TextEditingController();
    _presentAddressController = TextEditingController();
    _permanentAddressController = TextEditingController();
    
    // Add listeners for address fields to update character count
    _presentAddressController.addListener(() {
      setState(() {});
    });
    _permanentAddressController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadStudentData() async {
    try {
      final student = await DataService.getStudentData();
      if (student != null) {
        setState(() {
          _originalStudent = student;
          _populateFields(student);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFields(Student student) {
    _contactController.text = student.contactNumber;
    _emailController.text = student.email;
    _nidController.text = student.nidNo;
    _birthCertController.text = student.birthCertificateNo;
    _fatherNameController.text = student.fatherName;
    _fatherContactController.text = student.fatherContact;
    _fatherQualificationController.text = student.fatherQualification;
    _fatherProfessionController.text = student.fatherProfession;
    _motherNameController.text = student.motherName;
    _motherContactController.text = student.motherContact;
    _motherQualificationController.text = student.motherQualification;
    _motherProfessionController.text = student.motherProfession;
    _presentAddressController.text = student.presentAddress;
    _permanentAddressController.text = student.permanentAddress;
    
    _selectedGender = student.gender;
    _selectedNationality = student.nationality;
    _selectedReligion = student.religion;
    _selectedBloodGroup = student.bloodGroup;
    
    // Parse date of birth
    try {
      _selectedDateOfBirth = DateTime.parse(student.dateOfBirth.replaceAll('Jan', '01').replaceAll('04', '04').replaceAll('1999', '1999'));
    } catch (e) {
      _selectedDateOfBirth = DateTime(1999, 1, 4);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_originalStudent != null) {
        final updatedStudent = Student(
          regNo: _originalStudent!.regNo,
          name: _originalStudent!.name,
          session: _originalStudent!.session,
          program: _originalStudent!.program,
          faculty: _originalStudent!.faculty,
          department: _originalStudent!.department,
          yearSemester: _originalStudent!.yearSemester,
          classRoll: _originalStudent!.classRoll,
          contactNumber: _contactController.text.trim(),
          email: _emailController.text.trim(),
          nidNo: _nidController.text.trim(),
          dateOfBirth: _selectedDateOfBirth != null 
              ? '${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.year}'
              : _originalStudent!.dateOfBirth,
          birthCertificateNo: _birthCertController.text.trim(),
          nationality: _selectedNationality,
          religion: _selectedReligion,
          gender: _selectedGender,
          bloodGroup: _selectedBloodGroup,
          fatherName: _fatherNameController.text.trim(),
          fatherContact: _fatherContactController.text.trim(),
          fatherQualification: _fatherQualificationController.text.trim(),
          fatherProfession: _fatherProfessionController.text.trim(),
          motherName: _motherNameController.text.trim(),
          motherContact: _motherContactController.text.trim(),
          motherQualification: _motherQualificationController.text.trim(),
          motherProfession: _motherProfessionController.text.trim(),
          presentAddress: _presentAddressController.text.trim(),
          permanentAddress: _permanentAddressController.text.trim(),
        );

        await DataService.updateStudentData(updatedStudent);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (!_isLoading)
            TextButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, color: Colors.white),
              label: Text(
                'Save',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _originalStudent == null
              ? const Center(child: Text('No student data available'))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileHeader(),
                        const SizedBox(height: 20),
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 20),
                        _buildParentInfoSection(),
                        const SizedBox(height: 20),
                        _buildContactInfoSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
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
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              _originalStudent!.name.split(' ').map((e) => e[0]).take(2).join(),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _originalStudent!.name,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Reg: ${_originalStudent!.regNo}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      'Student Information',
      Icons.person,
      AppColors.primary,
      [
        _buildTextField(
          controller: _contactController,
          label: 'Contact Number',
          icon: Icons.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter contact number';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _nidController,
          label: 'NID No.',
          icon: Icons.credit_card,
        ),
        _buildDateField(),
        _buildTextField(
          controller: _birthCertController,
          label: 'Birth Certificate No',
          icon: Icons.article,
        ),
        _buildDropdownField(
          label: 'Nationality',
          value: _selectedNationality,
          items: ['Bangladeshi', 'Other'],
          onChanged: (value) => setState(() => _selectedNationality = value!),
        ),
        _buildDropdownField(
          label: 'Religion',
          value: _selectedReligion,
          items: ['Islam', 'Hinduism', 'Christianity', 'Buddhism', 'Other'],
          onChanged: (value) => setState(() => _selectedReligion = value!),
        ),
        _buildGenderField(),
        _buildDropdownField(
          label: 'Blood Group',
          value: _selectedBloodGroup,
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
          onChanged: (value) => setState(() => _selectedBloodGroup = value!),
        ),
      ],
    );
  }

  Widget _buildParentInfoSection() {
    return _buildSection(
      'Parents Information',
      Icons.family_restroom,
      AppColors.accent,
      [
        _buildTextField(
          controller: _fatherNameController,
          label: 'Father Name',
          icon: Icons.person,
        ),
        _buildTextField(
          controller: _fatherContactController,
          label: 'Father Contact',
          icon: Icons.phone,
        ),
        _buildTextField(
          controller: _fatherQualificationController,
          label: 'Father Qualification',
          icon: Icons.school,
        ),
        _buildTextField(
          controller: _fatherProfessionController,
          label: 'Father Profession',
          icon: Icons.work,
        ),
        _buildTextField(
          controller: _motherNameController,
          label: 'Mother Name',
          icon: Icons.person,
        ),
        _buildTextField(
          controller: _motherContactController,
          label: 'Mother Contact',
          icon: Icons.phone,
        ),
        _buildTextField(
          controller: _motherQualificationController,
          label: 'Mother Qualification',
          icon: Icons.school,
        ),
        _buildTextField(
          controller: _motherProfessionController,
          label: 'Mother Profession',
          icon: Icons.work,
        ),
      ],
    );
  }
  Widget _buildContactInfoSection() {
    return _buildSection(
      'Contact Information',
      Icons.location_on,
      AppColors.warning,
      [
        _buildAddressField(
          controller: _presentAddressController,
          label: 'Present Address',
          icon: Icons.home,
        ),
        _buildAddressField(
          controller: _permanentAddressController,
          label: 'Permanent Address',
          icon: Icons.location_city,
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
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
              children: children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: child,
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDateOfBirth ?? DateTime(1999, 1, 4),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _selectedDateOfBirth = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        child: Text(
          _selectedDateOfBirth != null
              ? '${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.year}'
              : 'Select date',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: _selectedDateOfBirth != null ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),    );
  }

  Widget _buildAddressField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 3,
          maxLength: 100,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Enter your $label (max 100 characters)',
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            counterStyle: GoogleFonts.inter(
              fontSize: 12,
              color: controller.text.length > 100 
                ? AppColors.error 
                : AppColors.textSecondary,
            ),
          ),
          onChanged: (value) {
            setState(() {}); // Trigger rebuild to update counter color
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your $label';
            }
            if (value.length > 100) {
              return '$label must be 100 characters or less';
            }
            return null;
          },
        ),
        const SizedBox(height: 4),
        Text(
          '${controller.text.length}/100 characters',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: controller.text.length > 100 
              ? AppColors.error 
              : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _contactController.dispose();
    _emailController.dispose();
    _nidController.dispose();
    _birthCertController.dispose();
    _fatherNameController.dispose();
    _fatherContactController.dispose();
    _fatherQualificationController.dispose();
    _fatherProfessionController.dispose();
    _motherNameController.dispose();
    _motherContactController.dispose();
    _motherQualificationController.dispose();
    _motherProfessionController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }
}
