abstract class SalesAnalyticsState {}

class SalesAnalyticsInitial extends SalesAnalyticsState {}

class SalesAnalyticsLoading extends SalesAnalyticsState {}

class SalesAnalyticsSuccess extends SalesAnalyticsState {
  final List<dynamic> topProducts;
  final List<dynamic> topCustomers;
  final Map<String, dynamic> chartData;
  final double totalSales;
  final double totalVat;
  final double netProfit;
  final int totalInvoices;

  SalesAnalyticsSuccess({
    required this.topProducts,
    required this.topCustomers,
    required this.chartData,
    required this.totalSales,
    required this.totalVat,
    required this.netProfit,
    required this.totalInvoices,
  });
}

class SalesAnalyticsError extends SalesAnalyticsState {
  final String message;
  SalesAnalyticsError(this.message);
}