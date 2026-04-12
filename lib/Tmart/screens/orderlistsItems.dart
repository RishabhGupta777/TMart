import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/controller/order_list_provider.dart';
import 'package:flashchat/TMart/screens/product_detail.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_title_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TOrderListItems extends StatefulWidget {
  const TOrderListItems({super.key});

  @override
  State<TOrderListItems> createState() => _TOrderListItemsState();
}

class _TOrderListItemsState extends State<TOrderListItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderListProvider>().getInitialOrderList();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: Consumer<OrderListProvider>(
        builder: (context,provider,_) {
          final orders = provider.getOrderLists(); //similar as List<Map<String,dynamics>>orders=provider.getNotes();
          return orders.isEmpty
              ? const Center(
            child: Text('No Order found!!'),
          )

          : ListView.separated(
            shrinkWrap: true,
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height:0),
            itemBuilder: (_, index){
              final order = orders[index]as Map<String,dynamic>;
              final name=order['name'];
              final status=order['status'];
              final variation=order['variation'] as Map<String, dynamic>;
              final imageUrl=variation['pic'];
              final orderDate = (order['orderDate'] as Timestamp).toDate();
              final formattedDate = DateFormat('dd MMM yyyy').format(orderDate);
              final variationIndex=order['variationIndex'] ?? 0;
              return GestureDetector(
                onTap: ()async{
                  final productId=order['productId'];
                  final productDoc =await FirebaseFirestore.instance
                      .collection('Products')
                      .doc(productId)
                      .get();
                  if (productDoc.exists) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(document: productDoc, selectedVariationIndex: variationIndex,
                        ),
                      ),
                    );
                 }
                },
                child: TRoundedContainer(
                margin: 10,
                showBorder: true,
                borderColor: Colors.black12,
                child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TRoundedContainer(
                          height: 100,
                          width: 100,
                          radius: 15,
                          child:Image.network(imageUrl, height: 100, fit: BoxFit.cover,),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0,top:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:136,
                              child: TProductTitleText(title:name,isLarge:false,),),
                            Text(status ?? 'Processing',
                              style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: TColors.primary, fontWeightDelta: 1),),
                            SizedBox(height: 3,),
                            Row(
                              children: [
                                        const Icon(Icons.calendar_month_outlined),
                                        const SizedBox(width: 8),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ordered On',
                                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                          ],
                        ),
                      )
                    ]
                ),
                            ),
              );
            }
          );
        }
      )
    );
  }
}
