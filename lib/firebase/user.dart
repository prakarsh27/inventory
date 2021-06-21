import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String uid;
  String email;
  String fullName;
  Timestamp accountCreated;

  OurUser({this.uid, this.email, this.fullName, this.accountCreated});
}

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = 'error';
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName' : user.fullName,
        'email' : user.email,
        'accountCreated' : Timestamp.now()
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();
    try {
      DocumentSnapshot _docSnap = await _firestore.collection('users').doc(uid).get();
      retVal.uid = uid;
      Map<String, dynamic> map = _docSnap.data();
      retVal.fullName = map['fullName'].toString();
      retVal.email = map['email'].toString();
      retVal.accountCreated = map['accountCreated'];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> getUserFullName(String uid) async {
    String retVal = 'null';
    try {
      DocumentSnapshot _docSnap = await _firestore.collection('users').doc(uid).get();
      Map<String, dynamic> map = _docSnap.data();
      retVal = map['fullName'].toString();
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
