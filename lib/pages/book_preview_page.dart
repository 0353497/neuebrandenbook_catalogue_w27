import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:neuebrandenbook_catalogue/pages/author_profile_page.dart';
import 'package:neuebrandenbook_catalogue/services/json_reader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BookPreviewPage extends StatefulWidget {
  const BookPreviewPage({super.key, this.book});
  final dynamic book;

  @override
  State<BookPreviewPage> createState() => _BookPreviewPageState();
}

class _BookPreviewPageState extends State<BookPreviewPage> {
  bool didShare = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.book['title']),
        actions: [
          IconButton(
            onPressed: () async {
              final res = await SharePlus.instance.share(
                ShareParams(
                  text:
                      'Have a look at "${widget.book['title']}"! \n https://neubrandenbook.blz-it.de/books/${widget.book['id']} \n Shared with the NeubrandenBook Catalogue App!',
                ),
              );
              if (res.status == ShareResultStatus.success && mounted) {
                setState(() {
                  didShare = true;
                });
              }
            },
            icon: Icon(didShare ? Icons.check : Icons.share),
          ),
        ],
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
                      crossAxisAlignment: .start,
                      children: [
                        Image.asset(
                          "assets/images/Book-Covers/${widget.book['id']}.png",
                          width: 100,
                        ),
                        Flexible(child: Text(widget.book['abstract'])),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => AuthorProfilePage(id: widget.book['authorId']),
                      );
                    },
                    child: FutureBuilder(
                      future: JsonReader.getName(widget.book['authorId']),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox.shrink();
                        }
                        return Text("by: ${asyncSnapshot.data.toString()}");
                      },
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd.MM.yyyy',
                    ).format(DateTime.parse(widget.book['publishingDate'])),
                  ),
                ],
              ),
              if (widget.book['dnbUrl'] != null)
                ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(widget.book['dnbUrl']));
                  },
                  child: Text("Show at DNB"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
