import 'package:flutter/material.dart';

import '/core/singletons/current_user.dart';
import '/core/utils/utils.dart';
import '/get_it.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = getIt<CurrentUser>();

    return DrawerHeader(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    currentUser.isLogged
                        ? Utils.title(currentUser.user!.name!)
                        : 'Acessar sua conta agora!',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(currentUser.isLogged
                      ? currentUser.user!.email
                      : 'Click aqui!'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
