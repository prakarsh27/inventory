import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory2/firebase/item.dart';

import '../pair.dart';

typedef MyEventCallback = void Function(String, int);

class GroceryItems extends StatefulWidget {
  Future<Map<String, String>> itemMap;
  String uid;
  GroceryItems({this.itemMap, this.uid});
  @override
  _GroceryItemsState createState() =>
      _GroceryItemsState(itemMap: itemMap, uid: uid);
}

class _GroceryItemsState extends State<GroceryItems> {
  Future<Map<String, String>> itemMap;
  String uid;

  _GroceryItemsState({this.itemMap, this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text('Grocery Items'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/26)),
          toolbarHeight: MediaQuery.of(context).size.height/9.1,
          centerTitle: true,
          backgroundColor: Colors.indigo[600],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height/91),
                child: FutureBuilder(
                    future: itemMap,
                    builder:
                        (context, AsyncSnapshot<Map<String, String>> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, String> map = Map.from(snapshot.data);

                        List<Pair> itemList = List.empty(growable: true);
                        map.forEach(
                            (key, value) => itemList.add(Pair(key, value)));
                        return GroceryListView(itemList: itemList, uid: uid);
                      } else
                        return Center(
                            child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: MediaQuery.of(context).size.height/9,
                          height: MediaQuery.of(context).size.height/9,
                        ));
                    }))));
  }
}

class GroceryListView extends StatefulWidget {
  List<Pair> itemList;
  String uid;

  GroceryListView({this.itemList, this.uid});

  @override
  _GroceryListViewState createState() =>
      _GroceryListViewState(itemList: itemList, uid: uid);
}

class _GroceryListViewState extends State<GroceryListView> {
  List<Pair> itemList;
  String uid;
  List<bool> delete = List.empty(growable: true);

  _GroceryListViewState({this.itemList, this.uid});

  @override
  void initState() {
    for (int i = 0; i < itemList.length; i++) delete.add(false);
    itemList.sort((a,b) => a.second.toLowerCase().compareTo(b.second.toLowerCase()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        for (int i = 0; i < itemList.length; i++)
          ListTile(
              title: Text(itemList[i].second.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/45.5)),
              trailing: (delete[i])
                  ? Wrap(
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: MediaQuery.of(context).size.height/26,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              delete[i] = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check_rounded,
                              size: MediaQuery.of(context).size.height/26, color: Colors.green[600]),
                          onPressed: () {
                            ItemDatabase().delete(uid, itemList[i].first,
                                list: 'groceryItems');
                            setState(() {
                              itemList.removeAt(i);
                              delete.removeAt(i);
                            });
                            Fluttertoast.showToast(
                                msg: 'Item Removed From Grocery List.');
                          },
                        )
                      ],
                    )
                  : IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          size: MediaQuery.of(context).size.height/26, color: Colors.indigo[600]),
                      onPressed: () {
                        setState(() {
                          delete = List.generate(delete.length, (_) => false,
                              growable: true);
                          delete[i] = true;
                        });
                      },
                    ))
      ],
    );
  }
}
