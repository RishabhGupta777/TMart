import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/controller/addScreenProvider.dart';
import 'package:flashchat/TMart/screens/add_new_address_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.selectedAddress,
    this.id,
    this.name,
    this.phone,
    this.area,
    this.city,
    this.houseName,
    this.pinCode,
    this.state,
});

  final bool selectedAddress;
  final String? id;
  final String? name;
  final String? phone;
  final String? state;
  final String? city;
  final String? houseName;
  final String? pinCode;
  final String? area;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: double.infinity,
      showBorder: true,
      backgroundColor: selectedAddress
          ? TColors.primary.withOpacity(0.3)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : Colors.black12,
      margin:8,
      padding: 8,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top:-8,
            child: Column(
              children: [
                PopupMenuButton(  itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context); // Close popup menu first
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewAddressScreen(
                                    isUpdate: true,
                                    id: id,
                                    name: name,
                                    phone: phone,
                                    state: state,
                                    city:city,
                                    houseName: houseName,
                                    pinCode: pinCode,
                                    area: area,
                                    isSelected:selectedAddress,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit_outlined, size: 19),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(context); // Close popup menu first
                              context.read<AddScreenProvider>().deleteAddress(id!);
                            },
                            icon: Icon(Icons.delete, size: 19),

                          ),
                        ],
                      ),
                    ),
                  ];
                },
                ),
                Icon(
                  selectedAddress ? Icons.check: null,
                  color: selectedAddress
                      ? Colors.black
                      : Colors.transparent,
                  size: 19,
                ),


              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? ' ',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height:8),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey, size: 16),
                  const SizedBox(width:12),
                  Text(
                    phone ?? ' ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height:8),
              Row(
                children: [
                  const Icon(Icons.location_history, color: Colors.grey, size: 16),
                  const SizedBox(width:12),
                  SizedBox(
                    width: 264,
                    child: Text(
                      '${houseName}, ${area}, ${city}, ${state}, ${pinCode}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
