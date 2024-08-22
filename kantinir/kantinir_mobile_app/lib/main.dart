import 'package:flutter/material.dart';
import 'package:kantinir_mobile_app/screens/authenticate/authenticate.dart';
import 'package:kantinir_mobile_app/screens/authenticate/sign_in.dart';
import 'package:kantinir_mobile_app/screens/food_page/food_establishments/48coffee_miagao.dart';
import 'package:kantinir_mobile_app/screens/food_page/food_establishments/aj_foodhub.dart';
import 'package:kantinir_mobile_app/screens/food_page/food_establishments/el_garaje.dart';
import 'package:kantinir_mobile_app/screens/food_page/food_establishments/kubo_resto.dart';
import 'package:kantinir_mobile_app/screens/food_page/food_establishments/mrj_chickenhouse_&_coffee.dart';
import 'package:kantinir_mobile_app/screens/home/profile_page.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housingPage.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housing_establishments/arkids_dorm.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housing_establishments/gumamela.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housing_establishments/kp_vision.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housing_establishments/lampirong.dart';
import 'package:kantinir_mobile_app/screens/housing_page/housing_establishments/royal_angels_dorm.dart';
import 'package:kantinir_mobile_app/screens/onboarding/onboarding1.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:kantinir_mobile_app/models/user.dart';
import 'package:kantinir_mobile_app/screens/wrapper.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // For launch screen
  // await Future.delayed(const Duration(seconds: 10));
  // FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: Wrapper());

    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name != null) {
            return MaterialPageRoute(builder: (context) {
              if (settings.name == 'El Garaje') {
                return elGarajePage();
              } else if (settings.name == 'Kubo Resto') {
                return kuboRestoPage();
              } else if (settings.name == 'A & J Food Hub') {
                return ajFoodHubPage();
              } else if (settings.name == '48 Coffee.Co Miagao') {
                return coffee48MiagaoPage();
              } else if (settings.name == 'Mr. J Chicken House and Cafe') {
                return mrJChickenHouseCoffee();
              } else if (settings.name == 'Arkids Dorm') {
                return arkidsDormPage();
              } else if (settings.name == 'KP Vision Boarding House') {
                return kpVisionPage();
              } else if (settings.name == 'Royal Angels Deluxe Dormtelle') {
                return royalAngelsPage();
              } else if (settings.name == 'Balay Lampirong UPV dorm') {
                return lampirongPage();
              } else if (settings.name == 'Balay Gumamela UPV dorm') {
                return gumamelaPage();
              }
              return Wrapper();
            });
          }
        },
        debugShowCheckedModeBanner: false,
        home: Onboarding1(),
        routes: {
          '/profile': (context) => profilePage(),
        },
      ),
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
