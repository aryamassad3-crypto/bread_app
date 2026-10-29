
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/student.dart';
import '../view_models/student_vm.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _uniIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _unitController;
  late final TextEditingController _floorController;
  late final TextEditingController _roomController;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final vm = context.read<StudentViewModel>();

    _nameController = TextEditingController(text: vm.studentName);
    _uniIdController = TextEditingController(text: vm.uniId);
    _phoneController = TextEditingController(text: vm.phone);
    _unitController = TextEditingController(text: vm.unit);
    _floorController = TextEditingController(text: vm.floor);
    _roomController = TextEditingController(text: vm.room);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _uniIdController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _floorController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _editProfileImage(StudentViewModel viewModel) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted || image == null) return;

      await viewModel.updateFaceImage(image.path);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الصورة الشخصية بنجاح!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('عذراً، فشل تحديث الصورة: $e')),
      );
    }
  }

  void _startEditing(StudentViewModel vm) {
    _nameController.text = vm.studentName;
    _uniIdController.text = vm.uniId;
    _phoneController.text = vm.phone;
    _unitController.text = vm.unit;
    _floorController.text = vm.floor;
    _roomController.text = vm.room;

    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _saveProfile(StudentViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final student = Student(
        name: _nameController.text.trim(),
        password: vm.studentPassword,
        universityId: _uniIdController.text.trim(),
        phone: _phoneController.text.trim(),
        unit: _unitController.text.trim(),
        floor: _floorController.text.trim(),
        room: _roomController.text.trim(),
        isReserved: vm.isReserved,
        faceImagePath: vm.pickedFaceImagePath,
      );

      await vm.updateProfile(student);

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ بياناتك بنجاح'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر حفظ البيانات: $e')),
      );
    }
  }

  void _cancelEditing(StudentViewModel vm) {
    _nameController.text = vm.studentName;
    _uniIdController.text = vm.uniId;
    _phoneController.text = vm.phone;
    _unitController.text = vm.unit;
    _floorController.text = vm.floor;
    _roomController.text = vm.room;

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentVM = context.watch<StudentViewModel>();

    final name = studentVM.studentName.isNotEmpty
        ? studentVM.studentName
        : 'أحمد أحمد';
    final uniId = studentVM.uniId.isNotEmpty
        ? studentVM.uniId
        : '4440';
    final phone = studentVM.phone.isNotEmpty
        ? studentVM.phone
        : '+963 999 999 999';
    final unit = studentVM.unit.isNotEmpty ? studentVM.unit : '11';
    final floor = studentVM.floor.isNotEmpty ? studentVM.floor : '5';
    final room = studentVM.room.isNotEmpty ? studentVM.room : '17';

    final imagePath = studentVM.pickedFaceImagePath;
    final hasImage = imagePath != null && File(imagePath).existsSync();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 30,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: const Color(0xFFBC6C25),
                          width: 1.5,
                        ),
                      ),
                      child: hasImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 65,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 65,
                              color: Colors.grey,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _isSaving
                            ? null
                            : () => _editProfileImage(studentVM),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDA15E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              if (_isEditing) ...[
                _buildEditableField('الاسم الكامل', _nameController),
                _buildEditableField('الرقم الجامعي', _uniIdController),
                _buildEditableField('رقم الموبايل', _phoneController),
                _buildEditableField('رقم الوحدة', _unitController),
                _buildEditableField('رقم الطابق', _floorController),
                _buildEditableField('رقم الغرفة', _roomController),
              ] else ...[
                _buildProfileDataField('الاسم الكامل', name),
                _buildProfileDataField('الرقم الجامعي', uniId),
                _buildProfileDataField('رقم الموبايل', phone),
                _buildProfileDataField('رقم الوحدة', unit),
                _buildProfileDataField('رقم الطابق', floor),
                _buildProfileDataField('رقم الغرفة', room),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          if (_isEditing) {
                            _saveProfile(studentVM);
                          } else {
                            _startEditing(studentVM);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC6C25),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isEditing ? 'حفظ التعديلات' : 'تعديل البيانات',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => _cancelEditing(studentVM),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBC6C25)),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال $title';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDataField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Divider(
            color: Colors.grey.shade200,
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
