import 'Cursa.dart';

class CursaDao {
  
  final List<Cursa> _matriculas = [];

  
  Future<List<Cursa>> listarCursa() async {
    return List.from(_matriculas);
  }


  Future<void> incluirCursa(Cursa cursa) async {
    cursa.id = (_matriculas.isEmpty) ? 1 : _matriculas.last.id! + 1;
    _matriculas.add(cursa);
  }


  Future<void> deleteCursa(int id) async {
    _matriculas.removeWhere((c) => c.id == id);
  }


  Future<void> editarCursa(Cursa cursaAtualizada) async {
    final index = _matriculas.indexWhere((c) => c.id == cursaAtualizada.id);
    if (index >= 0) {
      _matriculas[index] = cursaAtualizada;
    }
  }
}
