import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class OrderListProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.email;
  List<Map<String, dynamic>> _orderlists = [];

  List<Map<String, dynamic>> getOrderLists() => _orderlists;

  void getInitialOrderList() {
    _firestore
        .collection('orderlist')
        .doc(userId)
        .collection('items')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((snapshot) {
      _orderlists = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      notifyListeners();   //-> jo bhi ise listen krega uske uper data aa jaega then UI me reflect krega
    });
  }
}