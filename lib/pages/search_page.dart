import 'package:cached_network_image/cached_network_image.dart';
import 'package:duraemon_flutter/bloc/search_bloc.dart';
import 'package:duraemon_flutter/model/search_result.dart';
import 'package:duraemon_flutter/pages/good/good_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:loadmore/loadmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constant.dart';
import '../common/extensions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _histories = [];
  late SharedPreferences _sp;

  var hasMore = true;

  final TextEditingController _searchTextController = TextEditingController();

  final _searchBloc = SearchBloc();

  @override
  void dispose() {
    _searchBloc.close();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _searchBloc.bindContext(context);
    SharedPreferences.getInstance().then((sp) {
      var list = sp.getStringList("search_history");
      setState(() {
        _histories = list ?? List.empty();
      });
    });
    super.initState();
    _loadMore(word: "name");
  }

  searchSubmit(keyword) {
    _reset();
    _loadMore(word: keyword);
    //save search history
    SharedPreferences.getInstance().then((sp) {
      var list = sp.getStringList("search_history");
      list ??= List.empty(growable: true);
      if (list.length > maxHistory) {
        list.removeAt(0);
      }
      list.add(keyword);
      sp.setStringList("search_history", list);
      setState(() {
        _histories = list ?? List.empty(growable: true);
      });
    });
  }

  clearHistory() {
    //clear history
    setState(() {
      _histories = List.empty();
    });
    SharedPreferences.getInstance().then((sp) => sp.remove("search_history"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: searchSubmit,
                    autofocus: true,
                    controller: _searchTextController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: defaultOutlineBorder,
                    ),
                  ).scale(0.85),
                ),
                const Text("Cancel").gesture(onTap: () {
                  Navigator.of(context).pop();
                }).pa(16.0)
              ],
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Text("search history"),
                  const Spacer(),
                  const Icon(Icons.delete).onTap(clearHistory)
                ],
              ),
            ),
            SizedBox(
              width: 740.w,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: _histories.reversed
                    .map((word) => Chip(
                          backgroundColor: Colors.grey.shade200,
                          label: Text(word),
                        ).pa(6.0).onTap(() {
                          _searchTextController.text = word;
                          _reset();
                          _searchBloc.initData(word);
                        }))
                    .toList(),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: _searchBloc.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SearchResult>> snapshot) {
                    var list = snapshot.data?.toList();
                    if (snapshot.hasData && list != null) {
                      return LoadMore(
                        isFinish: !hasMore,
                        onLoadMore: _loadMore,
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return buildListView(list[index], context);
                            }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ).pa(16.0),
      ),
    );
  }

  Widget buildListView(SearchResult item, BuildContext _){
    return Card(
      elevation: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name??"",style: titleMe,),
                Text(
                  item.desc??"",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis ,
                  style: bodySm,
                ).pad(pt8)
              ],
            ).pa(8.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
              item.images?.map((url) =>
                  ImageNetwork(
                    width: 125.w,
                    height:125.w,
                    image: url,
                    imageCache: CachedNetworkImageProvider(url),
                  ).pa(4.0)
              ).toList()?? [],
          ).pa(8.0)
        ],
      ),
    ).onTap(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GoodPage(item.id!)));
    });
  }

  Future<bool> _loadMore({String? word}) async{
    var size = await _searchBloc.loadMore(word ?? _searchTextController.text);
    setState(() {
      hasMore = size > 0;
    });
    return true;
  }

  void _reset(){
    _searchBloc.empty();
    setState(() {
      hasMore = true;
    });
  }
}
