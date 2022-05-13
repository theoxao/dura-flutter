import 'dart:developer';

import 'package:duraemon_flutter/bloc/good_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/Item_detail.dart';
import 'package:duraemon_flutter/model/good_base_info.dart';
import 'package:duraemon_flutter/model/good_suggestion.dart';
import 'package:duraemon_flutter/model/request_model.dart';
import 'package:duraemon_flutter/widgets/category_select_widget.dart';
import 'package:duraemon_flutter/widgets/image_select_widget.dart';
import 'package:duraemon_flutter/widgets/search_choice_widget.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';

class GoodAddPage extends StatefulWidget {
  const GoodAddPage({Key? key}) : super(key: key);

  @override
  State<GoodAddPage> createState() => _GoodAddPageState();
}

class _GoodAddPageState extends State<GoodAddPage> {
  final _nameEditCtl = TextEditingController();
  final _descEditCtl = TextEditingController();

  final detailFieldList = [
    "name" , "desc" , "pd" , "qty", "best_favor", "storage" , "storage_used", "cost"
  ];

  final Map<String, TextEditingController> detailCtlMap = {};
  final Map<String, FocusNode> detailFnMap = {};

  final _descFocusNode = FocusNode();
  final _suggestionBloc = GoodSuggestionBloc();
  ValueNotifier<NewGoodRequest> addGoodRequest =
      ValueNotifier(NewGoodRequest());
  ValueNotifier<ItemDetail> itemDetail = ValueNotifier(ItemDetail());

  ValueNotifier<int> currentStep = ValueNotifier(0);
  final defaultTitle = "add good";
  late String appBarTitle;
  int? goodId;

  @override
  void initState() {
    super.initState();
    addGoodRequest =  ValueNotifier(NewGoodRequest());
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
              appBarTitle = defaultTitle;
            }
            break;
          case 1:
            {
              appBarTitle = _nameEditCtl.text;
            }
            break;
          case 2:
            {
              appBarTitle = _nameEditCtl.text;
            }
            break;
        }
      });
    });
    appBarTitle = defaultTitle;
    for (var field in detailFieldList) {
      var ctl  =TextEditingController();
      ctl.addListener(() {
        var value = ItemDetail.fromJson(itemDetail.value.toJson());
        value.desc = ctl.text;
        itemDetail.value = value;
      });
      detailCtlMap[field] =ctl ;
      detailFnMap[field] = FocusNode();
    }
  }

  bool checkNextEnable() {
    if (currentStep.value == 1 &&
        addGoodRequest.value.cate != null &&
        addGoodRequest.value.images.isNotEmpty) {
      return true;
    }
    if (currentStep.value == 2 && goodId!=null) {
      return true;
    }
    return false;
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
                      Center(
                          child: Text(item.name ?? "undefined").pa(8)),
                      if (item.goodId != null)
                        const Icon(Icons.explore_rounded)
                    ],
                  ));
            },
            textEditingController: _nameEditCtl,
            onItemSelected: (GoodSuggestion item) {
              _nameEditCtl.text = item.name ?? "undefined";
              if(item.goodId!=null){
                addGoodRequest.value.id = item.goodId;
              }
              //jump to next step
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
              value.cate =category?.id;
              addGoodRequest.value = value;
            });
          }).pa(8),
          TextField(
            controller: _descEditCtl,
            focusNode: _descFocusNode,
            maxLines: 8,
            minLines: 4,
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
              hintText: "Description...",
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 20,
                top: 14,
                bottom: 14,
              ),
            ),
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
      title: const Text("detail"),
      content:Material(
        child: Column(
          children: [
            detailTF("name"),
            detailTF("desc"),
            detailTF("qty", type: TextInputType.number),
            detailTF("storage"),
            detailTF("storage_used"),
            detailTF("cost", type: const TextInputType.numberWithOptions(decimal: true))
          ],
        ),
      ),
    );


    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          actions: [
            if (checkNextEnable())
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (currentStep.value == 1) {
                    GoodRepository(context).addGood(addGoodRequest.value).then((value) {
                      setState(() {
                        currentStep.value = 2;
                        goodId = value.id;
                      });
                    });
                  } else {
                    //submit good detail
                  }
                },
              )
          ],
        ),
        body: EnhanceStepper(
          onStepTapped: (step) {
            currentStep.value = step;
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container();
          },
          currentStep: currentStep.value,
          type: StepperType.horizontal,
          steps: [
            step1,
            step2,
            step3
          ],
        ));
  }

  Widget detailTF(String key , {TextInputType type = TextInputType.text}){
    return TextField(
      controller: detailCtlMap[key],
      focusNode: detailFnMap[key],
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      keyboardType: type,
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
        hintText: key,
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 20,
          top: 14,
          bottom: 14,
        ),
      ),
    ).pa(8);
  }

}
