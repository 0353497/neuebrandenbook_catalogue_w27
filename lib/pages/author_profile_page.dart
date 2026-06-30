import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neuebrandenbook_catalogue/services/json_reader.dart';

class AuthorProfilePage extends StatefulWidget {
  const AuthorProfilePage({super.key, required this.id});
  final String id;

  @override
  State<AuthorProfilePage> createState() => _AuthorProfilePageState();
}

class _AuthorProfilePageState extends State<AuthorProfilePage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: JsonReader.readArtist(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final artist = snapshot.data!;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  Text(artist['name']),

                  SizedBox(
                    width: double.maxFinite,
                    height: Get.height * .3,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(artist['cv']),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: JsonReader.getArtistBooks(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final books = snapshot.data!;
                      final int startYear = 1970;
                      return Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: Get.height * .2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: Get.width * 2,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Center(
                                          child: Container(
                                            height: 2,
                                            width: double.maxFinite,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      for (int i = 0; i <= 60; i += 10)
                                        Align(
                                          alignment: Alignment(
                                            ((i / 60) * 2) - 1,
                                            -1,
                                          ),
                                          child: Text("${startYear + i}"),
                                        ),
                                      for (int i = 0; i < books.length; i++)
                                        Align(
                                          alignment: Alignment(
                                            (((DateTime.parse(
                                                              books[i]['publishingDate'],
                                                            ).year -
                                                            startYear) /
                                                        60) *
                                                    2) -
                                                1,
                                            0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = i;
                                              });
                                            },
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedIndex == i
                                                    ? Colors.blue
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: books.length,
                                itemBuilder: (context, index) {
                                  final book = books[index];
                                  return ListTile(
                                    tileColor: selectedIndex == index
                                        ? Colors.blue
                                        : null,
                                    leading: Image.asset(
                                      "assets/images/Book-Covers/${book['id']}.png",
                                    ),
                                    title: Text(book['title']),
                                    subtitle: Text(
                                      DateFormat('yyy').format(
                                        DateTime.parse(book['publishingDate']),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
