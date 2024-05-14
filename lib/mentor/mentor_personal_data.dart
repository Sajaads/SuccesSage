import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:successage/mentee/mentee_detail.dart';
import 'package:successage/mentor/mentor_skill.dart';
import 'package:successage/models/mentordb.dart';

class MentorPersonalData extends StatefulWidget {
  final String uid;
  const MentorPersonalData({Key? key, required this.uid});

  @override
  State<MentorPersonalData> createState() => _MentorPersonalDataState();
}

class _MentorPersonalDataState extends State<MentorPersonalData> {
  String? fname;
  String? lname;
  String? mail;
  String? bio;
  String? designation;
  num? phnno;
  bool button = false;
  File? _profileImage;
  File? _proofImage;

  String? _imageUrl;
  String? _proofImageUrl; // New variable for proof image URL
  bool _loading = false;
  final picker = ImagePicker();

  Future getImageFromSource(ImageSource source,
      {bool isProfileImage = true}) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );

    setState(() {
      if (pickedFile != null) {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _proofImage = File(pickedFile.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      if (_profileImage != null) {
        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child(
                'mentee_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_profileImage!);

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

  Future<void> uploadProofImageToFirebaseStorage() async {
    try {
      if (_proofImage != null) {
        // Upload proof image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('proof_images')
            .child('proof_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_proofImage!);

        // Get the download URL of the uploaded proof image
        String downloadURL = await ref.getDownloadURL();

        setState(() {
          _proofImageUrl = downloadURL;
        });
      } else {
        print('No proof image selected.');
      }
    } catch (e) {
      print('Error uploading proof image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF8ECAE6),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo1.png',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Tell Us About Yourself',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                      labelText: "Last name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                            duration: Duration(seconds: 2),
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
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                        designation = value;
                        checkbutton();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Professional Role",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Upload your photo here',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                                  getImageFromSource(ImageSource.gallery,
                                      isProfileImage: true);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Photo'),
                                onTap: () {
                                  getImageFromSource(ImageSource.camera,
                                      isProfileImage: true);
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
                const SizedBox(
                  height: 20,
                ),
                if (_profileImage != null)
                  Container(
                    width: 200,
                    height: 200,
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
                      image: DecorationImage(
                        image: FileImage(_profileImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 30,
                ),
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
                                  getImageFromSource(ImageSource.gallery,
                                      isProfileImage: false);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Photo'),
                                onTap: () {
                                  getImageFromSource(ImageSource.camera,
                                      isProfileImage: false);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Upload Proof'),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_proofImage != null)
                  Container(
                    width: 200,
                    height: 200,
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
                      image: DecorationImage(
                        image: FileImage(_proofImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 2, 48, 71), // Text color
                  ),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    await uploadImageToFirebaseStorage();
                    await uploadProofImageToFirebaseStorage(); // Upload proof image
                    if (button && _imageUrl != null && _proofImageUrl != null) {
                      // Adding mentor data to Firestore
                      addMentorToFirestore(widget.uid,
                          fname: fname,
                          lname: lname,
                          phnno: phnno,
                          email: mail,
                          ppic: _imageUrl!,
                          designation: designation,
                          proof: _proofImageUrl!); // Include proof image URL

                      setState(() {
                        _loading = false;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MentorSkill(
                                uid: widget.uid,
                              )));
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
                if (_loading)
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
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
          designation != null &&
          designation!.isNotEmpty;
    });
  }
}
