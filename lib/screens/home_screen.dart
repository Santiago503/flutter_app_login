import 'package:flutter/material.dart';

import '../widgets/auth_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AuthBackGround(
      child: Container(width: double.infinity, color: Colors.indigo),
    );
  }
}
