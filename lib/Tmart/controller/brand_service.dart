import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getAllBrands({int? limit}) async {
  final snapshot = await FirebaseFirestore.instance.collection('Products').get();

  // Use a Set to ensure uniqueness
  final Set<String> brandNames = {};
  final Map<String, Map<String, dynamic>> brandData = {};

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final brand = data['brand'];
    final logo = data['brandLogo'];

    if (brand != null) {
      if (!brandNames.contains(brand)) {
        brandNames.add(brand);
        brandData[brand] = {
          'name': brand,
          'logo': logo,
          'totalItems': 1,
        };
      } else {
        brandData[brand]!['totalItems'] += 1;
      }
    }
  }

  final brandList = brandData.values.toList();

  if (limit != null && limit < brandList.length) {
    return brandList.sublist(0, limit);  //Return a portion of the brandList list, starting at index 0 and ending before index limit.
  }

  return brandList;
}