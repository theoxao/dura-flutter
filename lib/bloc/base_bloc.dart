import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


abstract class BaseBloc<T>{
  late BuildContext context;

  final _subject = BehaviorSubject<T>();

  void bindContext(BuildContext context) {
    this.context=context;
  }

  Stream<T> get stream => _subject.stream;

  Sink<T> get sink => _subject.sink;

  void close(){
    _subject.close();
  }
}