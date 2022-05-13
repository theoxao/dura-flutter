import 'dart:developer';

import 'package:duraemon_flutter/bloc/category_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/category.dart';
import 'package:flutter/material.dart';
import 'package:ktx/collections.dart';

class CategorySelector extends StatefulWidget {
  final void Function(Category? category) onSelected;

  const CategorySelector({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final _categoryListBloc = CategoryListBloc();
  final _categoryEditCtl = TextEditingController();
  final _categoryFocusNode= FocusNode();

  List<Category> selectedCategories = [];

  @override
  void initState() {
    _categoryListBloc.bindContext(context);
    _categoryListBloc.categories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _categoryListBloc.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          return TextField(
            controller: _categoryEditCtl,
            focusNode: _categoryFocusNode,
            onTap: () {
              if (snapshot.hasData && snapshot.data != null) {
                var list = snapshot.data!;
                var category = Category(id: 0, name: "全部", children: list);
                setState(() {
                  selectedCategories = [category];
                });
                showCategorySelectDialog(context, category).then((cate){
                  _categoryEditCtl.text = selectedCategories.sublist(1,selectedCategories.length).map((it) =>it.name ).join(">")+">"+(cate?.name??"");
                  widget.onSelected(cate);
                  _categoryFocusNode.unfocus();
                });
              }
            },
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x4437474F),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              // suffixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              hintText: "Select Category...",
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 20,
                top: 14,
                bottom: 14,
              ),
            ),
          );
        });
  }

  Future<Category?> showCategorySelectDialog(
      BuildContext context, Category list) async {
    return await showModalBottomSheet<Category>(
        constraints: BoxConstraints.tight(const Size.fromHeight(450)),
        context: context,
        elevation: 6,
        backgroundColor: Colors.white,
        builder: (context) {
          var children = list.children;
          return StatefulBuilder(
            builder: (_, setSelectState) {
              var rows = selectedCategories.sublist(0,selectedCategories.length-1).mapIndexed((index, cate) {
                return Text(cate.name).pa(8).onTap(() {
                  setSelectState(() {
                    selectedCategories.removeRange(
                        index + 1, selectedCategories.length);
                    children = cate.children;
                  });
                });
              }).toList()
                ..add(PhysicalModel(
                    color: Colors.white,
                    elevation: 3,
                    child: Text(selectedCategories.last.name).pa(12)));
              return Column(children: [
                Row(
                  children: rows,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        var cate = children?.elementAt(index);
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setSelectState(() {
                                if (cate?.children?.isNotEmpty == true) {
                                  selectedCategories =
                                      selectedCategories.toList()..add(cate!);
                                  children = cate.children;
                                } else {
                                  Navigator.pop(context, cate);
                                }
                              });
                            },
                            child: SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    Center(
                                        child: Text(cate?.name ?? "undefined")
                                            .pa(8)),
                                    const Spacer(),
                                    if (cate?.children?.isNotEmpty == true)
                                      const Icon(Icons.chevron_right_rounded)
                                  ],
                                )),
                          ),
                        );
                      },
                      itemCount: children?.length ?? 0,
                    ),
                  ),
                )
              ]);
            },
          );
        });
  }
}
