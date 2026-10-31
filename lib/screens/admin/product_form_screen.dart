import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../../models/product.dart';
import '../../services/product_repository.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// One form for both adding and updating a tablet.
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  /// When set, the form edits this product; otherwise it creates a new one.
  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _brand;
  late final TextEditingController _imageUrl;
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _code = TextEditingController(text: product?.code);
    _name = TextEditingController(text: product?.name);
    _price = TextEditingController(text: product?.price.toString());
    _brand = TextEditingController(text: product?.brand);
    _imageUrl = TextEditingController(text: product?.imageUrl);
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _price.dispose();
    _brand.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _clear() {
    for (final controller in [_code, _name, _price, _brand, _imageUrl]) {
      controller.clear();
    }
    _formKey.currentState?.reset();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = context.read<ProductRepository>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final product = Product(
      id: widget.product?.id,
      code: _code.text.trim(),
      name: _name.text.trim(),
      price: double.parse(_price.text.trim()),
      brand: _brand.text.trim(),
      imageUrl: _imageUrl.text.trim(),
    );

    setState(() => _saving = true);
    try {
      if (_isEditing) {
        await repository.updateProduct(product);
      } else {
        await repository.addProduct(product);
      }
      navigator.pop();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save the product. Try again.')),
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Update tablet' : 'Add new tablet')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _code,
                    label: 'Item code',
                    validator: (v) => Validators.notEmpty(v, field: 'Item code'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _name,
                    label: 'Item name',
                    validator: (v) => Validators.notEmpty(v, field: 'Item name'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _price,
                    label: 'Price (OMR)',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: Validators.price,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _brand,
                    label: 'Brand',
                    validator: (v) => Validators.notEmpty(v, field: 'Brand'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _imageUrl,
                    label: 'Product image URL',
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    validator: Validators.imageUrl,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isEditing ? 'Save changes' : 'Add product',
                    isLoading: _saving,
                    onPressed: _save,
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _clear, child: const Text('Clear')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
