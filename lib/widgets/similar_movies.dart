import 'package:flutter/material.dart';
import 'package:runomovies/utils/text.dart' show modified_text;
import '../description.dart';

class SimilarMovies extends StatefulWidget {
  final List similarMovieList;
  int id;
  SimilarMovies(this.id, this.similarMovieList, {super.key});

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  @override
  Widget build(BuildContext context) {
    return (widget.similarMovieList.isEmpty)
        ? const SizedBox(
            height: 80,
            child: Center(
              child: Text("No similar movies found"),
            ),
          )
        : SizedBox(
            height: 200,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.similarMovieList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                  widget.similarMovieList[index]['id'],
                                  widget.similarMovieList[index]
                                      ['original_title'],
                                  widget.similarMovieList[index]
                                              ['backdrop_path'] !=
                                          null
                                      ? 'https://image.tmdb.org/t/p/w500' +
                                          widget.similarMovieList[index]
                                              ['backdrop_path']
                                      : "",
                                  widget.similarMovieList[index]['overview'],
                                  widget.similarMovieList[index]
                                      ['original_language'],
                                  widget.similarMovieList[index]
                                      ['release_date'],
                                  widget.similarMovieList[index]['vote_average']
                                      .toString(),
                                  widget.similarMovieList[index]['popularity']
                                      .toString())));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, bottom: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            child: (widget.similarMovieList[index]
                                        ['poster_path'] ==
                                    null)
                                ? const Center(child: Text("No data"))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image: NetworkImage(
                                          'https://image.tmdb.org/t/p/w500' +
                                              widget.similarMovieList[index]
                                                  ['poster_path']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 30,
                            child: modified_text(Colors.grey[700]!, 15,
                                widget.similarMovieList[index]['release_date']),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
    ;
  }
}
