import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/sess%C3%A3o.dart';
import 'package:projeto_final/models/usu%C3%A1rio.dart';
import 'package:projeto_final/pages/login/inscri%C3%A7%C3%A3o.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DataBaseHelper db = DataBaseHelper();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool isObscure = true;
  bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/ifpi.png',
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Email',
                      ),
                    controller: _controllerEmail,
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Digite seu email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Senha',
                      ),
                    obscureText: isObscure,
                    controller: _controllerPassword,
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Digite sua senha';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.yellow,
                      onPressed: () async {
                        String message;
                        if (_formKey.currentState.validate()) {
                          String password = md5
                              .convert(utf8.encode(_controllerPassword.text))
                              .toString();
                          User user =
                              await db.getUser(_controllerEmail.text, password);
                          if (user != null) {
                            Session session = Session(
                              userId: user.id,
                              autenticado: 1,
                              data: DateTime.now().toString(),
                            );

                            db.setSession(session);
                            message = 'Cadastro realizado!';
                            Navigator.pushNamed(context, '/home',
                                arguments: {'session': session});
                          } else {
                            message = 'Login ou senha incorreta.';
                          }

                          setState(() {
                            _controllerEmail.text = '';
                            _controllerPassword.text = '';
                            FocusScope.of(context).requestFocus(FocusNode());
                          });

                          _scaffoldKey.currentState
                              .showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.black,
                          ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
              height: 20,
              alignment: Alignment.center,
              child: FlatButton(
                child: Text(
                  'Não tem uma conta? Cadastre-se!',
                ),
                onPressed: () {
                  Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
