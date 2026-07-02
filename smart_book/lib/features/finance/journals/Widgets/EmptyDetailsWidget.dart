


import '../../../../core/packages.dart';

class EmptyDetailsWidget extends StatelessWidget {
  const EmptyDetailsWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 16),

          Text(
            "لا توجد تفاصيل لهذا القيد",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "لم يتم العثور على حركات محاسبية مرتبطة بهذا القيد",
          ),
        ],
      ),
    );
  }
}