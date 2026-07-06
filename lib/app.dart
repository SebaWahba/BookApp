import 'package:flutter/material.dart';

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bazar Book App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Bazar App Architecture Ready'),
        ),
      ),
    );
  }
}