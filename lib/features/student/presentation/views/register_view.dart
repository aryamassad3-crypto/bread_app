
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../view_models/student_vm.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final _nameController = TextEditingController();
  final _uniIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _uniIdFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _selectedUnit;
  String? _selectedFloor;
  String? _selectedRoom;

  bool _isPasswordVisible = false;
  bool _isSubmitting = false;

  final List<String> _units = [
    'الوحدة الأولى',
    'الوحدة الثانية',
    'الوحدة الثالثة',
  ];

  final List<String> _floors = [
    'الطابق الأول',
    'الطابق الثاني',
    'الطابق الثالث',
    'الطابق الرابع',
  ];

  final List<String> _rooms = [
    '401',
    '402',
    '417',
    '418',
    '501',
    '502',
  ];

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() => _scrollToField(_nameFocus, 200));
    _uniIdFocus.addListener(() => _scrollToField(_uniIdFocus, 280));
    _phoneFocus.addListener(() => _scrollToField(_phoneFocus, 360));
    _passwordFocus.addListener(() => _scrollToField(_passwordFocus, 650));
  }

  void _scrollToField(FocusNode focusNode, double position) {
    if (!focusNode.hasFocus) return;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _uniIdController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _uniIdFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }

    if (name.length < 3) {
      return 'يجب أن يتكون الاسم من 3 أحرف على الأقل';
    }

    if (RegExp(r'\d').hasMatch(name)) {
      return 'يجب ألا يحتوي الاسم على أرقام';
    }

    return null;
  }

  String? _validateUniversityId(String? value) {
    final id = value?.trim() ?? '';

    if (id.isEmpty) {
      return 'يرجى إدخال الرقم الجامعي';
    }

    if (!RegExp(r'^\d+$').hasMatch(id)) {
      return 'الرقم الجامعي يجب أن يحتوي على أرقام فقط';
    }

    if (id.length < 4) {
      return 'الرقم الجامعي قصير جدًا';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'يرجى إدخال رقم الموبايل';
    }

    if (!RegExp(r'^09\d{8}$').hasMatch(phone)) {
      return 'أدخلي رقمًا صحيحًا مثل 09XXXXXXXX';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }

    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف إنجليزي ورقم على الأقل';
    }

    return null;
  }

  Future<void> _pickImageFromCamera(
    StudentViewModel viewModel,
  ) async {
    final picker = ImagePicker();

    try {
      final image = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (!mounted) return;

      if (image != null) {
        viewModel.updateFaceImage(image.path);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم التقاط الصورة الشخصية بنجاح',
              textAlign: TextAlign.right,
            ),
            backgroundColor: Color(0xFFBC6C25),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'عذرًا، تعذر فتح الكاميرا. يرجى المحاولة مرة أخرى.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showActivationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'يرجى مراجعة معتمد وحدتك السكنية لتفعيل الحساب '
                  'لتتمكن من البدء بحجز حصتك من الخبز.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      if (!mounted) return;
                      context.go('/waiting');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBC6C25),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'موافق',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitForm(StudentViewModel studentVM) async {
    if (_isSubmitting) return;

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) return;

    if (_selectedUnit == null ||
        _selectedFloor == null ||
        _selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار الوحدة والطابق والغرفة',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (studentVM.pickedFaceImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى التقاط صورة شخصية أولًا',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await studentVM.registerStudent(
        name: _nameController.text.trim(),
        password: _passwordController.text,
        uniId: _uniIdController.text.trim(),
        phone: _phoneController.text.trim(),
        unit: _selectedUnit!,
        floor: _selectedFloor!,
        room: _selectedRoom!,
      );

      if (!mounted) return;

      _showActivationDialog();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر إنشاء الحساب. يرجى المحاولة مرة أخرى.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentVM = Provider.of<StudentViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'إنشاء حساب',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'lib/assets/images/cookies.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'أنشئ حسابك الآن:',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                _buildFieldTitle('الاسم الكامل'),
                _buildTextField(
                  controller: _nameController,
                  hint: 'الاسم الكامل',
                  focusNode: _nameFocus,
                  validator: _validateName,
                  keyboardType: TextInputType.name,
                ),

                _buildFieldTitle('الرقم الجامعي'),
                _buildTextField(
                  controller: _uniIdController,
                  hint: 'الرقم الجامعي',
                  focusNode: _uniIdFocus,
                  validator: _validateUniversityId,
                  keyboardType: TextInputType.number,
                ),

                _buildFieldTitle('رقم الموبايل'),
                _buildTextField(
                  controller: _phoneController,
                  hint: '09XXXXXXXX',
                  focusNode: _phoneFocus,
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                ),

                _buildFieldTitle('رقم الوحدة'),
                _buildDropdownField(
                  hint: 'اختر الوحدة',
                  value: _selectedUnit,
                  items: _units,
                  onChanged: (value) {
                    setState(() => _selectedUnit = value);
                  },
                ),

                _buildFieldTitle('رقم الطابق'),
                _buildDropdownField(
                  hint: 'اختر الطابق',
                  value: _selectedFloor,
                  items: _floors,
                  onChanged: (value) {
                    setState(() => _selectedFloor = value);
                  },
                ),

                _buildFieldTitle('رقم الغرفة'),
                _buildDropdownField(
                  hint: 'اختر الغرفة',
                  value: _selectedRoom,
                  items: _rooms,
                  onChanged: (value) {
                    setState(() => _selectedRoom = value);
                  },
                ),

                _buildFieldTitle('كلمة المرور'),
                _buildPasswordField(),

                const SizedBox(height: 15),
                _buildFieldTitle('إرفاق صورة شخصية للوجه'),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _isSubmitting
                        ? null
                        : () => _pickImageFromCamera(studentVM),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: studentVM.pickedFaceImagePath == null
                          ? const Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.check_circle,
                              size: 35,
                              color: Color(0xFFBC6C25),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _submitForm(studentVM),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC6C25),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text(
                        'سجل دخولك الآن',
                        style: TextStyle(
                          color: Color(0xFFBC6C25),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      validator: validator,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFBC6C25),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      validator: (selectedValue) {
        if (selectedValue == null) {
          return 'يرجى اختيار $hint';
        }
        return null;
      },
      hint: Align(
        alignment: Alignment.centerRight,
        child: Text(
          hint,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
      isExpanded: true,
      alignment: Alignment.centerRight,
      icon: const Icon(
        Icons.unfold_more,
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFBC6C25),
            width: 1,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              item,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: !_isPasswordVisible,
      textAlign: TextAlign.right,
      validator: _validatePassword,
      decoration: InputDecoration(
        hintText: '********',
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        prefixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFBC6C25),
            width: 1,
          ),
        ),
      ),
    );
  }
}
