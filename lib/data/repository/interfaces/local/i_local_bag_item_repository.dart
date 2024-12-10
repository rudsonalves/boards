import '../../../models/bag_item.dart';
import '/core/abstracts/data_result.dart';

abstract class ILocalBagItemRepository {
  Future<void> initialize();
  Future<DataResult<List<BagItemModel>>> getAll();
  Future<DataResult<BagItemModel>> add(BagItemModel bag);
  Future<DataResult<int>> update(BagItemModel bag);
  Future<DataResult<int>> updateQuantity(BagItemModel bagItem);
  Future<DataResult<void>> delete(int bagId);
  Future<DataResult<void>> resetDatabase();
  Future<DataResult<void>> cleanDatabase();
}
