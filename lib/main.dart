import 'package:flutter/material.dart';
import 'package:notes/pages/home_page.dart';
import 'package:provider/provider.dart';



void main() =>runApp(MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
  }
}