import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/screens/order_placed_screen.dart';
import 'package:flashchat/TMart/screens/user_address_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_item.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_items.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/singleaddress.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkoutscreen extends StatefulWidget {
  final double totalPrice;
  final DocumentSnapshot? singleProduct;
  final int selectedVariationIndex;
  final String attValue;
  final String attributeName;

  const Checkoutscreen({
    super.key,
    this.totalPrice=0.00,
    this.singleProduct,
    this.selectedVariationIndex = 0,
    this.attValue='',
    this.attributeName='',
  });

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  double allPrice = 0.0;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_ScW8lR7cVFw4ax', // replace with your key
      'amount': (allPrice * 100).toInt(),
      'name': 'flashchat',
      'description': 'Order Payment',
      'prefill': {
        'contact': '9999999999',
        'email': FirebaseAuth.instance.currentUser?.email ?? ''
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final userId = FirebaseAuth.instance.currentUser?.email;
    if (userId == null) return;

    final orderRef = FirebaseFirestore.instance
        .collection('orderlist')
        .doc(userId)
        .collection('items');

    if (widget.singleProduct != null) {
      final data = widget.singleProduct!.data() as Map<String, dynamic>;
      final variationData = data['variation'][widget.selectedVariationIndex];

      await orderRef.add({
        'productId': widget.singleProduct!.id,
        'variationIndex': widget.selectedVariationIndex,
        'category': data['category'],
        'name': data['name'],
        'brand': data['brand'],
        'quantity': 1,
        'variation': variationData,
        'attValue': widget.attValue,
        'attributeName': widget.attributeName,
        'orderDate': Timestamp.now(),
        'totalPrice': allPrice,
        'status': "Paid", ///important
        'paymentId': response.paymentId,
      });

    } else {
      final cartItemsRef = FirebaseFirestore.instance
          .collection('cartlists')
          .doc(userId)
          .collection('items');

      final cartItemsSnapshot = await cartItemsRef.get();

      for (final doc in cartItemsSnapshot.docs) {
        final item = doc.data();

        await orderRef.add({
          ...item,
          'orderDate': Timestamp.now(),
          'totalPrice': allPrice,
          'status': "Paid",
          'paymentId': response.paymentId,
        });
      }

      // clear cart
      for (final doc in cartItemsSnapshot.docs) {
        await doc.reference.delete();
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrderPlacedScreen()),
    );
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut',style:Theme.of(context).textTheme.headlineSmall),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
           children: [
             widget.singleProduct != null
                 ?  TCartItem(
               removeAndQuantity: false,
               document: widget.singleProduct!,
               variationIndex: widget.selectedVariationIndex,
               attributeName:widget.attributeName,
               attValue:widget.attValue,
               isSingleProduct:true,
             )
                 : TCartItems(removeAndQuantity: false),
             const SizedBox(height: 14,),
             const TCouponCode(),
             SizedBox(height: 16,),
             TRoundedContainer(
               showBorder: true,
               borderColor: Colors.black12,
               padding: 8,
               child: Column(
                 children: [
                   TAmountAmountSection(totalPrice: widget.totalPrice,
                     onTotalCalculated: (value) {
                     setState(() {
                       allPrice = value;
                     });
                   },),
                   const SizedBox(height:14),
                   Divider(),
                   TBillingPaymentSection(),
                   TBillingAddressSection(),
                 ],
               ),
             )
           ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Text('₹${allPrice.toStringAsFixed(2)}',style: TextStyle(fontWeight:FontWeight.w500,fontSize: 25),),
            TButton(
              onTap: () async {
                openCheckout();
              },
              height: 40,
              width: 170,
              radius: 8,
              text: 'Continue',
            ),

          ],
        ),
      ),
    );
  }
}

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAddressScreen(),));
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('addresses')
              .doc(uid)
              .collection('userAddresses')
              .where('isSelected', isEqualTo: true)
              .snapshots(),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No addresses found.'));
            }

            // final data = snapshot.data!.docs as Map<String, dynamics>;
            final doc = snapshot.data!.docs.first;
            final data = doc.data() as Map<String, dynamic>;

            return TSingleAddress(
              id:doc.id,
              selectedAddress:false, // mark first as selected
              name: data['name'] ?? '',
              phone: data['phone'] ?? '',
              houseName: data['houseName'] ?? '',
              area: data['area'] ?? '',
              city: data['city'] ?? '',
              state: data['state'] ?? '',
              pinCode: data['pinCode'] ?? '',
            );
          },
        ),
      ],
    );
  }
}

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
     children: [
       TSectionHeading(title: 'Payment Method',buttonTitle:'Change' , onPressed: (){},),
       Row(
         children: [
           TRoundedContainer(
             width: 60,
             height: 35,
             child: Image.asset('assets/images/paytm.png',fit:BoxFit.contain,),
           ),
           SizedBox(width: 6,),
           Text('Paytm',style: Theme.of(context).textTheme.bodyLarge,)
         ],
       ),

     ],
    );
  }
}

class TAmountAmountSection extends StatefulWidget {
  final double totalPrice;
  final void Function(double) onTotalCalculated;

  const TAmountAmountSection({
    super.key,
    required this.totalPrice,
    required this.onTotalCalculated
  });

  @override
  State<TAmountAmountSection> createState() => _TAmountAmountSectionState();
}

class _TAmountAmountSectionState extends State<TAmountAmountSection> {
  double shippingFee=6.0;
  double taxFee=12.0;
  double allPrice=0;


  @override
  void initState() {
    super.initState();
    allPrice = shippingFee + taxFee + widget.totalPrice;

    // Delay the callback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTotalCalculated(allPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// SubTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${widget.totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height:8),

        /// Shipping Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${shippingFee.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),

        /// Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${taxFee.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height:6),

        /// Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.titleMedium),
            Text('${allPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}

class TCouponCode extends StatelessWidget {
  const TCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      borderColor: Colors.black12,
      height: 60,
      width: double.infinity,
      radius:12,
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Have a promo code? Enter here',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            TButton(height:44,onTap: (){},width:80,backgroundColor: Colors.grey,text: 'Apply', ),
          ],
        ),
      ),
      );
  }
}
