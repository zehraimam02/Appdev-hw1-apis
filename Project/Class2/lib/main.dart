import 'package:flutter/material.dart';
import '../list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        
        appBarTheme: AppBarTheme(),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false, // Add this line to remove the debug banner
      home: const ListPage(title: 'List view'),
    );
  }
}
