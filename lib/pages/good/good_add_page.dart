import 'package:duraemon_flutter/bloc/brand_bloc.dart';
import 'package:duraemon_flutter/bloc/category_bloc.dart';
import 'package:duraemon_flutter/bloc/good_bloc.dart';
import 'package:duraemon_flutter/bloc/item_bloc.dart';
import 'package:duraemon_flutter/bloc/item_detail_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/Item.dart';
import 'package:duraemon_flutter/model/Item_detail.dart';
import 'package:duraemon_flutter/model/category.dart';
import 'package:duraemon_flutter/model/good_suggestion.dart';
import 'package:duraemon_flutter/model/request_model.dart';
import 'package:duraemon_flutter/widgets/category_select_widget.dart';
import 'package:duraemon_flutter/widgets/field_builder/image_select_field_bloc_builder.dart';
import 'package:duraemon_flutter/widgets/field_builder/image_select_widget.dart';
import 'package:duraemon_flutter/widgets/field_builder/peroid_field_bloc_builder.dart';
import 'package:duraemon_flutter/widgets/field_builder/scan_field_bloc_builder.dart';
import 'package:duraemon_flutter/widgets/item_list_view.dart';
import 'package:duraemon_flutter/widgets/search_choice_widget.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GoodAddPage extends StatefulWidget {
  const GoodAddPage({Key? key}) : super(key: key);

  @override
  State<GoodAddPage> createState() => _GoodAddPageState();
}

class _GoodAddPageState extends State<GoodAddPage> {
  final _nameEditCtl = TextEditingController();
  final _descEditCtl = TextEditingController();
  final _descFocusNode = FocusNode();
  final _suggestionBloc = GoodSuggestionBloc();
  ValueNotifier<NewGoodRequest> addGoodRequest =
      ValueNotifier(NewGoodRequest());
  ValueNotifier<ItemDetail> itemDetail = ValueNotifier(ItemDetail());

  ValueNotifier<int> currentStep = ValueNotifier(2);
  final defaultTitle = "添加物品";
  late String appBarTitle;
  int? goodId;
  Item? selectItem;
  List<Item> itemList = [];
  ItemDetailFormBloc? itemDetailFormBloc;
  ItemFormBloc? itemFormBloc;
  final ItemListBloc _itemListBloc = ItemListBloc();
  List<String> storageCandidate = [];

  @override
  void initState() {
    super.initState();

    //for test
    goodId = 4;

    _itemListBloc.bindContext(context);
    addGoodRequest = ValueNotifier(NewGoodRequest());
    _suggestionBloc.bindContext(context);
    _nameEditCtl.addListener(() {
      setState(() {
        var value = NewGoodRequest().from(addGoodRequest.value);
        value.name = _nameEditCtl.text;
        addGoodRequest.value = value;
      });
    });
    _descEditCtl.addListener(() {
      setState(() {
        var value = NewGoodRequest().from(addGoodRequest.value);
        value.desc = _descEditCtl.text;
        addGoodRequest.value = value;
      });
    });
    currentStep.addListener(() {
      setState(() {
        switch (currentStep.value) {
          case 0:
            {
              //good
              appBarTitle = defaultTitle;
            }
            break;
          case 1:
            {
              //category
              appBarTitle = _nameEditCtl.text;
            }
            break;
          case 2:
            {
              //item
              appBarTitle = _nameEditCtl.text;
              if (goodId != null) {
                //RELEASE ME
                // _showOptionItem(goodId!);
              }
            }
            break;
          case 3:
            {
              //item detail
              appBarTitle = _nameEditCtl.text;
            }
            break;
        }
      });
    });
    currentStep.notifyListeners();
    appBarTitle = defaultTitle;
  }

  _showAddBrand() {
    var nameCtl = TextEditingController();
    var catsCtl = TextEditingController();
    List<int> cats = [];
    showDialog<Object>(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(16),
            backgroundColor: Colors.white,
            elevation: 2,
            child: IntrinsicWidth(
              stepWidth: 200.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 280.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(children: [
                      Text(
                        "新增品牌",
                        style: bodyMe,
                      ).pad(const EdgeInsets.only(bottom: 16)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close))
                    ]),
                    TextField(
                      controller: nameCtl,
                      decoration: defaultDecoration("品牌名"),
                    ).pa(8),
                    TextField(
                      controller: catsCtl,
                      decoration: defaultDecoration("分类"),
                      onTap: () async {
                        var cts =
                            await CategoryRepository(context).categories();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          // required for min/max child size
                          context: context,
                          builder: (ctx) {
                            return MultiSelectBottomSheet<Category>(
                              items: cts.map((cate) {
                                return MultiSelectItem<Category>(cate, cate.name);
                              }).toList(),
                              initialValue: [],
                              onConfirm: (list) {
                                catsCtl.text = list.map((e) => e.name).join("/");
                                cats = list.map((e) => e.id).toList();
                              },
                              maxChildSize: 0.8,
                            );
                          },
                        );
                      },
                    ).pa(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              BrandRepository(context)
                                  .addBrand(nameCtl.text, cats)
                                  .then((value){
                                Navigator.of(context).pop();
                                _refreshBrandList();
                              });
                            },
                            child: const Text("确认"))
                      ],
                    )
                  ],
                ),
              ),
            ).pa(16),
          );
        });
  }

  _showOptionItem(int goodId) async {
    ItemRepository(context).list(goodId).then((items) => {
          if (items.isNotEmpty) {
              showModalBottomSheet<Item>(
                  context: context,
                  builder: (context) {
                    itemList = items;
                    return SingleChildScrollView(
                      child: Column(
                        children: items
                            .map((item) =>
                                ItemListWidget(item: item).pa(8).onTap(() {
                                  setState(() {
                                    selectItem = item;
                                  });
                                  itemFormBloc?.set(item);
                                  Navigator.pop(context);
                                  currentStep.value = 3;
                                }))
                            .toList(),
                      ),
                    );
                  })
            }
        });
  }

  bool checkNextEnable(BuildContext context) {
    if (currentStep.value == 1 &&
        addGoodRequest.value.cate != null &&
        addGoodRequest.value.images.isNotEmpty) {
      return true;
    }
    // if (currentStep.value == 2 && goodId != null) {
    return true;
    // }
    return false;
  }

  _refreshBrandList(){
    BrandRepository(context).brandCandidate(null).then((list) {
      for (var element in list) {
        itemFormBloc!.brand.addItem(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var step1 = EnhanceStep(
      title: const Text("good"),
      content: Column(
        children: [
          SearchChoiceWidget(
            popupListItemBuilder: (GoodSuggestion item) {
              return SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Center(child: Text(item.name ?? "undefined").pa(8)),
                      if (item.goodId != null) const Icon(Icons.explore_rounded)
                    ],
                  ));
            },
            textEditingController: _nameEditCtl,
            onItemSelected: (GoodSuggestion item) {
              _nameEditCtl.text = item.name ?? "undefined";
              if (item.goodId != null) {
                addGoodRequest.value.id = item.goodId;
                goodId = item.goodId;
              }
              //jump to next step TODO jump to item if item id is present
              currentStep.value = item.goodId == null ? 1 : 2;
            },
            futureData: (String text) =>
                GoodRepository(context).suggestion(text),
            onAddTapped: () {
              currentStep.value = 1;
            },
          )
        ],
      ),
    );

    var step2 = EnhanceStep(
      title: const Text("category"),
      content: Column(
        children: [
          CategorySelector(onSelected: (category) {
            setState(() {
              var value = NewGoodRequest().from(addGoodRequest.value);
              value.cate = category?.id;
              addGoodRequest.value = value;
            });
          }).pa(8),
          TextField(
            controller: _descEditCtl,
            focusNode: _descFocusNode,
            maxLines: 8,
            minLines: 4,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            decoration: context.defaultDecoration("描述"),
          ).pa(8),
          ImageSelector(
            selectedImage: (List<String> list) {
              setState(() {
                var value = NewGoodRequest().from(addGoodRequest.value);
                value.images = list;
                addGoodRequest.value = value;
              });
            },
          ).pa(8),
        ],
      ),
    );

    var step3 = EnhanceStep(
        title: const Text("item"),
        content: Material(
          child: StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return BlocProvider(
                create: (BuildContext context) => ItemFormBloc(context),
                child: Builder(builder: (context) {
                  itemFormBloc = context.read<ItemFormBloc>();
                  itemFormBloc?.goodId = goodId;
                  GoodRepository(context).storageCandidate(null).then((list) {
                    for (var element in list) {
                      itemFormBloc!.storage.addItem(element);
                      itemFormBloc!.storageUsed.addItem(element);
                    }
                    // itemFormBloc!.storage.updateItems(list);
                    // itemFormBloc!.storageUsed.updateItems(list);
                  });
                  _refreshBrandList();
                  return FormBlocListener<ItemFormBloc, String, String>(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 560.w,
                                child: ScanFieldBlocBuilder(
                                  inputFieldBloc: itemFormBloc!.isbn,
                                  name: "ISBN",
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: SizedBox(
                                    height: 70.h,
                                    width: 70.w,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showOptionItem(goodId!);
                                      },
                                      child:
                                          const Icon(Icons.keyboard_arrow_down),
                                    )),
                              ),
                            ],
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: itemFormBloc!.name,
                            keyboardType: TextInputType.text,
                            decoration: context.defaultDecoration("名称"),
                          ),
                          TextFieldBlocBuilder(
                              textFieldBloc: itemFormBloc!.price,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: context.defaultDecoration("价格")),
                          TextFieldBlocBuilder(
                              textFieldBloc: itemFormBloc!.spec,
                              keyboardType: TextInputType.number,
                              decoration: context.defaultDecoration("规格")),
                          PeriodFieldBlocBuilder(
                            inputFieldBloc: itemFormBloc!.bestFavor,
                            keyboardType: TextInputType.number,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 560.w,
                                child: DropdownFieldBlocBuilder<String>(
                                    selectFieldBloc: itemFormBloc!.brand,
                                    itemBuilder: (context, value) => FieldItem(
                                          child: Text(value),
                                        ),
                                    decoration:
                                        context.defaultDecoration("品牌")),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _showAddBrand();
                                    },
                                    child: const Center(
                                      child: Icon(Icons.add),
                                    )),
                              )
                            ],
                          ),
                          DropdownFieldBlocBuilder<String>(
                              selectFieldBloc: itemFormBloc!.storage,
                              itemBuilder: (context, value) => FieldItem(
                                    child: Text(value),
                                  ),
                              decoration:
                                  context.defaultDecoration("保存方式-未拆封")),
                          DropdownFieldBlocBuilder<String>(
                              selectFieldBloc: itemFormBloc!.storageUsed,
                              itemBuilder: (context, value) => FieldItem(
                                    child: Text(value),
                                  ),
                              decoration:
                                  context.defaultDecoration("保存方式-已拆封")),
                          TextFieldBlocBuilder(
                              textFieldBloc: itemFormBloc!.remark,
                              keyboardType: TextInputType.text,
                              decoration: context.defaultDecoration("备注")),
                          ImageSelectFieldBlocBuilder(
                            inputFieldBloc: itemFormBloc!.images,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ));

    var step4 = EnhanceStep(
        title: const Text("detail"),
        content: Material(
          child: BlocProvider(
            create: (BuildContext context) => ItemDetailFormBloc(context),
            child: Builder(builder: (context) {
              itemDetailFormBloc = context.read<ItemDetailFormBloc>();
              itemDetailFormBloc?.goodId = goodId;
              itemDetailFormBloc?.itemId = selectItem?.id;
              GoodRepository(context).storageCandidate(null).then((list) {
                itemDetailFormBloc!.storage.updateItems(list);
                itemDetailFormBloc!.storageUsed.updateItems(list);
              });
              return FormBlocListener<ItemDetailFormBloc, String, String>(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      TextFieldBlocBuilder(
                        textFieldBloc: itemDetailFormBloc!.name,
                        keyboardType: TextInputType.text,
                        decoration: context.defaultDecoration("名称"),
                      ),
                      TextFieldBlocBuilder(
                          textFieldBloc: itemDetailFormBloc!.desc,
                          keyboardType: TextInputType.text,
                          decoration: context.defaultDecoration("描述")),
                      DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: itemDetailFormBloc!.pd,
                          format: DateFormat("yyyy-MM-dd"),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          decoration: context.defaultDecoration("生产日期")),
                      TextFieldBlocBuilder(
                          textFieldBloc: itemDetailFormBloc!.qty,
                          keyboardType: TextInputType.number,
                          decoration: context.defaultDecoration("数量")),
                      TextFieldBlocBuilder(
                          textFieldBloc: itemDetailFormBloc!.cost,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: context.defaultDecoration("价格")),
                      ImageSelectFieldBlocBuilder(
                        inputFieldBloc: itemDetailFormBloc!.images,
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ));

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          actions: [
            if (checkNextEnable(context))
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (currentStep.value == 1) {
                    GoodRepository(context)
                        .addGood(addGoodRequest.value)
                        .then((value) {
                      setState(() {
                        currentStep.value = 2;
                        goodId = value.id;
                      });
                    });
                  }
                  if (currentStep.value == 2) {
                    itemFormBloc?.goodId = goodId;
                    itemFormBloc?.onSubmitting();
                  } else {
                    if (itemDetailFormBloc != null) {
                      itemDetailFormBloc!.onSubmitting().then((value) {});
                    }
                  }
                },
              )
          ],
        ),
        body: EnhanceStepper(
          // onStepTapped: (step) {
          //   currentStep.value = step;
          // },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container();
          },
          currentStep: currentStep.value,
          type: StepperType.horizontal,
          steps: [step1, step2, step3, step4],
        ));
  }
}
