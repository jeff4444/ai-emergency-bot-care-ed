// This file contains the wrapper which navigates between the
// home screen (when a user is signed in) and
//the authenticate screen (when a user is signed out)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'signed_in/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    /// get user information to determine whether user is signed in or not (not null or null)
    final User? user = Provider.of<User?>(context);
    return (user == null) ? const Auhenticate() : Home();
  }
}

