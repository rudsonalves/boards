import 'package:flutter/material.dart';

import '../../../../features/account/my_ads/model/my_ads_dismissible.dart';
import '/core/models/ad.dart';
import '../../../widgets/base_dismissible_container.dart';
import 'ad_card_view.dart';

class DismissibleAd extends StatelessWidget {
  final AdModel ad;
  final AdStatus adStatus;
  final Function(AdModel)? updateAdStatus;

  const DismissibleAd({
    super.key,
    required this.ad,
    required this.adStatus,
    this.updateAdStatus,
  });

  @override
  Widget build(BuildContext context) {
    final dismiss = MyAdsDsimissible(adStatus: adStatus);

    return Dismissible(
      // FIXME: select direction to disable unnecessary shifts
      // direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: baseDismissibleContainer(
        context,
        alignment: Alignment.centerLeft,
        color: dismiss.color(DismissSide.left),
        icon: dismiss.iconData(DismissSide.left),
        label: dismiss.label(DismissSide.left),
      ),
      secondaryBackground: baseDismissibleContainer(
        context,
        alignment: Alignment.centerRight,
        color: dismiss.color(DismissSide.right),
        icon: dismiss.iconData(DismissSide.right),
        label: dismiss.label(DismissSide.right),
      ),
      child: AdCardView(
        ads: ad,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (updateAdStatus != null &&
              dismiss.status(DismissSide.left) != null) {
            ad.status = dismiss.status(DismissSide.left)!;
            updateAdStatus!(ad);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          if (updateAdStatus != null &&
              dismiss.status(DismissSide.right) != null) {
            ad.status = dismiss.status(DismissSide.right)!;
            updateAdStatus!(ad);
          }
          return false;
        }
        return false;
      },
    );
  }
}
