import 'package:neitorvet/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productMap) {
    return datasource.createUpdateProduct(productMap);
  }

  @override
  Future<Product> getProductsById(String id) {
    return datasource.getProductsById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 1}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<Product> getProductsByTerm(String term) {
    return datasource.getProductsByTerm(term);
  }
}
