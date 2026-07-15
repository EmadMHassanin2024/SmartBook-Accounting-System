import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product_model.dart';

import '../repository/product_repo.dart';

import 'ProductState.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository)
      : super(const ProductInitial());

  Future<void> addProduct(ProductModel product) async {
    emit(const ProductLoading());

    try {
      await _repository.addProduct(product);

      emit(const ProductSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    emit(const ProductLoading());

    try {
      await _repository.updateProduct(product);

      emit(const ProductSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(int productId) async {
    emit(const ProductLoading());

    try {
      await _repository.deleteProduct(productId);

      emit(const ProductSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}