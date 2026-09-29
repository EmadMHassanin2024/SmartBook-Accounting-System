import 'package:flutter/material.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

import '../cart/pos_cart_panel.dart';

class POSResponsiveLayout extends StatelessWidget {
  const POSResponsiveLayout({super.key});

  // Breakpoints احترافية
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= desktopBreakpoint) {
          return const POSLargeDesktopLayout();
        } else if (width >= tabletBreakpoint) {
          return const POSDesktopLayout();
        } else if (width >= mobileBreakpoint) {
          return const POSTabletLayout();
        } else {
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
