// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import '/core/abstracts/data_result.dart';
import '../../../models/message.dart';

/// A repository implementation for managing chat messages related to ads.
/// This class interacts with Firebase Firestore to handle message operations.
abstract class IMessageRepository {
  /// Fetches all messages for a specific ad in ascending order of their
  /// timestamp.
  ///
  /// [adId] - The ID of the ad for which to retrieve messages.
  ///
  /// Returns a [DataResult] containing a list of [MessageModel] on success,
  /// or an error result on failure.
  Future<DataResult<MessageModel>> sendMessage({
    required String adId,
    required MessageModel message,
  });

  /// Sends a new message for a specific ad and saves it to Firestore.
  ///
  /// [adId] - The ID of the ad for which the message is being sent.
  /// [message] - The [MessageModel] to send.
  ///
  /// Returns a [DataResult] containing the sent [MessageModel] with an updated
  /// ID.
  Future<DataResult<List<MessageModel>>> get(String adId);

  /// Updates the status of a specific message in Firestore.
  ///
  /// [adId] - The ID of the ad containing the message.
  /// [messageId] - The ID of the message to update.
  /// [read] - The updated read status (optional).
  /// [answered] - The updated answered status (optional).
  ///
  /// Returns a [DataResult] indicating success or failure.
  Future<DataResult<void>> updateStatus({
    required String adId,
    required String messageId,
    bool? read,
    bool? answered,
  });
}
