import 'dart:developer';
import 'dart:typed_data';

import 'package:duraemon_flutter/bloc/image_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ktx/standard.dart';
import 'package:ktx/collections.dart';

class ImageSelector extends StatefulWidget {
  final void Function(List<String> list) selectedImage;
  final InputFieldBloc<List<String>, Object>? inputFieldBloc;

  const ImageSelector({Key? key, required this.selectedImage,  this.inputFieldBloc}) : super(key: key);

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  List<ImageHolder> files = [];
  ValueNotifier<List<String>> paths = ValueNotifier([]);
  List<Widget> rows = [];
  late ImageRepository _imageRepository ;

  @override
  void initState() {
    paths.addListener(() {
      widget.selectedImage(paths.value);
      widget.inputFieldBloc?.updateValue(paths.value);
    });
    _imageRepository = ImageRepository(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rows = files.mapIndexed((index, file) {
      return Material(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onLongPress: (){
              setState(() {
                files.removeAt(index);
                paths.value.removeAt(index);
                paths.notifyListeners();
              });
            },
            child: Image.memory(
              file.bytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();
    return images(rows);
  }

  Widget images(List<Widget> list) {
    if (list.length < 10) {
      rows.add(Image.asset(
        "image/add-image.png",
        scale: 0.5,
      ).onTap( () {
        showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(64.0),
              child: Center(
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          selectImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          child: Center(
                            child: Text(
                              "拍照",
                              style: bodySm,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          selectImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          child: Center(
                            child: Text(
                              "从相册选择",
                              style: bodySm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }));
    }
    return Center(
      child: GridView.custom(
        shrinkWrap:true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        childrenDelegate: SliverChildListDelegate(rows),
        controller: ScrollController(keepScrollOffset: false),
      ),
    );
  }

  selectImage(ImageSource source) async {
    try {
      var file = await (await ImagePicker().pickImage(source: source))?.let((image) async{
        var bytes = await image.readAsBytes();
        var path  = await _imageRepository.upload(image.name, bytes);
        return ImageHolder(path, bytes);
      });
      setState(() {
        if(file!=null){
          files.add(file);
          paths.value = files.map((e) => e.path).toList();
        }
      });
    } on Exception catch (_, e) {
      debugPrint("select image cancelled: ${e.toString()}");
    }
  }
}

class ImageHolder{
  final String path;
  final Uint8List bytes;

  ImageHolder(this.path, this.bytes);
}