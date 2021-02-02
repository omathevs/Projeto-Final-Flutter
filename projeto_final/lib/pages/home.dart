import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/sess%C3%A3o.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBaseHelper db = DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    Session session = args['session'];
    void selecao(escolha) async {
      if (escolha == 'logout') {
        session.autenticado = 0;
        await db.updateSession(session.userId, session);
        Navigator.popAndPushNamed(context, '/');
      }
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              onSelected: selecao,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Sair'),
                    value: 'logout',
                  )
                ];
              },
            )
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              padding: const EdgeInsets.all(10.0),
              textColor: Colors.black,
              color: Colors.yellow,
              child: Text('Contatos'),
              onPressed: () {
                Navigator.pushNamed(context, '/home/contatos');
              },
            ),
            RaisedButton(
              padding: const EdgeInsets.all(10.0),
              textColor: Colors.black,
              color: Colors.yellow,
              child: Text('Mapas'),
              onPressed: () {
                Navigator.pushNamed(context, '/home/mapa');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deseja sair?'),
          actions: [
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
