// lib/features/finance/ledger/screens/ledger_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_book/features/finance/ledger/Screans/test_ledger_screen.dart';

import '../../../../l10n/app_localizations.dart';
import '../logic/LedgerState.dart';
import '../logic/ledger_cubit.dart';
import '../models/ledger_transaction_model.dart';
import '../widgets/LedgerAppBarActions.dart';
import '../widgets/LedgerItemCard.dart';
import '../widgets/LedgerSummaryHeader.dart';

class LedgerScreen extends StatefulWidget {
  final int accountId;

  const LedgerScreen({
    super.key,
    required this.accountId,
  });

  @override
  LedgerScreenState createState() => LedgerScreenState();
}

class LedgerScreenState extends State<LedgerScreen> {
  DateTimeRange? _dateRange;

  final DateFormat _dateFormat =
  DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) => _fetchData(),
    );
  }

  void _fetchData() {
    final start =
        _dateRange?.start ??
            DateTime.now().subtract(
              const Duration(days: 30),
            );

    final end =
        _dateRange?.end ??
            DateTime.now();

    context.read<LedgerCubit>().getLedger(
      widget.accountId,
      _dateFormat.format(start),
      _dateFormat.format(end),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang =
    AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.ledgerTitle,
        ),
        actions: [
          BlocBuilder<
              LedgerCubit,
              LedgerState>(
            builder: (context, state) {
              return LedgerAppBarActions(
                onDateRangeSelected:
                    (range) {
                  setState(
                        () =>
                    _dateRange =
                        range,
                  );

                  _fetchData();
                },
                onExportPdf: () =>
                    _exportToPdf(
                      state
                      is LedgerLoaded
                          ? state
                          .transactions
                          : [],
                    ),
                isExportEnabled:
                state
                is LedgerLoaded,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
        },
        child: BlocConsumer<
            LedgerCubit,
            LedgerState>(
          listener:
              (context, state) {
            if (state
            is LedgerError) {
              ScaffoldMessenger.of(
                  context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                  backgroundColor:
                  Colors.red,
                ),
              );
            }
          },
          builder:
              (context, state) {
            if (state
            is LedgerLoading) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            if (state
            is LedgerLoaded) {

              if (state.transactions.isEmpty) {
                return Center(
                  child: Text(
                    lang.noDataFound,
                  ),
                );
              }

              return Column(
                children: [
                  LedgerSummaryHeader(
                    state: state,
                  ),
                  Expanded(
                    child:
                        ListView.builder(
                      padding:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),
                      itemCount: state
                          .transactions
                          .length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) =>
                              LedgerItemCard(
                        transaction:
                            state.transactions[
                                index],
                      ),
                    ),
                  ),
                ],
              );



            }

            return const Center(
              child: Text(
                "يرجى اختيار تاريخ للبدء",
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _exportToPdf(
      List<LedgerTransaction>
      transactions,
      ) async {
    // منطق الـ PDF الخاص بك
  }
}