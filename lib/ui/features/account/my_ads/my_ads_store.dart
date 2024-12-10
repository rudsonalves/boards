import '../../../../data/models/ad.dart';
import '../../../components/state/state_store.dart';

class MyAdsStore extends StateStore {
  static const int pendingIndex = 0;
  static const int activeIndex = 1;
  static const int soldIndex = 2;

  AdStatus selectedTab = AdStatus.active;

  int get selectedTabIndex => selectedTab.index;
  String get selectedTabName => selectedTab.name;
}
