// lib/features/finance/income_statement/models/income_statement_model.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'income_statement_item.dart';

@immutable
class IncomeStatementModel extends Equatable {
  final List<IncomeStatementItem> revenues;
  final List<IncomeStatementItem> costOfSales;
  final List<IncomeStatementItem> expenses;
  final List<IncomeStatementItem> otherRevenues;
  final List<IncomeStatementItem> otherExpenses;
  final double totalRevenue;
  final double totalCostOfSales;
  final double grossProfit;
  final double operatingExpenses;
  final double operatingIncome;
  final double otherRevenueTotal;
  final double otherExpenseTotal;
  final double netProfit;

  const IncomeStatementModel({
    required this.revenues,
    required this.costOfSales,
    required this.expenses,
    required this.otherRevenues,
    required this.otherExpenses,
    required this.totalRevenue,
    required this.totalCostOfSales,
    required this.grossProfit,
    required this.operatingExpenses,
    required this.operatingIncome,
    required this.otherRevenueTotal,
    required this.otherExpenseTotal,
    required this.netProfit,
  });

  factory IncomeStatementModel.fromJson(Map<String, dynamic> json) {
    return IncomeStatementModel(
      revenues: (json['revenues'] as List).map((i) => IncomeStatementItem.fromJson(i)).toList(),
      costOfSales: (json['costOfSales'] as List).map((i) => IncomeStatementItem.fromJson(i)).toList(),
      expenses: (json['expenses'] as List).map((i) => IncomeStatementItem.fromJson(i)).toList(),
      otherRevenues: (json['otherRevenues'] as List).map((i) => IncomeStatementItem.fromJson(i)).toList(),
      otherExpenses: (json['otherExpenses'] as List).map((i) => IncomeStatementItem.fromJson(i)).toList(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalCostOfSales: (json['totalCostOfSales'] as num).toDouble(),
      grossProfit: (json['grossProfit'] as num).toDouble(),
      operatingExpenses: (json['operatingExpenses'] as num).toDouble(),
      operatingIncome: (json['operatingIncome'] as num).toDouble(),
      otherRevenueTotal: (json['otherRevenueTotal'] as num).toDouble(),
      otherExpenseTotal: (json['otherExpenseTotal'] as num).toDouble(),
      netProfit: (json['netProfit'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    revenues, costOfSales, expenses, otherRevenues, otherExpenses,
    totalRevenue, totalCostOfSales, grossProfit, operatingExpenses,
    operatingIncome, otherRevenueTotal, otherExpenseTotal, netProfit
  ];
}