import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'package:neitorvet/features/products/presentation/provider/products_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';

final productFormProvider = StateNotifierProvider.family
    .autoDispose<ProductFormNotifier, ProductFormState, Product>(
        (ref, product) {
//* LLAMANDO EL PROVIDER DE LA LISTA DE PRODUCTO
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(
      product: product, onSubmitCallback: createUpdateCallback);
});

//ESTOS SON EVENTOS PARA MANIPULAR EL ESTADO
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productMap) onSubmitCallback;

  ProductFormNotifier(
      {required Product product, required this.onSubmitCallback})
      : super(ProductFormState(
          id: product.id,
          inStock: Stock.dirty(product.stock),
          price: Price.dirty(product.price),
          slug: Slug.dirty(product.slug),
          title: Title.dirty(product.title),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(','),
          images: product.images,
        ));

  void _updateState({
    Title? title,
    Slug? slug,
    Price? price,
    Stock? inStock,
    List<String>? sizes,
    String? gender,
    String? description,
    String? tags,
  }) {
    state = state.copyWith(
      title: title ?? state.title,
      slug: slug ?? state.slug,
      price: price ?? state.price,
      inStock: inStock ?? state.inStock,
      sizes: sizes ?? state.sizes,
      gender: gender ?? state.gender,
      description: description ?? state.description,
      tags: tags ?? state.tags,
      isFormValid: Formz.validate([
        title ?? state.title,
        slug ?? state.slug,
        price ?? state.price,
        inStock ?? state.inStock,
      ]),
    );
  }

  void onTitleChanged(String value) {
    _updateState(title: Title.dirty(value));
  }

  void onSlugChanged(String value) {
    _updateState(slug: Slug.dirty(value));
  }

// En tu ProductFormNotifier
  void onPriceChanged(String value) {
    _updateState(price: Price.dirty(double.tryParse(value) ?? double.nan));
  }

  void onStockChanged(String value) {
    _updateState(inStock: Stock.dirty(int.tryParse(value) ?? -1));
  }

  void onSizesChanged(List<String> sizes) {
    _updateState(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    _updateState(gender: gender);
  }

  void onDescriptionChanged(String description) {
    _updateState(description: description);
  }

  void onTagsChanged(String tags) {
    _updateState(tags: tags);
  }

  Future<bool> onFormSubmit() async {
    // Marcar todos los campos como tocados
    _touchedEverything();

    // Esperar un breve momento para asegurar que el estado se actualice

    // Verificar si el formulario es válido y si ya se está posteando
    if (!state.isFormValid) {
      return false;
    }
    if (state.isPosting) {
      return false;
    }
    // Actualizar el estado para indicar que se está posteando
    state = state.copyWith(isPosting: true);
    final productMap = {
      "id": state.id == 'new' ? null : state.id,
      "title": state.title.value,
      "price": state.price.value,
      "slug": state.slug.value,
      "stock": state.inStock.value,
      "description": state.description,
      "sizes": state.sizes,
      "gender": state.gender,
      "tags": state.tags.split(','),
      "images": state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
    };

    try {
      final result = await onSubmitCallback(productMap);
      await Future.delayed(const Duration(seconds: 3));
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  void updateProductImage(String path) {
    state = state.copyWith(images: [...state.images, path]);
  }
}

//como se ve el ESTADO
class ProductFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.isPosted = false,
      this.isPosting = false,
      this.id,
      this.title = const Title.pure(),
      this.slug = const Slug.pure(),
      this.price = const Price.pure(),
      this.sizes = const [],
      this.gender = 'men',
      this.inStock = const Stock.pure(),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith(
      {bool? isFormValid,
      bool? isPosted,
      bool? isPosting,
      String? id,
      Title? title,
      Slug? slug,
      Price? price,
      List<String>? sizes,
      String? gender,
      Stock? inStock,
      String? description,
      String? tags,
      List<String>? images}) {
    return ProductFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      sizes: sizes ?? this.sizes,
      gender: gender ?? this.gender,
      inStock: inStock ?? this.inStock,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      images: images ?? this.images,
    );
  }
}
