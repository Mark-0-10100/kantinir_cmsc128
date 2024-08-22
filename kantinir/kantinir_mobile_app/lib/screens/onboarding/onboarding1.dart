import 'package:flutter/material.dart';
import 'package:kantinir_mobile_app/screens/onboarding/onboarding2.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Onboarding2(),
          ));
        },
        child: Center(
          child: RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'KAN',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                TextSpan(
                  text: 'TINIR',
                  style: TextStyle(
                      color: Color(0xFF59CCB5),
                      fontSize: 64,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
