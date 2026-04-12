import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class AddScreenProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.email;
  List<Map<String, dynamic>> _mData = [];

  List<Map<String, dynamic>> getNotes() => _mData;

  Future<void> addAddress(String name, String phone,String state, String city,String houseName, String pinCode,String area) async {
    try {
      await _firestore.collection('addresses').doc(uid).collection('userAddresses').add({
        'name': name,
        'phone': phone,
        'state': state,
        'city': city,
        'houseName': houseName,
        'pinCode': pinCode,
        'area': area,
        'timestamp': FieldValue.serverTimestamp(),
        'isSelected': false,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding address: $e');
      }
    }
  }

  Future<void> updateAddress(bool isSelected,String addressId,String name, String phone,String state, String city,String houseName, String pinCode,String area) async {
    try {
      await _firestore.collection('addresses').doc(uid).collection('userAddresses').doc(addressId).update({
        'name': name,
        'phone': phone,
        'state': state,
        'city': city,
        'houseName': houseName,
        'pinCode': pinCode,
        'area': area,
        // 'timestamp': FieldValue.serverTimestamp(),  // uss address ko time ke sath update karke upko uper le jayega
        'isSelected': isSelected,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating address: $e');
      }
    }
  }

  Future<void> updateIsSelected(String addressId,bool isSelected) async {
    try {
      await _firestore.collection('addresses').doc(uid).collection('userAddresses').doc(addressId).update({
        'isSelected': isSelected,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating address: $e');
      }
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _firestore
          .collection('addresses')
          .doc(uid)
          .collection('userAddresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting address: $e');
      }
    }
  }



  void getInitialNotes() {
    _firestore
        .collection('addresses')
        .doc(uid)
        .collection('userAddresses')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _mData = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // store the document ID for update/delete
          'name': doc['name'],
          'phone': doc['phone'],
          'state': doc['state'],
          'city': doc['city'],
          'houseName': doc['houseName'],
          'pinCode': doc['pinCode'],
          'area': doc['area'],
          'isSelected':doc['isSelected'],
        };
      }).toList();
      notifyListeners();   //-> jo bhi ise listen krega uske uper data aa jaega then UI me reflect krega
    });
  }
}