
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart'
    as types; // Import User from flutter_chat_types

import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';


import 'package:uuid/uuid.dart';

import 'chat_services.dart';
import 'messages.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic>? mentee; // Make mentee property nullable

  const ChatPage({Key? key, required this.mentee}) : super(key: key);


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String id;
  final ChatService _chatService = ChatService();
  List<types.Message> _messages = [];
  late FirebaseAuth.User _user;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;


  @override
  void initState() {
    super.initState();

    id = widget.mentee?['uid'] ?? '';
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
    _loadMessages();
  }

  types.Message convertToMessageType(Map<String, dynamic> data) {
    if (data['type'] == 'text') {
      return types.TextMessage(
        id: data['id'],
        text: data['text'],
        author: types.User(id: data['from']),
        createdAt: data['createdAt'].millisecondsSinceEpoch,
      );
    } else if (data['type'] == 'image') {
      return types.ImageMessage(
        id: data['id'],
        name: data['name'],
        size: data['size'],
        uri: data['uri'],
        width: data['width'],
        height: data['height'],
        author: types.User(id: data['authorId']),
        createdAt: data['createdAt'].millisecondsSinceEpoch,
      );
    } else if (data['type'] == 'file') {
      return types.FileMessage(
        id: data['id'],
        name: data['name'],
        size: data['size'],
        uri: data['uri'],
        mimeType: data['mimeType'],
        author: types.User(id: data['authorId']),
        createdAt: data['createdAt'].millisecondsSinceEpoch,
      );
    }
    throw Exception('Invalid message type');
  }


  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }


  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: 144,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleImageSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Photo'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleFileSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('File'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(

        author: types.User(id: _user.uid),

        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(

        author: types.User(id: _user.uid),

        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =

              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(

            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(

            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(

    types.TextMessage message,
    types.PreviewData previewData,
  ) {

    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(

      author: types.User(id: _user.uid),

      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage); // Add message to local storage

    _chatService.sendMessage(
        convertToMessageModel(textMessage)); // Store message in Firestore
  }

  // Convert TextMessage to Message model
  Messages convertToMessageModel(types.TextMessage textMessage) {
    return Messages(
        id: textMessage.id,
        text: textMessage.text,
        from: _user.uid,
        to: widget.mentee!['uid'],
        createdAt: textMessage.createdAt != null
            ? DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!)
            : DateTime.now(),
        type: 'text');
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];

    String chatRoomID = ids.join('_');

    // Get a reference to the subcollection containing messages
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection("messages")
        .doc(chatRoomID)
        .collection('chats');

    // Query the messages in descending order of creation time
    return messagesCollection
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  void _loadMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription =
        getMessages(_user.uid, widget.mentee!['uid']).listen((querySnapshot) {
      final List<types.Message> messages = querySnapshot.docs
          .map(
              (doc) => convertToMessageType(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _messages = messages;
      });
    }, onError: (e) {
      // Handle stream errors
      print('Error loading messages: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading messages: $e'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // Display a loading indicator while waiting for _user to initialize
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.mentee?['fname'] ?? ''}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.mentee?['fname'] ?? ''}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          centerTitle: true,
        ),
        body: Chat(
          messages: _messages,
          //onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: types.User(id: _user.uid),
          theme: const DefaultChatTheme(
            seenIcon: Text(
              'read',
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
        ),
      );
    }
  }
}

