import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class arkidsDormPage extends StatelessWidget {
  arkidsDormPage({super.key});
final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController commentController = TextEditingController();
  double rating = 0;

  Future<String?> getUsernameFromEmail(String email) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();

      if (snapshot.exists) {
        return snapshot['username'];
      } else {
        return null;
      }
    }

  Future<void> submitReview(BuildContext context) async {
    String? userEmail = currentUser.email;
    String? username = await getUsernameFromEmail(userEmail!);
    


    Map<String, dynamic> reviewData = {
      'userId' : username,
      'rating' : rating,
      'comment' : commentController.text,
    };

    // Store the review in Firebase
    FirebaseFirestore.instance.collection('tinir').doc('1').collection("reviews").add(reviewData);
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arkids Dorm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage('assets/your_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing between image and paragraph
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This is a paragraph describing Arkids Dorm. Add your text here.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20), // Add spacing between paragraph and "Menu" header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Add menu items or further widgets below as needed

            SizedBox(height: 20), // Add spacing between menu and "Review" header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Review',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10), // Add spacing between "Review" header and review section

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Been here?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5), // Add spacing between "Been here?" and "Leave a review"
                  GestureDetector(
                    onTap: () {
                      // Add code to show a review dialogue
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Leave a review'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber
                                  ),
                                  onRatingUpdate: (value) {
                                    rating = value;
                                  },
                                ),
                                TextFormField(
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    hintText: 'Write your review here',
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => submitReview(context),
                                child: Text('Submit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Leave a review',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tinir')
                  .doc('1')
                  .collection('reviews')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  String? userEmail = currentUser.email;
                  return FutureBuilder<String?>(
                    future: getUsernameFromEmail(userEmail!), // Assuming `currentUser` is defined somewhere
                    builder: (context, usernameSnapshot) {
                      if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final currentUsername = usernameSnapshot.data;

                      return Column(
                        children: snapshot.data!.docs.map((document) {
                          var data = document.data() as Map<String, dynamic>;
                          double rating = data['rating'].toDouble(); // Convert rating to double
                          String userId = data['userId'];

                          bool isCurrentUser = currentUsername == userId;

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Stack(
                              children: [
                                ListTile(
                                  title: Text('Username: $userId'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Rating: '),
                                          RatingBar.builder(
                                            initialRating: rating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (value) {},
                                          ),
                                        ],
                                      ),
                                      Text('Comment: ${data['comment']}'),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 4.0,
                                  right: 4.0,
                                  child: isCurrentUser
                                      ? IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirmation'),
                                                  content: Text('Are you sure you want to remove this comment?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        FirebaseFirestore.instance
                                                            .collection('tinir')
                                                            .doc('1')
                                                            .collection('reviews')
                                                            .doc(document.id)
                                                            .delete();

                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Remove'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                }

                return Center(child: Text(
                  'No reviews yet.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  ));
              },
            ),
            
          ],
        ),
      ),
    );
  }
}