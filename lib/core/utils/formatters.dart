import 'package:intl/intl.dart';

String formatDate(DateTime dt) {
  return DateFormat('d MMM yyyy, h:mm a').format(dt);
}
