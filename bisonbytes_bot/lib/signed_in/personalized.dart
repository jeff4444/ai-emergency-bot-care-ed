import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import 'bot.dart';

class PersonalizedPageThemeLoader extends StatelessWidget {
  const PersonalizedPageThemeLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: PersonalizedPage());
  }
}

class PersonalizedPage extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalized Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String userId = _userIdController.text;
                // Do something with the user ID

                // navigate to bot
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CourseBotChatPageThemeLoader();
                }));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
