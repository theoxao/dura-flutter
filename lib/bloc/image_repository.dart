import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageRepository extends BaseRepository {
  ImageRepository(BuildContext context) : super(context);

  Future<String> upload(String name , Uint8List bytes) async{
    String path = host + "image/upload";
    FormData body = FormData();
    final MultipartFile file = MultipartFile.fromBytes(bytes, filename: name);
    MapEntry<String, MultipartFile> imageEntry = MapEntry("image", file);
    body.files.add(imageEntry);
    var response = await request.post(path , data: body);
    debugPrint("response: ${response.data.toString()}");
    return response.data['data'];
  }
}
