import '../../../models/bag_item.dart';
import '/core/abstracts/data_result.dart';

abstract class IPaymentService {
  Future<DataResult<String>> createPaymentIntent(List<BagItemModel> items);
  Future<DataResult<String>> createCheckoutSession(List<BagItemModel> items);
}
