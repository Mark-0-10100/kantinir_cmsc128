import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:kantinir_mobile_app/services/my_list_tile.dart';

class profilePage extends StatefulWidget {
  profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String imageUrl = '';
  final AuthService _auth = AuthService();
  String educationValue = 'Choose education level';
  var educationLevels = [
    'Choose education level',
    'Elementary',
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Ph.D.',
  ];

  // TextEditingController for updating the username
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  @override
  void dispose() {
    // Dispose the controller when the state is disposed
    usernameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, Map<String, dynamic> userData) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .update({'birthdate': formattedDate});
    }
  }

  Future<void> _showEducationDropdown(BuildContext context) async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Education Level'),
          content: DropdownButton<String>(
            value: educationValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(
              color: Color.fromARGB(255, 83, 98, 93),
              fontSize: 17,
            ),
            items: educationLevels.map((String educationItem) {
              return DropdownMenuItem<String>(
                value: educationItem,
                child: Text(educationItem),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                educationValue = newValue!;
              });
              Navigator.of(context).pop(newValue);
            },
          ),
        );
      },
    );

    if (newValue != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .update({'education': newValue});
    }
  }

  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    //String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //Step 2: upload to Firebase storage

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload =
        referenceDirImages.child('${currentUser.uid}.jpg');

    try {
      await referenceImageToUpload.putFile(File(file!.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .update({'profileImageURL': imageUrl});
    } catch (error) {
      //Some error occured
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 63, 77),
          title: Text("User Profile"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Center(
                          child: userData['profileImageURL'] != null
                              ? ClipOval(
                                  child: Image.network(
                                  userData['profileImageURL'],
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ))
                              : Icon(
                                  Icons.person,
                                  size: 200,
                                ),
                        ),
                      ),
                      MyListTile(
                        icon: Icons.manage_accounts,
                        text: "Username: " + userData["username"],
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Edit Username'),
                                  content: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter new Username',
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Update'),
                                      onPressed: () async {
                                        String newUsername =
                                            usernameController.text.trim();

                                        //Update the Firestore document with the new username
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(currentUser.email)
                                            .update({"username": newUsername});

                                        Navigator.of(context)
                                            .pop(); //close the dialog
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                      MyListTile(
                        icon: Icons.manage_accounts,
                        text: "Email: " + currentUser.email!,
                        onTap: () async {
                          String newEmail = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController emailController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text('Change Email'),
                                content: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Enter new Email'),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Update'),
                                    onPressed: () {
                                      String updatedEmail =
                                          emailController.text.trim();
                                      Navigator.of(context).pop(updatedEmail);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                          if (newEmail != null && newEmail.isNotEmpty) {
                            try {
                              // Prompt the user to re-enter their password for reauthentication
                              String password = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController passwordController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text('Re-enter Password'),
                                    content: TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: 'Enter your password'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () {
                                          String enteredPassword =
                                              passwordController.text.trim();
                                          Navigator.of(context)
                                              .pop(enteredPassword);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );

                              if (password != null && password.isNotEmpty) {
                                // Re-authenticate the user with their current credentials
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                  email: currentUser.email!,
                                  password: password,
                                );

                                await currentUser
                                    .reauthenticateWithCredential(credential);

                                // Update email
                                await currentUser.updateEmail(newEmail);

                                // Show a success message
                                print('Update Email Success!');
                              }
                            } catch (e) {
                              //Show an error message if the update fails
                              print('Error updating email: $e');
                            }
                          }
                        },
                      ),
                      MyListTile(
                        icon: Icons.calendar_month,
                        text: 'Birthdate: ' + userData["birthdate"],
                        onTap: () {
                          _selectDate(context, userData);
                        },
                      ),
                      MyListTile(
                        icon: Icons.school,
                        text: 'Education: ' + userData["education"],
                        onTap: () {
                          _showEducationDropdown(context);
                        },
                      ),
                      MyListTile(
                        icon: Icons.admin_panel_settings,
                        text: 'Change Password',
                        onTap: () {
                          //Password tap functionality (edit user)
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Container(
                      color: Colors.grey,
                      child: MyListTile(
                        icon: Icons.logout,
                        text: 'Log Out',
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error${snapshot.error}'));
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
