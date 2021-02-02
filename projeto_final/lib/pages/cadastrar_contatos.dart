import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/contato.dart';

class AdicionarContato extends StatefulWidget {
  @override
  _AdicionarContatoState createState() => _AdicionarContatoState();
}

class _AdicionarContatoState extends State<AdicionarContato> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DataBaseHelper db = DataBaseHelper();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerLatLong = TextEditingController();
  Position position = Position();

  @override
  Widget build(BuildContext context) {
    if (position.latitude != null) {
      LatLng localizacao = LatLng(position.latitude, position.longitude);

      _controllerLatLong.text =
          '${localizacao.latitude},${localizacao.longitude}';
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Adicionar Contato'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerNome,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o nome';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerTelefone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu telefone';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerEndereco,
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu endereço';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerLatLong,
                  decoration: InputDecoration(
                      labelText: 'Coordenadas',
                      prefixIcon: Icon(Icons.location_on),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        tooltip: 'Localização atual',
                        onPressed: () async {
                          Position myLocation = await _determinePosition();
                          setState(() {
                            position = myLocation;
                          });
                        },
                      )
                    ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite sua localização';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  child: RaisedButton(
                    color: Colors.yellow,
                    child: Text('Adicionar'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Contato contato = Contato(
                          nome: _controllerNome.text,
                          telefone: _controllerTelefone.text,
                          endereco: _controllerEndereco.text,
                          latlong: _controllerLatLong.text,
                        );
                        await db.insertContato(contato);

                        setState(() {
                          _controllerNome.text = '';
                          _controllerTelefone.text = '';
                          _controllerEndereco.text = '';
                          _controllerLatLong.text = '';

                          FocusScope.of(context).requestFocus(FocusNode());
                        });

                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Contato adicionado!')));
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
