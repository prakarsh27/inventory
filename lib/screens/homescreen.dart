import 'package:flutter/material.dart';
import 'package:inventory2/firebase/item.dart';
import 'package:provider/provider.dart';

import '../firebase/authentication_service.dart';
import '../firebase/user.dart';
import '../screens/scanscreen.dart';
import '../screens/addscreen.dart';
import '../screens/allitems.dart';
import '../screens/groceryitems.dart';

class HomeScreen extends StatefulWidget {
  String uid;

  HomeScreen(this.uid);

  @override
  _HomeScreenState createState() => _HomeScreenState(uid);
}

class _HomeScreenState extends State<HomeScreen> {
  String uid;
  _HomeScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.indigo[600],
            onPressed: () => context.read<AuthenticationService>().signOut(),
            elevation: 5.0,
            label: Text('Sign Out',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 61)),
            icon: Icon(Icons.power_settings_new_rounded)),
        appBar: AppBar(
            title: Text('Inventory'.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 26)),
            toolbarHeight: MediaQuery.of(context).size.height / 9.1,
            backgroundColor: Colors.indigo[600],
            centerTitle: true),
        body: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blue[50],
              Colors.blue[100],
              Colors.blue[200]
            ])),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Expanded(
                  flex: 1,
                  child: Center(
                    child: FutureBuilder<String>(
                        future: UserDatabase().getUserFullName(uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          String welcomeMessage = 'Welcome';
                          if (snapshot.hasData)
                            welcomeMessage =
                                welcomeMessage + ' ' + snapshot.data;
                          return Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Text(welcomeMessage.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              30.3)));
                        }),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 32.5,
                        right: MediaQuery.of(context).size.height / 30,
                        left: MediaQuery.of(context).size.height / 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddScreen(uid))),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 20.2,
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
                                    'Add New Item'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                32.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanScreen(uid))),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 20.2,
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
                                    'Scan QR Code'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                32.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroceryItems(
                                          itemMap: ItemDatabase().getItemList(
                                              uid: uid, list: 'groceryItems'),
                                          uid: uid))),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 20.2,
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
                                    'View Grocery List'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                32.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllItemsList(
                                          ItemDatabase().getItemList(uid: uid),
                                          uid))),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 20.2,
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
                                    'View All Items'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                32.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer()
                        ]),
                  ))
            ])));
  }
}
