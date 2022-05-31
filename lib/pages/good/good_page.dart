import 'package:cached_network_image/cached_network_image.dart';
import 'package:duraemon_flutter/bloc/good_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/good_base_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:loading/loading.dart';

class GoodPage extends StatefulWidget {
  final int id;

  const GoodPage(this.id, {Key? key}) : super(key: key);

  @override
  State<GoodPage> createState() => _GoodPageState();
}

class _GoodPageState extends State<GoodPage> {
  late int id;
  final _goodDetailBloc = GoodInfoBloc();

  @override
  void initState() {
    id = widget.id;
    _goodDetailBloc.bindContext(context);
    _goodDetailBloc.goodInfo(id);
    super.initState();
  }

  @override
  void dispose() {
    _goodDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _goodDetailBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<GoodBaseInfo> snapshot) {
          if (snapshot.hasData) {
            var info = snapshot.data;
            if (info == null) {
              return Center(child: Loading(size: 100.0));
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  info.name ?? "",
                  style: titleMe,
                ),
                leading: const Icon(Icons.arrow_back_ios).onTap(() {
                  Navigator.pop(context);
                }),
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 240.w,
                      width: 750.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: info.images
                                ?.map((url) => ImageNetwork(
                                      width: 220.w,
                                      height: 220.w,
                                      image: url,
                                      imageCache:
                                          CachedNetworkImageProvider(url),
                                    ).pa(4.0))
                                .toList() ??
                            [],
                      ).pad(ph8),
                    ),
                    Row(
                      children: [
                        Chip(label: Text(info.cateStr ?? "")).pa(8),
                        Chip(label: Text(info.subCateStr ?? "")).pa(8)
                      ],
                    ),
                    Text(
                      info.desc ?? "",
                      style: bodyMe,
                    ).pa(8),
                    Divider(),
                  ]),
            );
          }
          return Center(child: Loading(size: 100.0));
        });
  }
}
