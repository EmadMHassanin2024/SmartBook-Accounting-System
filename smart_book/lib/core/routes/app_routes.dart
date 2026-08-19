import 'package:flutter/material.dart';


import '../../features/inventory/screens/items_list_screen.dart';
import '../../features/invoices/screens/invoices_list_screen.dart';
import '../../features/invoices/screens/create_invoice_screen.dart';

class AppRoutes {

  static const String login = '/';
  static const String signup = '/signup';
  static const String main = '/main';
  // Routes Names
  static const String invoicesList = '/invoices';
  static const String createInvoice = '/create-invoice';
  static const String itemsList = '/items';

  // Routes Map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //invoicesList: (context) => const InvoiceListItem (),
      createInvoice: (context) => const CreateInvoiceScreen(),
      itemsList: (context) => const ItemsListScreen(),
    };
  }
}



