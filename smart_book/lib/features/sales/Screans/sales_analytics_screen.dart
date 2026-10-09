import 'package:http/http.dart' as http;
import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../core/localization/language_keys.dart';
import '../data/repository/SalesRepository.dart';
import '../logic/sales_analytics_state.dart';
import '../logic/sales_analytics_cubit.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/top_customers_scroll.dart';
import '../widgets/top_products_list.dart';

class SalesAnalyticsScreen extends StatelessWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesAnalyticsCubit(
        SalesRepository(http.Client()),
        context.read<SystemConfigurationCubit>(),
      )..initialize(),
      child: const _SalesAnalyticsView(),
    );
  }
}

class _SalesAnalyticsView extends StatefulWidget {
  const _SalesAnalyticsView();

  @override
  State<_SalesAnalyticsView> createState() => _SalesAnalyticsViewState();
}

class _SalesAnalyticsViewState extends State<_SalesAnalyticsView> {
  late final SalesAnalyticsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SalesAnalyticsCubit>();
  }

  void _handlePrintOrExport() {
    final canExport = cubit.prepareReportForExport();

    if (canExport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(LanguageKeys.reportPreparingKey),
          backgroundColor: Colors.blueGrey,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(LanguageKeys.noDataToExportKey),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          LanguageKeys.salesAnalyticsKey,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined, color: AppColors.primaryBlue),
            tooltip: LanguageKeys.printOrExportReportKey,
            onPressed: _handlePrintOrExport,
          ),
        ],
      ),
      body: BlocConsumer<SalesAnalyticsCubit, SalesAnalyticsState>(
        listenWhen: (previous, current) => current is SalesAnalyticsError,
        listener: (context, state) {
          if (state is SalesAnalyticsError) {
            SnackbarHelper.showError(state.message);
          }
        },
        builder: (context, state) {
          if (state is SalesAnalyticsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          } else if (state is SalesAnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => cubit.initialize(),
                    child: const Text(LanguageKeys.retryKey),
                  ),
                ],
              ),
            );
          } else if (state is SalesAnalyticsSuccess) {
            final activeType = cubit.currentActivityType;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. شريط مؤشر النشاط النشط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront, size: 18, color: AppColors.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              "${LanguageKeys.activeModuleKey}: $activeType",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20, color: AppColors.primaryBlue),
                        onPressed: () => cubit.initialize(),
                        tooltip: LanguageKeys.refreshDataKey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. بطاقات المؤشرات المالية الإجمالية المتجاوبة
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 3;
                      }

                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: [
                          _buildKpiCard(LanguageKeys.totalSalesKey, '${state.totalSales.toStringAsFixed(2)} ر.س', Icons.trending_up, AppColors.primaryBlue),
                          _buildKpiCard(LanguageKeys.vat15Key, '${state.totalVat.toStringAsFixed(2)} ر.س', Icons.receipt_long, Colors.orange),
                          _buildKpiCard(LanguageKeys.netProfitKey, '${state.netProfit.toStringAsFixed(2)} ر.س', Icons.account_balance_wallet, Colors.green),
                          _buildKpiCard(LanguageKeys.totalInvoicesKey, '${state.totalInvoices}', Icons.format_list_numbered, Colors.purple),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 3. الرسم البياني لنمو المبيعات
                  const Text(
                    LanguageKeys.monthlySalesGrowthKey,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  SalesLineChart(chartData: state.chartData),

                  const SizedBox(height: 24),

                  // 4. الأصناف الأكثر طلباً
                  const Text(
                    LanguageKeys.topProductsKey,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  TopProductsList(products: state.topProducts),

                  const SizedBox(height: 24),

                  // 5. أفضل العملاء
                  const Text(
                    LanguageKeys.topCustomersKey,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  TopCustomersScroll(customers: state.topCustomers),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}