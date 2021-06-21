import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory2/firebase/item.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  String uid;

  ScanScreen(this.uid);

  @override
  _ScanScreenState createState() => _ScanScreenState(uid);
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  var scanResult = ' ';
  String uid;
  Stream<Barcode> qrStream;

  _ScanScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan Item'.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height / 26)),
          backgroundColor: Colors.indigo[600],
          toolbarHeight: MediaQuery.of(context).size.height / 9.1,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
            elevation: 15,
            backgroundColor: Colors.indigo[100],
            child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data == true)
                    return Icon(
                      Icons.flash_off_rounded,
                      color: Colors.indigo[600],
                    );
                  else if (snapshot.data == false)
                    return Icon(
                      Icons.flash_on_rounded,
                      color: Colors.indigo[600],
                    );
                  else
                    return Icon(Icons.flash_on_rounded,
                        color: Colors.indigo[600]);
                })),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: Column(
          children: [
            Expanded(
              child: _buildQRView(context),
              flex: 5,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: qrStream,
                    builder: (context, AsyncSnapshot<Barcode> snapshot) {
                      if (snapshot.connectionState == ConnectionState.none)
                        return Text('none');
                      else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                            child: Text('Please Scan A Valid QR Code.'));
                      else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        String scanResult = 'no res';
                        Barcode code = snapshot.data;
                        if (scanResult != code.code) {
                          scanResult = code.code;
                        }
                        if (scanResult != 'no res') {
                          return FutureBuilder(
                              future:
                                  ItemDatabase().checkIfExists(uid, scanResult),
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  String res = snapshot.data;
                                  if (res == 'nowhere') {
                                    return Center(
                                        child: Text(
                                            'Please Scan A Valid QR Code.'));
                                  } else if (res == 'all') {
                                    return Center(
                                        child: InkWell(
                                      onTap: () {
                                        ItemDatabase()
                                            .addToGrocery(uid, scanResult);
                                        Fluttertoast.showToast(
                                            msg: 'Item Added To Grocery List.');
                                        scanResult = 'no res';
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20.2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue[300],
                                                Colors.indigo[600],
                                                Colors.purple[900],
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Center(
                                          child: Text(
                                            'Add To Grocery List'.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    45.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ));
                                  } else if (res == 'all grocery') {
                                    return Center(
                                        child: InkWell(
                                      onTap: () {
                                        ItemDatabase().delete(uid, scanResult,
                                            list: 'groceryItems');
                                        Fluttertoast.showToast(
                                            msg:
                                                'Item Removed From Grocery List.');
                                        scanResult = 'no res';
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20.2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue[300],
                                                Colors.indigo[600],
                                                Colors.purple[900],
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Center(
                                          child: Text(
                                            'Remove From Grocery List'
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    45.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ));
                                  } else
                                    return Center(child: Text('error'));
                                } else
                                  return Center(
                                      child: SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 50,
                                    height: 50,
                                  ));
                              });
                        } else
                          return Center(
                              child: Text('Please Scan A Valid QR Code.'));
                      } else
                        return Text('hello');
                    }),
                flex: 1)
          ],
        ));
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Stream<Barcode> _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    return controller.scannedDataStream;
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width / 1.3;
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        setState(() {
          qrStream = _onQRViewCreated(controller);
        });
      },
      overlay: QrScannerOverlayShape(cutOutSize: scanArea),
    );
  }
}
