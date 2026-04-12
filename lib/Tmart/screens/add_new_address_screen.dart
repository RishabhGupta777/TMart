import 'package:flashchat/TMart/controller/addScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({
    super.key,
    required this.isUpdate,
    this.isSelected,
    this.id,
    this.name,
    this.phone,
    this.area,
    this.city,
    this.houseName,
    this.pinCode,
    this.state,
  });

  final bool isUpdate;
  final bool? isSelected;
  final String? id;
  final String? name;
  final String? phone;
  final String? state;
  final String? city;
  final String? houseName;
  final String? pinCode;
  final String? area;

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  // Controllers for each input
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController houseNameController;
  late TextEditingController pinCodeController;
  late TextEditingController areaController;

  @override
  void initState() {
    super.initState();
    // Prefill with widget values if updating
    nameController = TextEditingController(text: widget.name ?? '');
    phoneController = TextEditingController(text: widget.phone ?? '');
    stateController = TextEditingController(text: widget.state ?? '');
    cityController = TextEditingController(text: widget.city ?? '');
    houseNameController = TextEditingController(text: widget.houseName ?? '');
    pinCodeController = TextEditingController(text: widget.pinCode ?? '');
    areaController = TextEditingController(text: widget.area ?? '');
  }

  Future<void> saveAddressToFirebase() async {
    final provider = context.read<AddScreenProvider>();

    if (widget.isUpdate) {
      provider.updateAddress(
        widget.isSelected!,
        widget.id!, // Pass ID for update
        nameController.text,
        phoneController.text,
        stateController.text,
        cityController.text,
        houseNameController.text,
        pinCodeController.text,
        areaController.text,
      );
    } else {
      provider.addAddress(
        nameController.text,
        phoneController.text,
        stateController.text,
        cityController.text,
        houseNameController.text,
        pinCodeController.text,
        areaController.text,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isUpdate ? 'Update Address' : 'Add New Address')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextInputBox(controller: nameController, labelText: 'Name', icon: Icon(Icons.person_outline_sharp)),
            const SizedBox(height: 10),
            TextInputBox(controller: phoneController, labelText: 'Phone Number', icon: Icon(Icons.phone_android_outlined)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextInputBox(controller: stateController, labelText: 'State', icon: Icon(Icons.map)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextInputBox(controller: cityController, labelText: 'City', icon: Icon(Icons.location_city_outlined)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextInputBox(controller: houseNameController, labelText: 'House Name', icon: Icon(Icons.home_work_outlined)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextInputBox(controller: pinCodeController, labelText: 'Pin Code', icon: Icon(Icons.pin_drop_outlined)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextInputBox(controller: areaController, labelText: 'Area, Colony', icon: Icon(Icons.add_road)),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TButton(
          onTap: saveAddressToFirebase,
          radius: 16,
          text: 'Save',
          height: 53,
          backgroundColor: TColors.primary,
        ),
      ),
    );
  }
}

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
  });

  final TextEditingController controller;
  final String labelText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: labelText,
        labelStyle: TextStyle(color: TColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TColors.primary, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
