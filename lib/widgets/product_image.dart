import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  static const Widget _placeholder = ColoredBox(
    color: Color(0xFFEEEEEE),
    child: Center(
      child: Icon(Icons.tablet_mac_outlined, size: 40, color: Colors.grey),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder;
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _placeholder,
    );
  }
}
