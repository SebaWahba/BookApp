import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/order_history_remote_datasource.dart';
import '../../data/repositories/order_history_repository_impl.dart';
import '../../domain/repositories/order_history_repository.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/entities/order_entity.dart';

final orderHistoryRemoteDataSourceProvider = Provider<OrderHistoryRemoteDataSource>((ref) {
  return OrderHistoryRemoteDataSourceImpl(FirebaseFirestore.instance, FirebaseAuth.instance);
});

final orderHistoryRepositoryProvider = Provider<OrderHistoryRepository>((ref) {
  final dataSource = ref.watch(orderHistoryRemoteDataSourceProvider);
  return OrderHistoryRepositoryImpl(dataSource);
});

final getOrderHistoryUseCaseProvider = Provider<GetOrderHistoryUseCase>((ref) {
  final repository = ref.watch(orderHistoryRepositoryProvider);
  return GetOrderHistoryUseCase(repository);
});

final orderHistoryStreamProvider = StreamProvider<List<OrderEntity>>((ref) {
  final useCase = ref.watch(getOrderHistoryUseCaseProvider);
  return useCase();
});