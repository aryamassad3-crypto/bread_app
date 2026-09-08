import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../view_models/student_vm.dart';
import 'waiting_view.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final ScrollController _scrollController = ScrollController();

  final _nameController = TextEditingController();
  final _uniIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedUnit;
  String? _selectedFloor;
  String? _selectedRoom;
  bool _isPasswordVisible = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _uniIdFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final List<String> _units = ["الوحدة الأولى", "الوحدة الثانية", "الوحدة الثالثة"];
  final List<String> _floors = ["الطابق الأول", "الطابق الثاني", "الطابق الثالث", "الطابق الرابع"];
  final List<String> _rooms = ["401", "402", "417", "418", "501", "502"];

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() => _scrollToField(_nameFocus, 200));
    _uniIdFocus.addListener(() => _scrollToField(_uniIdFocus, 280));
    _phoneFocus.addListener(() => _scrollToField(_phoneFocus, 360));
    _passwordFocus.addListener(() => _scrollToField(_passwordFocus, 650));
  }

  void _scrollToField(FocusNode focusNode, double position) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            position,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
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

  Future<void> _pickImageFromCamera(StudentViewModel viewModel) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (!mounted) return;

      if (image != null) {
        viewModel.updateFaceImage(image.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("تم التقاط صورة الوجه وحفظها في الخلفية بنجاح!", textAlign: TextAlign.right),
            backgroundColor: const Color(0xFFBC6C25),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("عذراً، فشل فتح الكاميرا: $e", textAlign: TextAlign.right)),
      );
    }
  }

  void _showActivationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                const Text(
                  "يرجى مراجعة معتمد وحدتك السكنية لتفعيل الحساب لتتمكن من البدء بحجز حصتك من الخبز.",
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
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WaitingView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBC6C25),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "موافق",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
  @override
  Widget build(BuildContext context) {
    final studentVM = Provider.of<StudentViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "إنشاء حساب",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                "أنشئ حسابك الآن:",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 15),

              _buildFieldTitle("الاسم الكامل"),
              _buildTextField(_nameController, "الاسم الكامل", _nameFocus),

              _buildFieldTitle("الرقم الجامعي"),
              _buildTextField(_uniIdController, "مرحباً", _uniIdFocus),

              _buildFieldTitle("رقم الموبايل"),
              _buildTextField(_phoneController, "09XXXXXXXX", _phoneFocus),

              _buildFieldTitle("رقم الوحدة"),
              _buildDropdownField(
                hint: "اختر الوحدة",
                value: _selectedUnit,
                items: _units,
                onChanged: (val) {
                  setState(() => _selectedUnit = val);
                  _scrollController.animateTo(450, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),

              _buildFieldTitle("رقم الطابق"),
              _buildDropdownField(
                hint: "اختر الطابق",
                value: _selectedFloor,
                items: _floors,
                onChanged: (val) {
                  setState(() => _selectedFloor = val);
                  _scrollController.animateTo(520, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),

              _buildFieldTitle("رقم الغرفة"),
              _buildDropdownField(
                hint: "اختر الغرفة",
                value: _selectedRoom,
                items: _rooms,
                onChanged: (val) {
                  setState(() => _selectedRoom = val);
                  _scrollController.animateTo(590, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),
              _buildFieldTitle("كلمة المرور"),
              _buildPasswordField(),
              
              const SizedBox(height: 15),

              _buildFieldTitle("إرفاق صورة شخصية للوجه"),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _pickImageFromCamera(studentVM),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: const Icon(Icons.add, size: 30, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty ||
                      _uniIdController.text.trim().isEmpty ||
                      _phoneController.text.trim().isEmpty ||
                      _passwordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يرجى ملء جميع الحقول النصية أولاً!", textAlign: TextAlign.right),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (_selectedUnit == null || _selectedFloor == null || _selectedRoom == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يرجى اختيار رقم الوحدة والطابق والغرفة!", textAlign: TextAlign.right),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final currentVM = Provider.of<StudentViewModel>(context, listen: false);
                  if (currentVM.pickedFaceImagePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يرجى التقاط وإرفاق صورة شخصية للوجه أولاً!", textAlign: TextAlign.right),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  currentVM.registerStudent(
                    _nameController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  _showActivationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBC6C25),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "إنشاء حساب",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      );
                    },
                    child: const Text(
                      "سجل دخولك الآن",
                      style: TextStyle(color: Color(0xFFBC6C25), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const Text("لديك حساب بالفعل؟", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, FocusNode focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
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
      value: value,
      hint: Align(
        alignment: Alignment.centerRight,
        child: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ),
      isExpanded: true,
      alignment: Alignment.centerRight,
      icon: const Icon(Icons.unfold_more, color: Colors.grey),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: !_isPasswordVisible,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: "********",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        prefixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
        ),
      ),
    );
  }
}
