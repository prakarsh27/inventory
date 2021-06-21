//import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScreen extends StatefulWidget {
  Future<String> futureItemID;
  String itemID;
  String itemName;
  bool isFuture;

  QRScreen(
      {this.itemID, @required this.itemName, this.futureItemID, this.isFuture});

  @override
  _QRScreenState createState() {
    if (isFuture)
      return _QRScreenState(
          isFuture: isFuture, itemName: itemName, futureItemID: futureItemID);
    else
      return _QRScreenState(
          isFuture: isFuture, itemName: itemName, itemID: itemID);
  }
}

class _QRScreenState extends State<QRScreen> {
  Future<String> futureItemID;
  String itemID;
  String itemName;
  bool isFuture;
  GlobalKey _key = GlobalKey();

  _QRScreenState(
      {this.itemID, @required this.itemName, this.futureItemID, this.isFuture});

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    final info = statuses[Permission.storage].toString();
    print(info);
  }

  _screenshot() async {
    RenderRepaintBoundary boundry = _key.currentContext.findRenderObject();
    var image = await boundry.toImage(pixelRatio: 3.0);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(pngBytes);

    if (result['isSuccess']) {
      Fluttertoast.showToast(
          msg: 'QR added to gallery under Pictures folder.',
          gravity: ToastGravity.BOTTOM,
          fontSize: MediaQuery.of(context).size.height / 45.5);
    } else {
      Fluttertoast.showToast(
          msg: 'There was an error. Please try again.',
          gravity: ToastGravity.BOTTOM,
          fontSize: MediaQuery.of(context).size.height / 45.5);
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('qr'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height / 26)),
        toolbarHeight: MediaQuery.of(context).size.height / 9.1,
        centerTitle: true,
        backgroundColor: Colors.indigo[600],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blue[50],
            Colors.blue[100],
            Colors.blue[200]
          ])),
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 36.4),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            RepaintBoundary(
              key: _key,
              child: Container(
                  color: Colors.blue[300],
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Center(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height /
                                            45.5),
                                child: (isFuture == true)
                                    ? FutureBuilder(
                                        future: futureItemID,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData) {
                                            return QrImage(
                                                data: snapshot.data,
                                                version: QrVersions.auto,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3.64);
                                          } else {
                                            return SizedBox(
                                              child:
                                                  CircularProgressIndicator(),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.64,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.64,
                                            );
                                          }
                                        },
                                      )
                                    : QrImage(
                                        data: itemID,
                                        version: QrVersions.auto,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                3.64))),
                        Center(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height /
                                            45.5),
                                child: Text(itemName.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                36.4))))
                      ]))),
            ),
            Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 91),
                child: InkWell(
                  onTap: _screenshot,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 20.2,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[300],
                            Colors.indigo[600],
                            Colors.purple[900],
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: Text(
                        'Add QR To Gallery'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 36.4,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ))
          ])),
    );
  }
}
