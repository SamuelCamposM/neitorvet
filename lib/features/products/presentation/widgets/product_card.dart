import 'package:flutter/material.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(
          images: product.images,
        ),
        Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: size.hScreen(20),
        ),
      );
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
            height: size.hScreen(20),
            fadeOutDuration: const Duration(milliseconds: 100),
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            image: NetworkImage(images.first),
            fit: BoxFit.cover));
  }
}
