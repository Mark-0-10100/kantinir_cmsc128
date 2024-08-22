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

class HousingPage extends StatefulWidget {
  const HousingPage({super.key});

  @override
  State<HousingPage> createState() => _housingPageState();
}

class _housingPageState extends State<HousingPage> {
  final CollectionReference _tinir =
      FirebaseFirestore.instance.collection("tinir");
  String search_name_input = "";
  List<String> array_tag_housing = ["base_tag"];

  bool is_private_cr = false;
  bool is_allows_cooking = false;
  bool is_no_curfew = false;
  bool is_aircondition = false;
  bool is_has_refrigirator = false;

  bool fliterIsSwitched = false;

  double _slider_minimum_budget = 15000;

  @override
  Widget build(BuildContext context) {
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
                    max: 15000,
                    divisions: 30,
                    label: _slider_minimum_budget.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _slider_minimum_budget = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            //Slider
            Column(
              children: [
                SizedBox(height: 10),
                Text(
                    'Select Minimum Budget Value for a bed space: Php $_slider_minimum_budget'),
                SizedBox(height: 10),
                Slider(
                  value: _slider_minimum_budget,
                  max: 15000,
                  divisions: 30,
                  label: _slider_minimum_budget.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _slider_minimum_budget = value;
                    });
                  },
                ),
              ],
            ),
            // Tag filters
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
                            'Enable Housing Filter',
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
                                      'Private CR',
                                      style: TextStyle(
                                        color: is_private_cr
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: is_private_cr,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        is_private_cr = selected;
                                        if (selected) {
                                          array_tag_housing.add('private_cr');
                                        } else {
                                          array_tag_housing
                                              .remove('private_cr');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: is_private_cr
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        is_private_cr
                                            ? Icons.check
                                            : Icons.close,
                                        color: is_private_cr
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  ChoiceChip(
                                    label: Text(
                                      'Allows Cooking',
                                      style: TextStyle(
                                        color: is_allows_cooking
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: is_allows_cooking,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        is_allows_cooking = selected;
                                        if (selected) {
                                          array_tag_housing
                                              .add('allows_cooking');
                                        } else {
                                          array_tag_housing
                                              .remove('allows_cooking');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: is_allows_cooking
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        is_allows_cooking
                                            ? Icons.check
                                            : Icons.close,
                                        color: is_allows_cooking
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  // ChoiceChip(
                                  //   label: Text('is_allows_cooking'),
                                  //   selected: is_allows_cooking,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       is_allows_cooking = selected;
                                  //       if (selected) {
                                  //         array_tag_housing
                                  //             .add('allows_cooking');
                                  //       } else {
                                  //         array_tag_housing
                                  //             .remove('allows_cooking');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  ChoiceChip(
                                    label: Text(
                                      'No Curfew',
                                      style: TextStyle(
                                        color: is_no_curfew
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: is_no_curfew,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        is_no_curfew = selected;
                                        if (selected) {
                                          array_tag_housing.add('no_curfew');
                                        } else {
                                          array_tag_housing.remove('no_curfew');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: is_no_curfew
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        is_no_curfew
                                            ? Icons.check
                                            : Icons.close,
                                        color: is_no_curfew
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  // ChoiceChip(
                                  //   label: Text('is_no_curfew'),
                                  //   selected: is_no_curfew,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       is_no_curfew = selected;
                                  //       if (selected) {
                                  //         array_tag_housing.add('no_curfew');
                                  //       } else {
                                  //         array_tag_housing.remove('no_curfew');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  ChoiceChip(
                                    label: Text(
                                      'Air Condition',
                                      style: TextStyle(
                                        color: is_aircondition
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: is_aircondition,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        is_aircondition = selected;
                                        if (selected) {
                                          array_tag_housing.add('aircondition');
                                        } else {
                                          array_tag_housing
                                              .remove('aircondition');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: is_aircondition
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        is_aircondition
                                            ? Icons.check
                                            : Icons.close,
                                        color: is_aircondition
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  // ChoiceChip(
                                  //   label: Text('is_aircondition'),
                                  //   selected: is_no_curfew,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       is_aircondition = selected;
                                  //       if (selected) {
                                  //         array_tag_housing.add('aircondition');
                                  //       } else {
                                  //         array_tag_housing
                                  //             .remove('aircondition');
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  ChoiceChip(
                                    label: Text(
                                      'Has Refrigirator',
                                      style: TextStyle(
                                        color: is_has_refrigirator
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: is_has_refrigirator,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        is_has_refrigirator = selected;
                                        if (selected) {
                                          array_tag_housing
                                              .add('has_refrigirator');
                                        } else {
                                          array_tag_housing
                                              .remove('has_refrigirator');
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blue[800], // Royal blue when active
                                    backgroundColor: const Color.fromARGB(255,
                                        209, 209, 209), // Gray when inactive
                                    avatar: CircleAvatar(
                                      backgroundColor: is_has_refrigirator
                                          ? Colors.blue[800]
                                          : Colors.grey,
                                      child: Icon(
                                        is_has_refrigirator
                                            ? Icons.check
                                            : Icons.close,
                                        color: is_has_refrigirator
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),

                                  // ChoiceChip(
                                  //   label: Text('is_has_refrigirator'),
                                  //   selected: is_has_refrigirator,
                                  //   onSelected: (bool selected) {
                                  //     setState(() {
                                  //       is_has_refrigirator = selected;
                                  //       if (selected) {
                                  //         array_tag_housing
                                  //             .add('has_refrigirator');
                                  //       } else {
                                  //         array_tag_housing
                                  //             .remove('has_refrigirator');
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
                        Text("")
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream: createQuery(_tinir).snapshots(),
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
          ],
        ),
      ),
    );
  }

  Query createQuery(Query queryReference) {
    Query query = queryReference;
    //query = query.where('housing_tags', arrayContainsAny: array_tag_housing);

    // if (fliterIsSwitched == false) {
    //   query =
    //       query.where('min_spend', isLessThanOrEqualTo: _slider_minimum_budget);
    // }

    if (fliterIsSwitched == false) {
      query =
          query.where('min_spend', isLessThanOrEqualTo: _slider_minimum_budget);
    }

    if (fliterIsSwitched == true) {
      query = query.where('housing_tags', arrayContainsAny: array_tag_housing);
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
