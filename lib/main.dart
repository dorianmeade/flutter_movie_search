import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // for widgets
import 'package:flutter/foundation.dart'; // for compute function

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // for json decode

import 'movieList.dart';

// program driver
void main() {
  runApp(MaterialApp(
    home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jfif'),
            )
        ),
      child: HomePage()
    )
  ));
}

Future<List<Movie>> fetchSearch(http.Client client, String phrase) async {
  final response = await client.get('https://api.themoviedb.org/3/search/movie/?api_key=dc03f1bd4464f4297682b2d00a1eb455&query=' + phrase);
  return compute(parseMovies, response.body);
}

Future<List<Movie>> fetchMovies(http.Client client) async {
  final response = await client.get('https://api.themoviedb.org/3/trending/movie/day?api_key=dc03f1bd4464f4297682b2d00a1eb455');
  return compute(parseMovies, response.body);
}

List<Movie> parseMovies(String responseBody) {
  final parsedJson = jsonDecode(responseBody);
  var list = parsedJson['results'] as List;
  List<Movie> movies = list.map((i) => Movie.fromJson(i)).toList();
  return movies;
}

class Movie {
  final String id;
  final String original_title;
  final String poster_path;

  Movie({
    this.id,
    this.original_title,
    this.poster_path,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'].toString(),
        original_title: json['original_title'] as String,
        poster_path: json['poster_path'] as String,
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData= MediaQuery.of(context);

    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          actions: [
            IconButton(icon: (Icon(Icons.list)), onPressed:() =>
            {
              Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text("Trending"),
                      backgroundColor: Colors.red,
                      actions: [
                        IconButton(icon: (Icon(Icons.list)), onPressed:() => print('pressed'))
                      ],
                    ),
                    body: FindFlix()
                  );
                  }
                ))
              }
            )
          ],
        ),

        backgroundColor: Colors.transparent,
      body: Center(
            child: Container(
              color: Colors.transparent,
              width: queryData.size.width / 1.5,
              child: TextField(
                expands: false,
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                    prefixIcon: Icon(Icons.search, color: Colors.white,),
                    labelText: "Find Movies",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (search) {
                  print(search);
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.red,
                          actions: [
                            IconButton(icon: (Icon(Icons.list)), onPressed:() => print('pressed'))
                          ],
                        ),
                        body: SearchFlix(title: search,)
                      );
                    }
                    ));
                },
              ),

            ),
      )
        //FindFlix()
    );
  }
}

class FindFlix extends StatelessWidget {
  final String title;

  FindFlix({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: fetchMovies(http.Client()),
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? MovieList(movies: snapshot.data) : Center(child: CircularProgressIndicator());
        });
  }
}


class SearchFlix extends StatelessWidget {
  final String title;

  SearchFlix({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: fetchSearch(http.Client(), title),
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? MovieList(movies: snapshot.data) : Center(child: CircularProgressIndicator());
        });
  }
}
