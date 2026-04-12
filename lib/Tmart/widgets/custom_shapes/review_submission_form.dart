import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewForm extends StatefulWidget {
  final String productId;
  const ReviewForm({super.key, required this.productId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  double _rating = 5.0;
  final _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _userId = FirebaseAuth.instance.currentUser?.email;

  void _submitReview() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('Products')
        .doc(widget.productId)
        .collection('reviews')
        .add({
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'rating': _rating,
      'comment': _commentController.text.trim(),
      'submittedUser':_userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: 12,
      showBorder: true,
      borderColor: Colors.black12,
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) => setState(() => _rating = rating),
          ),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
                labelText: 'Write a review'),
          ),
          SizedBox(height: 12,),
          TButton(
            height: 50,
            onTap: _submitReview,
            text: "Submit Review",
          ),
        ],
      ),
    );
  }
}
