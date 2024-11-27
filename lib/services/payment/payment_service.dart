import 'dart:async';
import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../core/abstracts/data_result.dart';
import '../../core/models/bag_item.dart';

class PaymentService {
  PaymentService._();

  static Future<DataResult<String>> generatePreferenceId(
      List<BagItemModel> items) async {
    final function = ParseCloudFunction('createPaymentPreference');

    final parameters = {
      'items': items.map((item) => item.toMPParameter()).toList()
    };

    try {
      // Adds a 10 second timeout to the Cloud Function call
      final response = await function
          .execute(parameters: parameters)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Timed out while trying to get preferenceId.');
      });

      // Check the answer
      if (response.success && response.result != null) {
        return DataResult.success(response.result['preferenceId'] as String);
      } else {
        throw Exception(response.error?.message ?? 'unknow error');
      }
    } on TimeoutException catch (err) {
      final message =
          'PaymentService.getPreferenceId: timeout error: ${err.message}';
      log(message);
      return DataResult.failure(TimeoutFailure(message: message));
    } catch (err) {
      // Tratamento de outros erros inesperados
      final message = 'PaymentService.getPreferenceId: Unexpected error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  static Future<DataResult<String>> updateStockAndStatus(
      Map<String, int> parameters) async {
    final function = ParseCloudFunction('updateStockAndStatus');

    try {
      // Adds a 10 second timeout to the Cloud Function call
      final response = await function
          .execute(parameters: parameters)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Timed out while trying to get preferenceId.');
      });

      // Check the answer
      if (response.success && response.result != null) {
        return DataResult.success(response.result['preferenceId'] as String);
      } else {
        throw Exception(response.error?.message ?? 'unknow error');
      }
    } on TimeoutException catch (err) {
      final message =
          'PaymentService.updateStockAndStatus: timeout error: ${err.message}';
      log(message);
      return DataResult.failure(TimeoutFailure(message: message));
    } catch (err) {
      final message =
          'PaymentService.updateStockAndStatus: Unexpected error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }
}
