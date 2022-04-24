
import 'package:duraemon_flutter/bloc/request_wrap.dart';
import 'package:flutter/material.dart';

class BaseRepository{
  late RequestWrap request;
  BaseRepository(BuildContext context): request = RequestWrap(context);
}