import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/product.dart';
import '../../providers/auth_controller.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_repository.dart';
import '../../widgets/product_card.dart';
import '../../widgets/state_message.dart';
import '../cart/cart_screen.dart';
import '../cart/order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = context.read<ProductRepository>().watchProducts();
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  void _signOut() {
    context.read<CartProvider>().clear();
    context.read<AuthController>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(AppAssets.logoIcon),
        ),
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Purchase history',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => _open(const OrderHistoryScreen()),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) => IconButton(
              tooltip: 'Cart',
              icon: Badge(
                label: Text('${cart.totalQuantity}'),
                isLabelVisible: cart.totalQuantity > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => _open(const CartScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: _products,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const StateMessage(
              icon: Icons.error_outline,
              message: 'Could not load products. Please try again later.',
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const StateMessage(
              icon: Icons.tablet_mac_outlined,
              message: 'No tablets available yet.',
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
