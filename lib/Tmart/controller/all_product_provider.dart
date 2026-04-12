import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllProductProvider with ChangeNotifier {
  AllProductProvider() {     //  -->constructor of DBProvider class for calling from main.dart and start using getInitialNodes();
    getInitialWishlist();   //due to bahut jagah se all product chahiye hoga to main se hi call karake load kar lo sara items
     getInitialCategories();                       //har page se inistates se call nahi karwana parega
   getInitialBanners();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Store wishlist status per product
  List<DocumentSnapshot> _mData = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _banners= [];


  List<DocumentSnapshot> getAllProducts() => _mData;
  List<Map<String, dynamic>> getAllCategories() => _categories;
  List<Map<String, dynamic>> getAllBanners() => _banners;


  void getInitialWishlist() {
    _firestore
        .collection('Products')
        .snapshots()
        .listen((snapshot) {
      _mData = snapshot.docs;

      notifyListeners();
    });
  }

  void getInitialCategories() {
    _firestore
        .collection('category')
        .snapshots()
        .listen((snapshot) {
      _categories = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      notifyListeners();
    });
  }

  void getInitialBanners() {
    _firestore
        .collection('banner')
        .snapshots()
        .listen((snapshot) {
      _banners = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      notifyListeners();
    });
  }

}
