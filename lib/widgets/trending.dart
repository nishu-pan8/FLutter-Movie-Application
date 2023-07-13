import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runomovies/description.dart';
import 'package:runomovies/utils/text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../screens/see_all.dart';

class TrendingMovies extends StatefulWidget {
  final List trending;
  TrendingMovies(this.trending, this.scrollController, this.isLoadingMore);
  final scrollController;
  bool isLoadingMore;

  @override
  State<TrendingMovies> createState() => _TrendingMoviesState();
}

class _TrendingMoviesState extends State<TrendingMovies> {
  final controller = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 10),
            alignment: Alignment.topLeft,
            child: modified_text(Colors.indigo[900]!, 28, 'Home'),
          ),
          SizedBox(
            child: CarouselSlider.builder(
              carouselController: controller,
              itemCount: 5,
              itemBuilder: (context, index, _) {
                return widget.trending.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Description(
                                            widget.trending[index]['id'],
                                            widget.trending[index]
                                                ['original_title'],
                                            'https://image.tmdb.org/t/p/w500' +
                                                widget.trending[index]
                                                    ['backdrop_path'],
                                            widget.trending[index]['overview'],
                                            widget.trending[index]
                                                ['original_language'],
                                            widget.trending[index]
                                                ['release_date'],
                                            widget.trending[index]
                                                    ['vote_average']
                                                .toString(),
                                            widget.trending[index]['popularity']
                                                .toString())));
                              },
                              child: Container(
                                width: 600,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            widget.trending[index]
                                                ['poster_path'],
                                      ),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ),
                          ),
                          modified_text(Colors.black, 15,
                              widget.trending[index]['title'] ?? 'Loading'),
                          modified_text(
                              Colors.black,
                              13,
                              widget.trending[index]['release_date'] ??
                                  'Loading')
                        ],
                      );
              },
              options: CarouselOptions(
                  height: 300,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.4,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  }),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 80),
              AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: 5,
                effect: WormEffect(
                    offset: 30,
                    dotHeight: 6,
                    spacing: 10,
                    dotWidth: 40,
                    strokeWidth: 50,
                    activeDotColor: Colors.indigo[400]!),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: modified_text(Colors.indigo[900]!, 28, 'Trending'),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                // child: modified_text(Colors.indigo[500]!, 18, "See all..."),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SeeAll()));
                  },
                  child: modified_text(Colors.indigo[500]!, 18, "See all..."),
                ),
              )
            ],
          ),
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.isLoadingMore
                    ? widget.trending.length + 1
                    : widget.trending.length,
                itemBuilder: (context, index) {
                  if (index < widget.trending.length) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Description(
                                      widget.trending[index]['id'],
                                      widget.trending[index]['original_title'],
                                      'https://image.tmdb.org/t/p/w500' +
                                          widget.trending[index]
                                              ['backdrop_path'],
                                      widget.trending[index]['overview'],
                                      widget.trending[index]
                                          ['original_language'],
                                      widget.trending[index]['release_date'],
                                      widget.trending[index]['vote_average']
                                          .toString(),
                                      widget.trending[index]['popularity']
                                          .toString())));
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
                                    child: (widget.trending[index]
                                                ['poster_path'] !=
                                            null)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image(
                                              image: NetworkImage(
                                                  'https://image.tmdb.org/t/p/w500' +
                                                      widget.trending[index]
                                                          ['poster_path']),
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
                                            widget.trending[index]['title']),
                                        const SizedBox(height: 10),
                                        modified_text(
                                            Colors.grey[500]!,
                                            13,
                                            "Language : " +
                                                widget.trending[index]
                                                    ['original_language']),
                                        const SizedBox(height: 10),
                                        modified_text(
                                            Colors.grey[500]!,
                                            13,
                                            "Release Date : " +
                                                widget.trending[index]
                                                    ['release_date']),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                                  widget.trending[index]
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
                                                widget.trending[index]
                                                        ['vote_average']
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
        ],
      ),
    );
  }
}
