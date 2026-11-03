import 'package:smart_book/features/pos/auth_exports.dart';


class POSResponsiveLayout extends StatelessWidget {
  const POSResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final bool isWideScreen = constraints.maxWidth >= 700;

        if (isWideScreen) {
          return const Row(
            children: [

              Expanded(
                flex: 3,
                child: POSProductGrid(),
              ),

              Expanded(
                flex: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: POSDesktopCartPanel(),
                ),
              ),
            ],
          );
        }


        return const Stack(
          children: [
            POSProductGrid(),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
             child: POSFloatingCartBar(),
            ),
          ],
        );


      },
    );
  }
}