//: لعزل منطق الـ AppBar (التاريخ والـ PDF).
import '../../../../core/packages.dart';

class LedgerAppBarActions extends StatelessWidget {
  final Function(DateTimeRange) onDateRangeSelected;
  final Function() onExportPdf;
  final bool isExportEnabled;

  const LedgerAppBarActions({
    super.key,
    required this.onDateRangeSelected,
    required this.onExportPdf,
    required this.isExportEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context, firstDate: DateTime(2020), lastDate: DateTime(2030),
            );
            if (range != null) onDateRangeSelected(range);
          },
        ),
        IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: isExportEnabled ? onExportPdf : null,
        ),
      ],
    );
  }
}