import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookPreviewPage extends StatelessWidget {
  const BookPreviewPage({super.key, this.book});
  final dynamic book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(book['title']),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/Book-Covers/${book['id']}.png",
                        ),
                        Flexible(child: Text(book['abstract'])),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text("by: ${book['authorId']}"),
                  Text(
                    DateFormat(
                      'dd.MM.yyyy',
                    ).format(DateTime.parse(book['publishingDate'])),
                  ),
                ],
              ),
              ElevatedButton(onPressed: () {}, child: Text("Show at DNB")),
            ],
          ),
        ),
      ),
    );
  }
}
