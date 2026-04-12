import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);


const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration= InputDecoration(
  suffixIcon:Icon(Icons.visibility_off),
  hintText: 'Enter your password',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);




class PasswordTextField extends StatefulWidget {

  const PasswordTextField({super.key, required this.onChanged});
  final Function(String) onChanged;  //Using VoidCallback in place of Function(String) would not work
  // in this case because VoidCallback is a function that takes no parameters and returns nothing (void).
  // However, the onChanged callback for a TextField needs to pass a String (the input value) when the user types.
  //Function(String) onChanged: Accepts a function that takes a String parameter (user input from the text field).


  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: showPassword==false ? true : false ,
      textAlign: TextAlign.center,
      onChanged: widget.onChanged,  //In Flutter's StatefulWidget, the State class does not have direct access to the
      // properties declared in the Widget class. Instead, these properties are accessed using widget.propertyName.
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              showPassword ? showPassword=false : showPassword= true;
            });
          },
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
        ),
        hintText: 'Enter your password',
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}





// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});
//
//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }
//
// class _MyProfileState extends State<MyProfile> {
//   final _auth = FirebaseAuth.instance;
//   String name = "Rishabh";
//   String about = "I am Don";
//
//   void _editInfo(String title, String currentValue, Function(String) onSave) {
//     TextEditingController controller = TextEditingController(text: currentValue);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Edit $title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   hintText: "Enter new $title",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text("Cancel"),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       onSave(controller.text);
//                       Navigator.pop(context);
//                     },
//                     child: Text("Save", style: TextStyle(color: Colors.blue)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String? loggedInUser = _auth.currentUser!.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(color: Colors.black12, height: 1.0),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 40),
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 75,
//                   backgroundImage: NetworkImage(
//                     'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-transparent-png-2534623311',
//                   ),
//                   backgroundColor: Colors.grey[200],
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   right: 10,
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.green,
//                       ),
//                       child: Icon(Icons.camera_alt, color: Colors.white, size: 26),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 40),
//           Information(
//             onTap: () => _editInfo("Name", name, (newName) {
//               setState(() => name = newName);
//             }),
//             icon: Icon(Icons.person_outline_sharp),
//             infoName: 'Name',
//             info: name,
//           ),
//           SizedBox(height: 20),
//           Information(
//             onTap: () => _editInfo("About", about, (newAbout) {
//               setState(() => about = newAbout);
//             }),
//             icon: Icon(Icons.info_outline),
//             infoName: 'About',
//             info: about,
//           ),
//           SizedBox(height: 20),
//           Information(
//             onTap: () {},
//             icon: Icon(Icons.email_outlined),
//             infoName: 'Email',
//             info: '$loggedInUser',
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class Information extends StatelessWidget {
//   const Information({
//     super.key,
//     required this.icon,
//     required this.infoName,
//     required this.info,
//     required this.onTap,
//   });
//   final Icon icon;
//   final String infoName;
//   final String info;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
//         child: Row(
//           children: [
//             icon,
//             SizedBox(width: 25),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(infoName, style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(info, style: TextStyle(color: Colors.black45)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
