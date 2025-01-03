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
import 'package:flutter_localizations/flutter_localizations.dart';

import '/data/models/bag_item.dart';
import '/ui/features/splash/splash_page_screen.dart';
import 'data/models/address.dart';
import 'data/models/ad.dart';
import 'data/models/boardgame.dart';
import 'data/models/filter.dart';
import 'core/singletons/app_settings.dart';
import 'core/theme/theme.dart';
import 'core/theme/util.dart';
import 'ui/features/account/boardgames/boardgames_screen.dart';
import 'ui/features/account/boardgames/widgets/view_boardgame.dart';
import 'ui/features/account/boardgames/edit_boardgame/edit_boardgame_screen.dart';
import 'ui/features/bag/bag_screen.dart';
import 'ui/features/favorites/favorites_screen.dart';
import 'ui/features/account/account_screen.dart';
import 'ui/features/addresses/addresses_screen.dart';
import 'ui/features/account/my_ads/my_ads_screen.dart';
import 'ui/features/account/my_data/my_data_screen.dart';
import 'ui/features/payment/payment_screen.dart';
import 'ui/features/payment_session/payment_session_screen.dart';
import 'ui/features/shop/product/product_screen.dart';
import 'ui/features/filters/filters_screen.dart';
import 'ui/features/account/mechanics/mechanics_screen.dart';
import 'ui/features/chat/chat_screen.dart';
import 'ui/features/account/tools/tools_screen.dart';
import 'ui/features/shop/shop_screen.dart';
import 'ui/features/edit_ad/edit_ad_screen.dart';
import 'ui/features/signin/signin_screen.dart';
import 'ui/features/addresses/edit_address/edit_address_screen.dart';
import 'ui/features/signup/signup_screen.dart';
import 'core/get_it.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final app = getIt<AppSettings>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Manrope", "Comfortaa");
    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder(
        valueListenable: app.brightness,
        builder: (context, value, _) {
          return MaterialApp(
            theme: value == Brightness.light ? theme.light() : theme.dark(),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashPageScreen.routeName,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // Inglês
              Locale('pt', 'BR'), // Português do Brasil
            ],
            locale: const Locale('pt', 'BR'),
            routes: {
              SplashPageScreen.routeName: (_) => const SplashPageScreen(),
              ChatScreen.routeName: (_) => const ChatScreen(),
              AccountScreen.routeName: (_) => const AccountScreen(),
              SignInScreen.routeName: (_) => const SignInScreen(),
              SignUpScreen.routeName: (_) => const SignUpScreen(),
              AddressesScreen.routeName: (_) => const AddressesScreen(),
              ShopScreen.routeName: (_) => const ShopScreen(),
              MyAdsScreen.routeName: (_) => const MyAdsScreen(),
              MyDataScreen.routeName: (_) => const MyDataScreen(),
              FavoritesScreen.routeName: (_) => const FavoritesScreen(),
              BoardgamesScreen.routeName: (_) => const BoardgamesScreen(),
              ToolsScreen.routeName: (_) => const ToolsScreen(),
              BagScreen.routeName: (_) => const BagScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case PaymentScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final bag = settings.arguments as List<BagItemModel>;
                    return PaymentScreen(
                      items: bag,
                    );
                  });
                case PaymentSessionScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final sessionUrl = settings.arguments as String;
                    return PaymentSessionScreen(
                      sessionUrl: sessionUrl,
                    );
                  });
                case EditBoardgamesScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final bg = settings.arguments as BoardgameModel?;
                    return EditBoardgamesScreen(bg);
                  });
                case EditAdScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final ad = settings.arguments as AdModel?;
                    return EditAdScreen(ad: ad);
                  });

                case ProductScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final ad = settings.arguments as AdModel;

                    return ProductScreen(ad: ad);
                  });

                case FiltersScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final filter = settings.arguments as FilterModel?;

                    return FiltersScreen(filter);
                  });

                case MechanicsScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final selectedPsIds = settings.arguments as List<String>;

                    return MechanicsScreen(
                      selectedMechIds: selectedPsIds,
                    );
                  });

                case EditAddressScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final address = settings.arguments as AddressModel?;

                    return EditAddressScreen(
                      address: address,
                    );
                  });
                case ViewBoardgame.routeName:
                  return MaterialPageRoute(builder: (context) {
                    final bg = settings.arguments as BoardgameModel;

                    return ViewBoardgame(bg);
                  });
                default:
                  return null;
              }
            },
          );
        });
  }
}
