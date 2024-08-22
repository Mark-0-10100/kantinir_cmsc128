import 'package:kantinir_mobile_app/screens/authenticate/authenticate.dart';
import 'package:kantinir_mobile_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kantinir_mobile_app/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return AuthenticatePage();
    } else {
      return HomePage();
    }
  }
}
