import 'package:flutter/material.dart';

import '../models/my_user.dart';
import 'user_info.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  MyUser user = MyUser(uid: '', name: '', email: '', password: '');

  @override
  Widget build(BuildContext context) {
    return UserInfo(toggleAuth: widget.toggleAuth, user: user);
  }
}
