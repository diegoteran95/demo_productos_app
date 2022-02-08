import 'package:demo_productos_app/screens/screens.dart';
import 'package:demo_productos_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authService.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return Text('Espere...');
              }

              if (snapshot.data == '') {
                Future.microtask(() {
                  // Navigator.of(context).pushReplacementNamed('login');
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LoginScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              } else {
                Future.microtask(() {
                  // Navigator.of(context).pushReplacementNamed('login');
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => HomeScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              }

              return Container();
            }),
      ),
    );
  }
}
