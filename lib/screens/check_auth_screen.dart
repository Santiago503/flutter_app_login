import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:provider/provider.dart';

class CheackAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context, listen: false );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if ( !snapshot.hasData )            
              return const Text('');

            if ( snapshot.data == '' ) {
              Future.microtask(() {

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => const LoginScreen(),
                  transitionDuration: const Duration( seconds: 0)
                  )
                );

              });

            } else {

              Future.microtask(() {

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => const HomeScreen(),
                  transitionDuration: const Duration( seconds: 0)
                  )
                );

              });
            }

            return Container();
          },
          future: authService.readToken(),
        ),
     ),
   );
  }
}