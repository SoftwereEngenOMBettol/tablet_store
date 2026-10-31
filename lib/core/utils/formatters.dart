import '../constants/app_constants.dart';

String formatPrice(double value) =>
    '${value.toStringAsFixed(2)} ${AppConstants.currency}';

String formatDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}
