// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/contato.dart';
import 'cadastrar_contatos.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DataBaseHelper db = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdicionarContato()));

          setState(() {});
        },
      ),
      body: FutureBuilder(
        future: db.getContatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }

          List<Map> data = snapshot.data;

          return data != null
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onLongPress: () {
                        _showMyDialog({
                          'id': data[index]['id'],
                          'nome': data[index]['nome'],
                          'telefone': data[index]['telefone'],
                          'endereco': data[index]['endereco'],
                          'latlong': data[index]['latlong'],
                          });
                      },
                      leading: CircleAvatar(
                        child: Text(data[index]['nome'].toString()[0]),
                      ),
                      title: Text(data[index]['nome']),
                      subtitle: Column(
                        children: [
                          Text(data[index]['telefone'] ?? 'default'),
                          Text(data[index]['endereco']),
                          Text('LatLong: ${data[index]['latlong']}')
                        ],
                      ),
                    );
                  })
              : Container(
                  child: Center(
                    child: Text(
                        'Sem contatos.'),
                  ),
                );
        },
      ),
    );
  }

  Future<void> _showMyDialog(Map<String, dynamic> mapa) async {
    TextEditingController _controllerNome = TextEditingController();
    TextEditingController _controllerTelefone = TextEditingController();
    TextEditingController _controllerEndereco = TextEditingController();
    TextEditingController _controllerLatLong = TextEditingController();
    

    _controllerNome.text = mapa['nome'];
    _controllerTelefone.text = mapa['telefone'];
    _controllerEndereco.text = mapa['endereco'];
    _controllerLatLong.text = mapa['latlong'];
    

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Atualizar Contato"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: _controllerNome,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Número'),
                    controller: _controllerTelefone,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Endereço'),
                    controller: _controllerEndereco,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Coordenadas'),
                    controller: _controllerLatLong,
                  ),
                  
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              FlatButton(
                  onPressed: () async {
                    Contato contato = Contato(
                        id: mapa['id'],
                        nome: _controllerNome.text,
                        telefone: _controllerTelefone.text,
                        endereco: _controllerEndereco.text,
                        latlong: _controllerLatLong.text,
                        );
                    await db.updateContato(contato);
                    Navigator.of(context).pop();

                    setState(() {});
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Contato atualizado!')));
                  },
                  child: Text('Enviar')
                ),
              ],
            );
        });
      }
    }
