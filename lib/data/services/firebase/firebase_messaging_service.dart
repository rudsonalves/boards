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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static const keyUsers = 'users';
  static const keyUsersFcmToken = 'fcmToken';

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;
  User? get user => FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>> get _firebaseFirestore =>
      FirebaseFirestore.instance.collection(keyUsers);

  bool started = false;

  void init() {
    if (started) return;
    started = true;
    _listenForTokenChanges();
    log('FirebaseMessagingService: Token listener initialized');
  }

  void _listenForTokenChanges() {
    _firebaseMessaging.onTokenRefresh.listen(
      (newToken) async {
        if (user != null) {
          await _updateToken(newToken);
        }
      },
    );
  }

  Future<String?> getAndUpdateToken() async {
    try {
      final token = await getToken();
      if (user == null) return null;

      await _updateToken(token!);

      return token;
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  Future<String?> getToken() async {
    if (!started) init();

    try {
      if (user == null) return null;
      // Get token
      final token = await _firebaseMessaging.getToken();

      // Update token in Firestore
      if (token == null || token.isEmpty || !token.contains(":")) {
        final message = 'FbUserRepository.getToken:'
            ' Invalid or null token for user ${user!.uid}';
        throw Exception(message);
      }

      return token;
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  Future<void> _updateToken(String token) async {
    if (user == null) return;
    if (token.isEmpty || !token.contains(":")) {
      final message = 'FbUserRepository._updateToken:'
          ' Updating token for user ${user!.uid}';
      throw Exception(message);
    }
    await _firebaseFirestore.doc(user!.uid).update(
      {
        keyUsersFcmToken: token,
      },
    );
  }

  // Request IOS permissions for notification
  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Permissão concedida');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('Permissão concedida provisoriamente');
    } else {
      log('Permissão negada');
    }
  }
}
