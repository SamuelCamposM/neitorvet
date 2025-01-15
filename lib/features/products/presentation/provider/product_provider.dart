import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'package:neitorvet/features/products/presentation/provider/products_repository_provider.dart';

final productProvider = StateNotifierProvider.family
    .autoDispose<ProductNotifier, ProductState, String>(
  (ref, productId) {
    final productsRepository = ref.watch(productsRepositoryProvider);

    return ProductNotifier(
        productId: productId, productsRepository: productsRepository);
  },
);

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product newEmptyProduct() {
    return Product(
      id: 'new', // Asigna un valor adecuado para el id
      title: "",
      price: 0,
      description: "",
      slug: "",
      stock: 0,
      sizes: [],
      gender: "men",
      tags: [],
      images: [],
      // user: '', // Asigna un valor adecuado para el use
    );
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(isLoading: false, product: newEmptyProduct());
        return;
      }
      final product = await productsRepository.getProductsById(state.id);
      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Optionally, you can add error logging here
      // print('Error loading product: $e');
    }
  }

  @override
  void dispose() {
    // Log para verificar que se está destruyendo

    super.dispose();
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
      );
}
