import 'package:duraemon_flutter/bloc/item_detail_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PeriodFieldBlocBuilder extends StatefulWidget {
  const PeriodFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.keyboardType,

  })  :super(key: key);

  final InputFieldBloc<Period, Object> inputFieldBloc;

  final TextInputType? keyboardType;


  @override
  _PeriodFieldBlocBuilderState createState() => _PeriodFieldBlocBuilderState();
}

class _PeriodFieldBlocBuilderState extends State<PeriodFieldBlocBuilder> {
  late TextEditingController _controller;
  int unit = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.inputFieldBloc.state.value.duration.toString());
    _controller.addListener(_textControllerListener);
  }

  @override
  void didUpdateWidget(covariant PeriodFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(_textControllerListener);
    _controller.dispose();
    super.dispose();
  }

  /// Disable editing when the state of the FormBloc is [FormBlocSubmitting].
  void _textControllerListener() {
    if (widget.inputFieldBloc.state.formBloc?.state is FormBlocSubmitting) {
      if (_controller.text != (widget.inputFieldBloc.value.duration)) {
        _fixControllerTextValue(widget.inputFieldBloc.value.duration);
      }
    }
  }


  void _fixControllerTextValue(String value) async {
    _controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: _controller.text.length);

    await Future.delayed(const Duration(milliseconds: 0));
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
            return TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffix: _buildSuffix(unit),
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
                label: const Text("保质期限"),
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              ),
              keyboardType: widget.keyboardType,
              onChanged: (value) {
                var period = widget.inputFieldBloc.value;
                period.duration = value;
                widget.inputFieldBloc.changeValue(period);
              },
            ).pad(pv8);
  }

  Widget _buildSuffix(int value) {
    var word = "天";
    if (value == 1) {
      word = "天";
    }
    if (value == 2) {
      word = "周";
    }
    if (value == 3) {
      word = "月";
    }
    if (value == 4) {
      word = "年";
    }
    return Text(word).onTap(() {
      setState(() {
        unit = ((unit) % 4) + 1;
        var period = widget.inputFieldBloc.value;
        period.unit = unit;
        widget.inputFieldBloc.updateValue(period);
      });
    });
  }
}
