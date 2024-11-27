// Copyright (C) 2024 rudson
//
// This file is part of xlo_mobx.
//
// xlo_mobx is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_mobx is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_mobx.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../features/account/account_screen.dart';
import '../../core/singletons/app_settings.dart';
import '../../core/singletons/current_user.dart';
import '../../features/edit_ad/edit_ad_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../get_it.dart';
import 'widgets/custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final void Function() setPageTitle;
  final void Function() navToLoginScreen;

  CustomDrawer({
    super.key,
    required this.setPageTitle,
    required this.navToLoginScreen,
  });

  final app = getIt<AppSettings>();
  final currentUSer = getIt<CurrentUser>();

  Future<void> _logout(BuildContext context) async {
    await currentUSer.logout();
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 400));
    setPageTitle();
  }

  void _navAccountScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, AccountScreen.routeName);
  }

  void _navFavoriteScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, FavoritesScreen.routeName);
  }

  void _navEditAdScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, EditAdScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: app.isDark
          ? colorScheme.onSecondary.withOpacity(0.90)
          : colorScheme.onPrimary.withOpacity(0.90),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(35),
        bottomRight: Radius.circular(35),
      )),
      child: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              navToLoginScreen();
            },
            child: const CustomDrawerHeader(),
          ),
          ListTile(
            leading: Icon(
              Icons.camera,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Adicionar Anúncio',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            onTap:
                currentUSer.isLogged ? () => _navEditAdScreen(context) : null,
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Favoritos',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            onTap:
                currentUSer.isLogged ? () => _navFavoriteScreen(context) : null,
          ),
          ListTile(
            leading: Icon(
              color: currentUSer.isLogged ? null : colorScheme.outline,
              Icons.person,
            ),
            title: Text(
              'Minha Conta',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            onTap:
                currentUSer.isLogged ? () => _navAccountScreen(context) : null,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Sair',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            onTap: currentUSer.isLogged ? () => _logout(context) : null,
          ),
        ],
      ),
    );
  }
}
