import 'package:flutter/material.dart';

class LoandingScreen extends StatelessWidget {
  const LoandingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.indigo,
        )
      ),
    );
  }
}
