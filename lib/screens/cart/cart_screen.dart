import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../models/cart_item.dart';
import '../../providers/auth_controller.dart';
import '../../providers/cart_provider.dart';
import '../../services/order_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/state_message.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _placing = false;

  Future<void> _checkout() async {
    final cart = context.read<CartProvider>();
    final uid = context.read<AuthController>().user?.uid;
    final orders = context.read<OrderRepository>();
    final messenger = ScaffoldMessenger.of(context);
    if (uid == null || cart.isEmpty) return;

    setState(() => _placing = true);
    try {
      await orders.placeOrder(uid: uid, items: cart.items);
      cart.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Order placed. Thank you!')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not place the order. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return const StateMessage(
              icon: Icons.shopping_cart_outlined,
              message: 'Your cart is empty.',
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _CartTile(item: cart.items[index]),
                ),
              ),
              _CheckoutBar(
                total: cart.total,
                loading: _placing,
                onCheckout: _checkout,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ProductImage(url: item.product.imageUrl),
          ),
        ),
        title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(formatPrice(item.product.price)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Decrease quantity',
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => cart.decrease(item.key),
            ),
            Text('${item.quantity}'),
            IconButton(
              tooltip: 'Increase quantity',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => cart.increase(item.key),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.total,
    required this.loading,
    required this.onCheckout,
  });

  final double total;
  final bool loading;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text(
                      formatPrice(total),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  label: 'Checkout',
                  isLoading: loading,
                  onPressed: onCheckout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
