import 'dart:developer';

import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

typedef QueryListItemBuilder<T> = Widget Function(T item);
typedef OnItemSelected<T> = void Function(T item);
typedef SelectedItemBuilder<T> = Widget Function(
  T item
);

typedef TextFieldBuilder = Widget Function(
  TextEditingController controller,
  FocusNode focus,
);

typedef FutureData<T> = Future<List<T>> Function(String text);

class SearchChoiceWidget<T> extends StatefulWidget {

  const SearchChoiceWidget({
    required this.popupListItemBuilder,
    required this.futureData,
    required this.onAddTapped,
    this.textEditingController,
    Key? key,
    this.onItemSelected,
    this.hideSearchBoxWhenItemSelected = false,
    this.listContainerHeight,
    this.noItemsFoundWidget,
    this.textFieldBuilder,

  }) : super(key: key);

  final GestureTapCallback onAddTapped;
  final FutureData<T> futureData;
  final TextEditingController? textEditingController;
  final QueryListItemBuilder<T> popupListItemBuilder;
  final bool? hideSearchBoxWhenItemSelected;
  final double? listContainerHeight;
  final TextFieldBuilder? textFieldBuilder;
  final Widget? noItemsFoundWidget;

  final OnItemSelected<T>? onItemSelected;

  @override
  MySingleChoiceSearchState<T> createState() => MySingleChoiceSearchState<T>();
}

class MySingleChoiceSearchState<T> extends State<SearchChoiceWidget<T>> {
  var selected = false;
  late TextEditingController _controller;
  late List<T> _tempList;
  bool isFocused = false;
  late FocusNode _focusNode;
  late ValueNotifier<T?> notifier;
  bool? isRequiredCheckFailed;
  Widget? textField;
  OverlayEntry? overlayEntry;
  bool showTextBox = false;
  double listContainerHeight = 250;
  final LayerLink _layerLink = LayerLink();
  final double textBoxHeight = 48;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    setState(() {
      selected = false;
    });
    _controller = widget.textEditingController ?? TextEditingController();
    _tempList = <T>[];
    notifier = ValueNotifier<T?>(null);
    _focusNode = FocusNode();
    isFocused = false;
    _tempList.addAll([]);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // _controller.clear();
        if (overlayEntry != null) {
          overlayEntry?.remove();
        }
        overlayEntry = null;
      } else {
        setState(() {
          selected = false;
        });
        if(_controller.text.trim().isNotEmpty){
          widget.futureData(_controller.text).then((list) {
            _tempList = list;
            if (overlayEntry == null) {
              onTap();
            } else {
              overlayEntry?.markNeedsBuild();
            }
          });
        }else{
          _tempList
            ..clear()
            ..addAll([]);
          if (overlayEntry == null) {
            onTap();
          } else {
            overlayEntry?.markNeedsBuild();
          }
        }
      }
    });
    _controller.addListener(() {
      final text = _controller.text;
      if (text.trim().isNotEmpty && !selected) {
        _tempList.clear();
        widget.futureData(text).then((list) {
          _tempList = list;
          if (overlayEntry == null) {
            onTap();
          } else {
            overlayEntry?.markNeedsBuild();
          }
        });
      } else {
        _tempList
          ..clear()
          ..addAll([]);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry?.markNeedsBuild();
        }
      }
    });
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    listContainerHeight =
        widget.listContainerHeight ?? MediaQuery.of(context).size.height / 4;
    textField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          suffixIcon: const Icon(Icons.add).onTap(widget.onAddTapped),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          // suffixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.hideSearchBoxWhenItemSelected ??
            true && notifier.value != null)
          const SizedBox(height: 0)
        else
          CompositedTransformTarget(
            link: _layerLink,
            child: textField,
          ),
      ],
    );
    return column;
  }

  void onDropDownItemTap(T item) {
    debugPrint("item tapped");
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }
    overlayEntry = null;
    // _controller.clear();
    _focusNode.unfocus();
    // setState(() {
    //   notifier.value = item;
    //   isFocused = false;
    //   isRequiredCheckFailed = false;
    // });

    setState(() {
      selected = true;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  void onTap() {
    final RenderBox textFieldRenderBox =
        context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    final width = textFieldRenderBox.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        textFieldRenderBox.localToGlobal(
          textFieldRenderBox.size.topLeft(Offset.zero),
          ancestor: overlay,
        ),
        textFieldRenderBox.localToGlobal(
          textFieldRenderBox.size.topRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    overlayEntry = OverlayEntry(
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return Positioned(
          left: position.left,
          width: width,
          child: CompositedTransformFollower(
            offset: Offset(
              0,
              height - position.bottom < listContainerHeight
                  ? (textBoxHeight + 6.0)
                  : -(listContainerHeight - 8.0),
            ),
            showWhenUnlinked: false,
            link: _layerLink,
            child: Container(
              height: listContainerHeight,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: _tempList.isNotEmpty
                    ? Scrollbar(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                          itemBuilder: (context, index) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onDropDownItemTap(_tempList[index]),
                              child: widget.popupListItemBuilder(
                                _tempList.elementAt(index),
                              ),
                            ),
                          ),
                          itemCount: _tempList.length,
                        ),
                      )
                    : widget.noItemsFoundWidget != null
                        ? Center(
                            child: widget.noItemsFoundWidget,
                          )
                        : const NoItemFound(),
              ),
            ),
          ),
        );
      },
    );
    if (overlayEntry != null) {
      Overlay.of(context)?.insert(overlayEntry!);
      overlayEntry?.markNeedsBuild();
    }
  }


  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }
    // _focusNode.dispose();
    // _controller.dispose();
    overlayEntry = null;
    super.dispose();
  }
}


class NoItemFound extends StatelessWidget {
  final String title;
  final IconData icon;

  const NoItemFound({
    this.title = "No data found",
    this.icon = Icons.folder_open,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 24, color: Colors.grey[900]?.withOpacity(0.7)),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[900]?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
