// import 'package:flutter/material.dart';
// import '../widget.dart'; // Import MyWidget class

// class ListPage extends StatefulWidget {
//   const ListPage({super.key, required this.title});

//   final String title;

//   @override
//   State<ListPage> createState() => _ListPageState();
// }

// class _ListPageState extends State<ListPage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const MyWidget(), // Displaying MyWidget in the AppBar
//       ),
//       body: ListView.separated(
//         itemCount: 14,
//         separatorBuilder: (context, index) => const Divider(
//           color: Colors.grey,
//           thickness: 0.5,
//         ),
//         itemBuilder: (context, index) => ListTile(
//           leading: CircleAvatar(
//             child: Text(index.toString()),
//           ),
//           title: const Text('List Content'),
//           subtitle: const Text('subtitle text'),
//           trailing: const Icon(Icons.access_alarm),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widget.dart'; // Import MyWidget class

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // Fetch data from the API
  Future<List<Post>> fetchAllPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Keeping title of the page
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchAllPosts(), // Fetching posts asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetch: ${snapshot.error}')); // Error message
          } else if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.separated(
              itemCount: posts.length, // Displaying fetched posts in ListView
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                Post post = posts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(post.id.toString()),
                  ),
                  title: Text(post.title), // Post title
                  subtitle: Text(post.content), // Post content
                  trailing: const Icon(Icons.access_alarm),
                );
              },
            );
          } else {
            return const Center(child: Text('No data found')); // If no data
          }
        },
      ),
    );
  }
}
