import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SalesLineChart extends StatelessWidget {
  final Map<String, dynamic> chartData; // استقبال بيانات الرسم البياني ديناميكياً

  const SalesLineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات من الـ Map، مع توفير قيم افتراضية فارغة
    final months = chartData['months'] as List<dynamic>? ?? [];
    final values = chartData['values'] as List<dynamic>? ?? [];

    // تحديد أقصى ارتفاع متاح للعمود الواحد داخل الـ UI (مثلاً 120px)
    const double maxIndicatorHeight = 120.0;

    // 1. حساب أعلى قيمة (السقف) في البيانات لتحجيم الأعمدة بناءً عليها
    double maxDataValue = 0.0;
    if (values.isNotEmpty) {
      // تحويل القيم لنصوص ثم لأرقام عشرية، وإيجاد القيمة الأكبر
      maxDataValue = values
          .map((e) => double.tryParse(e.toString()) ?? 0.0)
          .reduce((a, b) => a > b ? a : b);
    }

    return Container(
      height: 220, // زيادة طفيفة في الارتفاع الكلي لاستيعاب التحجيم
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. ترويسة الرسم البياني
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "أداء المبيعات الشهرية",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Icon(Icons.stacked_line_chart, size: 20, color: AppColors.primaryBlue),
            ],
          ),
          const Spacer(),

          // 3. جسم الرسم البياني (الأعمدة الديناميكية)
          if (values.isNotEmpty && values.length == months.length)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                months.length,
                    (index) {
                  // جلب القيمة الحالية وتحويلها لرقم
                  final currentVal = double.tryParse(values[index].toString()) ?? 0.0;

                  // 4. حساب النسبة المئوية للقيمة الحالية من القيمة العظمى
                  double percentage = 0.0;
                  if (maxDataValue > 0) {
                    percentage = currentVal / maxDataValue;
                  }

                  // 5. حساب الارتفاع الفعلي للعمود بناءً على النسبة المئوية وأقصى ارتفاع متاح
                  double calculatedHeight = percentage * maxIndicatorHeight;

                  // التأكد من أن الارتفاع لا يقل عن قيمة دنيا (مثال 5px) لظهور العمود بوضوح لو كانت القيمة موجودة
                  if (calculatedHeight < 5.0 && currentVal > 0) calculatedHeight = 5.0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر للأسفل
                    children: [
                      // القيمة الرقمية فوق العمود (تظهر دائماً)
                      Text(
                        "${values[index]}",
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 4),

                      // العمود البياني (ارتفاعه ديناميكي الآن)
                      Container(
                        height: calculatedHeight, // الارتفاع المحسوب ديناميكياً
                        width: 14, // عرض ثابت للعمود
                        decoration: BoxDecoration(
                          // تدرج لوني بسيط يعطي جمالية
                          color: AppColors.primaryBlue.withOpacity(0.2 + (index * 0.1)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // اسم الشهر أسفل العمود
                      Text(
                        "${months[index]}",
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  );
                },
              ),
            )
          else
          // رسالة في حال عدم توفر البيانات أو عدم تطابق المصفوفات
            const Center(
              child: Text(
                "لا توجد بيانات متاحة للرسم البياني",
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}