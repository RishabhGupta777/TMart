import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;

  // Store wishlist status per product
  Map<String, bool> _wishlistStatus = {};
  List<DocumentSnapshot> _mData = [];

  List<DocumentSnapshot> getWishlists() => _mData;

  WishlistProvider() {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        userId = user.uid;
        getInitialWishlist(); //Load wishlist for new user
      } else {
        userId = null;
        clearWishlist(); // Clear when user logs out
      }
    });
  }

  bool isWishlisted(String productId) {
    return _wishlistStatus[productId] ?? false;
  }

  Future<void> checkIfWishlisted(String productId) async {
    if (userId == null) return; // prevent access if logged out

    final doc = await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .get();

    _wishlistStatus[productId] = doc.exists;
    notifyListeners();
  }

  Future<void> toggleWishlist(DocumentSnapshot productDoc) async {
    if (userId == null) return; // block when not logged in

    final docId = productDoc.id;
    final itemRef = _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('items')
        .doc(docId);

    final currentlyWishlisted = _wishlistStatus[docId] ?? false;

    if (currentlyWishlisted) {
      await itemRef.delete();
    } else {
      await itemRef.set(productDoc.data() as Map<String, dynamic>);
    }

    _wishlistStatus[docId] = !currentlyWishlisted;
    notifyListeners();
  }

  void getInitialWishlist() {
    if (userId == null) return; // avoid crash if user not logged in
    _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      _mData = snapshot.docs;
      _wishlistStatus = {
        for (var doc in snapshot.docs) doc.id: true,
      };
      notifyListeners();
    });
  }


  void clearWishlist() {
    _wishlistStatus.clear();
    _mData.clear();
    notifyListeners();
  }

}
