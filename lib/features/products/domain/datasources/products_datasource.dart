import 'package:neitorvet/features/products/domain/entities/product.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 1});
  Future<Product> getProductsById(String id);
  Future<Product> getProductsByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productMap);
}
