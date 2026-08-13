import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repositories.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/entities/order_entity.dart';

// 1. بروفايدر للـ Repository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl();
});

// 2. بروفايدر لـ UseCase إنشاء الطلب
final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return CreateOrderUseCase(repository);
});

// 3. بروفايدر لـ UseCase جلب تفاصيل الطلب بالـ ID
final getOrderByIdUseCaseProvider = Provider<GetOrderByIdUseCase>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return GetOrderByIdUseCase(repository);
});

// 4. بروفايدر المستقبل (FutureProvider) لجلب تفاصيل الأوردر في شاشة النجاح
final orderDetailsProvider = FutureProvider.family<OrderEntity, String>((ref, orderId) async {
  final useCase = ref.read(getOrderByIdUseCaseProvider);
  return await useCase(orderId);
});