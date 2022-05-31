import 'package:cached_network_image/cached_network_image.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/Item.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

class ItemListWidget extends StatefulWidget {
  final Item item;

  const ItemListWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    ExpandableThemeData defaults = ExpandableThemeData.defaults;
    ExpandableThemeData theme = ExpandableThemeData(tapHeaderToExpand: false);

    return ExpandablePanel(
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name ?? "",
                  style: bodyMe,
                ),
                Row(
                  children: [
                    const Text("规格:"),
                    Text(
                      widget.item.spec ?? "",
                      style: bodySm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: widget.item.images
                    ?.take(3)
                    .map((image) => ImageNetwork(
                          width: 100.w,
                          height: 100.w,
                          image: image,
                          imageCache: CachedNetworkImageProvider(image),
                        ).pa(4.0))
                    .toList() ?? [],
          )
        ],
      ),
      collapsed: Container(),
      expanded: Column(
        children: [
          Row(
            children: [const Text("ISBN:"), Text(widget.item.isbn??"")],
          ),
        ],
      ),
      theme: ExpandableThemeData.combine(theme, defaults),
    );
  }
}
