import 'package:b21_printer/b21_printer.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:loading/loading.dart';

class PrinterConnectPage extends StatefulWidget {
  const PrinterConnectPage({Key? key}) : super(key: key);

  @override
  State<PrinterConnectPage> createState() => _PrinterConnectPageState();
}

class _PrinterConnectPageState extends State<PrinterConnectPage> {
  Map<String, BluetoothDevice> _devices = {};
  bool _scanning = true;
  final FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();

  @override
  void initState() {
    super.initState();
    _bluetooth.devices.listen((device) {
      debugPrint(device.toString());
      setState(() {
        _devices.putIfAbsent(device.address, () => device);
      });
    });
    _bluetooth.scanStopped.listen((device) {
      setState(() {
        _scanning = false;
      });
      debugPrint("stop scan......");
    });
    _bluetooth.startScan();
    debugPrint("start scan......");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        title: const Text("Connect Printer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 1,
              child: Row(
                children: [
                  const Text("searching device...")
                      .pad(const EdgeInsets.only(left: 8)),
                  const Spacer(),
                  if (_scanning)
                    Loading(
                      color: Colors.black45,
                    )
                  else
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            _scanning = true;
                            _devices = {};
                          });
                          _bluetooth.startScan();
                        },
                        icon: const Icon(Icons.refresh))
                ],
              ).pa(8),
            ).pa(8),
            Column(
              children: _devices.values
                  .map((device) => Column(
                    children: [
                      SizedBox(
                        height: 35,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(device.name, style: bodyMe,),
                              Text("MAC:"+device.address, style: bodySm,)
                            ],
                          ))
                      .onTap(() async{
                        await _bluetooth.stopScan();
                        setState(() {
                          _scanning = false;
                        });
                        var result = await B21Printer.open(device.address);
                        if(result){

                        }
                      }),
                      const Divider(),
                    ],
                  ))
                  .toList(),
            ).pa(16)
          ],
        ),
      ),
    );
  }
}
