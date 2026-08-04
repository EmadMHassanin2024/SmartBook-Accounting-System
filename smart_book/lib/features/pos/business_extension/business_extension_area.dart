import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/product_model.dart';
import '../logic/pos_cubit.dart';


class BusinessExtensionArea extends StatelessWidget {
  final ProductModel product;

  const BusinessExtensionArea({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final extension = context.read<PosCubit>().activeExtension;

    if (extension == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: extension.buildProductDetails(product),
    );
  }
}