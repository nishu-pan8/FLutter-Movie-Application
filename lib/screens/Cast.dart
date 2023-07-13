import 'package:flutter/material.dart';
import 'package:runomovies/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Cast extends StatefulWidget {
  int id;
  Cast(this.id, {super.key});
  @override
  State<Cast> createState() => _CastState();
}

class _CastState extends State<Cast> {
  List cast = [];
  List crew = [];
  final String apikey = "76e1eedb309623f7903b6cab86fec3b7";
  final readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NmUxZWVkYjMwOTYyM2Y3OTAzYjZjYWI4NmZlYzNiNyIsInN1YiI6IjYzZWYzZDQxNDU3NjVkMDBiOWEzZTQyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XDnHrrKgCJZG2c4iV63zh5vu7Zaxx3pakaSKWuIWtBw';
  @override
  void initState() {
    _cast();
    super.initState();
  }

  _cast() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map castDetailsResults =
        await tmdbWithCustomLogs.v3.movies.getCredits(widget.id);
    Map crewResults = await tmdbWithCustomLogs.v3.movies.getCredits(widget.id);
    setState(() {
      cast = castDetailsResults['cast'];
      crew = crewResults['crew'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        title: modified_text(Colors.indigo[900]!, 30, "Cast"),
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
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: cast.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 0.0, mainAxisSpacing: 30.0),
          itemBuilder: (BuildContext context, int index) {
            return GridTile(
              child: (cast[index]['profile_path'] != null)
                  ? Column(
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500' +
                                        cast[index]['profile_path']),
                                fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(height: 5),
                        modified_text(Colors.black, 13, cast[index]['name']),
                        modified_text(Colors.grey[600]!, 12,
                            cast[index]['known_for_department']),
                      ],
                    )
                  : (crew[index]['profile_path'] != null)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 130,
                              width: 130,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            crew[index]['profile_path']),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(height: 5),
                            modified_text(
                                Colors.black, 12, crew[index]['name']),
                            modified_text(Colors.grey[600]!, 12,
                                crew[index]['known_for_department']),
                          ],
                        )
                      : Column(
                          children: const [
                            Image(
                                height: 130,
                                image: NetworkImage(
                                    'https://img.freepik.com/premium-vector/cute-boy-thinking-cartoon-avatar_138676-2439.jpg?w=826')),
                            modified_text(Colors.black, 15, "N/A"),
                          ],
                        ),
            );
          },
        ),
      ),
    );
  }
}
