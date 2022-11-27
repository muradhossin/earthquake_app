import 'package:intl/intl.dart';

String getFormattedDate(DateTime dt, {String pattern = 'yyyy-MM-dd'})=>
    DateFormat(pattern).format(dt);