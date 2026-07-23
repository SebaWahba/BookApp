import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'features/books/data/models/book_model.dart';
import 'features/books/data/repositories/books_repository_impl.dart';
import 'features/home/presentation/providers/home_provider.dart';

// no statefull widget
// no rebuild
// lightweight

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.read(textProvider);
    final carProviderObj = ref.watch(carProvider);
    final counter = ref.watch(counterProvider);
    final user = ref.watch(userProvider);
    final homeProviderNotifer = ref.watch(homeProvider);
    final booksProviderNotifier = ref.watch(bookProvider);

    // read -> read value once
    // watch -> watch value

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          ref.read(counterProvider.notifier).state = counter + 1;
          ref.read(userProvider.notifier).state = 'Abanoub';
          ref.read(homeProvider.notifier).addToList('Marina');
        },
      ),
      appBar: AppBar(title: Text(carProviderObj.color)),
      body: booksProviderNotifier.when(
        data: (data) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(counter.toString()),
                Text('Hello $user'),
                if (homeProviderNotifer.isNotEmpty) Text('Last value = ${homeProviderNotifer.last}'),
                if (data != null) ...data.map((book) => Text(book?.title ?? 'no title')),
              ],
            ),
          );
        },
        error: (error, st) {
          return Text(error.toString());
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// tool
// state management
// provider
// bloc
// riverpod
// getx
// state -> anything
// setState

// 4 types

// Simple provider (value will not be changed)
final textProvider = Provider<String>((ref) => 'Abanoub');
final carProvider = Provider<Car>((ref) => carObj);

// state provider (simple)
final counterProvider = StateProvider<int>((ref) => 0);
final userProvider = StateProvider<String>((ref) => 'user');

class Car {
  String color;
  final int doors;
  Car(this.color, this.doors);

  void changeColor(String color) {
    this.color = color;
  }
}

var carObj = Car('red', 4);

final homeProvider = NotifierProvider<HomeProvider, List<String>>(HomeProvider.new);

// notifier provider
class HomeProvider extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addToList(String value) {
    state.add(value);
  }

  void removeItem(int index) {
    state.removeAt(index);
  }
}

final bookProvider = AsyncNotifierProvider<BookProvider, List<BookModel?>?>(BookProvider.new);

class BookProvider extends AsyncNotifier<List<BookModel?>?> {
  @override
  FutureOr<List<BookModel?>?> build() async {
    state = AsyncLoading();
    final result = await ref.read(booksRepositoryProvider).getBooks(query: 'art');
    return result.fold(
      (failure) {
        state = AsyncError('Failed to fetch data', StackTrace.current);
        return null;
      },
      (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}
