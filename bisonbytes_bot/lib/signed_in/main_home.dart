import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import 'bot.dart';
import 'personalized.dart';

class MainHomePageThemeLoader extends StatelessWidget {
  const MainHomePageThemeLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: MainHomePage());
  }
}

class MainHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // push page to the generic response bot
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CourseBotChatPageThemeLoader();
              }));
            },
            child: Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text('Generic response \nbot',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          GestureDetector(
            onTap: () {
              // push page to the personalized response bot
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PersonalizedPageThemeLoader();
              }));
            },
            child: Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text('Personalized response bot',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
