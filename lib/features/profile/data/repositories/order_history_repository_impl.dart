import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_history_repository.dart';
import '../datasources/order_history_remote_datasource.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final OrderHistoryRemoteDataSource remoteDataSource;

  OrderHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<OrderEntity>> getOrdersStream() {
    return remoteDataSource.getOrdersStream();
  }
}