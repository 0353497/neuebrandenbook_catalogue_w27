import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuebrandenbook_catalogue/pages/book_preview_page.dart';
import 'package:neuebrandenbook_catalogue/pages/catalogue_page.dart';
import 'package:neuebrandenbook_catalogue/services/json_reader.dart';
import 'package:quick_actions/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String shortcut = 'no action set';
  int itemsShown = 3;
  List books = [];

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        shortcut = shortcutType;
      });
    });

    quickActions
        .setShortcutItems(<ShortcutItem>[
          const ShortcutItem(
            type: "I’m feeling lucky",
            localizedTitle: "I’m feeling lucky",
            icon: 'ic_launcher',
          ),
        ])
        .then((void _) async {
          if (shortcut == 'no action set') {
            shortcut = 'actions ready';
          }
        });

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NeubrandenBook"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: JsonReader.readJson(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final data = asyncSnapshot.data!;
              books =
                  data
                      .where((book) => book['saleCountInLast28Days'] > 500)
                      .toList()
                    ..sort(
                      ((a, b) => (b['saleCountInLast28Days'] as int).compareTo(
                        a['saleCountInLast28Days'],
                      )),
                    );

              final Random random = Random(DateTime.now().day % 52);
              final randombook = data[random.nextInt(data.length)];
              return Column(
                children: [
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 12,
                        children: [
                          Text("Have you read this one yet?"),
                          Row(
                            spacing: 12,
                            children: [
                              Image.asset(
                                "assets/images/Book-Covers/${randombook['id']}.png",
                                width: 40,
                              ),
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(randombook['title']),
                                  ElevatedButton(
                                    onPressed: () => Get.to(
                                      () => BookPreviewPage(book: randombook),
                                    ),
                                    child: Text("Have a look!"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text("Best sellers"),
                            ElevatedButton(
                              onPressed: () => Get.to(() => CataloguePage()),
                              child: Text("View Catalogue"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: itemsShown,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemBuilder: (context, index) {
                              final book = books[index % books.length];
                              return InkWell(
                                onTap: () =>
                                    Get.to(() => BookPreviewPage(book: book)),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      spacing: 6,
                                      children: [
                                        Image.asset(
                                          "assets/images/Book-Covers/${book['id']}.png",
                                          width: 50,
                                        ),
                                        Expanded(
                                          child: Column(
                                            spacing: 8,
                                            crossAxisAlignment: .start,
                                            mainAxisAlignment: .center,
                                            children: [
                                              Text(book["title"]),
                                              FutureBuilder(
                                                future: JsonReader.getName(
                                                  book['authorId'],
                                                ),
                                                builder:
                                                    (context, asyncSnapshot) {
                                                      if (asyncSnapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return SizedBox.shrink();
                                                      }
                                                      return Text(
                                                        asyncSnapshot.data
                                                            .toString(),
                                                      );
                                                    },
                                              ),
                                              Text(
                                                book['saleCountInLast28Days']
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (books.length > itemsShown)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                itemsShown += 3;
                              });
                            },
                            child: Text("Show more …"),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void ditch() async {
    if (shortcut == "I’m feeling lucky") {
      final Random random = Random();
      final randomIndex = random.nextInt(books.length);
      await Future.delayed(1.seconds);
      Get.to(() => BookPreviewPage(book: books[randomIndex]));
    }
  }

  void init() async {
    ditch();
  }
}
