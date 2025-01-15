import 'package:dio/dio.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'package:neitorvet/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;
  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {"Authorization": "Bearer $accessToken"}));

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: fileName)});
      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>>? _uploadPhotos(List<String> photos) async {
    final photosToUpload = photos.where((e) => e.contains('/')).toList();
    final photosToIgnore = photos.where((e) => !e.contains('/')).toList();
    final List<Future<String>> uploadJob = photosToUpload
        .map(
          _uploadFile,
        )
        .toList();

    final newImages = await Future.wait(uploadJob);

    return [...photosToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productMap) async {
    try {
      final String? productId = productMap['id'];
      final bool existeId = (productId != null);
      final String method = existeId ? 'PATCH' : 'POST';
      final String url = existeId ? '/products/$productId' : '/products';
      productMap.remove('id');
      productMap['images'] = await _uploadPhotos(productMap['images']);

      final response = await dio.request(url,
          data: productMap, options: Options(method: method));
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Product> getProductsById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw Exception();
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 1}) async {
    final response = await dio.get<List>("/products", queryParameters: {
      "limit": limit,
      "offset": offset,
    });
    final List<Product> products =
        response.data!.map((e) => ProductMapper.jsonToEntity(e)).toList();
    return products;
  }

  @override
  Future<Product> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
