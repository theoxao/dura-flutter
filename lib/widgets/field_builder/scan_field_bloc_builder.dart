import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:scan/scan.dart';

class ScanFieldBlocBuilder extends StatefulWidget {
  final String? name;
  final void Function(String)? onchange;

  const ScanFieldBlocBuilder(
      {Key? key, required this.inputFieldBloc, this.name, this.onchange})
      : super(key: key);

  final InputFieldBloc<String, Object> inputFieldBloc;

  @override
  _ScanFieldBlocBuilderState createState() => _ScanFieldBlocBuilderState();
}

class _ScanFieldBlocBuilderState extends State<ScanFieldBlocBuilder> {
  var _textController =  TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScanFieldBlocBuilder oldWidget) {
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
        return BlocBuilder<InputFieldBloc<String, Object>,
            InputFieldBlocState<String, Object>>(
          bloc: widget.inputFieldBloc,
          builder: (context, state) {
            return TextField(
              controller: _textController,
              onChanged: widget.onchange,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.qr_code).onTap(() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ScanView(
                        onCapture: (value){
                          widget.inputFieldBloc.updateValue(value);
                          _textController.text = value;
                          Navigator.of(context).pop();
                        },
                      )));
                }),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x4437474F),
                  ),
                ),
                border: InputBorder.none,
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // hintText: key,
                label: Text(widget.name ?? "Code"),
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              ),
            ).pad(pv8);
          },
        );
      },
    );
  }
}
