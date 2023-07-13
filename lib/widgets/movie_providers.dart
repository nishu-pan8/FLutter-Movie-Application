import 'package:flutter/material.dart';

class MovieProviders extends StatefulWidget {
  final List providerList;
  final int id;
  const MovieProviders(this.id, this.providerList, {super.key});
  @override
  State<MovieProviders> createState() => _MovieProvidersState();
}

class _MovieProvidersState extends State<MovieProviders> {
  
  @override
  Widget build(BuildContext context) {
    return (widget.providerList.isEmpty)?
        const SizedBox(
          height: 50,
            child: Center(child: Text("No details available")))
        :SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
          itemCount: widget.providerList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {

            return Container(
              padding: const EdgeInsets.only(right: 20),
              child: Image(
                image: NetworkImage('https://image.tmdb.org/t/p/w500' +
                    widget.providerList[index]['logo_path']),

              ),
            );
          }),
    );
  }
}
