import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}


class _MyProfileState extends State<MyProfile> {
  final _auth = FirebaseAuth.instance; //_auth is object and FirebaseAuth isa class
  final _firestore = FirebaseFirestore.instance;
  String name  = "..........";
  String about = "..........";
  String? userProfileUrl;

  void _editInfo(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter new $title",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      onSave(controller.text);
                      String newValue = controller.text;
                      setState(() {
                        if (title == "Name") {
                          name = newValue;
                        } else if (title == "About") {
                          about = newValue;
                        }
                      });
                      _firestore.collection('UsersInfo').doc(_auth.currentUser!.email).set({
                        title.toLowerCase(): newValue, // Store as lowercase keys: "name", "about"
                      }, SetOptions(merge: true)); //Use .set({...}, SetOptions(merge: true)) to update only the name field
                      // without overwriting other data in the document.
                      Navigator.pop(context);
                    },
                    child: const Text("Save", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    DocumentSnapshot userDoc = await _firestore.collection('UsersInfo').doc(_auth.currentUser!.email).get();
    if (userDoc.exists) {
      setState(() {
        name = userDoc.get('name') ?? "No Name";
        about = userDoc.get('about') ?? "No About Info";
        userProfileUrl = userDoc.get('profilePic');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String ? loggedInUser = _auth.currentUser!.email; // Get current user

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0), // Height of the line
            child: Container(
              color: Colors.black12, // Line color
              height: 1.0, // Thickness of the line
            ),
          ),
        ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25,),
          Center(
            child: Stack(
              children:[
                CircleAvatar(
                  radius: 77, // Adjust the size
                  backgroundImage: userProfileUrl != null
                      ? CachedNetworkImageProvider(userProfileUrl!)
                      : const AssetImage('assets/images/profile.png') as ImageProvider,
                  // backgroundColor: Colors.grey[200] // Background color if no image
                ),
                // Camera Icon Positioned Bottom Right
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green, // Background color of the icon
                    ),
                    child: IconButton(
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) => SelectPic(onImageUploaded: _fetchUserInfo,));
                        },
                        icon:  const Icon(Icons.camera_alt_outlined, color: Colors.white, size:26)),
                  ),
                ),
              ]
            ),
          ),
          const SizedBox(height: 40,),
          Information(
            onTap:(){
              _editInfo("Name", name, (newName) {
                setState(() => name = newName);
              });
            },
            icon:const Icon(Icons.person_outline_sharp),
            infoName:'Name',
            info: name,
          ),
          Information(
            onTap:(){
              _editInfo("About", about, (newAbout) {
                setState(() => about = newAbout);
              });
            },
            icon:const Icon(Icons.info_outline),
            infoName:'About',
            info: about,
          ),
          Information(
            onTap:(){},
            icon:const Icon(Icons.email_outlined),
            infoName:'Email',
            info: '$loggedInUser',
          )
        ],
      )
    );
  }
}

class Information extends StatelessWidget {
  const Information({
    super.key,
    required this.icon,
    required this.infoName,
    required this.info,
    required this.onTap
  });
  final Icon icon;
  final String infoName;
  final String info;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 25,),
             icon,
            const SizedBox(width: 25,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(infoName),
                Text(info,style: const TextStyle(color: Colors.black54),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class SelectPic extends StatefulWidget {
  final VoidCallback onImageUploaded; // <-- Added callback here

  const SelectPic({super.key, required this.onImageUploaded});

  @override
  State<SelectPic> createState() => _SelectPicState();
}

class _SelectPicState extends State<SelectPic> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      Navigator.pop(context);

      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      File file = File(image.path);
      String userId = _auth.currentUser!.uid;
      String fileName = "profile_$userId.jpg";


      // Upload to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child("profile_pics/$fileName");
      UploadTask uploadTask = storageRef.putFile(file);

      // Get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await FirebaseFirestore.instance.collection('UsersInfo').doc(_auth.currentUser!.email).set(
        {'profilePic': downloadUrl},
        SetOptions(merge: true),
      );
      // Refresh profile photo in parent widget
      widget.onImageUploaded(); // <-- Trigger refresh
    } catch (e) {
      print("Error uploading image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.only(top:26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AttachIcons(
                onPressed: ()=> _pickAndUploadImage(ImageSource.gallery),
                icon: const Icon(Icons.photo,color:Colors.blue),
                iconName:const Text('Galery'),
              ),
              AttachIcons(
                onPressed: ()=> _pickAndUploadImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt,color:Colors.red),
                iconName:const Text('Camera'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class AttachIcons extends StatelessWidget {
  const AttachIcons({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconName
  });
  final VoidCallback onPressed;
  final Widget icon;
  final Text iconName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all( // Add this border property
              color: Colors.black54, // Border color
              width: 1.0, // Border width
            ),
            color: Colors.white70,
            borderRadius:BorderRadius.circular(10.0) ,
          ),
          child: IconButton(onPressed:onPressed, icon:icon),),
        iconName
      ],
    );
  }
}
