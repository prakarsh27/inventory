import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../firebase/item.dart';
import '../screens/qrscreen.dart';
import '../pair.dart';

class AllItemsList extends StatefulWidget {
  Future<Map<String, String>> itemMap;
  String uid;

  AllItemsList(this.itemMap, this.uid);

  @override
  _AllItemsListState createState() => _AllItemsListState(itemMap, uid);
}

class _AllItemsListState extends State<AllItemsList> {
  Future<Map<String, String>> itemMap;
  String uid;

  _AllItemsListState(this.itemMap, this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text(
            'All Items'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height / 26),
          ),
          toolbarHeight: MediaQuery.of(context).size.height / 9.1,
          backgroundColor: Colors.indigo[600],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 91),
                child: FutureBuilder(
                    future: itemMap,
                    builder:
                        (context, AsyncSnapshot<Map<String, String>> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, String> map = Map.from(snapshot.data);
                        List<Pair> list = List.empty(growable: true);
                        map.forEach((key, value) => list.add(Pair(key, value)));
                        return ExpansionPanelWidget(list, uid);
                      } else
                        return Center(
                            child: SizedBox(
                                child: CircularProgressIndicator(),
                                width: MediaQuery.of(context).size.height / 9,
                                height:
                                    MediaQuery.of(context).size.height / 9));
                    }))));
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  List<Pair> itemList;
  String uid;

  ExpansionPanelWidget(this.itemList, this.uid);

  @override
  _ExpansionPanelWidgetState createState() =>
      _ExpansionPanelWidgetState(itemList, uid);
}

class _ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  List<Pair> itemList;
  List<bool> _isExpanded = List.empty(growable: true);
  String uid;
  _ExpansionPanelWidgetState(this.itemList, this.uid);

  @override
  void initState() {
    for (int i = 0; i < itemList.length; i++) _isExpanded.add(false);
    itemList.sort(
        (a, b) => a.second.toLowerCase().compareTo(b.second.toLowerCase()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 800),
      expandedHeaderPadding:
          EdgeInsets.all(MediaQuery.of(context).size.height / 182),
      dividerColor: Colors.indigo[600],
      expansionCallback: (index, isExpanded) => setState(() {
        if (isExpanded)
          _isExpanded[index] = false;
        else {
          _isExpanded =
              List.generate(_isExpanded.length, (_) => false, growable: true);
          _isExpanded[index] = true;
        }
      }),
      children: [
        for (int i = 0; i < itemList.length; i++)
          ExpansionPanel(
              backgroundColor: Colors.blue[200],
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 61),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemList[i].second.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50.5,
                                color: Colors.blue[900]),
                          )
                        ]));
              },
              isExpanded: _isExpanded[i],
              body: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Add To Grocery List'),
                    onTap: () {
                      ItemDatabase().addToGrocery(uid, itemList[i].first);
                      Fluttertoast.showToast(
                          msg: 'Item Added To Grocery List Successfully.');
                    },
                  ),
                  ListTile(
                    title: Text('Delete Item'),
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              title: Text(
                                  itemList[i].second.toUpperCase() +
                                      ' will Be Deleted.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              45.5)),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              53.5),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      ItemDatabase()
                                          .delete(uid, itemList[i].first);
                                      setState(() {
                                        itemList.removeAt(i);
                                        _isExpanded.removeAt(i);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Ok'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              53.5),
                                    ))
                              ],
                            )),
                  ),
                  ListTile(
                    title: Text('Generate QR Code'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRScreen(
                                itemName: itemList[i].second,
                                isFuture: false,
                                itemID: itemList[i].first))),
                  )
                ],
              ))
      ],
    );
  }
}
