import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentor/mentor_reg_success.dart';
import 'package:successage/models/mentordb.dart';

class MentorSkill extends StatefulWidget {
  final String uid;
  MentorSkill({Key? key, required this.uid});

  @override
  State<MentorSkill> createState() => _MentorSkillState();
}

class _MentorSkillState extends State<MentorSkill> {
  String? _selectedFirstOption;
  List<String> _secondOptions = [];
  List<String> itembox = [];
  String? bio;
  FirebaseFirestore _fire = FirebaseFirestore.instance;

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
                  'Area of Expertise',
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
                          backgroundColor: Color.fromARGB(255, 51, 113, 131),
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 0, 0, 0),
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

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Specialized In ',
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
                            'Give a bio so that mentees can understand you well.',
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
                              fillColor: Colors.white,
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
                              onPressed: () {
                                if (_selectedFirstOption != null &&
                                    bio != null &&
                                    bio!.isNotEmpty) {
                                  addMentorSkill(widget.uid,
                                      bio: bio, interest: _selectedFirstOption);
                                  _fire
                                      .collection('mentor')
                                      .doc(widget.uid)
                                      .update({"verified": 'no'}).then(
                                          (value) => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MentorRegistrationSuccess(
                                                        uid: widget.uid,
                                                      ))));
                                } else {
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
                        fillColor: Colors.white,
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
                        onPressed: () {
                          if (_selectedFirstOption != null &&
                              bio != null &&
                              bio!.isNotEmpty) {
                            addMentorSkill(widget.uid,
                                bio: bio, interest: _selectedFirstOption);
                            _fire
                                .collection('mentor')
                                .doc(widget.uid)
                                .update({"verified": 'no'}).then(
                                    (value) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MentorRegistrationSuccess(
                                              uid: widget.uid,
                                            ))));
                          } else {
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
