import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<Album> fetchAlbum()async{
  final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/6'));
  if(response.statusCode==200) {
//if the server did return a 200 ok response,
    //then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  }
  else{
//if the server did not return a 200 ok response,
//then throw an exception
  throw Exception('failed to load album');
  }
  }
  class Album{
  final int userId;
  final int id;
  final String title;
  const Album({
    required this.userId,required this.id,required this.title
  });
  factory Album.fromJson(Map<String,dynamic>Json){
    return Album(userId: Json['userId'], id: Json['id'], title: Json['title']);
  }
  }

void main()=>runApp(const MyApp());
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album>FutureAlbum;
  @override
  void initState(){
    super.initState();
    FutureAlbum=fetchAlbum();
  }
  @override
    Widget build(BuildContext context){
    return MaterialApp(title:'fetch data example',theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
        appBar: AppBar(title: const Text('fetch data example'),),
        body: Center(
          child:FutureBuilder<Album>(
            future:FutureAlbum,builder: (context,snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data!.title);
              }
              else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              //by default,show a loading spinner.
            return const CircularProgressIndicator();
          },
          ),
        ),
    ));

  }
}