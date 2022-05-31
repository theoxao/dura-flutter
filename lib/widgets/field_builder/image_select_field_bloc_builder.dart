import 'package:duraemon_flutter/widgets/field_builder/image_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';


class ImageSelectFieldBlocBuilder extends StatefulWidget {
  const ImageSelectFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
  }) : super(key: key);

  final InputFieldBloc<List<String>, Object> inputFieldBloc;

  @override
  _ImageSelectFieldBlocBuilderState createState() => _ImageSelectFieldBlocBuilderState();
}

class _ImageSelectFieldBlocBuilderState extends State<ImageSelectFieldBlocBuilder> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImageSelectFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CanShowFieldBlocBuilder(
      fieldBloc: widget.inputFieldBloc,
      builder: (_, __) {
        return BlocBuilder<InputFieldBloc<List<String>, Object>, InputFieldBlocState<List<String>, Object>>(
          bloc: widget.inputFieldBloc,
          builder: (context, state) {
            return ImageSelector(selectedImage: (List<String> images){
              widget.inputFieldBloc.changeValue(images);
            });
          },
        );
      },
    );
  }

}
