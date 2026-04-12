
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    this.iconColor=Colors.white,
    this.onPressed,
  });
  final Color iconColor;
  final VoidCallback ? onPressed;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.email;
    return Stack(children:[
      IconButton(
        icon: Icon(Icons.shopping_bag_outlined, color: iconColor),
        onPressed: onPressed,
      ),
      Positioned(
          right:10,
          top:10,
          child:CircleAvatar(
            backgroundColor: Colors.black,
            radius: 5,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cartlists')
                    .doc(userId)
                    .collection('items')
                    .snapshots(),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final cartlistDocs = snapshot.data?.docs ?? [];
                  return Text(cartlistDocs.length.toString(),style: TextStyle(fontSize:5.5,color: Colors.white,),);
                }),
            //
          ) )
    ]);
  }
}
