import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<MovieItem> fetchMovie(String id) async {
  final String url = 'https://api.themoviedb.org/3/movie/' + id + '?api_key=dc03f1bd4464f4297682b2d00a1eb455&query=movie';
  print(url);
  final response = await http.get(url);


  if(response.statusCode == 200){
    return MovieItem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('failed to load movie');
  }
}

class MovieItem {
  final String title;
  final String summary;
  final String release_date;
  final String poster_path;

  //final List<String> genres;

  MovieItem({
    this.title,
    this.summary,
    this.release_date,
    this.poster_path
    //this.genres
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      title: json['original_title'],
      summary: json['overview'],
      release_date: json['release_date'],
      poster_path: json['poster_path']
    );
  }
}


class MoviePage extends StatefulWidget {
  final String id;

  MoviePage({
    this.id
  });

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Future<MovieItem> futureMovie;

  @override
  initState() {
    super.initState();
    futureMovie = fetchMovie(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<MovieItem>(
        future: futureMovie,
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Text(snapshot.data.title, style: TextStyle(fontFamily: 'AbrilFatface', fontSize: 32), textAlign: TextAlign.center,),

                      Container(
                        margin: EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.red,
                              width: 10
                            )
                          ),
                          child: Image.network('https://image.tmdb.org/t/p/w200' + snapshot.data.poster_path,)),

                      Container(
                        width: 300,
                          child: Text(snapshot.data.summary, style: TextStyle(fontFamily: 'AbrilFatface', fontSize: 24))),

                    ],
                  ),
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
      )
    );
  }
}

