import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../description.dart';
import '../utils/text.dart';
import 'package:http/http.dart' as http;

class SeeAll extends StatefulWidget {
  const SeeAll({Key? key}) : super(key: key);

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  List trending = [];
  int page = 1;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    loadMovies();
  }

  loadMovies() async {
    String url =
        "https://api.themoviedb.org/3/movie/now_playing?api_key=76e1eedb309623f7903b6cab86fec3b7&language=en-US&page=$page";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        trending = trending + json['results'];
      });
    } else {
      print("Unexpected response");
    }
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await loadMovies();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        title: modified_text(Colors.indigo[900]!, 30, "All Movies"),
        centerTitle: true,
        leading: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.indigo[400]),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trending.length,
              itemBuilder: (context, index) {
                if (index < trending.length) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                    trending[index]['id'],
                                    trending[index]['original_title'],
                                    'https://image.tmdb.org/t/p/w500' +
                                        trending[index]['backdrop_path'],
                                    trending[index]['overview'],
                                    trending[index]['original_language'],
                                    trending[index]['release_date'],
                                    trending[index]['vote_average'].toString(),
                                    trending[index]['popularity'].toString())));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.grey[100],
                            ),
                            margin: const EdgeInsets.all(10),
                            //color: Colors.orange,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, top: 20, bottom: 20),
                                  child:
                                      (trending[index]['poster_path'] != null)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Hero(
                                                tag:
                                                    'poster-image-${trending[index]['poster_path']}',
                                                child: Image(
                                                  image: NetworkImage(
                                                      'https://image.tmdb.org/t/p/w500' +
                                                          trending[index]
                                                              ['poster_path']),
                                                ),
                                              ),
                                            )
                                          : Image(
                                              image: NetworkImage(
                                                  'https://img.freepik.com/premium-vector/cute-boy-thinking-cartoon-avatar_138676-2439.jpg?w=826'),
                                            ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      modified_text(Colors.black, 18,
                                          trending[index]['title']),
                                      const SizedBox(height: 10),
                                      modified_text(
                                          Colors.grey[500]!,
                                          13,
                                          "Language : " +
                                              trending[index]
                                                  ['original_language']),
                                      const SizedBox(height: 10),
                                      modified_text(
                                          Colors.grey[500]!,
                                          13,
                                          "Release Date : " +
                                              trending[index]['release_date']),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: trending[index]
                                                    ['vote_average'] /
                                                2,
                                            itemSize: 20,
                                            minRating: 1,
                                            //direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.indigo[400],
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          const SizedBox(width: 10),
                                          modified_text(
                                              Colors.grey[500]!,
                                              17,
                                              trending[index]['vote_average']
                                                  .toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
