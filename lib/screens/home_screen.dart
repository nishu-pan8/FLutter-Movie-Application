import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomovies/provider/favourite_provider.dart';
import 'package:runomovies/screens/search.dart';
import 'package:runomovies/utils/text.dart';
import 'package:runomovies/widgets/trending.dart';
import 'package:http/http.dart' as http;
import 'favourite_list.dart';
import 'my_header_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List trendingMovies = [];
  List<int> fav = [];
  int page = 1;
  final scrollController = ScrollController();
  bool showButton = false;
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    loadMovies();
    scrollController.addListener(() {
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showButton = true;
        setState(() {
          //update state
        });
      } else {
        showButton = false;
        setState(() {
          //update state
        });
      }
    });
  }

  loadMovies() async {
    String url =
        "https://api.themoviedb.org/3/movie/now_playing?api_key=76e1eedb309623f7903b6cab86fec3b7&language=en-US&page=$page";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        trendingMovies = trendingMovies + json['results'];
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
    final provider = Provider.of<FavouriteProvider>(context);
    fav = provider.fav;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: modified_text(
          Colors.indigo[900]!,
          25.0,
          'RunoMovies',
        ),
        backgroundColor: Colors.indigo[100],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // floatingActionButton: AnimatedOpacity(
      //   duration: const Duration(milliseconds: 1000), //show/hide animation
      //   opacity: showButton ? 1.0 : 0.0, //set opacity to 1 on visible, or hide
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       scrollController.animateTo(
      //           //go to top of scroll
      //           0, //scroll offset to go
      //           duration:
      //               const Duration(milliseconds: 500), //duration of scroll
      //           curve: Curves.fastOutSlowIn //scroll type
      //           );
      //     },
      //     backgroundColor: Colors.deepPurple[700],
      //     child: const Icon(Icons.arrow_upward),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          scrollController.animateTo(
              0, //scroll offset to go
              duration:
              const Duration(milliseconds: 500), //duration of scroll
              curve: Curves.fastOutSlowIn //scroll type
          );
        },
        //backgroundColor: Colors.deepPurple[700],
        backgroundColor: const Color.fromRGBO(0, 0, 255, 0.5),
        child: const Icon(Icons.arrow_upward),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [const MyHeaderDrawer(), MyDrawerList(context)],
          ),
        ),
      ),
      body: TrendingMovies(trendingMovies, scrollController, isLoadingMore),
    );
  }

  Widget MyDrawerList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(context),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FavouriteList(
                        fav: fav,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: const [
              Icon(
                Icons.favorite,
                size: 20,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Favourite List",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
