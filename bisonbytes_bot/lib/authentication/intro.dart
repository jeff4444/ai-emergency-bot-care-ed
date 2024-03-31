import 'package:bisonbytes_bot/services/auth_service.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
import '../loading.dart';

class Intro extends StatefulWidget {
  final Function
      toggleAuth; // allows toggle between the Onboarding, register and signIn pages
  Intro({required this.toggleAuth});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int currentIndex = 1;
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(() {
      if (mounted && (currentIndex < 2)) {
        setState(() {
          currentIndex = (_controller.value * 2).floor() + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return (currentIndex == 1)
            ? Loading()
            : Onboarding(
                toggleAuth: widget.toggleAuth,
              );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// the introduction page or Squash (First page the user sees)
class Onboarding extends StatefulWidget {
  final Function
      toggleAuth; // allows toggle between the Onboarding, register and signIn pages
  Onboarding({required this.toggleAuth});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

// Onboarding state class
class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          TextButton(
            // used to toggle to the signIn page
            onPressed: () => widget.toggleAuth(1),
            child: Text(
              'skip',
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 56, 107, 246),
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          // allows user to scroll down and up on the page
          child: Column(
            children: [
              const SizedBox(
                // just for space
                height: 5,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/onboarding.png'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'Text ...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'More text ...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 56, 107, 246)),
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 40)),
                ),
                onPressed: () => widget.toggleAuth(2),
                child: Text(
                  'Get Started',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.background),
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 80)),
                  side: MaterialStatePropertyAll<BorderSide>(
                    BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 56, 107, 246),
                    ),
                  ),
                ),
                onPressed: () => widget.toggleAuth(1),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 56, 107, 246),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.background),
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 80)),
                  side: MaterialStatePropertyAll<BorderSide>(
                    BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 56, 107, 246),
                    ),
                  ),
                ),
                onPressed: () {
                  AuthService().signInAnon();
                },
                child: Text(
                  'Emergency use',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 56, 107, 246),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
