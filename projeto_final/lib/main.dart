import 'package:flutter/material.dart';
import 'package:projeto_final/pages/contatos.dart';
import 'package:projeto_final/pages/home.dart';
import 'package:projeto_final/pages/login_page.dart';
import 'package:projeto_final/pages/mapas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => Home(),
        '/home/contatos': (context) => Contatos(),
        '/home/mapa': (context) => Mapas()
      }
    );
  }
}
