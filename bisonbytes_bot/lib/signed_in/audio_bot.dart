import 'package:flutter/material.dart';

class AudioBotPage extends StatefulWidget {
  @override
  _AudioBotPageState createState() => _AudioBotPageState();
}

class _AudioBotPageState extends State<AudioBotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Bot'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Audio Bot Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}