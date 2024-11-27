import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CloudFunctions {
  CloudFunctions._();

  static Future<void> assignUserToRoleCloud(
      String userId, String roleName) async {
    final response = await ParseCloudFunction('addUserToRole').execute(
      parameters: {'userId': userId, 'roleName': roleName},
    );

    if (!response.success) {
      throw Exception(
          'Failed to assign user to role "$roleName": ${response.error?.message ?? 'Unknown error'}');
    }
  }
}
