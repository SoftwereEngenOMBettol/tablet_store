import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../models/purchase_order.dart';
import '../../providers/auth_controller.dart';
import '../../services/order_repository.dart';
import '../../widgets/state_message.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late final Stream<List<PurchaseOrder>> _orders;

  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthController>().user?.uid ?? '';
    _orders = context.read<OrderRepository>().watchOrders(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase history')),
      body: StreamBuilder<List<PurchaseOrder>>(
        stream: _orders,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const StateMessage(
              icon: Icons.error_outline,
              message: 'Could not load your purchases.',
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const StateMessage(
              icon: Icons.receipt_long_outlined,
              message: 'No purchases yet.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ExpansionTile(
                  title: Text('Order on ${formatDate(order.placedAt)}'),
                  subtitle: Text('Total: ${formatPrice(order.total)}'),
                  children: [
                    for (final line in order.lines)
                      ListTile(
                        dense: true,
                        title: Text(line.name),
                        subtitle: Text('Qty: ${line.quantity}'),
                        trailing: Text(formatPrice(line.subtotal)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
