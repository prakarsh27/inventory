import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String uid;
  String itemID;
  String itemName;
  Item({this.uid = 'kit_inv_000001', this.itemID, this.itemName});
}

class ItemDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getLast(String uid) async {
    String lastID = 'kit_inv_000000';
    DocumentSnapshot doc =
        await _firestore.collection('storage').doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> map = doc.data();
      lastID = map['ID'];
    }
    return lastID;
  }

  Future<String> checkIfExists(
    String uid,
    String itemID,
  ) async {
    String res = 'nowhere';
    DocumentSnapshot doc = await _firestore
        .collection('storage')
        .doc(uid)
        .collection('allItems')
        .doc(itemID)
        .get();
    if (doc.exists)
      res = 'all';
    else
      return res;
    doc = await _firestore
        .collection('storage')
        .doc(uid)
        .collection('groceryItems')
        .doc(itemID)
        .get();
    if (doc.exists) res = res + ' grocery';
    return res;
  }

  setLast(String id, String uid) async {
    int x = int.parse(id.substring(8));
    x++;
    String itemID = x.toString();
    if (itemID.length == 1)
      itemID = '00000' + itemID;
    else if (itemID.length == 2)
      itemID = '0000' + itemID;
    else if (itemID.length == 3)
      itemID = '000' + itemID;
    else if (itemID.length == 4)
      itemID = '00' + itemID;
    else if (itemID.length == 5) itemID = '0' + itemID;
    itemID = 'kit_inv_' + itemID;

    await _firestore.collection('storage').doc(uid).set({'ID': itemID});
  }

  Future<String> createItem(String itemName, String uid) async {
    String itemID = await getLast(uid);
    setLast(itemID, uid);
    try {
      await _firestore
          .collection('storage')
          .doc(uid)
          .collection('allItems')
          .doc(itemID)
          .set({'itemName': itemName, 'timeCreated': Timestamp.now()});
    } catch (e) {
      print(e);
    }

    return itemID;
  }

  addToGrocery(String uid, String itemID) async {
    String itemName;
    DocumentSnapshot doc = await _firestore
        .collection('storage')
        .doc(uid)
        .collection('allItems')
        .doc(itemID)
        .get();
    if (doc.exists) {
      Map<String, dynamic> map = doc.data();
      itemName = map['itemName'].toString();
      await _firestore
          .collection('storage')
          .doc(uid)
          .collection('groceryItems')
          .doc(itemID)
          .set({'itemName': itemName, 'timeCreated': Timestamp.now()});
    } else
      print('doc not found');
  }

  delete(String uid, String itemID, {String list = 'allItems'}) async {
    await _firestore
        .collection('storage')
        .doc(uid)
        .collection(list)
        .doc(itemID)
        .delete();
    if (list == 'allItems')
      await _firestore
          .collection('storage')
          .doc(uid)
          .collection('groceryItems')
          .doc(itemID)
          .delete();
  }

  Future<Map<String, String>> getItemList(
      {String list = 'allItems', String uid}) async {
    Map<String, String> allItems = Map();
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('storage')
          .doc(uid)
          .collection(list)
          .get();
      List<DocumentSnapshot> docList = querySnapshot.docs;
      docList.forEach((doc) {
        Map<String, dynamic> map = doc.data();
        allItems[doc.id.toString()] = map['itemName'].toString();
      });
    } catch (e) {
      print(e);
    }
    return allItems;
  }
}
