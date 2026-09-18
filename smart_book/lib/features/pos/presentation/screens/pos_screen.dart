import 'package:smart_book/features/pos/auth_exports.dart';

import '../../../../core/utils/extensions/localization_extension.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final settings =
          context.read<SystemConfigurationCubit>().state.settings;

      context.read<PosCubit>().initialize(settings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        final activeExtension = state is PosLoaded ? state.extension : null;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text(
              activeExtension != null
                  ? '${context.lang.activity}: '
                  '${activeExtension.extensionName}'
                  : context.lang.pointOfSaleGeneral,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: context.lang.systemSettings,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const SystemConfigurationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: POSProductGrid(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: const POSDesktopCartPanel(),
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
          ),
        );
      },
    );
  }
}