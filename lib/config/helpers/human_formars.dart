import 'package:intl/intl.dart';

class HumanFormat {
  static String formatNumber(double number) {
    final numberString =
        NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en')
            .format(number);

    return numberString;
    /*return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');*/
  }
}
