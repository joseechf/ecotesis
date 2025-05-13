import 'package:ecoazuero/main.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

class login extends StatelessWidget {
  const login({super.key});
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(builder: Authenticator.builder(), home: const MyApp()),
    );
  }
}
