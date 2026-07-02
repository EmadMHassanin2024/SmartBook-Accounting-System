import '../../../../core/di/service_locator.dart';
import '../../../../core/packages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/widgets/auth_app_bar.dart';
import '../../repositories/FinancialReportsRepository.dart';
import '../../widgets/CommonReportFooter.dart';
import '../logic/TrialBalanceCubit.dart';
import '../logic/TrialBalanceState.dart';
import '../widgets/FilterBarWidget.dart';
import '../widgets/TrialBalanceTable.dart';

class TrialBalanceScreen extends StatelessWidget {
  const TrialBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
      TrialBalanceCubit(
        sl<FinancialReportsRepository>(),
      )..fetchTrialBalance(DateTime.now()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const AuthAppBar(
          primaryColor: AppColors.primaryBlue,
        ),
        body: Column(
          children: [
            const FilterBarWidget(),
            Expanded(
              child: BlocBuilder<
                  TrialBalanceCubit,
                  TrialBalanceState>(
                builder: (context, state) {
                  if (state is TrialBalanceLoading) {
                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (state is TrialBalanceError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  if (state is TrialBalanceLoaded) {
                    final totalDebit =
                    state.items.fold<double>(
                      0,
                          (sum, item) =>
                      sum + item.totalDebit,
                    );

                    final totalCredit =
                    state.items.fold<double>(
                      0,
                          (sum, item) =>
                      sum + item.totalCredit,
                    );

                    final difference =
                    (totalDebit - totalCredit)
                        .abs();

                    return Column(
                      children: [
                        Expanded(
                          child: TrialBalanceTable(
                            items: state.items,
                          ),
                        ),

                        CommonReportFooter(
                          totals: [
                            {
                              'title':
                              'إجمالي المدين',
                              'value': totalDebit
                                  .toStringAsFixed(
                                  2),
                              'color':
                              Colors.green,
                              'icon': Icons
                                  .arrow_downward,
                            },
                            {
                              'title':
                              'إجمالي الدائن',
                              'value': totalCredit
                                  .toStringAsFixed(
                                  2),
                              'color':
                              Colors.red,
                              'icon':
                              Icons.arrow_upward,
                            },

                          ],
                        ),
                      ],
                    );
                  }

                  return Center(
                    child: Text(lang.noData),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}