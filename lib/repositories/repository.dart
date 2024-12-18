import 'package:sqflite/sqflite.dart';
import 'package:tasks_list/repositories/database_connection.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    // initialize database connection
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await _databaseConnection!.setDatabase();
  // if (_database == null) return _database;
  // _database = await _databaseConnection!.setDatabase();
  // return _database;

  //inserting data to the table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  // read data from table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  //read data by id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //updating data
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //delete data
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }
}
