import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kantinir_mobile_app/screens/home/profile_page.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../food_page/foodPage.dart';
import '../housing_page/housingPage.dart';
import 'home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  int currentIndex = 1;
  final screens = [
    FoodPage(),
    Home_contentPage(),
    HousingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final CollectionReference _kaon =
        FirebaseFirestore.instance.collection("kaon");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 255, 236),
      appBar: AppBar(
        title: Text('KanTinir'),
        backgroundColor: Color.fromARGB(255, 0, 63, 77),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('profile'),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            }, 
          ),
          TextButton.icon(
            icon: Icon(Icons.logout),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          
        ],
      ),
      // body: Center(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 500,
      //         child: StreamBuilder(
      //           stream: _kaon.snapshots(),
      //           builder: (context, AsyncSnapshot snapshots) {
      //             if (snapshots.connectionState == ConnectionState.waiting) {
      //               return Center(
      //                 child: CircularProgressIndicator(color: Colors.green),
      //               );
      //             }
      //             if (snapshots.hasData) {
      //               return ListView.builder(
      //                 itemCount: snapshots.data!.docs.length,
      //                 itemBuilder: (context, index) {
      //                   final DocumentSnapshot records =
      //                       snapshots.data!.docs[index];
      //                   return Slidable(
      //                     startActionPane:
      //                         ActionPane(motion: StretchMotion(), children: [
      //                       // SlidableAction(
      //                       //   onPressed: (context) {
      //                       //     navigateToNewPage(context);
      //                       //   },
      //                       //   icon: Icons.phone,
      //                       //   backgroundColor: Colors.blue,
      //                       // )
      //                     ]),
      //                     child: ListTile(
      //                       title: Text(records["name"]),
      //                       subtitle: Text(records["owner"] +
      //                           '\n' +
      //                           (records["fb link"]) +
      //                           '\n' +
      //                           (records["location"])),
      //                     ),
      //                   );
      //                 },
      //               );
      //             }
      //             return Center(
      //               child: CircularProgressIndicator(color: Colors.red),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(label: "Food", icon: Icon(Icons.sensors)),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Housing',
            icon: Icon(Icons.inventory),
          )
        ],
      ),
    );
    // return Container(child: Text('This is the homepage'));
  }
}
