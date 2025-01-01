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

import 'package:flutter/material.dart';

import '../../components/state_messages/state_error_message.dart';
import '../../components/state_messages/state_loading_message.dart';
import '/core/theme/app_text_style.dart';
import '../shop/shop_screen.dart';
import 'splash_page_store.dart';
import 'splash_page_controller.dart';

class SplashPageScreen extends StatefulWidget {
  const SplashPageScreen({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPageScreen> createState() => _SplashPageScreenState();
}

class _SplashPageScreenState extends State<SplashPageScreen> {
  late final SplashPageController ctrl;
  final store = SplashPageStore();

  @override
  void initState() {
    super.initState();

    ctrl = SplashPageController(store);

    store.state.addListener(() {
      if (store.isSuccess) {
        Navigator.pushReplacementNamed(context, ShopScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * .6;

    return Scaffold(
      body: ListenableBuilder(
        listenable: store.state,
        builder: (context, _) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset('assets/images/boards_splash.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Boards',
                      style: AppTextStyle.titleFont28SemiBold,
                    ),
                  ),
                  if (store.isLoading) StateLoadingMessage(),
                ],
              ),
              if (store.isError)
                StateErrorMessage(
                  closeDialog: store.setStateSuccess,
                ),
            ],
          );
        },
      ),
    );
  }
}
