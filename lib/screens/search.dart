import 'package:flutter/material.dart';
import '../description.dart';
import '../models/search_model.dart';
import '../utils/text.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Result> search = [];
  String value = '';
  @override
  void initState() {
    super.initState();
  }

  Future<void> getMovieSearch(String value) async {
    // search=[];
    String url =
        'https://api.themoviedb.org/3/search/movie?api_key=76e1eedb309623f7903b6cab86fec3b7&language=en-US&query=${value}&page=1&include_adult=false';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        search = SearchRsponseFromJson(response.body).results;
      });
    } else {
      //print("Unexpected response");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        title: modified_text(Colors.indigo[900]!, 30, "Search Here"),
        centerTitle: true,
        leading: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.indigo[400]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search for a movie",
              style: TextStyle(
                  color: Colors.indigo[900],
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) => getMovieSearch(value),
              style: const TextStyle(
                  color: Colors.indigo, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo[50],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  hintText: "eg: Knock on the Cabin",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.indigo),
            ),
            const SizedBox(height: 20.0),
            Expanded(
                child: search.isEmpty
                    ? Center(
                        child: Text(
                          '"No results found"',
                          style: TextStyle(
                              color: Colors.indigo[900], fontSize: 15.0),
                        ),
                      )
                    : ListView.builder(
                        itemCount: search.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(
                              search[index].title!,
                              style: TextStyle(
                                  color: Colors.indigo[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              '${search[index].voteAverage}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            leading: (search[index].posterPath!.isEmpty)
                                ? Image.asset('assets/nature1.jpg')
                                : Image.network(
                                    'https://image.tmdb.org/t/p/w500' +
                                        search[index].posterPath),
                          );
                        },
                      )),
          ],
        ),
      ),
    );
  }
}
