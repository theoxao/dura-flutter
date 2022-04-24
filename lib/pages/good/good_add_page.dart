import 'package:flutter/material.dart';

import '../../common/constant.dart';
import '../../common/extensions.dart';

class GoodAddPage extends StatefulWidget {
  const GoodAddPage({Key? key}) : super(key: key);

  @override
  State<GoodAddPage> createState() => _GoodAddPageState();
}

class _GoodAddPageState extends State<GoodAddPage> {

  final _nameEditCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextField(
            controller: _nameEditCtl,
            decoration: const InputDecoration(
              hintText: "name",
              border: defaultOutlineBorder
            ),
          ).pa(8)
        ],
      ),
    );
  }
}
