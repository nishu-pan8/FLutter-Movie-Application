import 'package:flutter/material.dart';
import 'package:runomovies/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class Review extends StatefulWidget {
  int id;
  Review(this.id, {super.key});
  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List review = [];
  final String apikey = "76e1eedb309623f7903b6cab86fec3b7";
  final readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NmUxZWVkYjMwOTYyM2Y3OTAzYjZjYWI4NmZlYzNiNyIsInN1YiI6IjYzZWYzZDQxNDU3NjVkMDBiOWEzZTQyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XDnHrrKgCJZG2c4iV63zh5vu7Zaxx3pakaSKWuIWtBw';
  void initState() {
    _review();
    super.initState();
  }

  _review() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map review1detailsresults =
        await tmdbWithCustomLogs.v3.movies.getReviews(widget.id);

    setState(() {
      review = review1detailsresults['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        title: modified_text(Colors.indigo[900]!, 30, "Reviews"),
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.indigo[400]),
      ),
      body: Scrollbar(
        thickness: 8,
        radius: const Radius.circular(20),
        child: (review.isNotEmpty)
            ? ListView.builder(
                itemCount: review.length,
                itemBuilder: (context, index) {
                  String datetime =
                      review[index]['created_at'].substring(0, 10);
                  String content = review[index]['content'];
                  //print(datetime);
                  return Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: (review[index]
                                            ['author_details']['avatar_path'])
                                        .contains('https', 1)
                                    ? NetworkImage(review[index]
                                            ['author_details']['avatar_path']
                                        .substring(1))
                                    : NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            review[index]['author_details']
                                                ['avatar_path']),
                                radius: 60,
                              ),
                              const SizedBox(height: 15),
                              modified_text(
                                  Colors.black, 20, review[index]['author']),
                              Row(
                                children: [
                                  const SizedBox(width: 80),
                                  RatingBar.builder(
                                    initialRating: review[index]
                                                ['author_details']['rating'] !=
                                            null
                                        ? review[index]['author_details']
                                                ['rating'] /
                                            2
                                        : 0,
                                    minRating: 1,
                                    itemSize: 25,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.indigo[400],
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(width: 15),
                                  (review[index]['author_details']['rating'] ==
                                          null)
                                      ? modified_text(
                                          Colors.grey[500]!, 15, "N/A")
                                      : modified_text(
                                          Colors.grey[500]!,
                                          17,
                                          review[index]['author_details']
                                                  ['rating']
                                              .toString())
                                ],
                              ),
                              Text(
                                datetime,
                                style: TextStyle(
                                  color: Colors.grey[500]!,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 15),
                              ReadMoreText(
                                content,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[500]),
                                trimLines: 4,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                moreStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.indigo[500]),
                              ),
                              const SizedBox(height: 15),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 5,
                                indent: 70,
                                endIndent: 70,
                              ),
                            ],
                          )),
                    ],
                  );
                },
              )
            : Center(
              child: const Text("NO REVIEWS FOUND"),
            ),
      ),
    );
  }
}
