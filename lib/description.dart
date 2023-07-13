import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:runomovies/provider/favourite_provider.dart';
import 'package:runomovies/screens/Cast.dart';
import 'package:runomovies/utils/text.dart';
import 'package:runomovies/widgets/movie_providers.dart';
import 'package:runomovies/widgets/similar_movies.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:runomovies/screens/Reviews.dart';


class Description extends StatefulWidget {
  final String bannerUrl,name,rating,language,popularity,releaseDate,description;
  final int id;
  const Description(this.id,this.name,this.bannerUrl,this.description,this.language, this.releaseDate,this.rating,this.popularity,{super.key});
  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description>  {

  List nowPlaying=[];
  List movieProviders = [];
  List similarMovies = [];
  final String apikey = '76e1eedb309623f7903b6cab86fec3b7';
  final readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NmUxZWVkYjMwOTYyM2Y3OTAzYjZjYWI4NmZlYzNiNyIsInN1YiI6IjYzZWYzZDQxNDU3NjVkMDBiOWEzZTQyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XDnHrrKgCJZG2c4iV63zh5vu7Zaxx3pakaSKWuIWtBw';
  @override
  void initState() {
    moviesProviders();
    //getNowPlaying();
    super.initState();
  }

  moviesProviders() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map movieProviderResults =
        await tmdbWithCustomLogs.v3.movies.getWatchProviders(widget.id);
    Map similarMovieResults =
        await tmdbWithCustomLogs.v3.movies.getSimilar(widget.id);
    Map trendingMoviesResults =
        await tmdbWithCustomLogs.v3.movies.getNowPlaying();
    setState(() {
      movieProviders = movieProviderResults['results']['CA']['rent'];
      similarMovies = similarMovieResults['results'];
      nowPlaying = trendingMoviesResults['results'];
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Stack(
                children: [
                  ( widget.bannerUrl== "")
                      ? Image.asset('assets/nature1.jpg')
                      : Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.bannerUrl}',
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white),
                  ),
                  Positioned(
                    top: 200,
                    right: 1,
                    left: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 100,
                        width: 450,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.indigo[900]),
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          iconSize: 25,
                          onPressed: () {
                            print("added");
                            provider.toggleFavourite(widget.id);
                          },
                          icon: provider.isExist(widget.id)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: 20,
                  child: ListTile(
                    leading: RatingBar.builder(
                      initialRating: double.parse(widget.rating) / 2,
                      itemSize: 20,
                      minRating: 0,
                      //direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.indigo[400],
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    title: modified_text(Colors.grey[500]!, 17, widget.rating),
                  )),
              SizedBox(
                height: 28,
                child: ListTile(
                  leading: modified_text(
                      Colors.grey[500]!, 17, 'Language : ${widget.language}'),
                ),
              ),
              SizedBox(
                height: 28,
                child: ListTile(
                  leading: modified_text(Colors.grey[500]!, 17,
                      'Popularity : ${widget.popularity}'),
                ),
              ),
              SizedBox(
                height: 28,
                child: ListTile(
                  leading: modified_text(Colors.grey[500]!, 17,
                      'Release Date : ${widget.releaseDate}'),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading:
                      modified_text(Colors.grey[500]!, 17, "Release Status :"),
                  title: modified_text(Colors.blue[400]!, 17, "Released"),
                ),
              ),
              const ListTile(
                leading: modified_text(Colors.black, 20, "Synopsis"),
              ),
              SizedBox(
                height: 80,
                child: ListTile(
                  leading:
                      modified_text(Colors.grey[500]!, 15, widget.description),
                ),
              ),
              const ListTile(
                leading: modified_text(Colors.black, 20, "Production House"),
              ),
              MovieProviders(widget.id, movieProviders),
              const SizedBox(height: 15),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cast(widget.id)));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo[400], // Background Color
                      ),
                      child: const Text(
                        'Cast',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Review(widget.id)));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo[400], // Background Color
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const ListTile(
                leading: modified_text(Colors.black, 20, "Similar Movies"),
              ),
              SimilarMovies(widget.id, similarMovies),
            ],
          ),
        ),
      ),
    );
  }
}
