import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../accounting/screens/journal_entry_screen.dart';
import 'JournalDetailScreen.dart';
import '../logic/JournalListCubit.dart';
import '../logic/JournalListState.dart';
import '../models/JournalModel.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalListCubit>().fetchJournals();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة انتقال موحدة لمنع التكرار
  void _navigateToDetails(JournalModel journal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JournalDetailScreen(journal: journal)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int entryId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا القيد؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      context.read<JournalListCubit>().deleteJournal(entryId);
    }
  }

  Color _cardColor(String description) => description.contains("مبيعات")
      ? Colors.blue.shade50
      : Colors.orange.shade50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("دفتر اليومية العام", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: BlocListener<JournalListCubit, JournalListState>(
        listener: (context, state) {
          if (state is JournalListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => context.read<JournalListCubit>().searchJournals(val),
                decoration: InputDecoration(
                  hintText: "ابحث عن قيد...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<JournalListCubit, JournalListState>(
                builder: (context, state) {
                  if (state is JournalListLoading) return const Center(child: CircularProgressIndicator());

                  if (state is JournalListLoaded) {
                    if (state.journals.isEmpty) {
                      return ListView(
                        children: const [
                          SizedBox(height: 120),
                          Icon(Icons.menu_book, size: 80, color: Colors.grey),
                          Center(child: Text("لا توجد قيود حالياً", style: TextStyle(fontSize: 18))),
                        ],
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => await context.read<JournalListCubit>().fetchJournals(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: state.journals.length,
                        itemBuilder: (context, index) {
                          final journal = state.journals[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: _cardColor(journal.description),
                            child: ListTile(
                              title: Text("قيد رقم: ${journal.entryId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(journal.description),
                              onTap: () => _navigateToDetails(journal), // استخدام الدالة الموحدة
                              trailing: PopupMenuButton<String>(
                                onSelected: (val) => val == 'view'
                                    ? _navigateToDetails(journal) // استخدام الدالة الموحدة
                                    : _confirmDelete(context, journal.entryId),
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                                  const PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1677FF),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalEntryScreen())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}