import 'package:intl/intl.dart';

String stringDateFormat(String? stringTime) {
  final date = DateTime.tryParse(stringTime ?? '');
  return date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
}
