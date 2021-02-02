import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:projeto_final/models/contato.dart';
import 'package:projeto_final/models/sess%C3%A3o.dart';
import 'package:projeto_final/models/usu%C3%A1rio.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static DataBaseHelper _databaseHelper;
  static Database _database;

  // Definir as colunas da tabela
  // Tabela Contato
  String contatoTable = 'contato';
  String colId = 'id';
  String colNome = 'nome';
  String colTelefone = 'telefone';
  String colEndereco = 'endereco';
  String colLatLong = 'latlong';

  //------------------------------
  // Tabela Usuário
  String userTable = 'user';
  String colEmail = 'email';
  String colPassword = 'password';

  // Construtor nomeado para criar instância da classe
  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  // Inicia o banco de dados
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contatos.db';

    var contatosDataBase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDataBase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $contatoTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colNome TEXT, $colTelefone TEXT, $colEndereco TEXT, $colLatLong TEXT 
          )''');

    await db.execute('''CREATE TABLE $userTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colNome TEXT,
          $colEmail TEXT, 
          $colPassword TEXT)''');

    await db.execute('''CREATE TABLE session(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      data TEXT,
      autenticado INTEGER,
      FOREIGN KEY (userId) REFERENCES $userTable(id)
    )''');
  }

  // Types: INTEGER, TEXT, BOB, NULL
  // CRUD Usuário
  Future<int> inserirUser(User user) async {
    Database db = await this.database;
    int resultado = await db.insert(userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return resultado;
  }

  // CRUD Contato
  // Incluir contato no banco de dados
  Future<int> insertContato(Contato contato) async {
    Database db = await this.database;
    int resultado = await db.insert(contatoTable, contato.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return resultado;
  }

  // Buscar usuário por email e senha
  Future<User> getUser(String email, String password) async {
    Database db = await this.database;
    List<Map> maps = await db.query(userTable,
        where: "$colEmail = ? AND $colPassword = ?",
        whereArgs: [email, password]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Deletar usuário por id
  Future<int> deleteUser(int id) async {
    Database db = await this.database;
    int resultado =
        await db.delete(userTable, where: "$colId = ?", whereArgs: [id]);
    return resultado;
  }

  // Atualizar usuário
  Future<int> updateUser(User user) async {
    Database db = await this.database;
    int resultado = await db.update(userTable, user.toMap(),
        where: "$colId = ?", whereArgs: [user.id]);
    return resultado;
  }

  // Buscar contato por id
  Future<Contato> getContato(int id) async {
    Database db = await this.database;
    List<Map> maps = await db.query(contatoTable,
        columns: [colId, colNome, colTelefone, colEndereco, colLatLong],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Map>> getContatos() async {
    Database db = await this.database;
    List<Map> maps = await db.query(contatoTable,
        columns: [colId, colNome, colTelefone, colEndereco, colLatLong]);

    if (maps.length > 0) {
      return maps;
    } else {
      return null;
    }
  }

  // Atualizar contato por id
  Future<int> updateContato(Contato contato) async {
    Database db = await this.database;

    int resultado = await db.update(contatoTable, contato.toMap(),
        where: '$colId = ?', whereArgs: [contato.id]);

    return resultado;
  }

  // Deletar um objeto contato do banco
  Future<int> deleteContato(int id) async {
    Database db = await this.database;

    int resultado =
        await db.delete(contatoTable, where: '$colId = ?', whereArgs: [id]);
    return resultado;
  }

  // Qunatidade de contatos no banco
  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $contatoTable');
    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  // Fechar banco
  Future close() async {
    Database db = await this.database;
    db.close();
  }

  // Controle de sessão tabela sessão
  Future<Session> getSession() async {
    Database db = await this.database;

    List<Map<String, dynamic>> query =
        await db.query('session', where: 'autenticado = ?', whereArgs: [1]);
    if (query.length > 0) {
      return Session.fromMap(query.first);
    } else {
      return null;
    }
  }

  Future<int> setSession(Session session) async {
    Database db = await this.database;

    int resultado = await db.insert('session', session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return resultado;
  }

  Future<int> updateSession(int userId, Session session) async {
    Database db = await this.database;

    int resultado = await db.update('session', session.toMap(),
        where: 'userId = ?', whereArgs: [userId]);
    return resultado;
  }
}
