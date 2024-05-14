import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:successage/mentee/mentee_detail.dart';
import 'package:successage/models/menteeDb.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ScreenSignupInfo extends StatefulWidget {
  final String id;
  ScreenSignupInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<ScreenSignupInfo> createState() => _ScreenSignupInfoState();
}

class _ScreenSignupInfoState extends State<ScreenSignupInfo> {
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
    final pickedFile = await picker.pickImage(
      source: source,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      if (_image != null) {
        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child(
                'mentee_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);

        // Get the download URL of the uploaded image
        String downloadURL = await ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadURL;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Image.asset('assets/Logo1.png'),
                  Text('Let us know more about you'),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          fname = value;
                          checkbutton();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "First Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          lname = value;
                          checkbutton();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          mail = value;
                          checkbutton();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          try {
                            phnno = num.parse(value);
                          } catch (e) {
                            phnno = null;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Enter a valid number"),
                              duration: Duration(milliseconds: 500),
                            ));
                          }
                          checkbutton();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Phone No",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: edq,
                      onChanged: (value) {
                        setState(() {
                          edq = value;
                          checkbutton();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Education Qualification",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 162, 171, 178),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 154, 170, 183),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: "High School",
                          child: Text("High School"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Bachelor's Degree",
                          child: Text("Bachelor's Degree"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Master's Degree",
                          child: Text("Master's Degree"),
                        ),
                        // Add more options as needed
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 2, 48, 71), // Text color
                    ),
                    onPressed: () {
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
                                    getImageFromSource(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text('Take a Photo'),
                                  onTap: () {
                                    getImageFromSource(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Upload Image'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 2, 48, 71), // Text color
                    ),
                    onPressed: () async {
                      checkbutton();
                      setState(() {
                        _loading = true;
                      });
                      await uploadImageToFirebaseStorage();
                      if (button && _imageUrl != null) {
                        addMenteeToFirestore(
                          widget.id,
                          fname: fname,
                          lname: lname,
                          phnno: phnno,
                          email: mail,
                          edq: edq,
                          ppic: _imageUrl!,
                        );

                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return MenteeDataCollection(
                            uid: widget.id,
                            collection: "mentee",
                          );
                        })));
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please enter all the fields and upload image '),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text('Next'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_loading)
                    Container(
                      child: Center(
                        child: SimpleCircularProgressBar(
                          size: 40,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
