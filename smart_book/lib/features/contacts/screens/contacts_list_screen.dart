import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../Repository/contact_repository.dart';
import '../logic/ContactCubit.dart';
import '../logic/contact_list_cubit.dart';
import '../widgets/contact_list_view.dart';
import 'add_contact_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListCubit(ContactRepository()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          elevation: 0.5,
          title: const Text(
            "دليل العملاء والموردين",
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryBlue,
            tabs: const [
              Tab(text: "العملاء"),
              Tab(text: "الموردين"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ContactsListView(type: 'customer'),
            ContactsListView(type: 'supplier'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            String currentType = _tabController.index == 0 ? 'customer' : 'supplier';

            // انتظار العودة من صفحة الإضافة
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ContactCubit(ContactRepository()),
                  child: AddContactScreen(initialType: currentType),
                ),
              ),
            );

            // إذا تم الإرجاع بـ true، قم بتحديث القائمة
            if (result == true) {
              if (mounted) {
                // استخدام context الخاص بالـ BlocProvider الموجود في هذا الملف
                context.read<ContactListCubit>().fetchContacts(currentType);
              }
            }
          },
          backgroundColor: AppColors.primaryBlue,
          icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
          label: const Text("إضافة جديد", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}