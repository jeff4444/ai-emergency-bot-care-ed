import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

class LearnPageThemeLoader extends StatelessWidget {
  const LearnPageThemeLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: LearnPage());
  }
}

class LearnPage extends StatefulWidget {
  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  Map<String, String> topicsImages = {
    'First Aid for sever bleeding': 'image1.png',
    'First Aid for burns': 'image2.png',
    'First Aid for choking': 'image3.png',
    'First Aid for seizure': 'image4.png',
  };

  String searchVal = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(
              left: 10,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: (Theme.of(context).colorScheme.background ==
                      Colors.white)
                  ? [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]
                  : null,
            ),
            alignment: AlignmentDirectional.center,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () => {print('Hello!')},
                ),
                Expanded(
                  child: FractionallySizedBox(
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search for a topic',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchVal = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var topic in topicsImages.keys)
                  if (topic.toLowerCase().contains(searchVal.toLowerCase()))
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: (Theme.of(context).colorScheme.background ==
                                Colors.white)
                            ? [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/${topicsImages[topic]}',
                            width: 200,
                            height: 250,
                          ),
                          Text(topic),
                        ],
                      ),
                    )
              ],
            ),
          )
        ],
      ),
    );
  }
}
