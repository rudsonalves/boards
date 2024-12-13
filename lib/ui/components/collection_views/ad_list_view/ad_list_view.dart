import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/ad.dart';
import '../../../features/shop/product/product_screen.dart';
import 'widgets/ad_card_view.dart';
import 'widgets/dismissible_ad.dart';

class AdListView extends StatefulWidget {
  final List<AdModel> ads;
  final Future<void> Function() getMoreAds;
  final Future<bool> Function(AdModel)? updateAdStatus;
  final ScrollController scrollController;
  final bool buttonBehavior;
  final bool enableDismissible;
  final Function(AdModel ad)? editAd;
  final Function(AdModel ad)? deleteAd;

  const AdListView({
    super.key,
    required this.ads,
    required this.getMoreAds,
    this.updateAdStatus,
    required this.scrollController,
    required this.buttonBehavior,
    this.enableDismissible = false,
    this.editAd,
    this.deleteAd,
  });

  @override
  State<AdListView> createState() => _AdListViewState();
}

class _AdListViewState extends State<AdListView> {
  late ScrollController _scrollController;
  List<AdModel> get ads => widget.ads;
  double _scrollPosition = 0;
  bool _isScrolling = false;

  @override
  initState() {
    super.initState();
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

  Widget _editButon(AdModel ad) {
    return IconButton(
      onPressed: () {
        if (widget.editAd != null) widget.editAd!(ad);
      },
      icon: Icon(
        Icons.edit,
        color: Colors.yellowAccent.withValues(alpha: 0.65),
      ),
    );
  }

  Widget _deleteButton(AdModel ad) {
    return IconButton(
      onPressed: () {
        if (widget.deleteAd != null) widget.deleteAd!(ad);
      },
      icon: Icon(
        Icons.delete,
        color: Colors.redAccent.withValues(alpha: 0.65),
      ),
    );
  }

  void _showAd(AdModel ad) {
    Navigator.pushNamed(
      context,
      ProductScreen.routeName,
      arguments: ad,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      controller: _scrollController,
      itemCount: ads.length,
      itemBuilder: (context, index) => SizedBox(
        height: 150,
        child: Stack(
          children: [
            InkWell(
              onTap: () => _showAd(ads[index]),
              child: widget.enableDismissible
                  ? DismissibleAd(
                      ad: ads[index],
                      adStatus: ads[index].status,
                      updateAdStatus: widget.updateAdStatus,
                    )
                  : AdCardView(
                      ads: ads[index],
                    ),
            ),
            if (widget.buttonBehavior)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _editButon(ads[index]),
                        _deleteButton(ads[index]),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
