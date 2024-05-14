import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_reg_success.dart';
import 'package:successage/mentor/mentor_reg_success.dart';
import 'package:successage/models/menteeDb.dart';

class MenteeDataCollection extends StatefulWidget {
  final String uid;
  String collection;
  MenteeDataCollection({Key? key, required this.uid, required this.collection});

  @override
  State<MenteeDataCollection> createState() => _MenteeDataCollectionState();
}

class _MenteeDataCollectionState extends State<MenteeDataCollection> {
  String? _selectedFirstOption;
  List<String> _secondOptions = [];
  List<String> itembox = [];
  String? bio;

  void itemselection(String option) {
    setState(() {
      if (itembox.contains(option)) {
        itembox.remove(option);
      } else {
        itembox.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Logo1.png'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Area of interest:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('interest')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final interests =
                      snapshot.data!.docs.map((doc) => doc.id).toList();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: interests.map((interest) {
                        return ChoiceChip(
                          side: BorderSide.none,
                          elevation: 5,
                          shadowColor: Colors.black,
                          label: Text(interest),
                          selected: _selectedFirstOption == interest,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFirstOption = selected ? interest : null;
                              if (selected) {
                                _loadSecondOptions(interest);
                              } else {
                                _secondOptions.clear();
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              _selectedFirstOption != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Topic of interest',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            children: _secondOptions.map((option) {
                              return FilterChip(
                                side: BorderSide.none,
                                elevation: 5,
                                shadowColor: Colors.black,
                                label: Text(option),
                                selected: itembox.contains(option),
                                // Handle selection of second options
                                onSelected: (selected) {
                                  // Handle chip selection
                                  itemselection(option);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            textAlign: TextAlign.center,
                            'Give a bio so that mentors can understand you well.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(104, 166, 162, 162),
                              hintText: 'Type here...',
                            ),
                            onChanged: (value) {
                              bio = value;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(
                                    255, 2, 48, 71), // Text color
                              ),
                              onPressed: () {
                                if (_selectedFirstOption != null &&
                                    bio != null &&
                                    bio!.isNotEmpty) {
                                  // Ensure the user has selected an interest and provided a non-null and non-empty bio
                                  addMenteeinterest(widget.uid,
                                      bio: bio, interest: _selectedFirstOption);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => MenteeRegSuccess(
                                            uid: widget.uid,
                                            collection: widget.collection,
                                          ))));
                                } else {
                                  // Display a message or perform some action to indicate that the user needs to provide required inputs
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Please select an interest and provide a bio.'),
                                  ));
                                }
                              },
                              child: Text('Submit'))
                        ],
                      ),
                    )
                  : SizedBox(), // Placeholder if no option selected from first section
            ],
          ),
        ),
      ),
    );
  }

  void _loadSecondOptions(String interest) {
    // Fetch data for second section of options based on the selected interest
    FirebaseFirestore.instance
        .collection('interest')
        .doc(interest)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _secondOptions = (doc.data() as Map<String, dynamic>)
              .values
              .cast<String>()
              .toList();
        });
      }
    });
  }
}
