import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/localization/language_keys.dart';
import '../../../logic/pos_cubit.dart';

class POSSearchField extends StatefulWidget {
  const POSSearchField({super.key});

  @override
  State<POSSearchField> createState() => _POSSearchFieldState();
}

class _POSSearchFieldState extends State<POSSearchField> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<PosCubit>().searchProducts(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          hintText: LanguageKeys.searchProductHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
