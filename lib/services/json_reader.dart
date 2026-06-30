import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<List> readJson() async {
    final json = await rootBundle.loadString("assets/data/books.json");
    final data = await jsonDecode(json);
    return data;
  }
}
