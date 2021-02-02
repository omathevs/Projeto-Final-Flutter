import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/usu%C3%A1rio.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool isObscure = true;
  DataBaseHelper db = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('assets/ifpi.png', width: 150),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerNome,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu nome';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nome',
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerEmail,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      labelText: 'Email',
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerPassword,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Senha',
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text('Cadastre-se',
                        style: TextStyle(
                            color: Colors.black,
                            )
                          ),
                    color: Colors.yellow,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String password = md5
                            .convert(utf8.encode(_controllerPassword.text))
                            .toString();
                        User user = User(
                            email: _controllerEmail.text,
                            nome: _controllerNome.text,
                            password: password);

                        await db.inserirUser(user);

                        setState(() {
                          _controllerNome.text = '';
                          _controllerEmail.text = '';
                          _controllerPassword.text = '';
                          FocusScope.of(context).requestFocus(FocusNode());
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Cadastro realizado!')));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
