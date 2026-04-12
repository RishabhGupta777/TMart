import 'package:flashchat/TMart/controller/addScreenProvider.dart';
import 'package:flashchat/TMart/screens/add_new_address_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/singleaddress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddScreenProvider>().getInitialNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child:SingleChildScrollView(
          child:Consumer<AddScreenProvider>(
              builder: (context, provider, child){
                final allAddresses = provider.getNotes(); //similar as List<Map<String,dynamics>>allAddresses=provider.getNotes();
                return allAddresses.isEmpty
                    ? const Center(
                  child: Text('No Notes yet!'),
                ):ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allAddresses.length,
                          itemBuilder: (context, index) {
                            final doc = allAddresses[index];
                            final data = doc as Map<String, dynamic>;
                            // final isSelected = data['isSelected'] ?? false;  //TSingleAddress me isSelected pass karke to ye line likhna parta

                            return GestureDetector(
                              onTap: () async {
                                // Unselect all addresses
                                for (final addr in allAddresses) {
                                await  provider.updateIsSelected(addr['id'],false);
                                  // await addr.reference.update({'isSelected': false});
                                }

                                // Select the tapped one
                             await provider.updateIsSelected(data['id'],true);
                              },
                              child: TSingleAddress(
                                id:data['id'],
                                selectedAddress:data['isSelected'] ?? false,
                                name: data['name'] ?? '',
                                phone: data['phone'] ?? '',
                                houseName: data['houseName'] ?? '',
                                area: data['area'] ?? '',
                                city: data['city'] ?? '',
                                state: data['state'] ?? '',
                                pinCode: data['pinCode'] ?? '',
                              ),
                            );
                          },
                        );
              }
          )
        ),
      ),
      bottomNavigationBar:Padding(
        padding: const EdgeInsets.all(8.0),
        child: TButton(text:'Add new address',height: 52,
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewAddressScreen(isUpdate: false,),));
            }),
      ) ,
    );
  }
}

