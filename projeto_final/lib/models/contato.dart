class Contato {
  int id;
  String nome;
  String telefone;
  String endereco;
  String latlong;

  Contato({this.id, this.nome, this.telefone, this.endereco, this.latlong});
  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
    endereco = map['endereco'];
    latlong = map['latlong'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['endereco'] = endereco;
    data['latlong'] = latlong;

    return data;
  }
}
