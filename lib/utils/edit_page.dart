import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:successage/utils/textfield.dart';

import '../models/menteeDb.dart';
import 'app_layouts.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _bio = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _designation = TextEditingController();
  TextEditingController _phone_no = TextEditingController();

  String? fname;
  String? lname;
  String? mail;
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
                'mentor_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
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
  }

  Stream<Map<String, dynamic>> _fetchMentorDataStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
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
                            backgroundImage:
                                NetworkImage(snapshot.data!['ppic']),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {},
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
                            ))
                      ]),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyTextField(
                                textController: _fname,
                                hintText: snapshot.data!['fname'],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyTextField(
                                textController: _lname,
                                hintText: snapshot.data!['lname'],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          textController: _phone_no,
                          hintText: snapshot.data!['phone no'].toString()),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          textController: _email,
                          hintText: snapshot.data!['email']),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          textController: _bio,
                          hintText: snapshot.data!['bio']),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          textController: _designation,
                          hintText: snapshot.data!['designation']),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async{
                            checkbutton();
                            setState(() {
                              _loading=true;
                            });
                            await uploadImageToFirebaseStorage();
                            if(button &&_imageUrl != null){
                              addMenteeToFirestore(
                                _user.uid,
                                fname: fname,
                                lname: lname,
                                phnno: phnno,
                                email: mail,
                                edq: edq,
                                ppic: _imageUrl!,
                              );
                            }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    ));
  }
  void checkbutton() {
    setState(() {
      button = fname != null &&
          fname!.isNotEmpty &&
          lname != null &&
          lname!.isNotEmpty &&
          mail != null &&
          mail!.isNotEmpty &&
          phnno != null &&
          edq != null &&
          edq!.isNotEmpty;
    });
  }
}
