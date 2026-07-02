

import '../../../../core/packages.dart';

class SummaryItem extends StatelessWidget {
  final String title, value;
  final Color color;
  const SummaryItem({super.key, required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Column(children: [Text(title), Text(value, style: TextStyle(color: color))]);
}