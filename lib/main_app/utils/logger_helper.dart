import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
    filter: _AppLogFilter(),
    printer: PrettyPrinter(printTime: false, colors: false, printEmojis: true));

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
