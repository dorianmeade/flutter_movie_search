import 'package:flutter/material.dart';
import 'main.dart';

import 'movie.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({Key key, this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: ((size.width/2)/ (size.height /2))),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

                child:
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.red,
                                      width: 2
                                  ),
                                  bottom: BorderSide(
                                      color: Colors.red,
                                      width: 2
                                  )
                              )
                          ),
                          child: Image.network('https://image.tmdb.org/t/p/w200' + movies[index].poster_path, height: 300,)),
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext){
                          return MoviePage(id: movies[index].id);
                        }))
                      }
                    ),
                    Align(alignment: Alignment.bottomCenter, child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(movies[index].original_title, style: TextStyle(fontFamily: 'AbrilFatface',fontSize: 18), textAlign: TextAlign.center,),
                    )),],
                )
            ),
          );
        });
  }
}

