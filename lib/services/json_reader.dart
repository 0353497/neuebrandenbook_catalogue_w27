import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<List> readJson() async {
    final json = await rootBundle.loadString("assets/data/books.json");
    final data = await jsonDecode(json);
    return data;
  }

  static Future<dynamic> readArtist(String id) async {
    final json = await rootBundle.loadString("assets/data/authors.json");
    final List data = await jsonDecode(json);
    return data.firstWhere((author) => author['id'] == id);
  }

  static Future<String> getName(String authorId) async {
    final json = await rootBundle.loadString("assets/data/authors.json");
    final List data = await jsonDecode(json);
    return data
        .firstWhere((author) => author['id'] == authorId)['name']
        .toString();
  }

  static Future<List> getArtistBooks(String id) async {
    final json = await rootBundle.loadString("assets/data/books.json");
    final List data = await jsonDecode(json);
    return data.where((book) => book['authorId'] == id).toList();
  }
}
