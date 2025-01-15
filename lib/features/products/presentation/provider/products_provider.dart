import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }









  Future<bool> createOrUpdateProduct(Map<String, dynamic> productMap) async {
    try {
      final product = await productsRepository.createUpdateProduct(productMap);

      final isProductInList =
          state.products.any((productA) => productA.id == product.id);

      if (!isProductInList) {
        state = state.copyWith(products: [...state.products, product]);
        return true;
      }
      state = state.copyWith(
          products: state.products
              .map((productM) => productM.id == product.id ? product : productM)
              .toList());

      return true;
    } catch (e) {
      return false;
    }
  }

















  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }
    state = state.copyWith(
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

// STATE
class ProductsState {
  final bool isLastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.isLoading = false,
      this.limit = 10,
      this.offset = 0,
      this.products = const []});

  ProductsState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        products: products ?? this.products,
      );
}
