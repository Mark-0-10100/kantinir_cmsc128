import 'package:async/async.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kantinir_mobile_app/services/my_list_tile.dart';
import 'package:rxdart/rxdart.dart';
import '../food_page/foodPage.dart';
import '../housing_page/housingPage.dart';

class Home_contentPage extends StatefulWidget {
  const Home_contentPage({Key? key}) : super(key: key);

  @override
  State<Home_contentPage> createState() => _Home_contentPageState();
}

class _Home_contentPageState extends State<Home_contentPage> {
  final CollectionReference _kaon =
      FirebaseFirestore.instance.collection("kaon");
  final CollectionReference _tinir =
      FirebaseFirestore.instance.collection("tinir");

  CollectionReference currentCollection =
      FirebaseFirestore.instance.collection("kaon");

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _showImage = false;
  Widget currentPage = Container();
  int currentIndex = 0;

  void updateCollection(bool isKaon) {
    setState(() {
      currentCollection = isKaon ? _kaon : _tinir;
    });
  }

  @override
  void initState() {
    super.initState();
    _showWelcomeDialog();
  }

  void _showWelcomeDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Welcome!"),
            content: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Text(
                    "Welcome, ${userData["username"]}!",
                    style: TextStyle(fontSize: 18),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "What are you looking for?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              //child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      updateCollection(true);
                    },
                    child: Image.asset(
                      'images/food_lua.jpg', // Replace this with your image path
                      //width: 50,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      updateCollection(false);
                    },
                    child: Image.asset(
                      'images/Housing_lua.jpg', // Replace this with your image path
                      //width: 50,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
              //),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'RECOMMENDATIONS',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: FoodPageList(
                kaonCollection: _kaon,
                tinirCollection: _tinir,
                collectionReference: currentCollection),
          ),
        ],
      ),
    );
  }
}

class FoodPageList extends StatelessWidget {
  // final CollectionReference _kaon = FirebaseFirestore.instance.collection("kaon");
  // final CollectionReference _tinir = FirebaseFirestore.instance.collection("tinir");
  final CollectionReference collectionReference;
  final CollectionReference kaonCollection;
  final CollectionReference tinirCollection;

  const FoodPageList(
      {Key? key,
      required this.collectionReference,
      required this.kaonCollection,
      required this.tinirCollection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 350,
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: _mergeAndSortCollectionStreams(),
                  builder: (context,
                      AsyncSnapshot<List<QueryDocumentSnapshot>> snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }
                    if (snapshots.hasData) {
                      List<QueryDocumentSnapshot> combinedData =
                          snapshots.data!;

                      List<QueryDocumentSnapshot> filteredData =
                          combinedData.where((doc) {
                        return doc.reference.parent == collectionReference;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot records = filteredData[index];
                          final reviewsCollection =
                              records.reference.collection('reviews');

                          return StreamBuilder<double>(
                            stream: getAverageRatingStream(
                                reviewsCollection, records.reference),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                final averageRating = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, records["name"]);
                                    },
                                    child: Slidable(
                                      startActionPane: ActionPane(
                                          motion: StretchMotion(),
                                          children: []),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'images/${records["name"]}.jpg'),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Colors.white.withOpacity(0.8),
                                              BlendMode.srcOver,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: ListTile(
                                          title: Text(records["name"]),
                                          //subtitle: Text(records["owner"] + '\n' + (records["fb link"]) + '\n' + (records["location"])),
                                          trailing: Text(
                                              'Average Rating: ${averageRating.toStringAsFixed(1)}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(); // Placeholder while waiting for rating
                            },
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<QueryDocumentSnapshot>> _mergeAndSortCollectionStreams() {
    return CombineLatestStream.combine2(
      kaonCollection.orderBy('averageRating', descending: true).snapshots(),
      tinirCollection.orderBy('averageRating', descending: true).snapshots(),
      (QuerySnapshot kaonSnap, QuerySnapshot tinirSnap) {
        final List<QueryDocumentSnapshot> kaonDocs = kaonSnap.docs;
        final List<QueryDocumentSnapshot> tinirDocs = tinirSnap.docs;

        // Combine and sort the snapshots from both collections
        List<QueryDocumentSnapshot> combinedSorted = [
          ...kaonDocs,
          ...tinirDocs
        ];
        combinedSorted
            .sort((a, b) => b['averageRating'].compareTo(a['averageRating']));

        return combinedSorted;
      },
    );
  }

  Stream<double> getAverageRatingStream(CollectionReference reviewsCollection,
      DocumentReference documentReference) {
    return reviewsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0.0;
      }

      double totalRating = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('rating')) {
          final rating = data['rating'];
          if (rating is num) {
            totalRating +=
                rating.toDouble(); // Assuming rating is a numeric value
          }
        }
      }

      final averageRating = totalRating / snapshot.docs.length;
      documentReference.update({
        'averageRating': averageRating
      }); // Update Firestore with the average rating
      return averageRating;
    });
  }
}
