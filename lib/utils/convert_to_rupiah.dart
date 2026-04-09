import 'package:intl/intl.dart';

class ConvertToRupiah {
  static String convertToRupiah(int dataKey) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(dataKey);
  }
}
