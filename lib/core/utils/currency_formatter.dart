/// Formatter for financial numbers, rates, advances, and balances
class CurrencyFormatter {
  CurrencyFormatter._();

  static const String defaultCurrencySymbol = 'Rs.';

  /// Formats amount into standard currency display e.g. "Rs. 2,500"
  static String format(double amount, {String symbol = defaultCurrencySymbol}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs().toInt();
    final buffer = StringBuffer();
    final str = absAmount.toString();

    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      }
    }

    final formatted = buffer.toString().split('').reversed.join();
    return '$symbol ${isNegative ? '-' : ''}$formatted';
  }
}
