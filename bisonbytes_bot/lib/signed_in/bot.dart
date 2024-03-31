import 'dart:convert';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme_provider.dart';
import '../../../../themes.dart';
import '../models/bot_message.dart';
import '../models/my_user.dart';
import '../services/bot_service.dart';
import 'recorder.dart';
import 'stt_file.dart';
import 'tts_file.dart';

class CourseBotChatPageThemeLoader extends StatefulWidget {
  const CourseBotChatPageThemeLoader({super.key});

  @override
  State<CourseBotChatPageThemeLoader> createState() =>
      _CourseBotChatPageThemeLoaderState();
}

class _CourseBotChatPageThemeLoaderState
    extends State<CourseBotChatPageThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: CourseBotChatPage(),
    );
  }
}

class CourseBotChatPage extends StatefulWidget {
  const CourseBotChatPage({super.key});

  @override
  State<CourseBotChatPage> createState() => _CourseBotChatPageState();
}

class _CourseBotChatPageState extends State<CourseBotChatPage> {
  late MyUser? user;
  final record = AudioRecorder();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? day;
  DateTime today = DateTime.now();
  final double _borderRadius = 40;
  bool thinking = false;

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 2),
      curve: Curves.easeIn,
    );
  }

  void askBotQuestion() async {
    if (_messageController.text.isNotEmpty) {
      BotMessage message =
          BotMessage(message: _messageController.text, isBot: false);

      await BotService(uid: user?.uid ?? '').addMessage(message);
      _messageController.clear();
      setState(() {
        thinking = true;
      });
      String url =
          'https://07f8-2601-152-b01-1550-f801-8bd1-8ea4-81ed.ngrok-free.app/api?Query=${message.message}';
      var decodedData;
      try {
        String data = await getData(url);
        decodedData = jsonDecode(data);
      } catch (e) {
        decodedData = {
          'response':
              'I am sorry, I am not able to answer that question at the moment'
        };
      }

      setState(() {
        thinking = false;
      });
      BotMessage botMessage =
          BotMessage(message: decodedData['response'], isBot: true);
      await BotService(uid: user?.uid ?? '').addMessage(botMessage);
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: BotService(uid: user?.uid ?? '').getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occured!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document, user))
                    .toList() +
                [
                  thinking ? Text('Thinking...') : SizedBox(),
                ],
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot, MyUser? user) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    var isBot = data['isBot'] ?? false;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              width: data['message'].length > (screenWidth / 10)
                  ? ((2 * screenWidth) / 3)
                  : null,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: isBot
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: data['message'].length > (screenWidth / 12)
                          ? ((2 * screenWidth) / 3)
                          : (data['message'].length / 6) * 47,
                      alignment: Alignment.topLeft,
                      // child: isBot ? TeXView(
                      //   child: TeXViewDocument(data['message'],
                      //       style: TeXViewStyle(
                      //         contentColor:
                      //             Theme.of(context).colorScheme.background,
                      //       )),
                      //   renderingEngine: TeXViewRenderingEngine.katex(),
                      // ) : Text(data['message']),
                      child: Text(
                        data['message'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    // color: Colors.green,
                    child: Text(
                      '${data['time'].toDate().hour.toString().padLeft(2, '0')}:${data['time'].toDate().minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMessageBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: boxDecoration(Theme.of(context), _borderRadius),
            child: TextFormField(
                maxLines: null,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                controller: _messageController,
                decoration: inputDecoration(
                    Theme.of(context), _borderRadius, 'Ask me anything...')),
          ),
        ),
        IconButton(
            onPressed: () => askBotQuestion(), icon: Icon(Icons.send_outlined)),

        // Icon for audio recording
        IconButton(
          onPressed: () async {
            // Check and request permission if needed
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // return RecorderPage();
              // return TTSPage();
              return SpeechToTextPage();
            }));
          },
          icon: Icon(Icons.mic),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          child: Icon(Icons.android),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Column(children: [
          Expanded(
            child: _buildMessageList(),
          ),
          SizedBox(
            height: 10,
          ),
          buildMessageBox(),
        ]),
      ),
    );
  }
}

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    ;
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}
