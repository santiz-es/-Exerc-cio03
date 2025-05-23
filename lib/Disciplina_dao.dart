import 'package:dbestudante/DatabaseHelper.dart';
import 'package:dbestudante/Disciplina.dart';
//import 'package:dbestudante/estudante.dart';
import 'package:sqflite/sqflite.dart';

class DisciplinaDao {
  final Databasehelper _dbHelper = Databasehelper();

  //incluir no banco
  Future<void> incluirDisciplina(Disciplina d) async {
    final db = await _dbHelper.database;
    await db.insert(
      "disciplina",
      d.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Editar no banco
  Future<void> editarDisciplina(Disciplina d) async {
    final db = await _dbHelper.database;
    await db.update(
      "disciplina",
      d.toMap(), 
      where: "id = ?", 
      whereArgs: [d.id]);
  }

  //Excluir
  Future<void> deleteDisciplina(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "disciplina", 
      where: "id = ?", 
      whereArgs: [index]);
  }

  //Listar
  Future<List<Disciplina>> listarDisciplina() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("disciplina");
    return List.generate(maps.length, (index){
      return Disciplina.fromMap(maps[index]);
    });
  }

  Future<List<Disciplina>> listarDisciplinasObjDoEstudante(int estudanteId) async {
  final db = await _dbHelper.database;
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT d.id, d.nome, d.professor
    FROM cursa c
    INNER JOIN disciplina d ON c.id_disciplina = d.id
    WHERE c.id_estudante = ?
  ''', [estudanteId]);

  return result.map((map) => Disciplina.fromMap(map)).toList();
}
}
