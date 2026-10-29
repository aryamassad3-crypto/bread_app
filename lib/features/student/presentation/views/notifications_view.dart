import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<Map<String, String>> _notifications = [
    {"time": "07:00 م", "msg": "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلاف حصتك."},
    {"time": "07:00 م", "msg": "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلاف حصتك."},
    {"time": "07:00 م", "msg": "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلاف حصتك."},
    {"time": "07:00 م", "msg": "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلاف حصتك."},
  ];

  @override
  Widget build(BuildContext context) {
    // تم تحويلها لـ Container صافي لكي تندمج داخل المحرك الأساسي بنجاح
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("اليوم", "2/2/2026"),
            const SizedBox(height: 10),
            _buildNotificationCard("04:00 م", "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلام حصتك."),
            const SizedBox(height: 25),

            _buildSectionHeader("الأمس", "1/2/2026"),
            const SizedBox(height: 10),
            _buildNotificationCard("07:00 م", "بدأ الآن توزيع الخبز لطلاب الطابق 1. يرجى التوجه للمعتمد لاستلام حصتك."),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الشهر الماضي",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextButton(
                  onPressed: _notifications.isEmpty ? null : () {
                    setState(() {
                      _notifications.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("تم مسح سجل إشعارات الشهر الماضي بنجاح!"),
                        backgroundColor: Color(0xFFBC6C25),
                      ),
                    );
                  },
                  child: Text(
                    "مسح الكل",
                    style: TextStyle(
                      color: _notifications.isEmpty ? Colors.grey.shade300 : Colors.redAccent, 
                      fontSize: 13, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            
            if (_notifications.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    "لا توجد إشعارات للشهر الماضي",
                    style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildNotificationCard(
                      _notifications[index]["time"]!,
                      _notifications[index]["msg"]!,
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        Text(date, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildNotificationCard(String time, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
