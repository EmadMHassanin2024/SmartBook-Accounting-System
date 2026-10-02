
import 'package:smart_book/features/pos/auth_exports.dart';

import '../cart/pos_cart_panel.dart';

/// أنواع الأجهزة حسب العرض
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// دالة تحدد نوع الجهاز بناءً على العرض
DeviceType getDeviceType(double width) {
  if (width >= 1200) return DeviceType.largeDesktop;
  if (width >= 900) return DeviceType.desktop;
  if (width >= 600) return DeviceType.tablet;
  return DeviceType.mobile;
}

class POSResponsiveLayout extends StatelessWidget {
  const POSResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = getDeviceType(constraints.maxWidth);

        switch (deviceType) {
          case DeviceType.largeDesktop:
            return const POSLargeDesktopLayout();

          case DeviceType.desktop:
            return const POSDesktopLayout();

          case DeviceType.tablet:
            return const POSTabletLayout();

          case DeviceType.mobile:
            return const POSMobileLayout();
        }
      },
    );
  }
}

/// ----------------------------
///        LARGE DESKTOP
/// ----------------------------

class POSLargeDesktopLayout extends StatelessWidget {
  const POSLargeDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 4,
          child: POSProductGrid(),
        ),
        Expanded(
          flex: 3,
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
}

/// ----------------------------
///        DESKTOP
/// ----------------------------

class POSDesktopLayout extends StatelessWidget {
  const POSDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// ----------------------------
///        TABLET
/// ----------------------------

class POSTabletLayout extends StatelessWidget {
  const POSTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: POSProductGrid()),
        SizedBox(height: 10),
        POSFloatingCartBar(),
      ],
    );
  }
}

/// ----------------------------
///        MOBILE
/// ----------------------------

class POSMobileLayout extends StatelessWidget {
  const POSMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
