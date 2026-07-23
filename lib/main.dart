import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  // can reuse any provider from anywhere
  runApp(ProviderScope(child: BookApp()));
}
