import 'package:flutter/material.dart';

import '../firebase/item.dart';
import '../screens/qrscreen.dart';

class AddScreen extends StatefulWidget {
  String uid;

  AddScreen(this.uid);

  @override
  _AddScreenState createState() => _AddScreenState(uid);
}

class _AddScreenState extends State<AddScreen> {
  String uid;
  String _itemName;

  _AddScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add New Item'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/26),
          ),
          toolbarHeight: MediaQuery.of(context).size.height/9.1,
          backgroundColor: Colors.indigo[600],
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height/30.3),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(primaryColor: Colors.indigo[600]),
                            child: TextFormField(
                              onChanged: (String value) => _itemName = value,
                              decoration: InputDecoration(
                                  labelText: 'Item Name'.toUpperCase(),
                                  fillColor: Colors.indigo[600],
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25))),
                            )))),
                Expanded(
                    flex: 2,
                    child: Center(
                      child: InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  title: Text(
                                    'Confirm ?'.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height/32.5),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('cancel'.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: MediaQuery.of(context).size.height/45.5,
                                                fontWeight: FontWeight.bold))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Future<String> itemID = ItemDatabase()
                                              .createItem(_itemName, uid);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRScreen(
                                                          isFuture: true,
                                                          futureItemID: itemID,
                                                          itemName:
                                                              _itemName)));
                                        },
                                        child: Text('Ok'.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.indigo[600],
                                                fontSize: MediaQuery.of(context).size.height/45.5,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                )),
                        child: Container(
                          height: MediaQuery.of(context).size.height/20.2,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[300],
                                  Colors.indigo[600],
                                  Colors.purple[900],
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'Add Item'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height/32.5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ))
              ]),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blue[50],
            Colors.blue[100],
            Colors.blue[200]
          ])),
        ));
  }
}
