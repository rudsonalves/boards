import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/ad.dart';
import '../../../features/shop/product/product_screen.dart';
import 'widgets/ad_shop_view.dart';

enum ButtonBehavior { edit, delete }

class ShopGridView extends StatefulWidget {
  final List<AdModel> ads;
  final Future<void> Function() getMoreAds;
  final ScrollController scrollController;
  final ButtonBehavior? buttonBehavior;
  final Function(AdModel ad)? editAd;
  final Function(AdModel ad)? deleteAd;

  const ShopGridView({
    super.key,
    required this.ads,
    required this.getMoreAds,
    required this.scrollController,
    this.buttonBehavior,
    this.editAd,
    this.deleteAd,
  });

  @override
  State<ShopGridView> createState() => _ShopGridViewState();
}

class _ShopGridViewState extends State<ShopGridView> {
  late ScrollController _scrollController;
  // late final ShopController ctrl;
  double _scrollPosition = 0;
  bool _isScrolling = false;

  @override
  initState() {
    super.initState();

    // ctrl = widget.ctrl;
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.hasClients &&
        _scrollController.position.atEdge &&
        !_isScrolling) {
      final isBottom = _scrollController.position.pixels != 0;
      if (isBottom) {
        _scrollPosition = _scrollController.position.pixels;
        _isScrolling = true;
        await widget.getMoreAds();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _scrollController.animateTo(
          //   _scrollPosition,
          //   duration: const Duration(microseconds: 300),
          //   curve: Curves.easeInOut,
          // );
          _scrollController.jumpTo(_scrollPosition);
          _isScrolling = false;
        });
      }
    }
  }

  Widget showImage(String image) {
    if (image.isEmpty) {
      final color = Theme.of(context).colorScheme.secondaryContainer;
      return Icon(
        Icons.image_not_supported_outlined,
        color: color,
        size: 150,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
      );
    }
  }

  Widget? getItemButton(int index) {
    final ad = widget.ads[index];

    switch (widget.buttonBehavior) {
      case null:
        return null;
      case ButtonBehavior.edit:
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (widget.editAd != null) widget.editAd!(ad);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.edit,
              color: Colors.yellowAccent.withOpacity(0.65),
            ),
          ),
        );
      case ButtonBehavior.delete:
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (widget.deleteAd != null) widget.deleteAd!(ad);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.redAccent.withOpacity(0.65),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3.4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      controller: _scrollController,
      itemCount: widget.ads.length,
      itemBuilder: (context, index) => SizedBox(
        // height: 150,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductScreen.routeName,
              arguments: widget.ads[index],
            );
          },
          child: AdShopView(
            ad: widget.ads[index],
          ),
        ),
      ),
    );
  }
}
