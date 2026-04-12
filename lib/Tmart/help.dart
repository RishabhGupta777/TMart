// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<void> renameDocument({
//   required String collectionPath,
//   required String oldDocId,
//   required String newDocId,
// }) async {
//   final collection = FirebaseFirestore.instance.collection(collectionPath);
//
//   // Step 1: Get old document data
//   final oldDocSnapshot = await collection.doc(oldDocId).get();
//   if (!oldDocSnapshot.exists) {
//     throw Exception("Old document does not exist");
//   }
//
//   final data = oldDocSnapshot.data();
//
//   // Step 2: Set data to new document
//   await collection.doc(newDocId).set(data!);
//
//   // Step 3: Delete old document
//   await collection.doc(oldDocId).delete();
// }
//
//
// onTap apply anywhere
// try {
// await renameDocument(
// collectionPath: 'Products',
// oldDocId: 'shoe2',
// newDocId: '004',
// );
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Document renamed successfully')),
// );
// } catch (e) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Error: ${e.toString()}')),
// );
// }