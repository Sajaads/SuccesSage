import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:successage/mentor/profile_page.dart';
import 'package:successage/utils/textfield.dart';

import '../models/menteeDb.dart';
import '../utils/app_layouts.dart';

class MenteeEditPage extends StatefulWidget {
  const MenteeEditPage({Key? key}) : super(key: key);

  @override
  State<MenteeEditPage> createState() => _MenteeEditPageState();
}

class _MenteeEditPageState extends State<MenteeEditPage> {
  bool isEditing = false;
  late TextEditingController _fname = TextEditingController();
  late TextEditingController _lname = TextEditingController();
  late TextEditingController _bio = TextEditingController();
  late TextEditingController _email = TextEditingController();
  late TextEditingController _designation = TextEditingController();
  late TextEditingController _phone_no = TextEditingController();

  String? fname;
  String? lname;
  String? mail;
  String? bio;
  String? edq;
  num? phnno;
  bool button = false;
  File? _image;
  String? _imageUrl;
  bool _loading = false;
  final picker = ImagePicker();

  Future getImageFromSource(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      if (_image != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child(
            'mentee_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);

        String downloadURL = await ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadURL;
        });
      } else {
        print("No image selected .");
      }
    } catch (e) {
      print("Error uploading image : $e");
    }
  }

  late FirebaseAuth.User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
    TextEditingController _fname = TextEditingController(text: fname);
    TextEditingController _lname = TextEditingController(text: lname);
    TextEditingController _bio = TextEditingController(text: bio);
    TextEditingController _email = TextEditingController(text: mail);
    TextEditingController _designation = TextEditingController(text: edq);
    TextEditingController _phone_no = TextEditingController(text: phnno.toString());
    TextEditingController(text: phnno.toString());
  }

  Stream<Map<String, dynamic>> _fetchMentorDataStream() {
    return FirebaseFirestore.instance
        .collection('mentee')
        .doc(_user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("Edit Profile ")),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<Map<String, dynamic>>(
            stream: _fetchMentorDataStream(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Center(child: Text("No data available"));
              } else {
                fname = snapshot.data!['fname'];
                lname = snapshot.data!['lname'];
                mail = snapshot.data!['email'];
                bio = snapshot.data!['bio'];
                edq = snapshot.data!['designation'];
                phnno = snapshot.data!['phone no'];
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!) as ImageProvider
                                  : NetworkImage(snapshot.data!['ppic']),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.photo_library),
                                            title: Text('Choose from Gallery'),
                                            onTap: () {
                                              getImageFromSource(
                                                  ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Take a Photo'),
                                            onTap: () {
                                              getImageFromSource(
                                                  ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: MyTextField(
                                  labelText: "fname",
                                  textController: _fname,
                                  hintText: fname.toString(),
                                  fieldName: 'fname',
                                  defaultValue: fname.toString(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: MyTextField(
                                  labelText: "lname",
                                  textController: _lname,
                                  hintText: lname.toString(),
                                  fieldName: 'lname',
                                  defaultValue: lname.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          labelText: "phone no",
                          textController: _phone_no,
                          hintText: phnno.toString(),
                          fieldName: 'phone no',
                          defaultValue: phnno.toString(),
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          labelText: "email",
                          textController: _email,
                          hintText: mail.toString(),
                          fieldName: 'email',
                          defaultValue: mail.toString(),
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          labelText: "bio",
                          textController: _bio,
                          hintText: bio.toString(),
                          fieldName: 'bio',
                          defaultValue: bio.toString(),
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          labelText: "designation",
                          textController: _designation,
                          hintText: edq.toString(),
                          fieldName: 'designation',
                          defaultValue: edq.toString(),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            await uploadImageToFirebaseStorage();
                            editMenteeToFirestore(
                                _user.uid,
                                _fname.text,
                                _lname.text,
                                _email.text,
                                _bio.text,
                                _designation.text,
                                _imageUrl.toString(),
                                num.tryParse(_phone_no.text)!
                            );

                            Navigator.pop(context);
                            setState(() {
                              _loading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void editMenteeToFirestore(String uid, String fname, String lname,
      String email, String biodata, String designation, String ppic,num phnno) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Mentee mentee = Mentee(
        fname: fname,
        lname: lname,
        email: email,
        phnno: phnno,
        bio: biodata,
        designation: designation,
        ppic: ppic);

    firestore
        .collection('mentee') // Replace 'mentees' with your collection name
        .doc(_user.uid) // Document ID is set to the UID
        .update(mentee.toMap())
        .then((value) => print("Mentee added successfully"))
        .catchError((error) => print("Failed to add mentee: $error"));
  }
}

class Mentee {
  String fname;
  String lname;
  String email;
  String bio;
  String ppic;
  String? designation;
  num? phnno;

  Mentee(
      {required this.fname,
        required this.lname,
        required this.email,
        required this.bio,
        required this.ppic,
        required this.designation,
        required this.phnno});

  // Convert Mentor object to a Map
  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'bio': bio,
      'ppic': ppic,
      'designation': designation,
      'phone no': phnno
    };
  }
}
