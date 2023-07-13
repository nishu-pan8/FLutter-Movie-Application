import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../description.dart';
import '../models/favourite_model.dart';
import '../provider/favourite_provider.dart';
import '../utils/text.dart';
import 'package:http/http.dart' as http;

class FavouriteList extends StatefulWidget {
  final List<int> fav;
   const FavouriteList({Key? key, required this.fav}) : super(key: key);

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  List<int> fav = [];
  List<Favourites> favourite = [];
  @override
  void initState() {
    super.initState();
    fav = widget.fav;
    getFavouriteList();
  }

  Future<void> getFavouriteList() async {
    favourite=[];
    for (int i = 0; i < fav.length; i++) {
      String url =
          "https://api.themoviedb.org/3/movie/${fav[i]}?api_key=76e1eedb309623f7903b6cab86fec3b7&language=en-US";
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          favourite.add(favouriteResponseFromJson(response.body));
        });
      } else {
        print("Unexpected response");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        title: modified_text(Colors.indigo[900]!, 30, "Favourite Movies"),
        centerTitle: true,
        leading: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.indigo[400]),
      ),
      body: Column(
        children: [
          if (favourite.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favourite.length,
              itemBuilder: (context, index) {
                DateTime datetime=favourite[index].releaseDate;
                String formattedDate=DateFormat('yyyy-MM-dd').format(datetime);
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                  favourite[index].id,
                                  favourite[index].originalTitle,
                                  'https://image.tmdb.org/t/p/w500' +
                                      favourite[index].backdropPath,
                                  favourite[index].overview,
                                  favourite[index].originalLanguage,
                                  favourite[index].releaseDate.toString(),
                                  favourite[index].voteAverage.toString(),
                                  favourite[index].popularity.toString())));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 15),
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
                                child: (favourite[index].posterPath != null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Hero(
                                          tag:
                                              'poster-image-${favourite[index].posterPath}',
                                          child: Image(
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500' +
                                                    favourite[index]
                                                        .posterPath),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    modified_text(Colors.black, 18,
                                        favourite[index].originalTitle),
                                    Row(
                                      children: [
                                        modified_text(
                                            Colors.grey[500]!,
                                            13,
                                            "Language : " +
                                                favourite[index].originalLanguage),
                                        Expanded(
                                          child: IconButton(
                                            iconSize: 20,
                                            onPressed: (
                                                ) {
                                              setState(() {
                                                provider.toggleFavourite(favourite[index].id);
                                                getFavouriteList();
                                              });
                                            },
                                            icon: provider.isExist(favourite[index].id)
                                                ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                                : const Icon(Icons.favorite_border),
                                          ),
                                        ),
                                      ],
                                    ),
                                    modified_text(
                                        Colors.grey[500]!,
                                        13,
                                        "Release Date : " +
                                            formattedDate),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating:
                                              favourite[index].voteAverage / 2,
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
                                            favourite[index]
                                                .voteAverage
                                                .toString())
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ));
              },
            ),
        ],
      ),
    );
  }
}
