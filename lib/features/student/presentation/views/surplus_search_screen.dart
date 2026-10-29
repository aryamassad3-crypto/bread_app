import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class SurplusSearchScreen extends StatelessWidget {
  const SurplusSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final units = [
      {
        'name': 'الوحدة (1)',
        'status': 'لا يوجد فائض حالياً',
        'available': false,
      },
      {
        'name': 'الوحدة (2)',
        'status': 'يوجد فائض 15 ربطة',
        'available': true,
      },
      {
        'name': 'الوحدة (3)',
        'status': 'يوجد فائض 2 ربطة',
        'available': true,
      },
      {
        'name': 'الوحدة (5)',
        'status': 'لا يوجد فائض حالياً',
        'available': false,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text('البحث عن فائض'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وحدتك السكنية',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'لا يوجد فائض حالياً.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الوحدات الأخرى:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...units.map((unit) {
              final available = unit['available'] as bool;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        unit['status'] as String,
                        style: TextStyle(
                          color: available
                              ? AppColors.primary
                              : AppColors.textMuted,
                          fontWeight: available
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      unit['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}