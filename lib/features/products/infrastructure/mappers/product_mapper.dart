import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/auth/infrastructure/infrastructure.dart';
import 'package:neitorvet/features/products/domain/entities/product.dart';

class ProductMapper {
  static Product jsonToEntity(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        price: double.parse(json['price'].toString()),
        description: json['description'],
        slug: json['slug'],
        stock: json['stock'],
        sizes: List<String>.from(json['sizes'].map((x) => x)),
        gender: json['gender'],
        tags: List<String>.from(json['tags'].map((x) => x)),
        images: List<String>.from(json['images'].map((image) =>
            image.startsWith('http')
                ? image
                : '${Environment.apiUrl}/files/product/$image')),
        user: UserMapper.userJsonToEntity(json['user']),
      );
}
