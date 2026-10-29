import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintView extends StatefulWidget {
  const ComplaintView({Key? key}) : super(key: key);

  @override
  State<ComplaintView> createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
  final _descriptionController = TextEditingController();
  String? _selectedIssueType;
  String? _attachedMediaPath;

  final List<String> _issueTypes = [
    "تأخر المعتمد في التوزيع",
    "جودة الخبز غير جيدة",
    "مشكلة في مسح كود الاستلام",
    "نقص في عدد الأرغفة",
    "أخرى"
  ];

  Future<void> _pickComplaintMedia() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? media = await picker.pickImage(source: ImageSource.gallery);
      if (media != null) {
        setState(() {
          _attachedMediaPath = media.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم إرفاق صورة الدليل بنجاح!"),
            backgroundColor: Color(0xFFBC6C25),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("عذراً، فشل فتح معرض الصور: $e")),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🟫 تم تحويل الشاشة إلى Container صافي ومستدير ليدخل مباشرة وبنعومة داخل هيكل الـ Home الموحد دون تكرار الأشرطة!
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "تقديم شكوى",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 25),

            _buildFieldTitle("نوع المشكلة"),
            DropdownButtonFormField<String>(
              value: _selectedIssueType,
              hint: const Text("نوع المشكلة", style: TextStyle(color: Colors.grey, fontSize: 14)),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
                ),
              ),
              items: _issueTypes.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedIssueType = val);
              },
            ),
            const SizedBox(height: 20),

            _buildFieldTitle("وصف المشكلة"),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "اكتب هنا بالتفصيل",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildFieldTitle("إرفاق فيديو أو صورة"),
            GestureDetector(
              onTap: _pickComplaintMedia,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: _attachedMediaPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_attachedMediaPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.add_rounded, size: 36, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 45),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedIssueType == null || _descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يرجى اختيار نوع المشكلة وكتابة الوصف أولاً!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم إرسال شكواك بنجاح وجاري مراجعتها من قِبل الإدارة."),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _descriptionController.clear();
                  setState(() {
                    _selectedIssueType = null;
                    _attachedMediaPath = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBC6C25),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text(
                  "إرسال",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    );
  }
}
