import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:kantinir_mobile_app/screens/authenticate/authenticate.dart';
import 'package:kantinir_mobile_app/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // key to associate data
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;
  void _handleRegisterError(String errorMessage) {
    setState(() {
      _errorMessage =
          errorMessage.replaceAllMapped(RegExp(r'\[[^\]]*\]'), (match) {
        return ''; // Replace the matched content with an empty string
      });
    });
  }

  // text field state
  String email = '';
  String password = '';
  String fcolor = '';
  String password1 = '';
  String confirmPassword = '';
  String error = '';
  String bday = '';
  String username = '';

  TextEditingController dateInput =
      TextEditingController(); // Initialize the controller

  String selectedEducationLevel = '';
  String educationValue = 'Choose education level';
  var educationLevels = [
    'Choose education level',
    'Elementary',
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Ph.D.',
  ];
  String selectedColorLevel = '';
  String colorValue = 'Choose a color';
  var colorLevels = [
    'Choose a color',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Color(0xFF22A1BB),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 0),
              const Text(
                "Create your",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFFB6B6B6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFFB6B6B6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Enter your username' : null,
                  onChanged: (val) {
                    setState(() => username = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFFB6B6B6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password1 = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFFB6B6B6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val != password1 ? 'Passwords do not match' : null,
                  onChanged: (val) {
                    setState(() => confirmPassword = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: dateInput,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Birthdate",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateInput.text = formattedDate;
                        bday = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: DropdownButton(
                    value: educationValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 83, 98, 93), fontSize: 17),
                    items: educationLevels.map((String educationItem) {
                      return DropdownMenuItem(
                        value: educationItem,
                        child: Text(educationItem),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        educationValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110),
                  child: DropdownButton(
                    value: colorValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 83, 98, 93), fontSize: 17),
                    items: colorLevels.map((String coloritem) {
                      return DropdownMenuItem(
                        value: coloritem,
                        child: Text(coloritem),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        colorValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 113, 62)),
                child: const Text('Register',
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email,
                        username,
                        confirmPassword,
                        colorValue,
                        bday,
                        educationValue,
                        _handleRegisterError);

                    if (result == null) {
                      setState(() => error = _errorMessage!);
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              const SizedBox(height: 180),
            ],
          ),
        ),
      ),
    );
  }
}
