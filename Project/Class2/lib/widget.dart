import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyWidget extends StatelessWidget {

  Future<void> fetchAllPosts() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.org/posts'));
    
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
        jsonResponse.map((post) => Post.fromJson(post)).toList();
    }else {
      throw Exception('Failed to load posts');
    }

  }

  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Text(
    //   'My Custom Widget',
    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    // );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(future: fetchAllPosts(),
        builder: (context,snap){
          if(snap.hasData){
            return Text('data fetch');
          }
          else if (snap.hasError){
            return Text('error in fetch');
          }
          return Center(child: CircularProgressIndicator(),);
        }),
      ),
    );
  }
}


class Post {
  final int id;
  final String slug;
  final String url;
  final String title;
  final String content;
  final String img;

  Post({
    required this.id,
    required this.slug,
    required this.url,
    required this.title,
    required this.content,
    required this.img,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? 'No slug',
      url: json['url'] ?? 'No url',
      title: json['title'] ?? 'No title',
      content: json['content'] ?? 'No content',
      img: json['img'] ?? 'No image',
      
    );
  }



  
}

 

