import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuebrandenbook_catalogue/pages/book_preview_page.dart';
import 'package:neuebrandenbook_catalogue/services/json_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

enum SortType { titleAsc, titleDesc, dateAsc, dateDesc, authorAsc, authorDesc }

class _CataloguePageState extends State<CataloguePage> {
  late List books = [];
  SortType currentSort = SortType.titleAsc;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catalogue"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: .center,
                    children: [
                      Text("Select sort"),
                      Row(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("title"),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.titleAsc);
                            },
                            child: const Text("Asc"),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.titleDesc);
                            },
                            child: const Text("Desc"),
                          ),
                        ],
                      ),

                      Row(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("publishingDate"),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.dateAsc);
                            },
                            child: const Text("Asc"),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.dateDesc);
                            },
                            child: const Text("Desc"),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("author"),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.authorAsc);
                            },
                            child: const Text("Asc"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              await applySort(SortType.authorDesc);
                            },
                            child: const Text("Desc"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final book = books[index % books.length];
                    return Badge(
                      label: Text("Best Seller"),
                      alignment: Alignment(-.2, -1),
                      isLabelVisible:
                          (book['saleCountInLast28Days'] as int) > 500,
                      child: InkWell(
                        onTap: () => Get.to(() => BookPreviewPage(book: book)),
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
                                        builder: (context, asyncSnapshot) {
                                          if (asyncSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox.shrink();
                                          }
                                          return Text(asyncSnapshot.data!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void init() async {
    final data = await JsonReader.readJson();
    books = data..sort((a, b) => (a['title'] as String).compareTo(b['title']));
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('sortType') ?? 0;

    await applySort(SortType.values[index]);

    await Future.delayed(10.seconds);
    if (mounted) {
      Get.dialog(
        Dialog(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Text('That one seems interesting!'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 6,
                    children: [
                      Image.asset(
                        "assets/images/Book-Covers/${books.first['id']}.png",
                        width: 50,
                      ),
                      Expanded(
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: .start,
                          mainAxisAlignment: .center,
                          children: [
                            Text(books.first["title"]),
                            FutureBuilder(
                              future: JsonReader.getName(
                                books.first['authorId'],
                              ),
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox.shrink();
                                }
                                return Text(asyncSnapshot.data!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("I’m just looking around"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Get.to(() => BookPreviewPage(book: books.first)),
                      child: Text("I’ll give it a look"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> applySort(SortType type) async {
    currentSort = type;

    switch (type) {
      case SortType.titleAsc:
        books.sort((a, b) => (a['title'] as String).compareTo(b['title']));
        break;

      case SortType.titleDesc:
        books.sort((a, b) => (b['title'] as String).compareTo(a['title']));
        break;

      case SortType.dateAsc:
        books.sort(
          (a, b) =>
              (a['publishingDate'] as String).compareTo(b['publishingDate']),
        );
        break;

      case SortType.dateDesc:
        books.sort(
          (a, b) =>
              (b['publishingDate'] as String).compareTo(a['publishingDate']),
        );
        break;

      case SortType.authorAsc:
        books.sort((a, b) {
          int authorCompare = (a['authorId'] as String).compareTo(
            b['authorId'],
          );

          if (authorCompare != 0) {
            return authorCompare;
          }

          return (a['title'] as String).compareTo(b['title']);
        });
        break;
      case SortType.authorDesc:
        books.sort((a, b) {
          int authorCompare = (b['authorId'] as String).compareTo(
            a['authorId'],
          );

          if (authorCompare != 0) {
            return authorCompare;
          }

          return (a['title'] as String).compareTo(b['title']);
        });
        break;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sortType', type.index);

    setState(() {});
  }
}
