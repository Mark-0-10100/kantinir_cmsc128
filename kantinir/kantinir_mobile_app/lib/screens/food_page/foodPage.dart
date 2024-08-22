import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kantinir_mobile_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../food_page/foodPage.dart';
import '../housing_page/housingPage.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final CollectionReference _kaon =
      FirebaseFirestore.instance.collection("kaon");

  List<String> array_foodType = ["base_tag"];

  String search_name_input = "";
  int budget_min = 0;

  double _slider_minimum_budget = 300;
  bool _slider_minimum_budget_toggled = false;

  double _slider_minimum_review = 1;
  bool _slider_minimum_review_is_toggled = false;

  bool is_changing_menu = false;
  bool is_changing_menu_is_switched = false;

  bool has_pork = false;
  bool has_pork_is_switched = false;

  bool has_beef = false;
  bool has_beef_is_switched = false;

  bool has_chicken = false;
  bool has_chicken_is_switched = false;

  bool has_vegies = false;
  bool has_vegies_is_switched = false;

  bool fliterIsSwitched = false;
  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.6;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 25),
                Text(
                  'Select Minimum Budget Value for one meal: Php $_slider_minimum_budget',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 10),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.0,
                    activeTrackColor:
                        Colors.blue[800], // Darker blue for active part
                    inactiveTrackColor:
                        Colors.blue[100], // Lighter blue for inactive part
                    thumbColor: Colors.white, // White thumb
                    overlayColor:
                        Colors.blue[800]?.withOpacity(0.3), // Overlay color
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.blue[800],
                    inactiveTickMarkColor: Colors.blue[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor:
                        Colors.blue[800], // Darker blue value indicator
                    valueIndicatorTextStyle:
                        TextStyle(color: Colors.white), // White text
                  ),
                  child: Slider(
                    value: _slider_minimum_budget,
                    max: 300,
                    divisions: 10,
                    label: _slider_minimum_budget.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _slider_minimum_budget = value;
                        _slider_minimum_budget_toggled = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            //Todo #1 This needs a corresponding query condition
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Enable Food Filter',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14.0,
                            ),
                          ),
                          Switch(
                            value: fliterIsSwitched,
                            onChanged: (value) {
                              setState(() {
                                fliterIsSwitched = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (fliterIsSwitched)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  ChoiceChip(
                                    label: Text(
                                      'Pork',
                                      style: TextStyle(
                                        color: has_pork
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: has_pork,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        has_pork = selected;
                                        if (selected) {
                                          array_foodType.add('pork');
                                        } else {
                                          array_foodType.remove('pork');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: has_pork
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        has_pork ? Icons.check : Icons.close,
                                        color: has_pork
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  //---------------------
                                  // ChoiceChip(
                                  //   label: Text('has_pork'),
                                  //   selected: has_pork,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       has_pork = selected;
                                  //       if (selected) {
                                  //         array_foodType.add('pork');
                                  //       } else {
                                  //         array_foodType.remove('pork');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  //=================
                                  ChoiceChip(
                                    label: Text(
                                      'Beef',
                                      style: TextStyle(
                                        color: has_beef
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: has_beef,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        has_beef = selected;
                                        if (selected) {
                                          array_foodType.add('beef');
                                        } else {
                                          array_foodType.remove('beef');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: has_beef
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        has_beef ? Icons.check : Icons.close,
                                        color: has_beef
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  //---------------------
                                  // ChoiceChip(
                                  //   label: Text('has_beef'),
                                  //   selected: has_beef,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       has_beef = selected;
                                  //       if (selected) {
                                  //         array_foodType.add('beef');
                                  //       } else {
                                  //         array_foodType.remove('beef');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  ChoiceChip(
                                    label: Text(
                                      'Chicken',
                                      style: TextStyle(
                                        color: has_chicken
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: has_chicken,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        has_chicken = selected;
                                        if (selected) {
                                          array_foodType.add('chicken');
                                        } else {
                                          array_foodType.remove('chicken');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: has_chicken
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        has_chicken ? Icons.check : Icons.close,
                                        color: has_chicken
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  // ChoiceChip(
                                  //   label: Text('has_chicken'),
                                  //   selected: has_chicken,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       has_chicken = selected;
                                  //       if (selected) {
                                  //         array_foodType.add('chicken');
                                  //       } else {
                                  //         array_foodType.remove('chicken');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  ChoiceChip(
                                    label: Text(
                                      'Vegetables',
                                      style: TextStyle(
                                        color: has_vegies
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: has_vegies,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        has_vegies = selected;
                                        if (selected) {
                                          array_foodType.add('vegies');
                                        } else {
                                          array_foodType.remove('vegies');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: has_vegies
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        has_vegies ? Icons.check : Icons.close,
                                        color: has_vegies
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),

                                  // ChoiceChip(
                                  //   label: Text('has_vegies'),
                                  //   selected: has_vegies,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       has_vegies = selected;
                                  //       if (selected) {
                                  //         array_foodType.add('vegies');
                                  //       } else {
                                  //         array_foodType.remove('vegies');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: 5,
                        )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: createQuery(_kaon).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot records =
                            snapshots.data!.docs[index];
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
                                        motion: StretchMotion(), children: []),
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
                                        title: Text(
                                          "\n\n\n\n" + records["name"],
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Text(
                                          'Average Rating: ${averageRating.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 12.0,
                                          ),
                                        ),
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
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _kaon
                    .orderBy('averageRating', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot records =
                            snapshots.data!.docs[index];
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
                                        motion: StretchMotion(), children: []),
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
                                        color: Colors.grey,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 158, 158, 158),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ListTile(
                                        title: Text(records["name"]),
                                        subtitle: Text(records["owner"] +
                                            '\n' +
                                            (records["fb link"]) +
                                            '\n' +
                                            (records["location"])),
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
          ],
        ),
      ),
    );
  }

  Query createQuery(Query queryReference) {
    Query query = queryReference;

    if (fliterIsSwitched == false) {
      query =
          query.where('min_spend', isLessThanOrEqualTo: _slider_minimum_budget);
    }

    if (fliterIsSwitched == true) {
      query = query.where('food_type_array', arrayContainsAny: array_foodType);
    }

    return query;
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
