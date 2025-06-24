import 'package:intl/intl.dart';

class ModelParser {
  static int? intFromJson(final dynamic json) {
    if (json is int) {
      return json;
    } else if (json is String) {
      return int.tryParse(json);
    } else {
      return null;
    }
  }

  static double? doubleFromJson(final dynamic json) {
    if (json is double) {
      return json;
    } else if (json is String) {
      return double.tryParse(json);
    } else if (json is int) {
      return json.toDouble();
    } else {
      return null;
    }
  }

  static bool? boolFromJson(final dynamic json) {
    if (json is bool) {
      return json;
    } else if (json is String) {
      return bool.tryParse(json);
    } else {
      return null;
    }
  }

  static DateTime? parseDate({
    required final String date,
    final String? pattern,
    final bool isUtc = false,
  }) {
    final DateFormat format = DateFormat(pattern ?? 'yyyy-MM-dd', 'id_ID');
    final DateTime? parsedDate = format.tryParse(date);
    return parsedDate;
  }

  static String formatDate({
    required final DateTime? date,
    final String? pattern,
    final String? onNull,
  }) {
    if (date == null) {
      return onNull ?? "";
    }
    final DateFormat formatter = DateFormat(pattern ?? 'yyyy-MM-dd', 'id_ID');
    return formatter.format(date);
  }
}
