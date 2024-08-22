import 'package:flutter/material.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:kantinir_mobile_app/screens/authenticate/authenticate.dart';
import 'package:kantinir_mobile_app/shared/constants.dart';
import 'package:kantinir_mobile_app/screens/authenticate/register.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  const SignInPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();

  // key to associate data
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  // error state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/person1.png', width: 280, height: 280),
                const SizedBox(height: 20),
                const Text(
                  "Let's get you in!",
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFB6B6B6)),
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
                    validator: (val) => val!.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.signInWithEmailAndPassword(
                          email,
                          password,
                        );
                        if (result == null) {
                          setState(() => error = 'credentials are not valid.');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF11CDA7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Register(
                          toggleView: () {},
                        ),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
