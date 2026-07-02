import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../journals/logic/JournalListCubit.dart';
import '../../journals/logic/JournalListState.dart';
import '../../journals/repositories/JournalRepository.dart';
import '../logic/journal_entry_cubit.dart';
import '../logic/journal_entry_state.dart';
import '../widgets/JournalEntryFormBody.dart';

class JournalEntryScreen extends StatefulWidget {
  final Map<String, dynamic>? journalData;
  const JournalEntryScreen({super.key, this.journalData});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  // تعريف الـ Cubit هنا لضمان استمراريته
  late JournalListCubit _listCubit;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Cubit هنا
    _listCubit = JournalListCubit(JournalRepository());
    // 🚀 جلب البيانات تلقائياً بمجرد دخول الصفحة
    _listCubit.fetchJournals();
  }

  @override
  void dispose() {
    _listCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _listCubit),
        BlocProvider(create: (context) => JournalEntryCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text("دفتر اليومية العام", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: BlocListener<JournalEntryCubit, JournalEntryState>(
          listener: (context, state) {
            if (state is JournalEntrySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم الترحيل بنجاح"), backgroundColor: Colors.green));
              // تحديث القائمة بعد نجاح الترحيل
              context.read<JournalListCubit>().fetchJournals();
            }
          },
          child: BlocBuilder<JournalListCubit, JournalListState>(
            builder: (context, listState) {

              if (listState is JournalListLoading || listState is JournalListInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (listState is JournalListFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      Text(listState.error),
                      ElevatedButton.icon(
                        onPressed: () => _listCubit.fetchJournals(), // استخدام الـ Cubit المعرف محلياً
                        icon: const Icon(Icons.refresh),
                        label: const Text("إعادة المحاولة"),
                      )
                    ],
                  ),
                );
              }

              // الحالة الطبيعية
              return const JournalEntryFormBody();
            },
          ),
        ),
      ),
    );
  }
}